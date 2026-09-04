import 'package:flutter/foundation.dart';
import '../models/exercise.dart';
import '../models/workout_plan.dart';
import '../repositories/exercise_repository.dart';

class HealthViewModel extends ChangeNotifier {
  HealthViewModel(this._repository) {
    load();
  }

  final ExerciseRepository _repository;

  String _hubTag = 'Exercise';
  String _category = 'All';
  List<Exercise> _exercises = [];
  List<WorkoutPlan> _workoutPlans = [];
  bool _isLoading = false;

  String get hubTag => _hubTag;
  String get selectedCategory => _category;
  List<Exercise> get allExercises => _exercises;
  List<WorkoutPlan> get workoutPlans => _workoutPlans;
  bool get isLoading => _isLoading;

  List<Exercise> get filteredExercises {
    if (_category == 'All') return _exercises;
    return _exercises.where((e) => e.category == _category).toList();
  }

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    try {
      final exercisesFuture = _repository.loadExercises();
      final plansFuture = _repository.loadWorkoutPlans();
      final results = await Future.wait([exercisesFuture, plansFuture]);
      _exercises = results[0] as List<Exercise>;
      _workoutPlans = results[1] as List<WorkoutPlan>;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectHubTag(String tag) {
    if (_hubTag != tag) {
      _hubTag = tag;
      notifyListeners();
    }
  }

  void selectCategory(String value) {
    if (_category != value) {
      _category = value;
      notifyListeners();
    }
  }
}
