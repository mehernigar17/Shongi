import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shongi/core/theme/app_colors.dart';
import '../../../care_plan/care_plan_progress.dart';
import '../../../care_plan/views/widgets/care_plan_week_banner.dart';
import '../../models/skincare_routine.dart';
import 'skincare_detail_sheet.dart';

class SkincareRoutineCard extends StatelessWidget {
  const SkincareRoutineCard({
    super.key,
    required this.routine,
    required this.onStartRoutine,
    this.onRestartRoutine,
    this.progress,
    this.week,
  });

  final SkincareRoutine routine;
  final VoidCallback onStartRoutine;

  /// Called when the user confirms a restart of the running plan. Falls back to
  /// [onStartRoutine] when the host does not supply one.
  final VoidCallback? onRestartRoutine;

  /// Live progress for the running plan; `null` while nothing is active.
  final CarePlanProgress? progress;

  /// The week to display — the live week when active, week 1 as a preview
  /// otherwise.
  final SkincareWeek? week;

  /// Steps for the week on display.
  List<SkincareStep> get _visibleSteps =>
      week?.steps ?? routine.previewSteps;

  /// Restarting resets the plan clock, so it asks first.
  Future<void> _confirmRestart(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Restart this plan?',
          style: GoogleFonts.poppins(
            color: textColor,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Your ${routine.planLengthLabel} will start again from week 1, day 1.',
          style: GoogleFonts.poppins(
            color: textSecondary,
            fontSize: 13.5,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: textSecondary,
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              'Restart',
              style: GoogleFonts.poppins(
                color: accentColor,
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      (onRestartRoutine ?? onStartRoutine)();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cardBorderColor),
        boxShadow: [
          BoxShadow(
            color: accentColorDeep.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gradient Header with decorative bubbles
          Stack(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: routine.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: Emoji, Active Badge (if active), 7 Days badge
                    Row(
                      children: [
                        Icon(
                          routine.icon,
                          color: routine.iconColor ?? Colors.white,
                          size: 20,
                        ),
                        if (routine.isActive) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.notifications_active_outlined,
                                  color: Colors.white,
                                  size: 13,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Active',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3.5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            routine.planLengthLabel,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
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
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      routine.subtitle,
                      style: GoogleFonts.poppins(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Decorative subtle circle watermark in top right
              Positioned(
                top: -15,
                right: -15,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
              Positioned(
                top: 25,
                right: 35,
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
              ),
            ],
          ),

          // Steps list container
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarePlanWeekBanner(
                  progress: progress,
                  focus: week?.focus ?? '',
                  cadence: week?.cadence ?? '',
                  accent: routine.gradientColors.first,
                ),
                const SizedBox(height: 18),
                Text(
                  routine.isActive
                      ? 'THIS WEEK · ${_visibleSteps.length} STEPS'
                      : 'WEEK 1 OF ${routine.totalWeeks} · ${_visibleSteps.length} STEPS',
                  style: GoogleFonts.poppins(
                    color: textSecondary,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 10),
                ..._visibleSteps.map((step) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: chipBackground,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${step.stepNumber}',
                            style: GoogleFonts.poppins(
                              color: accentColor,
                              fontSize: 11,
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
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    // Know more button
                    Expanded(
                      child: SizedBox(
                        height: 42,
                        child: TextButton.icon(
                          onPressed: () {
                            SkincareDetailSheet.show(
                              context,
                              routine,
                              currentWeekNumber: progress?.weekNumber,
                            );
                          },
                          icon: const Icon(
                            Icons.info_outline_rounded,
                            size: 16,
                            color: accentColor,
                          ),
                          label: Text(
                            'Know more',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: accentColor,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: chipBackground,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Start Routine / Restart button
                    Expanded(
                      child: SizedBox(
                        height: 42,
                        child: routine.isActive
                            ? OutlinedButton.icon(
                                onPressed: () => _confirmRestart(context),
                                icon: const Icon(
                                  Icons.restart_alt_rounded,
                                  size: 17,
                                  color: greenAccent,
                                ),
                                label: Text(
                                  'Restart plan',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: greenAccent,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: greenBackground,
                                  side: const BorderSide(
                                    color: Color(0xFF59C289),
                                    width: 1.2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              )
                            : ElevatedButton(
                                onPressed: onStartRoutine,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentColor,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  'Start Routine',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
