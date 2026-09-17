import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_profile.dart';
import '../repositories/profile_repository.dart';

/// Persists the onboarding profile in Firestore under `users/{uid}`.
///
/// The same document also carries the `onboardingCompleted` flag that
/// AuthWrapper reads to decide between onboarding and the dashboard.
class FirestoreProfileRepository implements ProfileRepository {
  FirestoreProfileRepository({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  String? get _uid => _auth.currentUser?.uid;

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _firestore.collection('users').doc(uid);

  @override
  Future<UserProfile?> load() async {
    final uid = _uid;
    if (uid == null) return null;
    final doc = await _doc(uid).get();
    if (!doc.exists) return null;
    final data = doc.data();
    if (data == null) return null;
    // Only treat it as a completed profile if onboarding actually finished.
    if (data['onboardingCompleted'] != true) return null;
    return UserProfile.fromMap(data);
  }

  @override
  Future<void> save(UserProfile profile) async {
    final uid = _uid;
    if (uid == null) {
      throw StateError('No signed-in user to save the profile for.');
    }
    await _doc(uid).set({
      ...profile.toMap(),
      'onboardingCompleted': true,
      'completedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}