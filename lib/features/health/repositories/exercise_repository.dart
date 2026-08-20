import '../models/exercise.dart'; abstract class ExerciseRepository { Future<List<Exercise>> loadExercises(); }
