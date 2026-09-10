import '../models/skincare_routine.dart';

abstract class SkincareRepository {
  Future<List<SkincareRoutine>> loadRoutines();
  Future<String> getPersonalizedSkinType();
  Future<void> saveActiveRoutine(String routineId);
}
