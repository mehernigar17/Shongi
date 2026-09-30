import 'dart:math' as math;

import '../../logs/models/daily_log.dart';
import '../models/wellness_insight.dart';

/// Turns the user's own daily logs into a short, ranked list of observations.
///
/// The rules are deliberately deterministic and local: every insight quotes the
/// figure it was derived from, and nothing is sent to a remote model. That way
/// the feature works offline, is testable, and cannot invent advice.
class WellnessInsightEngine {
  const WellnessInsightEngine();

  /// At most this many insights are shown, highest priority first.
  static const int maxInsights = 4;

  /// Nights per side when comparing recent sleep against earlier sleep.
  static const int trendWindow = 7;

  /// Average nightly sleep below this is called out.
  static const double lowSleepHours = 6.5;

  /// Hours of change between the two trend windows that counts as a shift.
  static const double sleepShiftHours = 0.8;

  /// Standard deviation above this suggests an irregular schedule.
  static const double sleepSpreadHours = 1.2;

  /// Consecutive low-mood days that trigger a check-in.
  static const int lowMoodStreakDays = 3;

  /// A symptom logged at least this many times is treated as recurring.
  static const int recurringSymptomCount = 3;

  static const Set<String> lowMoods = {'😔', '😳'};
  static const Set<String> positiveMoods = {'🙂', '😊', '😄'};

  /// Free-text health notes containing any of these are surfaced for review.
  static const List<String> healthWarningKeywords = [
    'pain',
    'cramp',
    'fever',
    'bleed',
    'dizzy',
    'nausea',
    'headache',
  ];

  /// Builds the ranked insight list for [logs].
  ///
  /// [now] is injectable so the calendar-dependent rules stay testable.
  /// Returns an empty list only when there is nothing at all to learn from.
  List<WellnessInsight> build(List<DailyLog> logs, {DateTime? now}) {
    if (logs.isEmpty) return const [];

    final ordered = [...logs]
      ..sort((a, b) => a.date.compareTo(b.date));

    final insights = <WellnessInsight>[];
    _addSleepInsights(insights, ordered);
    _addMoodInsights(insights, ordered);
    _addSymptomInsights(insights, ordered);
    _addHealthNoteInsights(insights, ordered);
    _addConsistencyInsight(insights, ordered, now ?? DateTime.now());

    if (insights.isEmpty) {
      insights.add(WellnessInsight(
        title: 'Nothing looks off',
        detail: 'Sleep, mood and symptoms across your logged days are all in a '
            'healthy range. Keep logging daily so this stays up to date.',
        severity: InsightSeverity.good,
        priority: 0,
      ));
    }

    insights.sort((a, b) => a.priority.compareTo(b.priority));
    return insights.take(maxInsights).toList();
  }

  void _addSleepInsights(List<WellnessInsight> out, List<DailyLog> ordered) {
    final sleep = ordered.where((l) => l.sleepHours > 0).toList();
    if (sleep.isEmpty) return;

    final nights = sleep.length;
    final average = _average(sleep.map((l) => l.sleepHours));

    if (average < lowSleepHours) {
      out.add(WellnessInsight(
        title: 'Sleep is running short',
        detail: 'You averaged ${_fmt(average)} h across $nights logged '
            '${nights == 1 ? 'night' : 'nights'}. Staying under '
            '${_fmt(lowSleepHours)} h tends to drag mood and energy down, so an '
            'earlier wind-down is the cheapest thing to try first.',
        severity: InsightSeverity.attention,
        priority: 0,
      ));
    }

    if (sleep.length >= trendWindow * 2) {
      final earlier = _average(
        sleep.sublist(0, sleep.length - trendWindow).map((l) => l.sleepHours),
      );
      final recent = _average(
        sleep.sublist(sleep.length - trendWindow).map((l) => l.sleepHours),
      );
      final change = recent - earlier;

      if (change <= -sleepShiftHours) {
        out.add(WellnessInsight(
          title: 'Sleep is trending down',
          detail: 'Your last $trendWindow logged nights average ${_fmt(recent)} h, '
              'down from ${_fmt(earlier)} h over the $trendWindow before them.',
          severity: InsightSeverity.attention,
          priority: 1,
        ));
      } else if (change >= sleepShiftHours) {
        out.add(WellnessInsight(
          title: 'Sleep is trending up',
          detail: 'Your last $trendWindow logged nights average ${_fmt(recent)} h, '
              'up from ${_fmt(earlier)} h over the $trendWindow before them. '
              'Worth protecting that routine.',
          severity: InsightSeverity.good,
          priority: 8,
        ));
      }
    }

    if (sleep.length >= 4) {
      final spread = _standardDeviation(sleep.map((l) => l.sleepHours));
      if (spread >= sleepSpreadHours) {
        out.add(WellnessInsight(
          title: 'Sleep times are jumping around',
          detail: 'Your logged sleep varies by about ${_fmt(spread)} h night to '
              'night. A steadier wake time is usually the easiest way to steady '
              'sleep.',
          severity: InsightSeverity.info,
          priority: 5,
        ));
      }
    }
  }

