/// Shared weekly-progression logic for the skincare and haircare care plans.
///
/// A care plan is a fixed list of weekly phases. Which phase the user is on is
/// derived from how long ago they started the plan, so the plan advances on its
/// own after every 7 days — no scheduled job, no manual bookkeeping, and the
/// stored state stays a single start date.
class CarePlanProgress {
  const CarePlanProgress({
    required this.weekNumber,
    required this.totalWeeks,
    required this.dayInWeek,
    this.isPlanFinished = false,
  });

  /// Days in one phase. A phase advances after a full calendar week.
  static const int weekLengthInDays = 7;

  /// 1-based week the user is currently on, clamped to [totalWeeks].
  final int weekNumber;
  final int totalWeeks;

  /// 1..7 — how far into the current week the user is.
  final int dayInWeek;

  /// True once every week of the plan has been worked through.
  final bool isPlanFinished;

  int get daysRemaining => weekLengthInDays - dayInWeek;
  int get weeksCompleted => weekNumber - 1;

  /// 0..1 progress through the current week.
  double get weekFraction => dayInWeek / weekLengthInDays;

  /// 0..1 progress through the whole plan.
  double get planFraction {
    if (totalWeeks <= 0) return 0;
    final done = weeksCompleted + weekFraction;
    return done / totalWeeks;
  }

  /// Short label for the header, e.g. `Week 2 of 4`.
  String get weekLabel => 'Week $weekNumber of $totalWeeks';

  /// Short label for the current week position, e.g. `Day 3 of 7`.
  String get dayLabel => 'Day $dayInWeek of $weekLengthInDays';
}

/// Computes which weekly phase a care plan is currently on.
///
/// Returns `null` when there is nothing to show — a plan with no weeks. A start
/// date in the future (device clock moved backwards, or a stale write) is
/// treated as day 1 instead of throwing the plan off.
CarePlanProgress? computeCarePlanProgress({
  required DateTime startedAt,
  required int totalWeeks,
  DateTime? now,
}) {
  if (totalWeeks <= 0) return null;

  final today = _dateOnly(now ?? DateTime.now());
  final start = _dateOnly(startedAt);

  var elapsedDays = today.difference(start).inDays;
  if (elapsedDays < 0) elapsedDays = 0;

  final weekIndex = elapsedDays ~/ CarePlanProgress.weekLengthInDays;
  final dayInWeek = elapsedDays % CarePlanProgress.weekLengthInDays + 1;

  return CarePlanProgress(
    weekNumber: (weekIndex + 1).clamp(1, totalWeeks),
    totalWeeks: totalWeeks,
    dayInWeek: dayInWeek,
    isPlanFinished: weekIndex >= totalWeeks,
  );
}

/// Strips the time component so progression is measured in whole days.
DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);