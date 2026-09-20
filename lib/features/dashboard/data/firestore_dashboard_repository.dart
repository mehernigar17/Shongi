import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../logs/models/daily_log.dart';
import '../../onboarding/models/user_profile.dart';
import '../../periods/models/period_entry.dart';
import '../models/dashboard_data.dart';
import '../repositories/dashboard_repository.dart';

/// Loads the home screen data from the signed-in user's Firestore records:
/// profile (`users/{uid}`), periods (`users/{uid}/periods`) and logs
/// (`users/{uid}/logs`).
class FirestoreDashboardRepository implements DashboardRepository {
  FirestoreDashboardRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  String? get _uid => _auth.currentUser?.uid;

  @override
  Future<DashboardData> load() async {
    final uid = _uid;
    if (uid == null) return DashboardData.empty();

    final userRef = _firestore.collection('users').doc(uid);

    final profileDoc = await userRef.get();
    final profileData = profileDoc.data();
    final profile = (profileData != null && profileData['onboardingCompleted'] == true)
        ? UserProfile.fromMap(profileData)
        : null;

    final periodsSnap = await userRef.collection('periods').get();
    final periods = periodsSnap.docs
        .map((d) => PeriodEntry.fromMap(d.id, d.data()))
        .toList();

    final logsSnap = await userRef.collection('logs').get();
    final logs = logsSnap.docs
        .map((d) => DailyLog.fromMap(d.id, d.data()))
        .toList();

    return DashboardData.compute(
      profile: profile,
      periods: periods,
      logs: logs,
    );
  }
}