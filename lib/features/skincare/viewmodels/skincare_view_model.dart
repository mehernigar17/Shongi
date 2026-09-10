import 'package:flutter/foundation.dart';
import '../models/skincare_routine.dart';
import '../repositories/skincare_repository.dart';

class SkincareViewModel extends ChangeNotifier {
  SkincareViewModel(this._repository) {
    load();
  }

  final SkincareRepository _repository;

  List<SkincareRoutine> _routines = [];
  String _activeRoutineId = '';
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

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    try {
      final futures = await Future.wait([
        _repository.loadRoutines(),
        _repository.getPersonalizedSkinType(),
      ]);
      _routines = futures[0] as List<SkincareRoutine>;
      _skinType = futures[1] as String;
      
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
