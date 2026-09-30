import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shongi/core/theme/app_colors.dart';
import 'package:shongi/features/health/models/exercise.dart';
import 'package:shongi/features/health/models/workout_plan.dart';
import 'package:shongi/features/health/views/widgets/Exercise_detail_sheet.dart';

class PersonalizedplanHealthpage extends StatelessWidget {
  final List<WorkoutPlan>? plans;

  /// Title of the plan matched to the user's current cycle phase. The card
  /// carrying this title is badged as the recommendation.
  final String? recommendedTitle;

  /// Exercises available in the library, used to open a plan's items. An item
  /// with no matching exercise is still listed in the sheet, just without a
  /// tutorial to open.
  final List<Exercise>? exercises;

  const PersonalizedplanHealthpage({
    super.key,
    this.plans,
    this.recommendedTitle,
    this.exercises,
  });

  static const List<WorkoutPlan> _defaultPlans = [
    WorkoutPlan(
      icon: Icons.balance_rounded,
      title: "Balance & Tone",
      subtitle: "Full body alignment",
      items: ["Vinyasa Flow", "Dance Cardio", "Full Body Strength"],
    ),
    WorkoutPlan(
      icon: Icons.tune_rounded,
      title: "Flexibility & Mind",
      subtitle: "Calm stress & tension",
      items: ["Sun Salutation", "Hip & Lower Back Stretch", "Yin Yoga"],
    ),
    WorkoutPlan(
      icon: Icons.favorite_rounded,
      title: "Core & Energy",
      subtitle: "Boost stamina & pelvic floor",
      items: ["Core Pilates", "Brisk Walk", "Resistance Band"],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final activePlans = (plans != null && plans!.isNotEmpty) ? plans! : _defaultPlans;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF7A58B8),
            Color(0xFF5B3996),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "YOUR PERSONALIZED PLAN",
                  style: GoogleFonts.poppins(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "Maintain your healthy physique with balanced routines",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              height: 1.3,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 215,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemCount: activePlans.length,
              itemBuilder: (context, index) {
                final plan = activePlans[index];
                return PlanCard(
                  plan: plan,
                  isRecommended: recommendedTitle == plan.title,
                  onTap: () => _openPlan(context, plan),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Opens the plan's exercises, matching each item to a library exercise by
  /// title so the tutorial sheet can be opened from here.
  void _openPlan(BuildContext context, WorkoutPlan plan) {
    final library = exercises ?? const <Exercise>[];
    final matches = <String, Exercise>{
      for (final exercise in library)
        exercise.title.trim().toLowerCase(): exercise,
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.35,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: pageBackground,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: cardBorderColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: accentColorLight,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(plan.icon, color: accentColor, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plan.title,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                            ),
                            if (plan.subtitle.isNotEmpty)
                              Text(
                                plan.subtitle,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  for (final item in plan.items)
                    _PlanExerciseTile(
                      title: item,
                      exercise: matches[item.trim().toLowerCase()],
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _PlanExerciseTile extends StatelessWidget {
  final String title;
  final Exercise? exercise;

  const _PlanExerciseTile({required this.title, this.exercise});

  @override
  Widget build(BuildContext context) {
    final match = exercise;
    final subtitle = match == null
        ? 'Not in the library yet'
        : '${match.category} · ${match.duration} · ${match.level}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          // Only offer a tap target when there is a tutorial to open, so an
          // unlisted item does not look broken.
          onTap: match == null
              ? null
              : () {
                  Navigator.of(context).pop();
                  showExerciseDetailSheet(context, match);
                },
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: cardBorderColor),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: chipBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    match?.icon ?? Icons.fitness_center,
                    size: 18,
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
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 11.5,
                          color: textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                if (match != null)
                  const Icon(
                    Icons.play_circle_outline_rounded,
                    size: 20,
                    color: accentColor,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final WorkoutPlan plan;
  final bool isRecommended;

  /// Called when the card is tapped, so a plan can be acted on rather than
  /// being a dead summary.
  final VoidCallback? onTap;

  const PlanCard({
    super.key,
    required this.plan,
    this.isRecommended = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: isRecommended
            ? Colors.white.withValues(alpha: 0.26)
            : Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isRecommended
              ? Colors.white.withValues(alpha: 0.85)
              : Colors.white.withValues(alpha: 0.25),
          width: isRecommended ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: _buildBody(),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(plan.icon, color: Colors.white, size: 20),
              ),
              if (isRecommended) ...[
                const SizedBox(width: 8),
                Flexible(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "FOR YOU",
                      maxLines: 1,
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF5B3996),
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Text(
            plan.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
              height: 1.25,
            ),
          ),
          if (plan.subtitle.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              plan.subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: Colors.white.withValues(alpha: 0.75),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: plan.items.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "• ",
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                      Expanded(
                        child: Text(
                          plan.items[index],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w400,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
    );
  }
}