import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../logs/models/daily_log.dart';
import '../../periods/models/period_entry.dart';
import '../models/statistics_data.dart';
import '../repositories/statistics_repository.dart';

/// Loads statistics from the signed-in user's real logs and periods.
/// rangeIndex: 0 = last 7 days, 1 = last 30 days, 2 = last 90 days.
class FirestoreStatisticsRepository implements StatisticsRepository {
  FirestoreStatisticsRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  String? get _uid => _auth.currentUser?.uid;

  @override
  Future<StatisticsData> load(int rangeIndex) async {
    final uid = _uid;
    if (uid == null) return const StatisticsData();

    final days = rangeIndex == 0 ? 7 : (rangeIndex == 1 ? 30 : 90);
    final now = DateTime.now();
    // Midnight of the first day of the range so logs stored at
    // 00:00:00 on the boundary day are included.
    final from = DateTime(now.year, now.month, now.day - days);
    final fromKey = from.toIso8601String();

    final userRef = _firestore.collection('users').doc(uid);

    // Run both queries in parallel.
    // Logs are range-filtered (sleep/mood are daily metrics), but periods
    // are loaded from the FULL history: a cycle length needs two period
    // starts, so a 7/30-day window would almost never contain one.
    final results = await Future.wait([
      userRef
          .collection('logs')
          .where('date', isGreaterThanOrEqualTo: fromKey)
          .get(),
      userRef.collection('periods').get(),
    ]);

    final logs = results[0].docs
        .map((d) => DailyLog.fromMap(d.id, d.data()))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    final periods = results[1].docs
        .map((d) => PeriodEntry.fromMap(d.id, d.data()))
        .toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    // Cycle lengths between consecutive period starts (within the range).
    final cycleDays = <double>[];
    for (var i = 1; i < periods.length; i++) {
      final diff = periods[i].startDate
          .difference(periods[i - 1].startDate)
          .inDays;
      if (diff > 0) cycleDays.add(diff.toDouble());
    }

    return StatisticsData(
      sleepHours: logs.where((l) => l.sleepHours > 0).map((l) => l.sleepHours).toList(),
      cycleDays: cycleDays,
      moods: logs.where((l) => l.mood.isNotEmpty).map((l) => l.mood).toList(),
    );
  }
}