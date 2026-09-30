import '../models/skincare_routine.dart';
import '../repositories/skincare_repository.dart';
import 'skincare_catalog.dart';

class MockSkincareRepository implements SkincareRepository {
  String _activeRoutineId = '';
  DateTime? _startedAt;

  @override
  Future<List<SkincareRoutine>> loadRoutines() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return skincareCatalog
        .map((routine) => routine.copyWith(isActive: routine.id == _activeRoutineId))
        .toList();
  }

  @override
  Future<String> getPersonalizedSkinType() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return 'Normal Skin';
  }

  @override
  Future<void> saveActiveRoutine(String routineId, {DateTime? startedAt}) async {
    await Future.delayed(const Duration(milliseconds: 50));
    _activeRoutineId = routineId;
    if (routineId.isEmpty) {
      _startedAt = null;
    } else {
      _startedAt = startedAt ?? DateTime.now();
    }
  }

  @override
  Future<DateTime?> loadActiveRoutineStartedAt() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _activeRoutineId.isEmpty ? null : _startedAt;
  }
}