import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PreferencesCard extends StatelessWidget {
  final bool dailyReminders;
  final bool notificationsEnabled;
  final bool privacyEnabled;

  const PreferencesCard({
    super.key,
    required this.dailyReminders,
    required this.notificationsEnabled,
    required this.privacyEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFFEDE4FA),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF8FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.settings_outlined,
                  color: Color(0xFF4A90E2),
                  size: 20,
                ),
              ),

              const SizedBox(width: 12),

              Text(
                "Preferences",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2D1457),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          PreferenceRow(
            title: "Daily Reminders",
            subtitle: "Receive cycle tracking reminders",
            icon: Icons.notifications_active_outlined,
            value: dailyReminders,
          ),

          const Divider(height: 24),

          PreferenceRow(
            title: "Notification Settings",
            subtitle: "Manage alerts and updates",
            icon: Icons.tune_rounded,
            value: notificationsEnabled,
          ),

          const Divider(height: 24),

          PreferenceRow(
            title: "Privacy & Data",
            subtitle: "Control data sharing preferences",
            icon: Icons.shield_outlined,
            value: privacyEnabled,
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

  const PreferenceRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFF7F1FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 20,
            color: const Color(0xFF9A63F7),
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
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2D1457),
                ),
              ),

              const SizedBox(height: 2),

              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),

        Switch(
          value: value,
          onChanged: (_) {},
          activeColor: const Color(0xFF9A63F7),
          activeTrackColor: const Color(0xFFDCC8FF),
        ),
      ],
    );
  }
}