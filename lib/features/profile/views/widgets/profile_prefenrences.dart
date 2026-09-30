import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shongi/core/theme/app_colors.dart';

class PreferencesCard extends StatelessWidget {
  final bool dailyReminders;
  final bool notificationsEnabled;
  final bool privacyEnabled;
  final String selfCareDay;
  final ValueChanged<bool>? onDailyRemindersChanged;
  final ValueChanged<bool>? onNotificationsChanged;
  final ValueChanged<bool>? onPrivacyChanged;
  final ValueChanged<String>? onSelfCareDayChanged;

  const PreferencesCard({
    super.key,
    required this.dailyReminders,
    required this.notificationsEnabled,
    required this.privacyEnabled,
    this.selfCareDay = 'Sunday',
    this.onDailyRemindersChanged,
    this.onNotificationsChanged,
    this.onPrivacyChanged,
    this.onSelfCareDayChanged,
  });

  /// Picks the weekday the weekly log reminder should fire on.
  Future<void> _pickDay(BuildContext context) async {
    final days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday',
    ];
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cardBorderColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 6),
                child: Text(
                  "Log reminder day",
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 0, 22, 10),
                child: Text(
                  "We'll remind you at 8:00 PM on this day to log sleep, mood and symptoms.",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    height: 1.5,
                    color: textSecondary,
                  ),
                ),
              ),
              ...days.map(
                (day) => ListTile(
                  title: Text(
                    day,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: day == selfCareDay
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: day == selfCareDay ? accentColor : textColor,
                    ),
                  ),
                  trailing: day == selfCareDay
                      ? Icon(Icons.check_circle_rounded,
                          color: accentColor, size: 20)
                      : null,
                  onTap: () => Navigator.pop(context, day),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
    if (picked != null) onSelfCareDayChanged?.call(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cardBorderColor),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: chipBackground,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.settings_outlined,
                  color: accentColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "Preferences",
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          PreferenceRow(
            title: "Daily Reminders",
            subtitle: "Receive cycle tracking reminders",
            icon: Icons.notifications_active_outlined,
            value: dailyReminders,
            onChanged: onDailyRemindersChanged,
          ),
          Divider(color: cardBorderColor.withValues(alpha: 0.6), height: 16),
          PreferenceActionRow(
            title: "Log Reminder Day",
            subtitle: dailyReminders
                ? "Reminds you every $selfCareDay at 8:00 PM"
                : "Reminders are currently off",
            icon: Icons.event_repeat_rounded,
            value: selfCareDay,
            onTap: () => _pickDay(context),
          ),
          Divider(color: cardBorderColor.withValues(alpha: 0.6), height: 16),
          PreferenceRow(
            title: "Notification Settings",
            subtitle: "Manage alerts and updates",
            icon: Icons.tune_rounded,
            value: notificationsEnabled,
            onChanged: onNotificationsChanged,
          ),
          Divider(color: cardBorderColor.withValues(alpha: 0.6), height: 16),
          PreferenceRow(
            title: "Privacy & Data",
            subtitle: "Control data sharing preferences",
            icon: Icons.shield_outlined,
            value: privacyEnabled,
            onChanged: onPrivacyChanged,
          ),
        ],
      ),
    );
  }
}

/// Tappable preference row that reveals a value instead of a switch.
class PreferenceActionRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String value;
  final VoidCallback? onTap;

  const PreferenceActionRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: chipBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: accentColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: accentColor,
                ),
              ),
              const SizedBox(width: 2),
              Icon(Icons.chevron_right_rounded,
                  size: 20, color: textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

class PreferenceRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const PreferenceRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: chipBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 20,
              color: accentColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged ?? (_) {},
            activeThumbColor: accentColor,
            activeTrackColor: accentColorLight,
          ),
        ],
      ),
    );
  }
}