import '../models/haircare_routine.dart';
import '../repositories/haircare_repository.dart';
import 'haircare_catalog.dart';

class MockHaircareRepository implements HaircareRepository {
  String _activeRoutineId = '';
  DateTime? _startedAt;

  @override
  Future<List<HaircareRoutine>> loadRoutines() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return haircareCatalog
        .map((routine) => routine.copyWith(isActive: routine.id == _activeRoutineId))
        .toList();
  }

  @override
  Future<String> getPersonalizedPlanTitle() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return 'Hair & Scalp Care';
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