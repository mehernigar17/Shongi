import 'package:flutter/foundation.dart';
import '../models/doctor.dart';
import '../repositories/doctor_repository.dart';

class DoctorsViewModel extends ChangeNotifier {
  DoctorsViewModel(this._repository) {
    load();
  }

  final DoctorRepository _repository;
  List<Doctor> _doctors = [];
  Doctor? _selected;
  bool _isLoading = false;

  List<Doctor> get doctors => _doctors;
  Doctor? get selectedDoctor => _selected;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    try {
      _doctors = await _repository.loadDoctors();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectDoctor(Doctor? doctor) {
    _selected = doctor;
    notifyListeners();
  }
}
