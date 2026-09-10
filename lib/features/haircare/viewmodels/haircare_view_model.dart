import 'package:flutter/foundation.dart';
import '../models/haircare_routine.dart';
import '../repositories/haircare_repository.dart';

class HaircareViewModel extends ChangeNotifier {
  HaircareViewModel(this._repository) {
    load();
  }

  final HaircareRepository _repository;

  List<HaircareRoutine> _routines = [];
  String _activeRoutineId = '';
  String _personalizedTitle = 'Hair & Scalp Care';
  bool _isLoading = false;

  List<HaircareRoutine> get routines => _routines;
  String get activeRoutineId => _activeRoutineId;
  String get personalizedTitle => _personalizedTitle;
  bool get isLoading => _isLoading;

  HaircareRoutine? get activeRoutine {
    try {
      return _routines.firstWhere((r) => r.id == _activeRoutineId);
    } catch (_) {
      return null;
    }
  }

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    try {
      final futures = await Future.wait([
        _repository.loadRoutines(),
        _repository.getPersonalizedPlanTitle(),
      ]);
      _routines = futures[0] as List<HaircareRoutine>;
      _personalizedTitle = futures[1] as String;

      final active = _routines.where((r) => r.isActive).toList();
      if (active.isNotEmpty) {
        _activeRoutineId = active.first.id;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> startRoutine(String routineId) async {
    _activeRoutineId = routineId;
    _routines = _routines.map((r) {
      return r.copyWith(isActive: r.id == routineId);
    }).toList();
    notifyListeners();

    await _repository.saveActiveRoutine(routineId);
    return true;
  }

  Future<void> deactivateRoutine(String routineId) async {
    if (_activeRoutineId == routineId) {
      _activeRoutineId = '';
    }
    _routines = _routines.map((r) {
      return r.copyWith(isActive: r.id == routineId ? false : r.isActive);
    }).toList();
    notifyListeners();

    await _repository.saveActiveRoutine('');
  }
}