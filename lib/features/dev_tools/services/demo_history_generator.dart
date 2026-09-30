import 'dart:math' as math;

import '../../logs/models/daily_log.dart';
import '../../periods/models/period_entry.dart';

/// Builds a realistic demo history as plain Dart objects.
///
/// Kept separate from the Firestore writer so the shape of the generated data
/// can be unit tested, in particular that it actually exercises the pattern
/// detection in `WellnessInsightEngine`. A perfectly healthy history would make
/// those features look broken.
class DemoHistoryGenerator {
  const DemoHistoryGenerator();

  /// Enough history for the 7/30/90-day statistics ranges and the 30-day
  /// insight window to all have data.
  static const int logDays = 75;

  /// Fixed seed so re-seeding produces identical history and screenshots or bug
  /// reports stay comparable.
  static const int randomSeed = 20260330;

  static const List<int> _cycleLengths = [29, 30, 28, 31, 29];
  static const List<int> _periodLengths = [5, 5, 4, 6, 5];

  /// How many days ago the most recent period started.
  static const int _latestPeriodStartOffset = 6;

  /// Recent days deliberately left unlogged so the logging-gap nudge fires.
  static const List<int> _skipDaysAgo = [4, 9, 13];

  DemoHistory generate(DateTime today) {
    final day = DateTime(today.year, today.month, today.day);
    final random = math.Random(randomSeed);
    return DemoHistory(
      logs: _buildLogs(day, random),
      periods: _buildPeriods(day),
    );
  }

  List<DailyLog> _buildLogs(DateTime today, math.Random random) {
    final periodDays = _periodDayOffsets();

    final logs = <DailyLog>[];
    for (var ago = logDays - 1; ago >= 0; ago--) {
      final date = today.subtract(Duration(days: ago));
      if (_skipDaysAgo.contains(ago)) continue;

      // 0 at the start of the window, 1 today, so sleep visibly declines.
      final progress = (logDays - ago) / logDays;
      var sleep = 7.6 - (2.1 * progress) + (random.nextDouble() - 0.5) * 0.7;
      if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
        sleep += 0.6;
      }
      sleep = _round(sleep, lower: 3.5, upper: 9.5);

      final onPeriod = periodDays.contains(ago);

      logs.add(DailyLog(
        date: date,
        sleepHours: sleep.toDouble(),
        mood: _moodFor(ago, random),
        food: _foodFor(random),
        health: _healthFor(ago, onPeriod, random),
        symptoms: _symptomsFor(ago, onPeriod, random),
      ));
    }
    return logs;
  }

  List<PeriodEntry> _buildPeriods(DateTime today) {
    final periods = <PeriodEntry>[];
    var startOffset = _latestPeriodStartOffset;

    for (var i = 0; i < _cycleLengths.length; i++) {
      final start = today.subtract(Duration(days: startOffset));
      final end = start.add(Duration(days: _periodLengths[i] - 1));
      periods.add(PeriodEntry(
        startDate: start,
        // The most recent period may still be running.
        endDate: end.isAfter(today) ? today : end,
        flowLevel: 1 + (i % 3),
        symptoms: const ['Cramps', 'Bloating'],
      ));
      startOffset += _cycleLengths[i];
    }
    return periods;
  }

  /// The last three days are low, so the low-mood streak rule has something to
  /// find. Before that the mix stays positive-leaning but not perfectly so.
  String _moodFor(int daysAgo, math.Random random) {
    if (daysAgo <= 2) return '😔';
    if (daysAgo <= 5) return '😳';
    final roll = random.nextDouble();
    if (roll < 0.62) return '😊';
    if (roll < 0.84) return '🙂';
    if (roll < 0.94) return '😄';
    return '😳';
  }

  String _foodFor(math.Random random) {
    const options = [
      'Dal, rice and vegetables',
      'Oats with fruit and yoghurt',
      'Chicken and salad',
      'Roti with sabzi',
      'Grilled fish and quinoa',
      'Khichdi and pickle',
    ];
    return options[random.nextInt(options.length)];
  }

  String _healthFor(int daysAgo, bool onPeriod, math.Random random) {
    if (onPeriod && daysAgo < 8) return 'Light cramping and tiredness';
    if (daysAgo <= 2) return 'Heavy cramping, low energy';
    final roll = random.nextDouble();
    if (roll < 0.55) return 'Feeling fine';
    if (roll < 0.8) return 'Slight tiredness in the afternoon';
    return 'Mild headache';
  }

  /// "Headache" recurs across the window so the recurring-symptom rule fires.
  List<String> _symptomsFor(int daysAgo, bool onPeriod, math.Random random) {
    if (daysAgo % 9 == 3) return const ['Headache'];
    if (onPeriod) {
      final roll = random.nextDouble();
      if (roll < 0.5) return const ['Bloating', 'Cramps'];
      if (roll < 0.8) return const ['Cramps'];
      return const ['Tender breasts'];
    }
    return const [];
  }

  /// Offsets from today (0 = today) on which a period day falls.
  Set<int> _periodDayOffsets() {
    final offsets = <int>{};
    var offset = _latestPeriodStartOffset;
    for (var i = 0; i < _cycleLengths.length; i++) {
      for (var day = 0; day < _periodLengths[i]; day++) {
        if (offset + day < logDays) offsets.add(offset + day);
      }
      offset += _cycleLengths[i];
    }
    return offsets;
  }

  double _round(double value, {required double lower, required double upper}) {
    final rounded = (value * 10).roundToDouble() / 10;
    if (rounded < lower) return lower;
    if (rounded > upper) return upper;
    return rounded;
  }
}

/// A generated demo history.
class DemoHistory {
  final List<DailyLog> logs;
  final List<PeriodEntry> periods;

  const DemoHistory({required this.logs, required this.periods});
}