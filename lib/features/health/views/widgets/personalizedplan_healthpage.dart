import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shongi/core/theme/app_colors.dart';
import 'package:shongi/features/health/models/workout_plan.dart';

class PersonalizedplanHealthpage extends StatelessWidget {
  final List<WorkoutPlan>? plans;

  const PersonalizedplanHealthpage({super.key, this.plans});

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
                  "PERSONALIZED PLAN",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
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
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 190,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemCount: activePlans.length,
              itemBuilder: (context, index) {
                return PlanCard(plan: activePlans[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final WorkoutPlan plan;

  const PlanCard({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 175,
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              plan.icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            plan.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: plan.items.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5),
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
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
      ),
    );
  }
}

