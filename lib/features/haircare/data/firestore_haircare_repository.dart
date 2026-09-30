import '../../profile/data/firestore_user_settings_repository.dart';
import '../models/haircare_routine.dart';
import '../repositories/haircare_repository.dart';
import 'haircare_catalog.dart';

/// Haircare repository backed by Firestore.
///
/// The routine catalog is static content (`haircareCatalog`), but the *active*
/// plan and its start date come from the signed-in user's own profile
/// (`users/{uid}`).
class FirestoreHaircareRepository implements HaircareRepository {
  FirestoreHaircareRepository({FirestoreUserSettingsRepository? settings})
      : _settings = settings ?? FirestoreUserSettingsRepository();

  final FirestoreUserSettingsRepository _settings;

  @override
  Future<List<HaircareRoutine>> loadRoutines() async {
    final data = await _settings.loadSettings();
    final activeId = data['activeHaircareRoutine'] as String? ?? '';
    return haircareCatalog
        .map((routine) => routine.copyWith(isActive: routine.id == activeId))
        .toList();
  }

  @override
  Future<String> getPersonalizedPlanTitle() async {
    final data = await _settings.loadSettings();
    final cycleType = data['cycleType'] as String? ?? 'Regular';
    return cycleType == 'Irregular' ? 'Hair & Scalp Care' : 'Hair & Scalp Care';
  }

  @override
  Future<void> saveActiveRoutine(String routineId, {DateTime? startedAt}) async {
    await _settings.updateActiveRoutine(
      'haircare',
      routineId,
      startedAt: startedAt,
    );
  }

  @override
  Future<DateTime?> loadActiveRoutineStartedAt() async {
    final startedAt = await _settings.loadActiveRoutineStartedAt('haircare');
    if (startedAt != null) return startedAt;

    // Plans activated before the weekly clock existed have no start date.
    // Anchor them to today so their plan starts at week 1 instead of reading
    // as finished.
    final data = await _settings.loadSettings();
    final activeId = data['activeHaircareRoutine'] as String? ?? '';
    if (activeId.isEmpty) return null;

    final now = DateTime.now();
    await _settings.updateActiveRoutine('haircare', activeId, startedAt: now);
    return now;
  }
}