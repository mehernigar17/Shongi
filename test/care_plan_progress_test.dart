import 'package:flutter_test/flutter_test.dart';
import 'package:shongi/features/care_plan/care_plan_progress.dart';

void main() {
  group('computeCarePlanProgress', () {
    final start = DateTime(2026, 9, 1);

    test('day 1 is the first day of week 1', () {
      final progress = computeCarePlanProgress(
        startedAt: start,
        totalWeeks: 4,
        now: DateTime(2026, 9, 1),
      );

      expect(progress, isNotNull);
      expect(progress!.weekNumber, 1);
      expect(progress.dayInWeek, 1);
      expect(progress.daysRemaining, 6);
      expect(progress.isPlanFinished, isFalse);
      expect(progress.weekLabel, 'Week 1 of 4');
    });

    test('day 7 is still week 1', () {
      final progress = computeCarePlanProgress(
        startedAt: start,
        totalWeeks: 4,
        now: DateTime(2026, 9, 7),
      )!;

      expect(progress.weekNumber, 1);
      expect(progress.dayInWeek, 7);
      expect(progress.daysRemaining, 0);
    });

    test('day 8 rolls over to week 2', () {
      final progress = computeCarePlanProgress(
        startedAt: start,
        totalWeeks: 4,
        now: DateTime(2026, 9, 8),
      )!;

      expect(progress.weekNumber, 2);
      expect(progress.dayInWeek, 1);
      expect(progress.daysRemaining, 6);
    });

    test('advances exactly one week every 7 days', () {
      for (var week = 1; week <= 4; week++) {
        final now = start.add(Duration(days: (week - 1) * 7));
        final progress = computeCarePlanProgress(
          startedAt: start,
          totalWeeks: 4,
          now: now,
        )!;

        expect(
          progress.weekNumber,
          week,
          reason: 'expected week $week after ${(week - 1) * 7} days',
        );
      }
    });

    test('clamps to the last week and reports the plan as finished', () {
      final progress = computeCarePlanProgress(
        startedAt: start,
        totalWeeks: 4,
        // 35 days in: a full 4-week plan plus one more day.
        now: start.add(const Duration(days: 35)),
      )!;

      expect(progress.weekNumber, 4, reason: 'must not exceed totalWeeks');
      expect(progress.isPlanFinished, isTrue);
    });

    test('a start date in the future is treated as day 1', () {
      final progress = computeCarePlanProgress(
        startedAt: DateTime(2026, 9, 10),
        totalWeeks: 4,
        now: DateTime(2026, 9, 1),
      )!;

      expect(progress.weekNumber, 1);
      expect(progress.dayInWeek, 1);
    });

    test('returns null when the plan has no weeks', () {
      final progress = computeCarePlanProgress(
        startedAt: start,
        totalWeeks: 0,
        now: DateTime(2026, 9, 1),
      );

      expect(progress, isNull);
    });

    test('the time of day does not shift the day count', () {
      final morning = computeCarePlanProgress(
        startedAt: start,
        totalWeeks: 4,
        now: DateTime(2026, 9, 8, 1),
      )!;
      final lateAtNight = computeCarePlanProgress(
        startedAt: start,
        totalWeeks: 4,
        now: DateTime(2026, 9, 8, 23, 59),
      )!;

      expect(morning.weekNumber, lateAtNight.weekNumber);
      expect(morning.dayInWeek, lateAtNight.dayInWeek);
    });

    test('fractions stay within 0..1 across the whole plan', () {
      for (var days = 0; days <= 40; days++) {
        final progress = computeCarePlanProgress(
          startedAt: start,
          totalWeeks: 4,
          now: start.add(Duration(days: days)),
        )!;

        expect(progress.planFraction, inInclusiveRange(0.0, 1.0));
        expect(progress.weekFraction, inInclusiveRange(0.0, 1.0));
      }
    });

    test('the final day of the last week reads as 100% complete', () {
      final progress = computeCarePlanProgress(
        startedAt: start,
        totalWeeks: 4,
        now: start.add(const Duration(days: 27)), // day 28 = last day
      )!;

      expect(progress.weekNumber, 4);
      expect(progress.planFraction, closeTo(1.0, 0.0001));
    });
  });
}