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

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;

  String get name => (_profile?.name.isNotEmpty == true) ? _profile!.name : 'Aria';
  String get memberSubtitle => 'PCOS Warrior • Member since 2024';
  String get avgCycleLength => '30 Days';
  String get lastPeriod => 'April 2, 2026';
  String get cycleType => _profile?.cycleType ?? 'Irregular';
  String get pcosDiagnosis => 'Confirmed';
  List<String> get goals => const [
        'Fertility Support',
        'Weight Management',
        'Better Mood',
      ];

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
}
