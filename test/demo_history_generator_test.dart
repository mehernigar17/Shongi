import 'package:flutter_test/flutter_test.dart';
import 'package:shongi/features/dev_tools/services/demo_history_generator.dart';
import 'package:shongi/features/insights/models/wellness_insight.dart';
import 'package:shongi/features/insights/services/wellness_insight_engine.dart';

/// The demo data only earns its place if it actually makes the app's pattern
/// detection visible. These tests pin that contract: a seeded account must
/// produce real insights on every rule the engine can fire, rather than a
/// uniformly healthy history that would make those features look broken.
void main() {
  final now = DateTime(2026, 3, 30);
  final history = const DemoHistoryGenerator().generate(now);

  group('DemoHistoryGenerator', () {
    test('fills enough days for the 7/30/90-day ranges and insight window', () {
      expect(
        history.logs.length,
        greaterThanOrEqualTo(70),
        reason: 'statistics ranges need real coverage',
      );
      expect(history.periods, isNotEmpty);
    });

    test('is deterministic for a given day', () {
      final again = const DemoHistoryGenerator().generate(now);
      expect(again.logs.length, history.logs.length);
      expect(
        again.logs.map((l) => '${l.date}|${l.sleepHours}|${l.mood}'),
        history.logs.map((l) => '${l.date}|${l.sleepHours}|${l.mood}'),
      );
      expect(
        again.periods.map((p) => p.startDate),
        history.periods.map((p) => p.startDate),
      );
    });

    test('leaves a few recent days unlogged so gap nudges can fire', () {
      final loggedDays =
          history.logs.map((l) => l.date.toIso8601String()).toSet();
      final missing = <DateTime>[];
      for (var ago = 1; ago <= 14; ago++) {
        final day = now.subtract(Duration(days: ago));
        final midnight = DateTime(day.year, day.month, day.day);
        if (!loggedDays.contains(midnight.toIso8601String())) {
          missing.add(midnight);
        }
      }
      expect(missing, isNotEmpty);
    });

    test('produces a plausible irregular cycle length for the pattern card', () {
      final starts = history.periods.map((p) => p.startDate).toList()..sort();
      expect(starts.length, greaterThanOrEqualTo(4));
      for (var i = 1; i < starts.length; i++) {
        final gap = starts[i].difference(starts[i - 1]).inDays;
        expect(gap, inInclusiveRange(25, 33));
      }
    });
  });

  group('Seeded history exercises the insight engine', () {
    late List<WellnessInsight> insights;

    setUpAll(() {
      insights = const WellnessInsightEngine().build(history.logs, now: now);
    });

    test('surfaces multiple insights for a seeded account', () {
      expect(insights.length, greaterThan(1));
    });

    test('catches the falling sleep trend and short nights', () {
      final titles = insights.map((i) => i.title).toList();
      expect(
        titles.any((t) => t.toLowerCase().contains('sleep')),
        isTrue,
        reason: 'seeded data is meant to show the sleep rules firing: $titles',
      );
    });

    test('catches the low-mood run and recurring symptom', () {
      final text =
          insights.map((i) => '${i.title} ${i.detail}').join(' ').toLowerCase();
      expect(
        text.contains('mood') || text.contains('feel'),
        isTrue,
        reason: 'low-mood streak should be visible: $text',
      );
      expect(
        text.contains('headache') || text.contains('symptom'),
        isTrue,
        reason: 'recurring symptom should be visible: $text',
      );
    });
  });
}