import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shongi/core/theme/app_colors.dart';

class AchievementsCard extends StatelessWidget {
  final ValueChanged<String>? onBadgeTap;

  const AchievementsCard({super.key, this.onBadgeTap});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  color: amberBackground,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: amberAccent,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "Achievements",
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AchievementBadge(
                icon: Icons.local_fire_department_rounded,
                iconColor: pinkAccent,
                bgColor: pinkBackground,
                title: "2-week streak",
                onTap: onBadgeTap != null ? () => onBadgeTap!("2-week streak") : null,
              ),
              AchievementBadge(
                icon: Icons.edit_note_rounded,
                iconColor: accentColor,
                bgColor: chipBackground,
                title: "30 logs",
                onTap: onBadgeTap != null ? () => onBadgeTap!("30 logs") : null,
              ),
              AchievementBadge(
                icon: Icons.favorite_rounded,
                iconColor: const Color(0xFF8B5CF6),
                bgColor: const Color(0xFFF3ECFF),
                title: "Self-care pro",
                onTap: onBadgeTap != null ? () => onBadgeTap!("Self-care pro") : null,
              ),
              AchievementBadge(
                icon: Icons.local_florist_rounded,
                iconColor: greenAccent,
                bgColor: greenBackground,
                title: "3-mo member",
                onTap: onBadgeTap != null ? () => onBadgeTap!("3-mo member") : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AchievementBadge extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String title;
  final VoidCallback? onTap;

  const AchievementBadge({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 70,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: iconColor.withValues(alpha: 0.15)),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 22,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: textSecondary,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}