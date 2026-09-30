import 'package:flutter/foundation.dart';
import '../../care_plan/care_plan_progress.dart';
import '../models/skincare_routine.dart';
import '../repositories/skincare_repository.dart';

class SkincareViewModel extends ChangeNotifier {
  SkincareViewModel(this._repository) {
    load();
  }

  final SkincareRepository _repository;

  List<SkincareRoutine> _routines = [];
  String _activeRoutineId = '';
  DateTime? _startedAt;
  String _skinType = 'Normal Skin';
  bool _isLoading = false;

  List<SkincareRoutine> get routines => _routines;
  String get activeRoutineId => _activeRoutineId;
  String get skinType => _skinType;
  bool get isLoading => _isLoading;

  SkincareRoutine? get activeRoutine {
    try {
      return _routines.firstWhere((r) => r.id == _activeRoutineId);
    } catch (_) {
      return null;
    }
  }

  /// How far through the active plan the user is, or `null` when no plan runs.
  ///
  /// Derived from the stored start date on every read, so the plan advances by
  /// itself after each 7 days without needing a refresh or a scheduled job.
  CarePlanProgress? get activeProgress {
    final startedAt = _startedAt;
    final routine = activeRoutine;
    if (startedAt == null || routine == null) return null;
    return computeCarePlanProgress(
      startedAt: startedAt,
      totalWeeks: routine.totalWeeks,
    );
  }

  /// The week the given plan should display: the live week for a running plan,
  /// or week one as a preview for a plan that has not been started.
  SkincareWeek? weekFor(SkincareRoutine routine) {
    if (!routine.isActive) return routine.weekAt(1);
    final progress = activeProgress;
    return routine.weekAt(progress?.weekNumber ?? 1);
  }

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    try {
      final futures = await Future.wait([
        _repository.loadRoutines(),
        _repository.getPersonalizedSkinType(),
        _repository.loadActiveRoutineStartedAt(),
      ]);
      _routines = futures[0] as List<SkincareRoutine>;
      _skinType = futures[1] as String;
      _startedAt = futures[2] as DateTime?;

      final active = _routines.where((r) => r.isActive).toList();
      _activeRoutineId = active.isNotEmpty ? active.first.id : '';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Starts [routineId] as the active plan.
  ///
  /// Returns true only when this actually started a new plan. Re-selecting the
  /// plan that is already running leaves its start date alone — otherwise every
  /// tap on the card would reset the user back to week one.
  Future<bool> startRoutine(String routineId) async {
    final wasAlreadyActive = _activeRoutineId == routineId;

    _activeRoutineId = routineId;
    _routines = _routines.map((r) {
      return r.copyWith(isActive: r.id == routineId);
    }).toList();
    if (!wasAlreadyActive) {
      _startedAt = DateTime.now();
    }
    notifyListeners();

    await _repository.saveActiveRoutine(routineId, startedAt: _startedAt);
    return !wasAlreadyActive;
  }

  /// Re-anchors the plan clock so [routineId] starts again from week 1, day 1.
  ///
  /// Used by the "Restart plan" action on the card of a running plan.
  Future<void> restartRoutine(String routineId) async {
    if (_activeRoutineId != routineId) {
      await startRoutine(routineId);
      return;
    }
    _startedAt = DateTime.now();
    notifyListeners();
    await _repository.saveActiveRoutine(routineId, startedAt: _startedAt);
  }

  Future<void> deactivateRoutine(String routineId) async {
    if (_activeRoutineId == routineId) {
      _activeRoutineId = '';
    }
    _routines = _routines.map((r) {
      return r.copyWith(isActive: r.id == routineId ? false : r.isActive);
    }).toList();
    _startedAt = null;
    notifyListeners();

    await _repository.saveActiveRoutine('');
  }
}