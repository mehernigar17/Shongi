import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Local weekly reminder that tells the user to log their day.
///
/// The weekday comes from the user's own choice in onboarding / profile
/// and is persisted in Firestore (`users/{uid}.logReminderDay`).
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  static const int _logReminderId = 1001;
  static const int _periodReminderId = 1002;
  static const String _channelId = 'shongi_reminders';
  static const String _channelName = 'Daily reminders';
  static const String _channelDescription =
      'Reminders to log your wellness entries.';

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  bool get isInitialized => _initialized;

  /// Request permission is granted/available — used to show an inline note.
  bool? _permissionGranted;

  bool? get permissionGranted => _permissionGranted;

  /// Initializes the plugin, timezone database and the Android channel.
  /// Safe to call multiple times.
  Future<void> initialize({bool requestPermission = true}) async {
    if (_initialized) return;
    try {
      tzdata.initializeTimeZones();
      // Match the device's own timezone so a weekly repeat lands on the
      // user's local time rather than UTC.
      final deviceTz = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(deviceTz.identifier));

      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

      await _plugin.initialize(
        const InitializationSettings(
          android: androidSettings,
          iOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
        ),
      );

      if (defaultTargetPlatform == TargetPlatform.android) {
        final android = _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
        await android?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            _channelName,
            description: _channelDescription,
            importance: Importance.high,
          ),
        );
        if (requestPermission) {
          _permissionGranted =
              await android?.requestNotificationsPermission();
        }
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        if (requestPermission) {
          _permissionGranted = await _plugin
              .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(alert: true, badge: true, sound: true);
        } else {
          _permissionGranted = true;
        }
      } else {
        _permissionGranted = false;
      }

      _initialized = true;
    } catch (e) {
      // A device without notification support must never block the app.
      _initialized = false;
      if (kDebugMode) debugPrint('Notification init failed: $e');
    }
  }

  static const _mondayToFriday = {
    'mon': DateTime.monday,
    'monday': DateTime.monday,
    'tue': DateTime.tuesday,
    'tues': DateTime.tuesday,
    'tuesday': DateTime.tuesday,
    'wed': DateTime.wednesday,
    'wednesday': DateTime.wednesday,
    'thu': DateTime.thursday,
    'thur': DateTime.thursday,
    'thurs': DateTime.thursday,
    'thursday': DateTime.thursday,
    'fri': DateTime.friday,
    'friday': DateTime.friday,
    'sat': DateTime.saturday,
    'saturday': DateTime.saturday,
    'sun': DateTime.sunday,
    'sunday': DateTime.sunday,
  };

  /// Converts a stored day name ("Mon".."Sun" or "Monday".."Sunday") to a
  /// weekday number. Falls back to Monday when missing or unknown.
  static int weekdayFor(String? dayName) =>
      _mondayToFriday[dayName?.trim().toLowerCase() ?? ''] ?? DateTime.monday;

  /// Human label for a weekday number, used in the confirmation text.
  static String labelFor(String? dayName) {
    final weekday = weekdayFor(dayName);
    return const ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday',
      'Saturday', 'Sunday'][weekday - 1];
  }

  /// Weekly notification at 8:00 PM on [dayName] asking the user to log.
  /// Returns true when the schedule call succeeded.
  Future<bool> scheduleWeeklyLogReminder(String dayName) async {
    if (!_initialized) {
      await initialize();
      if (!_initialized) return false;
    }
    try {
      await _plugin.cancel(_logReminderId);
      await _plugin.zonedSchedule(
        _logReminderId,
        'Time to log your day 🌸',
        'A 1-minute check-in helps you spot patterns in sleep, mood and symptoms.',
        _nextInstanceOf(dayName, hour: 20),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDescription,
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
      return true;
    } catch (e) {
      if (kDebugMode) debugPrint('Could not schedule reminder: $e');
      return false;
    }
  }

  /// Extra nudge 2 days after the expected next period.
  Future<bool> schedulePeriodReminder(DateTime expectedStart) async {
    if (!_initialized) {
      await initialize();
      if (!_initialized) return false;
    }
    try {
      await _plugin.cancel(_periodReminderId);
      final when = tz.TZDateTime.from(
        expectedStart.subtract(const Duration(days: 2)),
        tz.local,
      );
      await _plugin.zonedSchedule(
        _periodReminderId,
        'Your period may start soon 🩸',
        'Log your period to keep your cycle predictions accurate.',
        when,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDescription,
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
      return true;
    } catch (e) {
      if (kDebugMode) debugPrint('Could not schedule period reminder: $e');
      return false;
    }
  }

  Future<void> cancelAll() async {
    if (!_initialized) return;
    await _plugin.cancel(_logReminderId);
    await _plugin.cancel(_periodReminderId);
  }

  /// Next occurrence of [weekday] at [hour]:00 local time.
  tz.TZDateTime _nextInstanceOf(String dayName, {required int hour}) {
    final weekday = weekdayFor(dayName);
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
    );
    // Move forward to the chosen weekday (0 = today means "next week").
    while (scheduled.weekday != weekday || !scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}