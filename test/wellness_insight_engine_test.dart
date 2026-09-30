import 'package:flutter_test/flutter_test.dart';
import 'package:shongi/features/insights/models/wellness_insight.dart';
import 'package:shongi/features/insights/services/wellness_insight_engine.dart';
import 'package:shongi/features/logs/models/daily_log.dart';

/// Builds a log on [date] at midnight, matching how the app stores logs.
DailyLog log(
  DateTime date, {
  double sleep = 0,
  String mood = '',
  String health = '',
  List<String> symptoms = const [],
}) =>
    DailyLog(
      date: DateTime(date.year, date.month, date.day),
      sleepHours: sleep,
      mood: mood,
      health: health,
      symptoms: symptoms,
    );

/// [count] consecutive days ending the day before [now].
List<DailyLog> days(int count, DateTime now) =>
    List.generate(count, (i) => log(now.subtract(Duration(days: count - i))));

/// Applies [transform] with the day index to each entry of [logs].
List<DailyLog> at(
  List<DailyLog> logs,
  DailyLog Function(int index, DailyLog entry) transform,
) =>
    List.generate(logs.length, (i) => transform(i, logs[i]));

WellnessInsight find(List<WellnessInsight> insights, String title) =>
    insights.firstWhere(
      (i) => i.title == title,
      orElse: () => throw StateError('no insight titled "$title" in $insights'),
    );

