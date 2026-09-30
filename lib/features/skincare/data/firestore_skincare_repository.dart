import '../../profile/data/firestore_user_settings_repository.dart';
import '../models/skincare_routine.dart';
import '../repositories/skincare_repository.dart';
import 'skincare_catalog.dart';

/// Skincare repository backed by Firestore.
///
/// The routine catalog is static content (`skincareCatalog`), but the *active*
/// plan, its start date and the personalized skin type come from the signed-in
/// user's own profile (`users/{uid}`), so each user sees their own state.
class FirestoreSkincareRepository implements SkincareRepository {
  FirestoreSkincareRepository({FirestoreUserSettingsRepository? settings})
      : _settings = settings ?? FirestoreUserSettingsRepository();

  final FirestoreUserSettingsRepository _settings;

  @override
  Future<List<SkincareRoutine>> loadRoutines() async {
    final data = await _settings.loadSettings();
    final activeId = data['activeSkincareRoutine'] as String? ?? '';
    return skincareCatalog
        .map((routine) => routine.copyWith(isActive: routine.id == activeId))
        .toList();
  }

  @override
  Future<String> getPersonalizedSkinType() async {
    final data = await _settings.loadSettings();
    final skinType = data['skinType'] as String? ?? 'Combination';
    return '$skinType Skin';
  }

  @override
  Future<void> saveActiveRoutine(String routineId, {DateTime? startedAt}) async {
    await _settings.updateActiveRoutine(
      'skincare',
      routineId,
      startedAt: startedAt,
    );
  }

  @override
  Future<DateTime?> loadActiveRoutineStartedAt() async {
    final startedAt = await _settings.loadActiveRoutineStartedAt('skincare');
    if (startedAt != null) return startedAt;

    // Plans activated before the weekly clock existed have no start date.
    // Anchor them to today so their plan starts at week 1 instead of reading
    // as finished.
    final data = await _settings.loadSettings();
    final activeId = data['activeSkincareRoutine'] as String? ?? '';
    if (activeId.isEmpty) return null;

    final now = DateTime.now();
    await _settings.updateActiveRoutine('skincare', activeId, startedAt: now);
    return now;
  }
}