import '../models/exercise.dart';
import '../models/workout_plan.dart';

abstract class ExerciseRepository {
  Future<List<Exercise>> loadExercises();
  Future<List<WorkoutPlan>> loadWorkoutPlans();
}
