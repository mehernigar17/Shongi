import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../logs/models/daily_log.dart';
import '../models/wellness_insight.dart';
import '../repositories/wellness_insight_repository.dart';
import '../services/wellness_insight_engine.dart';

/// Reads the user's own logs and runs the local insight engine over them.
///
/// The window is a fixed 30 days rather than the statistics range chips,
/// because patterns such as a downward sleep trend need more history than a
/// 7-day chart window offers.
class FirestoreWellnessInsightRepository implements WellnessInsightRepository {
  FirestoreWellnessInsightRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    WellnessInsightEngine? engine,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _engine = engine ?? const WellnessInsightEngine();

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final WellnessInsightEngine _engine;

  static const int lookbackDays = 30;

  @override
  Future<List<WellnessInsight>> loadInsights() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const [];

    final now = DateTime.now();
    // Midnight of the first day in the window, so a log saved at 00:00:00 on
    // the boundary day is included. Logs store dates as ISO-8601 strings, which
    // sort lexicographically in chronological order.
    final from = DateTime(now.year, now.month, now.day - (lookbackDays - 1));

    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('logs')
        .where('date', isGreaterThanOrEqualTo: from.toIso8601String())
        .get();

    final logs = snapshot.docs
        .map((d) => DailyLog.fromMap(d.id, d.data()))
        .toList();

    return _engine.build(logs, now: now);
  }
}
