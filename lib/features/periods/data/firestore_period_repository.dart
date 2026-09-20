import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/period_entry.dart';
import '../repositories/period_repository.dart';

/// Persists period entries in Firestore under `users/{uid}/periods`.
class FirestorePeriodRepository implements PeriodRepository {
  FirestorePeriodRepository({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  String? get _uid => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> _collection() {
    final uid = _uid;
    if (uid == null) {
      throw StateError('No signed-in user to access periods.');
    }
    return _firestore.collection('users').doc(uid).collection('periods');
  }

  @override
  Future<List<PeriodEntry>> loadPeriods() async {
    final snap = await _collection().orderBy('startDate', descending: true).get();
    return snap.docs.map((d) => PeriodEntry.fromMap(d.id, d.data())).toList();
  }

  @override
  Future<void> addPeriod(PeriodEntry entry) async {
    await _collection().add(entry.toMap());
  }

  @override
  Future<void> deletePeriod(String id) async {
    await _collection().doc(id).delete();
  }
}