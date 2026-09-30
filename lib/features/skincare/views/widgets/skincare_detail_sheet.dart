import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shongi/core/theme/app_colors.dart';
import '../../models/skincare_routine.dart';

class SkincareDetailSheet extends StatelessWidget {
  const SkincareDetailSheet({
    super.key,
    required this.routine,
    this.currentWeekNumber,
  });

  final SkincareRoutine routine;

  /// The week the user is on right now, so it can be marked in the plan.
  final int? currentWeekNumber;

  static Future<void> show(
    BuildContext context,
    SkincareRoutine routine, {
    int? currentWeekNumber,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SkincareDetailSheet(
        routine: routine,
        currentWeekNumber: currentWeekNumber,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final maxHeight = mediaQuery.size.height * 0.88;
    final accent = routine.gradientColors.first;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: const BoxDecoration(
        color: pageBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with gradient matching routine
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: routine.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
              boxShadow: [
                BoxShadow(
                  color: routine.gradientColors.first.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top drag indicator
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Icon, badge and close button
                Row(
                  children: [
                    Icon(
                      routine.icon,
                      color: routine.iconColor ?? Colors.white,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        routine.planLengthLabel,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  routine.title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  routine.subtitle,
                  style: GoogleFonts.poppins(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Each week builds on the last. Follow the steps for the week you are on.',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          // Scrollable plan: every week with its own steps
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final week in routine.weeks) ...[
                    _WeekHeader(
                      week: week,
                      accent: accent,
                      isCurrent: week.weekNumber == currentWeekNumber,
                      isPast:
                          currentWeekNumber != null &&
                          week.weekNumber < currentWeekNumber!,
                    ),
                    const SizedBox(height: 12),
                    ...week.steps.map((step) => _buildStepCard(step, accent)),
                    const SizedBox(height: 20),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard(SkincareStep step, Color accent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cardBorderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${step.stepNumber}',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  step.title,
                  style: GoogleFonts.poppins(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'HOW TO USE',
            style: GoogleFonts.poppins(
              color: textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            step.howToUse,
            style: GoogleFonts.poppins(
              color: textColor,
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 1.45,
            ),
          ),
          if (step.whyItHelps != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: chipBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.star_outline_rounded,
                        size: 15,
                        color: accent,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'WHY IT HELPS',
                        style: GoogleFonts.poppins(
                          color: accent,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    step.whyItHelps!,
                    style: GoogleFonts.poppins(
                      color: textColor.withValues(alpha: 0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _WeekHeader extends StatelessWidget {
  const _WeekHeader({
    required this.week,
    required this.accent,
    required this.isCurrent,
    required this.isPast,
  });

  final SkincareWeek week;
  final Color accent;
  final bool isCurrent;
  final bool isPast;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isCurrent ? accent : accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrent ? accent : accent.withValues(alpha: 0.2),
          width: isCurrent ? 1.6 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'WEEK ${week.weekNumber}',
                style: GoogleFonts.poppins(
                  color: isCurrent ? Colors.white : accent,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(width: 8),
              if (isCurrent)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'YOU ARE HERE',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                )
              else if (isPast)
                Icon(
                  Icons.check_circle_rounded,
                  size: 14,
                  color: accent.withValues(alpha: 0.6),
                ),
              const Spacer(),
              Text(
                week.cadence,
                style: GoogleFonts.poppins(
                  color: isCurrent
                      ? Colors.white.withValues(alpha: 0.9)
                      : textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            week.focus,
            style: GoogleFonts.poppins(
              color: isCurrent ? Colors.white : textColor,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}