void main() {
  const engine = WellnessInsightEngine();
  // Fixed clock so the calendar-dependent logging-gap rule is deterministic.
  final now = DateTime(2026, 3, 30);
  final today = DateTime(2026, 3, 30);

  group('WellnessInsightEngine', () {
    test('returns nothing when there are no logs at all', () {
      expect(engine.build(const [], now: now), isEmpty);
    });

    test('confirms a balanced history when nothing is flagged', () {
      // Sleep is fine, mood sits at 40% positive and the last day is neutral,
      // so no rule should fire.
      final moods = ['😊', '😊', '😊', '😊', '😔', '😔', '😔', '😔', '😔', '😐'];
      final insights = engine.build(
        at(days(10, now), (i, l) => l.copyWith(sleepHours: 7.5, mood: moods[i])),
        now: now,
      );

      expect(insights.single.title, 'Nothing looks off');
      expect(insights.single.severity, InsightSeverity.good);
    });

    test('does not call a 6.5 h average short, since that is the cutoff', () {
      final insights = engine.build(
        at(days(10, now), (i, l) => l.copyWith(sleepHours: 6.5, mood: '😐')),
        now: now,
      );

      expect(findOrNull(insights, 'Sleep is running short'), isNull);
    });

    test('flags short average sleep and quotes the average', () {
      final insights = engine.build(
        at(days(5, now), (i, l) => l.copyWith(sleepHours: 5)),
        now: now,
      );

      final shortfall = find(insights, 'Sleep is running short');
      expect(shortfall.severity, InsightSeverity.attention);
      expect(shortfall.detail, contains('5.0 h'));
      expect(shortfall.detail, contains('5 logged nights'));
    });

    test('does not call a healthy average short', () {
      final insights = engine.build(
        at(days(5, now), (i, l) => l.copyWith(sleepHours: 7)),
        now: now,
      );

      expect(findOrNull(insights, 'Sleep is running short'), isNull);
    });

    test('detects a falling sleep trend across the two windows', () {
      final insights = engine.build(
        // First week 8 h, second week 6 h: a 2 h drop.
        at(days(14, now), (i, l) => l.copyWith(sleepHours: i < 7 ? 8 : 6)),
        now: now,
      );

      final trend = find(insights, 'Sleep is trending down');
      expect(trend.severity, InsightSeverity.attention);
      expect(trend.detail, contains('down from 8.0 h'));
      // The drop matters more than the plain average, so it must lead.
      expect(insights.indexOf(trend), lessThan(2));
    });

    test('detects a rising sleep trend as a positive', () {
      final insights = engine.build(
        at(days(14, now), (i, l) => l.copyWith(sleepHours: i < 7 ? 6 : 8)),
        now: now,
      );

      expect(
        find(insights, 'Sleep is trending up').severity,
        InsightSeverity.good,
      );
    });

    test('needs a full trend window before claiming a direction', () {
      // Ten logged nights cannot fill two seven-night windows.
      final insights = engine.build(
        at(days(10, now), (i, l) => l.copyWith(sleepHours: 5)),
        now: now,
      );

      expect(insights.where((i) => i.title.contains('trending')), isEmpty);
    });

    test('flags an irregular sleep schedule by its spread', () {
      final insights = engine.build(
        at(
          days(6, now),
          (i, l) => l.copyWith(sleepHours: l.date.day.isEven ? 5 : 9),
        ),
        now: now,
      );

      final spread = find(insights, 'Sleep times are jumping around');
      expect(spread.severity, InsightSeverity.info);
    });

    test('flags a run of low moods', () {
      final insights = engine.build(
        at(
          days(5, now),
          // Three low moods at the end, two positive before them.
          (i, l) => l.copyWith(sleepHours: 7.5, mood: i < 2 ? '😊' : '😔'),
        ),
        now: now,
      );

      final streak = insights.firstWhere((i) => i.title.contains('Low mood'));
      expect(streak.title, contains('3 days in a row'));
      expect(streak.detail, contains('last 3 logged moods'));
      expect(streak.severity, InsightSeverity.attention);
    });

    test('does not flag a low-mood run that has already been broken', () {
      final insights = engine.build(
        at(
          days(5, now),
          (i, l) => l.copyWith(
            sleepHours: 7.5,
            mood: i == 4 ? '😊' : '😔',
          ),
        ),
        now: now,
      );

      expect(insights.where((i) => i.title.contains('Low mood')), isEmpty);
    });

    test('rewards a mostly positive mood history', () {
      final insights = engine.build(
        at(
          days(6, now),
          (i, l) => l.copyWith(
            sleepHours: 7.5,
            mood: i == 0 ? '😳' : '😄',
          ),
        ),
        now: now,
      );

      final positive = find(insights, 'Mood has been mostly positive');
      expect(positive.severity, InsightSeverity.good);
      expect(positive.detail, contains('83%'));
    });

    test('flags a symptom logged three or more times', () {
      final insights = engine.build(
        at(
          days(4, now),
          (i, l) => l.copyWith(
            sleepHours: 7.5,
            mood: '😊',
            symptoms: i < 3 ? ['Headache'] : const [],
          ),
        ),
        now: now,
      );

      // Matched case-insensitively, but echoed back as the user typed it.
      expect(
        find(insights, 'A symptom keeps coming back').detail,
        contains('Headache 3 times'),
      );
    });

    test('ignores a symptom seen only twice', () {
      final insights = engine.build(
        at(
          days(4, now),
          (i, l) => l.copyWith(
            sleepHours: 7.5,
            mood: '😊',
            symptoms: i < 2 ? ['Headache'] : const [],
          ),
        ),
        now: now,
      );

      expect(findOrNull(insights, 'A symptom keeps coming back'), isNull);
    });

    test('surfaces warning keywords from free-text health notes', () {
      final insights = engine.build(
        at(
          days(4, now),
          (i, l) => l.copyWith(
            sleepHours: 7.5,
            mood: '😊',
            health: i == 1 ? 'Heavy cramping today' : '',
          ),
        ),
        now: now,
      );

      final note = find(insights, 'Your notes mention something to watch');
      expect(note.detail, contains('cramp'));
      expect(note.severity, InsightSeverity.attention);
    });

    test('nudges the user when logging has gaps', () {
      // Two entries inside the last 14 days.
      final sparse = [
        log(today.subtract(const Duration(days: 2)), sleep: 7.5, mood: '😊'),
        log(today.subtract(const Duration(days: 9)), sleep: 7.5, mood: '😊'),
      ];

      final insights = engine.build(sparse, now: now);

      expect(find(insights, 'Logging has gaps').detail,
          contains('2 of the last 14 days'));
    });

    test('sorts the most useful insight first and caps the list', () {
      final insights = engine.build(
        at(
          days(14, now),
          (i, l) => l.copyWith(
            // First week 8 h, second week 4 h: a 6.0 h average plus a 4 h drop,
            // so both the average and the trend are flagged.
            sleepHours: i < 7 ? 8 : 4,
            mood: i < 11 ? '😊' : '😔',
            health: 'cramping',
            symptoms: const ['Bloating'],
          ),
        ),
        now: now,
      );

      expect(insights.length, WellnessInsightEngine.maxInsights);
      final priorities = insights.map((i) => i.priority).toList();
      expect(priorities, orderedEquals(priorities..sort()));
      // Sleep is both short and falling, so the average note leads.
      expect(insights.first.title, 'Sleep is running short');
    });

    test('sorts unordered input by date before reading a trend', () {
      final shuffled =
          at(days(14, now), (i, l) => l.copyWith(sleepHours: i < 7 ? 6 : 8))
            ..shuffle();

      final insights = engine.build(shuffled, now: now);

      expect(findOrNull(insights, 'Sleep is trending up'), isNotNull);
    });
  });
}

/// Returns the insight with [title], or null when it was not raised.
WellnessInsight? findOrNull(List<WellnessInsight> insights, String title) {
  for (final insight in insights) {
    if (insight.title == title) return insight;
  }
  return null;
}