  void _addMoodInsights(List<WellnessInsight> out, List<DailyLog> ordered) {
    final moodLogs = ordered.where((l) => l.mood.isNotEmpty).toList();
    if (moodLogs.isEmpty) return;

    var streak = 0;
    for (final log in moodLogs.reversed) {
      if (!lowMoods.contains(log.mood)) break;
      streak++;
    }
    if (streak >= lowMoodStreakDays) {
      out.add(WellnessInsight(
        title: 'Low mood for $streak days in a row',
        detail: 'Your last $streak logged moods were all on the lower side. '
            'Long low runs are worth a gentle check-in with someone, and if it '
            'carries on, a doctor.',
        severity: InsightSeverity.attention,
        priority: 2,
      ));
    }

    if (moodLogs.length >= 4) {
      final positive = moodLogs.where((l) => positiveMoods.contains(l.mood)).length;
      final share = positive / moodLogs.length * 100;

      if (share >= 70) {
        out.add(WellnessInsight(
          title: 'Mood has been mostly positive',
          detail: '${share.round()}% of your ${moodLogs.length} logged moods '
              'were positive. Whatever you are doing lately, it is working.',
          severity: InsightSeverity.good,
          priority: 9,
        ));
      } else if (share < 40) {
        out.add(WellnessInsight(
          title: 'Mood has been mostly low',
          detail: 'Only ${share.round()}% of your ${moodLogs.length} logged '
              'moods were positive. Small, regular things tend to help more than '
              'occasional big ones.',
          severity: InsightSeverity.info,
          priority: 6,
        ));
      }
    }
  }

  void _addSymptomInsights(List<WellnessInsight> out, List<DailyLog> ordered) {
    final counts = <String, int>{};
    final labels = <String, String>{};

    for (final log in ordered) {
      for (final raw in log.symptoms) {
        final symptom = raw.trim().toLowerCase();
        if (symptom.isEmpty) continue;
        counts[symptom] = (counts[symptom] ?? 0) + 1;
        labels[symptom] = raw.trim();
      }
    }

    final recurring = counts.entries
        .where((e) => e.value >= recurringSymptomCount)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    if (recurring.isEmpty) return;

    final top = recurring.take(2).map((e) => labels[e.key]!).join(' and ');
    out.add(WellnessInsight(
      title: 'A symptom keeps coming back',
      detail: 'You logged $top ${recurring.first.value} times in this period. '
          'Repetition is worth mentioning to a doctor even if it settles on its own.',
      severity: InsightSeverity.attention,
      priority: 3,
    ));
  }

  void _addHealthNoteInsights(List<WellnessInsight> out, List<DailyLog> ordered) {
    final hits = <String>[];
    for (final log in ordered) {
      final note = log.health.toLowerCase();
      for (final keyword in healthWarningKeywords) {
        if (note.contains(keyword) && !hits.contains(keyword)) {
          hits.add(keyword);
        }
      }
    }
    if (hits.isEmpty) return;

    out.add(WellnessInsight(
      title: 'Your notes mention something to watch',
      detail: 'Health notes in this period mention ${hits.take(3).join(', ')}. '
          'This is not a diagnosis — if it keeps recurring or gets worse, book a '
          'doctor.',
      severity: InsightSeverity.attention,
      priority: 4,
    ));
  }

  void _addConsistencyInsight(
    List<WellnessInsight> out,
    List<DailyLog> ordered,
    DateTime now,
  ) {
    final today = DateTime(now.year, now.month, now.day);
    final cutoff = today.subtract(const Duration(days: 13));
    final recentDays = ordered
        .map((l) => DateTime(l.date.year, l.date.month, l.date.day))
        .where((d) => !d.isBefore(cutoff) && !d.isAfter(today))
        .toSet()
        .length;

    if (recentDays > 0 && recentDays < 7) {
      out.add(WellnessInsight(
        title: 'Logging has gaps',
        detail: 'Only $recentDays of the last 14 days has an entry. Insights '
            'improve a lot once the picture is complete.',
        severity: InsightSeverity.info,
        priority: 7,
      ));
    }
  }

  double _average(Iterable<double> values) =>
      values.reduce((a, b) => a + b) / values.length;

  double _standardDeviation(Iterable<double> values) {
    final list = values.toList();
    final average = _average(list);
    final variance =
        list.map((v) => (v - average) * (v - average)).reduce((a, b) => a + b) /
            list.length;
    return math.sqrt(variance);
  }

  String _fmt(double value) => value.toStringAsFixed(1);
}
