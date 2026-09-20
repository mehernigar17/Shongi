import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shongi/core/theme/app_colors.dart';
import 'package:shongi/features/profile/viewmodels/profile_view_model.dart';

class AchievementsCard extends StatelessWidget {
  final List<AchievementStatus> achievements;
  final ValueChanged<String>? onBadgeTap;

  const AchievementsCard({
    super.key,
    this.achievements = const [],
    this.onBadgeTap,
  });

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
              for (final a in achievements)
                AchievementBadge(
                  icon: a.icon,
                  iconColor: a.iconColor,
                  bgColor: a.bgColor,
                  title: a.title,
                  unlocked: a.unlocked,
                  progress: a.progress,
                  onTap: a.unlocked && onBadgeTap != null
                      ? () => onBadgeTap!(a.title)
                      : null,
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
  final bool unlocked;
  final String? progress;
  final VoidCallback? onTap;

  const AchievementBadge({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    this.unlocked = true,
    this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = unlocked ? iconColor : textSecondary;
    final effectiveBg = unlocked ? bgColor : const Color(0xFFF1F0F4);
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 70,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: effectiveBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: effectiveColor.withValues(alpha: unlocked ? 0.15 : 0.1),
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: effectiveColor,
                    size: 22,
                  ),
                ),
                if (!unlocked)
                  Positioned(
                    right: -3,
                    bottom: -3,
                    child: Container(
                      height: 18,
                      width: 18,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: cardBorderColor),
                      ),
                      child: Icon(
                        Icons.lock_rounded,
                        size: 11,
                        color: textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: unlocked ? textSecondary : textSecondary.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
            if (progress != null && !unlocked) ...[
              const SizedBox(height: 2),
              Text(
                progress!,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 8.5,
                  color: textSecondary.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w400,
                  height: 1.1,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}