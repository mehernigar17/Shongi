import '../models/haircare_routine.dart';

abstract class HaircareRepository {
  Future<List<HaircareRoutine>> loadRoutines();
  Future<String> getPersonalizedPlanTitle();

  /// Persists which plan is running.
  ///
  /// Pass [startedAt] to (re)anchor the plan clock — that date is what drives
  /// the weekly progression, so it is written whenever a plan is started.
  /// Passing an empty [routineId] clears the plan and its start date.
  Future<void> saveActiveRoutine(String routineId, {DateTime? startedAt});

  /// When the active plan was started, or `null` if no plan is running.
  Future<DateTime?> loadActiveRoutineStartedAt();
}