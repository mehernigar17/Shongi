import '../../logs/models/daily_log.dart';
import '../../onboarding/models/user_profile.dart';
import '../../periods/models/period_entry.dart';

/// Everything the home screen needs, computed from the signed-in user's
/// real Firestore records (profile + periods + logs).
class DashboardData {
  final String userName;
  final UserProfile? profile;

  // Cycle
  final int cycleDay; // 1-based day of the current cycle
  final int avgCycleLength; // days
  final int avgPeriodDuration; // days (from real logged periods)
  final int daysUntilNextPeriod;
  final DateTime? nextPeriodDate;
  final DateTime? lastPeriodStart;
  final String cycleStatusLabel;

  // Logs
  final int logsThisMonth;
  final int logsLast30Days;
  final double avgSleepLast7;

  // Insights
  final String insightTitle;
  final String insightBody;
  final String insightTip;

  final List<PeriodEntry> recentPeriods;
  final List<DailyLog> recentLogs;

  const DashboardData({
    required this.userName,
    this.profile,
    this.cycleDay = 1,
    this.avgCycleLength = 28,
    this.avgPeriodDuration = 5,
    this.daysUntilNextPeriod = 0,
    this.nextPeriodDate,
    this.lastPeriodStart,
    this.cycleStatusLabel = 'No cycle data yet',
    this.logsThisMonth = 0,
    this.logsLast30Days = 0,
    this.avgSleepLast7 = 0,
    this.insightTitle = 'Start logging your day',
    this.insightBody = 'Track sleep, mood, food and health to unlock personalized insights.',
    this.insightTip = 'Tap Start Logging to add today\'s entry',
    this.recentPeriods = const [],
    this.recentLogs = const [],
  });

  factory DashboardData.empty() => const DashboardData(userName: '');

  /// Builds the dashboard from real records.
  factory DashboardData.compute({
    required UserProfile? profile,
    required List<PeriodEntry> periods,
    required List<DailyLog> logs,
    int? profileAvgCycleLength,
  }) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // ── Cycle math ──────────────────────────────────────────────
    final sorted = [...periods]..sort((a, b) => a.startDate.compareTo(b.startDate));
    final recentPeriods = sorted.reversed.take(6).toList();

    // Average cycle length from real gaps between period starts.
    // Falls back to the user's profile setting, then 28.
    int avgCycle = profileAvgCycleLength ?? 28;
    if (sorted.length >= 2) {
      final diffs = <int>[];
      for (var i = 1; i < sorted.length; i++) {
        final diff = sorted[i].startDate.difference(sorted[i - 1].startDate).inDays;
        if (diff > 0) diffs.add(diff);
      }
      if (diffs.isNotEmpty) {
        avgCycle = (diffs.reduce((a, b) => a + b) / diffs.length).round();
      }
    }

    // Average period duration from real logged start/end dates.
    int avgDuration = 5;
    if (sorted.isNotEmpty) {
      final durations = sorted.map((p) => p.durationDays).toList();
      avgDuration = (durations.reduce((a, b) => a + b) / durations.length).round();
    }

    DateTime? lastStart;
    if (sorted.isNotEmpty) {
      lastStart = DateTime(
        sorted.last.startDate.year,
        sorted.last.startDate.month,
        sorted.last.startDate.day,
      );
    }

    int cycleDay = 1;
    int daysUntilNext = 0;
    DateTime? nextPeriod;
    String cycleStatusLabel = 'No cycle data yet';

    if (lastStart != null) {
      cycleDay = today.difference(lastStart).inDays + 1;
      nextPeriod = lastStart.add(Duration(days: avgCycle));
      daysUntilNext = nextPeriod.difference(today).inDays;
      if (daysUntilNext < 0) daysUntilNext = 0;
      cycleStatusLabel = 'Next period in ~$daysUntilNext days';
    }

    // ── Log stats ───────────────────────────────────────────────
    final monthStart = DateTime(today.year, today.month, 1);
    final logsThisMonth = logs.where((l) => !l.date.isBefore(monthStart)).length;
    final cutoff30 = today.subtract(const Duration(days: 30));
    final last30 = logs.where((l) => !l.date.isBefore(cutoff30)).toList();
    final last7 = logs.where((l) => !l.date.isBefore(today.subtract(const Duration(days: 7)))).toList();

    double avgSleep = 0;
    if (last7.isNotEmpty) {
      final withSleep = last7.where((l) => l.sleepHours > 0).toList();
      if (withSleep.isNotEmpty) {
        avgSleep = withSleep.map((l) => l.sleepHours).reduce((a, b) => a + b) / withSleep.length;
      }
    }

    // ── Insights ────────────────────────────────────────────────
    String insightTitle;
    String insightBody;
    String insightTip;

    if (logs.isEmpty) {
      insightTitle = 'Start logging your day';
      insightBody = 'Track sleep, mood, food and health to unlock personalized insights.';
      insightTip = 'Tap Start Logging to add today\'s entry';
    } else if (avgSleep > 0 && avgSleep < 7) {
      insightTitle = 'You slept less than usual 🌙';
      insightBody = 'Try maintaining 7-8 hours for better cycle balance and hormone health.';
      insightTip = 'Try a 10 min wind-down routine';
    } else if (avgSleep >= 7) {
      insightTitle = 'Great sleep streak 💜';
      insightBody = 'You averaged ${avgSleep.toStringAsFixed(1)}h of sleep this week. Keep it up!';
      insightTip = 'Consistent sleep supports cycle regularity';
    } else {
      insightTitle = 'Keep logging to see insights';
      insightBody = 'Add a few more days of logs and we\'ll spot your patterns.';
      insightTip = 'Logs are saved to your private account';
    }

    return DashboardData(
      userName: profile?.name.isNotEmpty == true ? profile!.name : '',
      profile: profile,
      cycleDay: cycleDay,
      avgCycleLength: avgCycle,
      avgPeriodDuration: avgDuration,
      daysUntilNextPeriod: daysUntilNext,
      nextPeriodDate: nextPeriod,
      lastPeriodStart: lastStart,
      cycleStatusLabel: cycleStatusLabel,
      logsThisMonth: logsThisMonth,
      logsLast30Days: last30.length,
      avgSleepLast7: avgSleep,
      insightTitle: insightTitle,
      insightBody: insightBody,
      insightTip: insightTip,
      recentPeriods: recentPeriods,
      recentLogs: last30,
    );
  }
}