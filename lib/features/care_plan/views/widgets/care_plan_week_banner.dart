import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shongi/core/theme/app_colors.dart';

import '../../care_plan_progress.dart';

/// Progress strip shown on a running care plan.
///
/// Shows which week of the plan the user is on, how far through that week they
/// are, and what that week is focused on — so it is obvious that the plan
/// changes as the weeks pass instead of repeating one fixed routine.
class CarePlanWeekBanner extends StatelessWidget {
  const CarePlanWeekBanner({
    super.key,
    required this.progress,
    required this.focus,
    required this.cadence,
    required this.accent,
  });

  /// `null` renders a "not started yet" preview strip.
  final CarePlanProgress? progress;

  /// What the current week is about, e.g. `Build retinol tolerance`.
  final String focus;

  /// How hard the plan runs this week, e.g. `Retinol · 2 nights`.
  final String cadence;

  /// Colour taken from the routine's gradient.
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final plan = progress;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Pill(
                label: plan == null
                    ? 'WEEK 1 PREVIEW'
                    : (plan.isPlanFinished ? 'PLAN COMPLETE' : plan.weekLabel.toUpperCase()),
                icon: plan == null
                    ? Icons.play_circle_outline_rounded
                    : (plan.isPlanFinished
                        ? Icons.emoji_events_outlined
                        : Icons.calendar_today_rounded),
                color: accent,
              ),
              const Spacer(),
              if (plan != null && !plan.isPlanFinished)
                Text(
                  '${plan.dayLabel} · ${plan.daysRemaining} left',
                  style: GoogleFonts.poppins(
                    color: textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: plan?.planFraction ?? 0,
              minHeight: 7,
              backgroundColor: accent.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(accent),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            focus,
            style: GoogleFonts.poppins(
              color: textColor,
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            plan == null
                ? 'This is week 1. Start the plan and it advances automatically every 7 days.'
                : (plan.isPlanFinished
                    ? 'You finished all ${plan.totalWeeks} weeks of this plan.'
                    : cadence),
            style: GoogleFonts.poppins(
              color: textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
          if (plan != null && !plan.isPlanFinished) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 13, color: accent),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    'Next week starts automatically on day 8.',
                    style: GoogleFonts.poppins(
                      color: textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}