/// Settings that live on the user's own Firestore document
/// (`users/{uid}`): editable profile fields, goals, preferences and
/// active routines. All operations are scoped to the signed-in user.
abstract class UserSettingsRepository {
  Future<Map<String, dynamic>> loadSettings();
  Future<void> updateName(String name);
  Future<void> updateCycleDetails({
    int? avgCycleLength,
    DateTime? lastPeriod,
    String? cycleType,
    String? pcosDiagnosis,
  });
  Future<void> updateGoals(List<String> goals);
  Future<void> updatePreferences({
    bool? dailyReminders,
    bool? notificationsEnabled,
    bool? privacyEnabled,
  });

  /// Stores which routine of [kind] (`skincare` or `haircare`) is active.
  ///
  /// [startedAt] anchors the plan clock that drives weekly progression. Passing
  /// an empty [routineId] clears both the routine and its start date.
  Future<void> updateActiveRoutine(
    String kind,
    String routineId, {
    DateTime? startedAt,
  });

  /// Reads back the start date for the active routine of [kind].
  Future<DateTime?> loadActiveRoutineStartedAt(String kind);
}