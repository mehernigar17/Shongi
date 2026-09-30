import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'demo_history_generator.dart';

/// Writes the generated demo history for the signed-in user so every screen has
/// something real to show on a fresh emulator install or a new account.
///
/// This is a development helper and is only reachable from debug builds. It
/// writes through the same document shapes and `users/{uid}` paths the app
/// reads, so nothing downstream needs to treat the data specially.
class DemoDataService {
  DemoDataService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    DemoHistoryGenerator? generator,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _generator = generator ?? const DemoHistoryGenerator();

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final DemoHistoryGenerator _generator;

  /// Marks every document this service writes, so seeding twice overwrites
  /// instead of duplicating, and clearing only removes demo rows.
  static const String idPrefix = 'seed_';

  /// Firestore accepts at most 500 operations per batch.
  static const int maxBatchSize = 450;

  String? get _uid => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> _logs() =>
      _firestore.collection('users').doc(_uid!).collection('logs');

  CollectionReference<Map<String, dynamic>> _periods() =>
      _firestore.collection('users').doc(_uid!).collection('periods');

  /// Seeds logs, periods and the profile. Returns a short summary for the UI.
  Future<String> seed() async {
    final uid = _uid;
    if (uid == null) {
      throw StateError('Sign in before seeding demo data.');
    }

    final today = DateTime.now();
    final history = _generator.generate(today);

    await _writeLogs(history);
    await _writePeriods(history);
    await _writeProfile(uid, today, history);

    final skipped = DemoHistoryGenerator.logDays - history.logs.length;
    return 'Seeded ${history.logs.length} logs and '
        '${history.periods.length} periods'
        '${skipped > 0 ? ' · $skipped days left blank on purpose' : ''}.';
  }

  /// Removes only the documents this service created, leaving any real data
  /// the user entered themselves untouched.
  Future<String> clear() async {
    final uid = _uid;
    if (uid == null) {
      throw StateError('Sign in before clearing demo data.');
    }

    final removed =
        await _deleteSeeded(_logs()) + await _deleteSeeded(_periods());
    await _firestore.collection('users').doc(uid).set({
      'demoSeededAt': FieldValue.delete(),
      'demoSeedDay': FieldValue.delete(),
    });
    return 'Removed $removed demo documents.';
  }

  Future<void> _writeLogs(DemoHistory history) async {
    final rows = history.logs
        .map((log) => {
              'id': '$idPrefix${_dateKey(log.date)}',
              ...log.toMap(),
            })
        .toList();
    await _writeInBatches(_logs(), rows);
  }

  Future<void> _writePeriods(DemoHistory history) async {
    final rows = history.periods
        .map((period) => {
              'id': '$idPrefix${_dateKey(period.startDate)}',
              ...period.toMap(),
            })
        .toList();
    await _writeInBatches(_periods(), rows);
  }

  Future<void> _writeInBatches(
    CollectionReference<Map<String, dynamic>> target,
    List<Map<String, dynamic>> rows,
  ) async {
    for (var start = 0; start < rows.length; start += maxBatchSize) {
      final end = math.min(start + maxBatchSize, rows.length);
      final batch = _firestore.batch();
      for (final row in rows.sublist(start, end)) {
        batch.set(target.doc(row['id'] as String), {...row}..remove('id'));
      }
      await batch.commit();
    }
  }

  Future<int> _deleteSeeded(
    CollectionReference<Map<String, dynamic>> target,
  ) async {
    final snapshot = await target.get();
    final seeded =
        snapshot.docs.where((doc) => doc.id.startsWith(idPrefix)).toList();
    if (seeded.isEmpty) return 0;

    for (var start = 0; start < seeded.length; start += maxBatchSize) {
      final end = math.min(start + maxBatchSize, seeded.length);
      final batch = _firestore.batch();
      for (final doc in seeded.sublist(start, end)) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }
    return seeded.length;
  }

  /// Gives the account a visible identity and a last-period date so the
  /// dashboard and cycle screens are not empty.
  Future<void> _writeProfile(
    String uid,
    DateTime today,
    DemoHistory history,
  ) async {
    final latest = history.periods.first;

    await _firestore.collection('users').doc(uid).set({
      'displayName': 'Ayesha Rahman',
      'onboardingCompleted': true,
      'name': 'Ayesha Rahman',
      'age': 27,
      'weightKg': 58.4,
      'heightCm': 162.0,
      'skinType': 'Combination',
      'cycleType': 'Regular',
      'selfCareDay': 'Sunday',
      'medications': '',
      'lastPeriodStart': latest.startDate.toIso8601String(),
      'lastPeriodEnd': latest.endDate.toIso8601String(),
      'demoSeededAt': FieldValue.serverTimestamp(),
      'demoSeedDay': _dateKey(today),
    }, SetOptions(merge: true));
  }

  static String _dateKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}