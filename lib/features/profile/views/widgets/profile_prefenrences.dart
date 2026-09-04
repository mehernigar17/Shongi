import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shongi/core/theme/app_colors.dart';

class PreferencesCard extends StatelessWidget {
  final bool dailyReminders;
  final bool notificationsEnabled;
  final bool privacyEnabled;
  final ValueChanged<bool>? onDailyRemindersChanged;
  final ValueChanged<bool>? onNotificationsChanged;
  final ValueChanged<bool>? onPrivacyChanged;

  const PreferencesCard({
    super.key,
    required this.dailyReminders,
    required this.notificationsEnabled,
    required this.privacyEnabled,
    this.onDailyRemindersChanged,
    this.onNotificationsChanged,
    this.onPrivacyChanged,
  });

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