import 'package:flutter/foundation.dart';
import '../../onboarding/models/user_profile.dart';
import '../../onboarding/repositories/profile_repository.dart';
import '../repositories/user_settings_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel(this._repository, this._settingsRepository) {
    load();
  }

  final ProfileRepository _repository;
  final UserSettingsRepository _settingsRepository;

  UserProfile? _profile;
  bool _isLoading = false;

  bool _dailyReminders = true;
  bool _notificationsEnabled = true;
  bool _privacyEnabled = false;

  String _fallbackName = '';
  String _avgCycleLength = '30 Days';
  String _lastPeriod = 'Not logged yet';
  String _pcosDiagnosis = 'Not set';
  List<String> _goals = const [];

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;

  String get name => (_profile?.name.isNotEmpty == true) ? _profile!.name : _fallbackName;
  String get memberSubtitle => 'Member since 2024';
  String get avgCycleLength => _avgCycleLength;
  String get lastPeriod => _lastPeriod;
  String get cycleType => _profile?.cycleType ?? 'Regular';
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
      final settings = await _settingsRepository.loadSettings();

      final avg = settings['avgCycleLength'];
      if (avg is num && avg > 0) _avgCycleLength = '${avg.toInt()} Days';

      final lastPeriod = settings['lastPeriodStart'];
      if (lastPeriod != null) {
        final dt = lastPeriod is DateTime
            ? lastPeriod
            : DateTime.tryParse(lastPeriod.toString());
        if (dt != null) _lastPeriod = _formatDate(dt);
      }

      final pcos = settings['pcosDiagnosis'];
      if (pcos is String && pcos.trim().isNotEmpty) {
        _pcosDiagnosis = pcos.trim();
      }

      final goals = settings['goals'];
      if (goals is List) {
        _goals = goals.map((g) => g.toString()).toList();
      }

      final reminders = settings['dailyReminders'];
      if (reminders is bool) _dailyReminders = reminders;
      final notifications = settings['notificationsEnabled'];
      if (notifications is bool) _notificationsEnabled = notifications;
      final privacy = settings['privacyEnabled'];
      if (privacy is bool) _privacyEnabled = privacy;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─────────────────────── PERSISTED UPDATES ───────────────────────

  Future<bool> updateName(String value) async {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return false;
    try {
      await _settingsRepository.updateName(trimmed);
      _fallbackName = trimmed;
      _profile = _profile == null
          ? null
          : UserProfile(
              name: trimmed,
              age: _profile!.age,
              weightKg: _profile!.weightKg,
              heightCm: _profile!.heightCm,
              skinType: _profile!.skinType,
              cycleType: _profile!.cycleType,
              selfCareDay: _profile!.selfCareDay,
              medications: _profile!.medications,
              lastPeriodStart: _profile!.lastPeriodStart,
              lastPeriodEnd: _profile!.lastPeriodEnd,
            );
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateCycleDetails({
    String? avgCycleLength,
    String? lastPeriod,
    String? cycleType,
    String? pcosDiagnosis,
  }) async {
    try {
      int? avgDays;
      if (avgCycleLength != null && avgCycleLength.trim().isNotEmpty) {
        final parsed = int.tryParse(avgCycleLength.trim().replaceAll(RegExp(r'[^0-9]'), ''));
        if (parsed != null && parsed > 0) {
          avgDays = parsed;
          _avgCycleLength = '$parsed Days';
        }
      }

      DateTime? lastPeriodDate;
      if (lastPeriod != null && lastPeriod.trim().isNotEmpty) {
        lastPeriodDate = _parseFlexibleDate(lastPeriod.trim());
        if (lastPeriodDate != null) _lastPeriod = _formatDate(lastPeriodDate);
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

      await _settingsRepository.updateCycleDetails(
        avgCycleLength: avgDays,
        lastPeriod: lastPeriodDate,
        cycleType: cycleType?.trim().isNotEmpty == true ? cycleType!.trim() : null,
        pcosDiagnosis: pcosDiagnosis?.trim().isNotEmpty == true ? pcosDiagnosis!.trim() : null,
      );
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> addGoal(String goal) async {
    final trimmed = goal.trim();
    if (trimmed.isEmpty || _goals.contains(trimmed)) return false;
    _goals = [..._goals, trimmed];
    notifyListeners();
    try {
      await _settingsRepository.updateGoals(_goals);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> removeGoal(String goal) async {
    _goals = _goals.where((g) => g != goal).toList();
    notifyListeners();
    try {
      await _settingsRepository.updateGoals(_goals);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> setDailyReminders(bool value) async {
    _dailyReminders = value;
    notifyListeners();
    try {
      await _settingsRepository.updatePreferences(dailyReminders: value);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> setNotifications(bool value) async {
    _notificationsEnabled = value;
    notifyListeners();
    try {
      await _settingsRepository.updatePreferences(notificationsEnabled: value);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> setPrivacy(bool value) async {
    _privacyEnabled = value;
    notifyListeners();
    try {
      await _settingsRepository.updatePreferences(privacyEnabled: value);
      return true;
    } catch (_) {
      return false;
    }
  }

  // ─────────────────────── HELPERS ───────────────────────

  static DateTime? _parseFlexibleDate(String input) {
    // Try ISO first, then "April 2, 2026" style.
    final iso = DateTime.tryParse(input);
    if (iso != null) return iso;
    final match = RegExp(r'([A-Za-z]+)\s+(\d{1,2}),?\s+(\d{4})').firstMatch(input);
    if (match != null) {
      const months = {
        'january': 1, 'february': 2, 'march': 3, 'april': 4, 'may': 5, 'june': 6,
        'july': 7, 'august': 8, 'september': 9, 'october': 10, 'november': 11, 'december': 12,
      };
      final month = months[match.group(1)!.toLowerCase()];
      if (month != null) {
        return DateTime(int.parse(match.group(3)!), month, int.parse(match.group(2)!));
      }
    }
    return null;
  }

  static String _formatDate(DateTime d) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }
}