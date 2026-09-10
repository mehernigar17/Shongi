import '../models/haircare_routine.dart';

abstract class HaircareRepository {
  Future<List<HaircareRoutine>> loadRoutines();
  Future<String> getPersonalizedPlanTitle();
  Future<void> saveActiveRoutine(String routineId);
}