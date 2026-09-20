import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shongi/core/theme/app_colors.dart';
import '../../logs/data/firestore_log_repository.dart';
import '../../logs/models/daily_log.dart';
import '../../logs/repositories/log_repository.dart';
import '../../onboarding/models/user_profile.dart';
import '../../onboarding/repositories/profile_repository.dart';
import '../repositories/user_settings_repository.dart';

/// A single achievement badge with its real unlock state.
class AchievementStatus {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final bool unlocked;
  final String? progress;

  const AchievementStatus({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.unlocked,
    this.progress,
  });
}

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel(this._repository, this._settingsRepository, {LogRepository? logRepository})
      : _logRepository = logRepository ?? FirestoreLogRepository() {
    load();
  }

  final ProfileRepository _repository;
  final UserSettingsRepository _settingsRepository;
  final LogRepository _logRepository;

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

  List<DailyLog> _logs = const [];
  DateTime? _memberSince;
  String _activeSkincareRoutine = '';
  String _activeHaircareRoutine = '';

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;

  String get name => (_profile?.name.isNotEmpty == true) ? _profile!.name : _fallbackName;
  String get memberSubtitle {
    if (_memberSince == null) return 'Member';
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return 'Member since ${months[_memberSince!.month - 1]} ${_memberSince!.year}';
  }

  String get avgCycleLength => _avgCycleLength;
  String get lastPeriod => _lastPeriod;
  String get cycleType => _profile?.cycleType ?? 'Regular';
  String get pcosDiagnosis => _pcosDiagnosis;
  List<String> get goals => List.unmodifiable(_goals);

  // ── Real progress (no mocks) ────────────────────────────────────
  int get streakDays => _computeStreak(_logs);
  int get totalLogs => _logs.length;
  String get streakLabel => '${streakDays}d';
  String get totalLogsLabel => '$totalLogs';
  String get userLevel => _levelFor(totalLogs);

  List<AchievementStatus> get achievements => _buildAchievements();

  bool get dailyReminders => _dailyReminders;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get privacyEnabled => _privacyEnabled;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    try {
      final results = await Future.wait([
        _repository.load(),
        _settingsRepository.loadSettings(),
        _logRepository.loadLogs(),
      ]);
      _profile = results[0] as UserProfile?;
      final settings = results[1] as Map<String, dynamic>;
      _logs = results[2] as List<DailyLog>;

      final avg = settings['avgCycleLength'];
      if (avg is num && avg > 0) _avgCycleLength = '${avg.toInt()} Days';

      final lastPeriod = settings['lastPeriodStart'];
      if (lastPeriod != null) {
        final dt = _toDateTime(lastPeriod);
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

      _memberSince = _toDateTime(settings['createdAt']);
      _activeSkincareRoutine = settings['activeSkincareRoutine'] as String? ?? '';
      _activeHaircareRoutine = settings['activeHaircareRoutine'] as String? ?? '';
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

  // ─────────────────────── REAL PROGRESS HELPERS ───────────────────────

  /// Consecutive days with a log, counting back from today
  /// (or yesterday if today isn't logged yet).
  static int _computeStreak(List<DailyLog> logs) {
    if (logs.isEmpty) return 0;
    final dates = logs
        .map((l) => DateTime(l.date.year, l.date.month, l.date.day))
        .toSet();
    var day = DateTime.now();
    var current = DateTime(day.year, day.month, day.day);
    if (!dates.contains(current)) {
      current = current.subtract(const Duration(days: 1));
    }
    var streak = 0;
    while (dates.contains(current)) {
      streak++;
      current = current.subtract(const Duration(days: 1));
    }
    return streak;
  }

  static String _levelFor(int logs) {
    if (logs >= 60) return 'Platinum';
    if (logs >= 30) return 'Gold';
    if (logs >= 10) return 'Silver';
    if (logs >= 1) return 'Bronze';
    return 'New';
  }

  List<AchievementStatus> _buildAchievements() {
    final streak = streakDays;
    final logs = totalLogs;
    final hasRoutine = _activeSkincareRoutine.isNotEmpty || _activeHaircareRoutine.isNotEmpty;
    final memberMonths = _memberSince == null
        ? 0
        : DateTime.now().difference(_memberSince!).inDays ~/ 30;

    return [
      AchievementStatus(
        title: '2-week streak',
        icon: Icons.local_fire_department_rounded,
        iconColor: pinkAccent,
        bgColor: pinkBackground,
        unlocked: streak >= 14,
        progress: streak >= 14 ? null : '$streak/14 days',
      ),
      AchievementStatus(
        title: '30 logs',
        icon: Icons.edit_note_rounded,
        iconColor: accentColor,
        bgColor: chipBackground,
        unlocked: logs >= 30,
        progress: logs >= 30 ? null : '$logs/30 logs',
      ),
      AchievementStatus(
        title: 'Self-care pro',
        icon: Icons.local_florist_rounded,
        iconColor: greenAccent,
        bgColor: greenBackground,
        unlocked: hasRoutine,
        progress: hasRoutine ? null : 'Start a routine',
      ),
      AchievementStatus(
        title: '3-mo member',
        icon: Icons.emoji_events_rounded,
        iconColor: amberAccent,
        bgColor: amberBackground,
        unlocked: memberMonths >= 3,
        progress: memberMonths >= 3 ? null : '$memberMonths/3 months',
      ),
    ];
  }

  // ─────────────────────── DATE HELPERS ───────────────────────

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is Timestamp) return value.toDate();
    return DateTime.tryParse(value.toString());
  }

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