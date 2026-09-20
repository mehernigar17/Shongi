import '../../logs/models/daily_log.dart';
import '../../onboarding/models/user_profile.dart';
import '../../periods/models/period_entry.dart';

/// Computed health summary shown in the doctor report preview.
/// Built from the signed-in user's real Firestore records.
class ReportData {
  final String cycleHistory;
  final String mainSymptoms;
  final String lifestyle;
  final String last30Days;
  final String updatedLabel;

  const ReportData({
    required this.cycleHistory,
    required this.mainSymptoms,
    required this.lifestyle,
    required this.last30Days,
    this.updatedLabel = 'Updated Today',
  });

  factory ReportData.empty() => const ReportData(
        cycleHistory: 'No cycle data yet',
        mainSymptoms: 'No symptoms logged yet',
        lifestyle: 'Log your day to build lifestyle insights',
        last30Days: '0 logs completed',
      );

  /// Builds the report from the user's real records:
  /// profile (cycle type / avg length), period entries (cycle history)
  /// and daily logs (symptoms, sleep, activity in the last 30 days).
  factory ReportData.compute({
    UserProfile? profile,
    List<DailyLog> logs = const [],
    List<PeriodEntry> periods = const [],
    DateTime? now,
  }) {
    final today = now ?? DateTime.now();

    // ── Cycle history ──────────────────────────────────────────────
    String cycleHistory;
    final sortedPeriods = [...periods]..sort((a, b) => b.startDate.compareTo(a.startDate));
    if (sortedPeriods.length >= 2) {
      final gaps = <int>[];
      for (var i = 0; i < sortedPeriods.length - 1; i++) {
        final gap = sortedPeriods[i].startDate
            .difference(sortedPeriods[i + 1].startDate)
            .inDays;
        if (gap > 0) gaps.add(gap);
      }
      if (gaps.isNotEmpty) {
        final avg = (gaps.reduce((a, b) => a + b) / gaps.length).round();
        final regularity = gaps.every((g) => (g - avg).abs() <= 5)
            ? 'Regular'
            : 'Irregular';
        cycleHistory = '$regularity — avg $avg days';
      } else {
        cycleHistory = '1 period logged — keep tracking';
      }
    } else if (sortedPeriods.isNotEmpty) {
      cycleHistory = '1 period logged — keep tracking';
    } else if (profile?.cycleType.isNotEmpty == true) {
      cycleHistory = '${profile!.cycleType} cycle — no periods logged yet';
    } else {
      cycleHistory = 'No cycle data yet';
    }

    // ── Main symptoms ──────────────────────────────────────────────
    final symptomCounts = <String, int>{};
    for (final log in logs) {
      for (final s in log.symptoms) {
        symptomCounts[s] = (symptomCounts[s] ?? 0) + 1;
      }
    }
    for (final p in periods) {
      for (final s in p.symptoms) {
        symptomCounts[s] = (symptomCounts[s] ?? 0) + 1;
      }
    }
    final topSymptoms = symptomCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    String mainSymptoms;
    if (topSymptoms.isEmpty) {
      mainSymptoms = 'No symptoms logged yet';
    } else {
      mainSymptoms = topSymptoms.take(3).map((e) => e.key).join(', ');
    }

    // ── Lifestyle ──────────────────────────────────────────────────
    final sleepLogs = logs.where((l) => l.sleepHours > 0).toList();
    String lifestyle;
    if (sleepLogs.isEmpty) {
      lifestyle = 'Log your day to build lifestyle insights';
    } else {
      final avgSleep =
          sleepLogs.map((l) => l.sleepHours).reduce((a, b) => a + b) / sleepLogs.length;
      final activity = avgSleep >= 7 ? 'Good sleep' : 'Low sleep';
      lifestyle = '$activity, avg ${avgSleep.toStringAsFixed(1)}h sleep';
    }

    // ── Last 30 days ───────────────────────────────────────────────
    final cutoff = today.subtract(const Duration(days: 30));
    final recentLogs = logs.where((l) => !l.date.isBefore(cutoff)).length;
    final last30Days = '$recentLogs log${recentLogs == 1 ? '' : 's'} completed';

    return ReportData(
      cycleHistory: cycleHistory,
      mainSymptoms: mainSymptoms,
      lifestyle: lifestyle,
      last30Days: last30Days,
    );
  }
}