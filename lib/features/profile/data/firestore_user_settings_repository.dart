import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../repositories/user_settings_repository.dart';

/// Firestore implementation of [UserSettingsRepository].
/// Reads/writes the signed-in user's own `users/{uid}` document.
class FirestoreUserSettingsRepository implements UserSettingsRepository {
  FirestoreUserSettingsRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _doc() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw StateError('No signed-in user to update settings.');
    }
    return _firestore.collection('users').doc(uid);
  }

  Future<void> _update(Map<String, dynamic> data) async {
    await _doc().set(data, SetOptions(merge: true));
  }

  @override
  Future<Map<String, dynamic>> loadSettings() async {
    final doc = await _doc().get();
    return doc.data() ?? {};
  }

  @override
  Future<void> updateName(String name) async {
    await _update({'name': name, 'displayName': name});
  }

  @override
  Future<void> updateCycleDetails({
    int? avgCycleLength,
    DateTime? lastPeriod,
    String? cycleType,
    String? pcosDiagnosis,
  }) async {
    final data = <String, dynamic>{};
    if (avgCycleLength != null) data['avgCycleLength'] = avgCycleLength;
    if (lastPeriod != null) {
      data['lastPeriodStart'] = lastPeriod.toIso8601String();
    }
    if (cycleType != null) data['cycleType'] = cycleType;
    if (pcosDiagnosis != null) data['pcosDiagnosis'] = pcosDiagnosis;
    if (data.isNotEmpty) await _update(data);
  }

  @override
  Future<void> updateGoals(List<String> goals) async {
    await _update({'goals': goals});
  }

  @override
  Future<void> updatePreferences({
    bool? dailyReminders,
    bool? notificationsEnabled,
    bool? privacyEnabled,
  }) async {
    final data = <String, dynamic>{};
    if (dailyReminders != null) data['dailyReminders'] = dailyReminders;
    if (notificationsEnabled != null) {
      data['notificationsEnabled'] = notificationsEnabled;
    }
    if (privacyEnabled != null) data['privacyEnabled'] = privacyEnabled;
    if (data.isNotEmpty) await _update(data);
  }

  @override
  Future<void> updateActiveRoutine(
    String kind,
    String routineId, {
    DateTime? startedAt,
  }) async {
    final idField =
        kind == 'skincare' ? 'activeSkincareRoutine' : 'activeHaircareRoutine';
    final startedAtField = kind == 'skincare'
        ? 'activeSkincareRoutineStartedAt'
        : 'activeHaircareRoutineStartedAt';

    if (routineId.isEmpty) {
      // Clearing the plan must clear its clock too, otherwise a later start
      // would inherit a stale start date.
      await _update({
        idField: FieldValue.delete(),
        startedAtField: FieldValue.delete(),
      });
      return;
    }

    final data = <String, dynamic>{idField: routineId};
    if (startedAt != null) {
      data[startedAtField] = startedAt.toIso8601String();
    }
    await _update(data);
  }

  @override
  Future<DateTime?> loadActiveRoutineStartedAt(String kind) async {
    final field = kind == 'skincare'
        ? 'activeSkincareRoutineStartedAt'
        : 'activeHaircareRoutineStartedAt';
    final data = await loadSettings();
    return _parseDate(data[field]);
  }

  /// Firestore dates in this app are stored as ISO-8601 strings.
  static DateTime? _parseDate(Object? value) {
    if (value is! String || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }
}