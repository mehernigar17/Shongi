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
  Future<void> updateActiveRoutine(String kind, String routineId);
}