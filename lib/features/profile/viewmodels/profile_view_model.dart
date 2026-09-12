import 'package:flutter/foundation.dart';
import '../../onboarding/models/user_profile.dart';
import '../../onboarding/repositories/profile_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel(this._repository) {
    load();
  }

  final ProfileRepository _repository;
  UserProfile? _profile;
  bool _isLoading = false;

  bool _dailyReminders = true;
  bool _notificationsEnabled = true;
  bool _privacyEnabled = false;

  String _fallbackName = 'Aria';
  String _avgCycleLength = '30 Days';
  String _lastPeriod = 'April 2, 2026';
  String _pcosDiagnosis = 'Confirmed';
  List<String> _goals = const [
    'Fertility Support',
    'Weight Management',
    'Better Mood',
  ];

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;

  String get name => (_profile?.name.isNotEmpty == true) ? _profile!.name : _fallbackName;
  String get memberSubtitle => 'Member since 2024';
  String get avgCycleLength => _avgCycleLength;
  String get lastPeriod => _lastPeriod;
  String get cycleType => _profile?.cycleType ?? 'Irregular';
  String get pcosDiagnosis => _pcosDiagnosis;
  List<String> get goals => List.unmodifiable(_goals);

  String get streakDays => '14d';
  String get totalLogs => '86';
  String get userLevel => 'Silver';

  bool get dailyReminders => _dailyReminders;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get privacyEnabled => _privacyEnabled;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    try {
      _profile = await _repository.load();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setDailyReminders(bool value) {
    _dailyReminders = value;
    notifyListeners();
  }

  void setNotifications(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }

  void setPrivacy(bool value) {
    _privacyEnabled = value;
    notifyListeners();
  }

  void updateName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;
    _fallbackName = trimmed;
    notifyListeners();
  }

  void updateCycleDetails({
    String? avgCycleLength,
    String? lastPeriod,
    String? cycleType,
    String? pcosDiagnosis,
  }) {
    if (avgCycleLength != null && avgCycleLength.trim().isNotEmpty) {
      _avgCycleLength = avgCycleLength.trim();
    }
    if (lastPeriod != null && lastPeriod.trim().isNotEmpty) {
      _lastPeriod = lastPeriod.trim();
    }
    if (cycleType != null && cycleType.trim().isNotEmpty) {
      _profile = _profile == null
          ? null
          : UserProfile(
              name: _profile!.name,
              age: _profile!.age,
              weightKg: _profile!.weightKg,
              heightCm: _profile!.heightCm,
              skinType: _profile!.skinType,
              cycleType: cycleType.trim(),
              selfCareDay: _profile!.selfCareDay,
              medications: _profile!.medications,
              lastPeriodStart: _profile!.lastPeriodStart,
              lastPeriodEnd: _profile!.lastPeriodEnd,
            );
    }
    if (pcosDiagnosis != null && pcosDiagnosis.trim().isNotEmpty) {
      _pcosDiagnosis = pcosDiagnosis.trim();
    }
    notifyListeners();
  }

  void addGoal(String goal) {
    final trimmed = goal.trim();
    if (trimmed.isEmpty || _goals.contains(trimmed)) return;
    _goals = [..._goals, trimmed];
    notifyListeners();
  }

  void removeGoal(String goal) {
    _goals = _goals.where((g) => g != goal).toList();
    notifyListeners();
  }
}