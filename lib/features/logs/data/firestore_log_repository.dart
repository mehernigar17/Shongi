import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/daily_log.dart';
import '../repositories/log_repository.dart';

/// Persists daily wellness logs in Firestore under `users/{uid}/logs`.
/// Every operation is scoped to the signed-in user.
class FirestoreLogRepository implements LogRepository {
  FirestoreLogRepository({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  String? get _uid => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> _collection() {
    final uid = _uid;
    if (uid == null) {
      throw StateError('No signed-in user to access logs.');
    }
    return _firestore.collection('users').doc(uid).collection('logs');
  }

  @override
  Future<List<DailyLog>> loadLogs({DateTime? from, DateTime? to}) async {
    var query = _collection().orderBy('date', descending: true);
    if (from != null) {
      query = query.where('date', isGreaterThanOrEqualTo: from.toIso8601String());
    }
    if (to != null) {
      query = query.where('date', isLessThanOrEqualTo: to.toIso8601String());
    }
    final snap = await query.get();
    return snap.docs.map((d) => DailyLog.fromMap(d.id, d.data())).toList();
  }

  @override
  Future<void> saveLog(DailyLog log) async {
    final dateKey = log.date.toIso8601String();
    // One log per day: update the existing entry if present.
    final existing = await _collection()
        .where('date', isEqualTo: dateKey)
        .limit(1)
        .get();
    if (existing.docs.isNotEmpty) {
      await existing.docs.first.reference.update(log.toMap());
    } else {
      await _collection().add(log.toMap());
    }
  }

  @override
  Future<void> deleteLog(String id) async {
    await _collection().doc(id).delete();
  }
}