import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shongi/core/theme/app_colors.dart';

class ProfileStats extends StatelessWidget {
  final String streak;
  final String logs;
  final String level;
  final VoidCallback? onStreakTap;
  final VoidCallback? onLogsTap;
  final VoidCallback? onLevelTap;

  const ProfileStats({
    super.key,
    this.streak = "14d",
    this.logs = "86",
    this.level = "Silver",
    this.onStreakTap,
    this.onLogsTap,
    this.onLevelTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: statCard(
            icon: Icons.local_fire_department_rounded,
            iconColor: pinkAccent,
            value: streak,
            title: "Streak",
            valueColor: pinkAccent,
            cardColor: pinkBackground,
            borderColor: const Color(0xFFFFD4DF),
            onTap: onStreakTap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: statCard(
            icon: Icons.favorite_rounded,
            iconColor: accentColor,
            value: logs,
            title: "Logs",
            valueColor: accentColor,
            cardColor: chipBackground,
            borderColor: cardBorderColor,
            onTap: onLogsTap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: statCard(
            icon: Icons.emoji_events_rounded,
            iconColor: amberAccent,
            value: level,
            title: "Level",
            valueColor: const Color(0xFF9E6B00),
            cardColor: amberBackground,
            borderColor: const Color(0xFFFFECC0),
            onTap: onLevelTap,
          ),
        ),
      ],
    );
  }

  Widget statCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String title,
    required Color valueColor,
    required Color cardColor,
    required Color borderColor,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          height: 105,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: iconColor.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 22,
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: valueColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}