import 'package:flutter/foundation.dart';
import 'package:shongi/features/periods/repositories/period_repository.dart';

import '../models/exercise.dart';
import '../models/workout_plan.dart';
import '../repositories/exercise_repository.dart';

/// Where the user sits in their cycle today. Drives which plan is suggested.
enum CyclePhase {
  unknown,
  menstrual,
  follicular,
  ovulation,
  luteal;

  String get label => switch (this) {
        CyclePhase.unknown => 'Not tracking yet',
        CyclePhase.menstrual => 'Menstrual phase',
        CyclePhase.follicular => 'Follicular phase',
        CyclePhase.ovulation => 'Ovulation phase',
        CyclePhase.luteal => 'Luteal phase',
      };

  String get guidance => switch (this) {
        CyclePhase.unknown =>
          'Log your period to get a plan matched to your cycle.',
        CyclePhase.menstrual =>
          'Gentle movement helps cramps and lifts energy. Keep intensity low.',
        CyclePhase.follicular =>
          'Strength and stamina peak here — a good time to push harder.',
        CyclePhase.ovulation =>
          'Energy is at its highest. Power, core and cardio all land well.',
        CyclePhase.luteal =>
          'F favour flexibility, balance and calm to ease tension.',
      };
}

class HealthViewModel extends ChangeNotifier {
  HealthViewModel(this._repository, {PeriodRepository? periodRepository})
      : _periodRepository = periodRepository {
    load();
  }

  final ExerciseRepository _repository;
  final PeriodRepository? _periodRepository;

  String _hubTag = 'Exercise';
  String _category = 'All';
  List<Exercise> _exercises = [];
  List<WorkoutPlan> _workoutPlans = [];
  bool _isLoading = false;

  // Cycle personalization
  CyclePhase _phase = CyclePhase.unknown;
  int _cycleDay = 0;

  String get hubTag => _hubTag;
  String get selectedCategory => _category;
  List<Exercise> get allExercises => _exercises;
  List<WorkoutPlan> get workoutPlans => _workoutPlans;
  bool get isLoading => _isLoading;

  CyclePhase get cyclePhase => _phase;
  int get cycleDay => _cycleDay;
  String get cyclePhaseLabel => _phase.label;
  String get cyclePhaseGuidance => _phase.guidance;

  List<Exercise> get filteredExercises {
    if (_category == 'All') return _exercises;
    return _exercises.where((e) => e.category == _category).toList();
  }

  /// The plan recommended for today's phase. Plans themselves stay curated
  /// static content; the *order* is driven by real cycle data.
  WorkoutPlan? get recommendedPlan {
    if (_workoutPlans.isEmpty) return null;
    final preferred = _preferredPlanIndex;
    if (preferred == null) return _workoutPlans.first;
    return _workoutPlans[preferred];
  }

  /// Index of the plan that best matches the current phase.
  int? get _preferredPlanIndex {
    if (_workoutPlans.length < 3) return null;
    // The curated order is [balance & tone, flexibility & mind, core & energy].
    return switch (_phase) {
      CyclePhase.menstrual => 1, // stretch and calm
      CyclePhase.follicular => 0, // build strength
      CyclePhase.ovulation => 2, // peak power and core
      CyclePhase.luteal => 1, // balance tension
      CyclePhase.unknown => null,
    };
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
      await _loadCyclePhase();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Reads the user's real period history and derives today's cycle day and
  /// phase. Silently degrades to "unknown" when nothing is logged yet.
  Future<void> _loadCyclePhase() async {
    final repository = _periodRepository;
    if (repository == null) return;
    try {
      final periods = await repository.loadPeriods();
      if (periods.isEmpty) {
        _phase = CyclePhase.unknown;
        _cycleDay = 0;
        return;
      }
      final latest = periods.first;
      final today = DateTime.now();
      final start = DateTime(
        latest.startDate.year,
        latest.startDate.month,
        latest.startDate.day,
      );
      _cycleDay = today.difference(start).inDays + 1;
      _phase = _phaseFor(_cycleDay, latest.endDate);
    } catch (_) {
      _phase = CyclePhase.unknown;
      _cycleDay = 0;
    }
  }

  /// Menstrual lasts until the logged end date; the rest of the cycle is
  /// divided by the usual phase landmarks.
  CyclePhase _phaseFor(int cycleDay, DateTime periodEnd) {
    if (cycleDay <= 0) return CyclePhase.unknown;
    final end = DateTime(
      periodEnd.year,
      periodEnd.month,
      periodEnd.day,
    );
    final today = DateTime.now();
    final sinceEnd = today.difference(end).inDays;
    // Still bleeding, or within 2 days of it ending.
    if (sinceEnd < 2) return CyclePhase.menstrual;
    if (cycleDay <= 13) return CyclePhase.follicular;
    if (cycleDay <= 16) return CyclePhase.ovulation;
    return CyclePhase.luteal;
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
