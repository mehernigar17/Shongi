import 'package:flutter/material.dart';
import 'widgets/profile_head.dart';
import 'package:shongi/features/profile/views/widgets/profile_stats.dart';
import 'package:shongi/features/profile/views/widgets/profile_cycle.dart';
import 'package:shongi/features/profile/views/widgets/profile_goal.dart';
import 'package:shongi/features/profile/views/widgets/profile_prefenrences.dart';
import 'package:shongi/features/profile/views/widgets/profile_achievements.dart';
import 'package:shongi/features/profile/views/widgets/profile_logout.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F4FB),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              children: [
                ProfileHeader(),
                SizedBox(height: 16),
                ProfileStats(),
                SizedBox(height: 16),
                CycleProfileCard(
                  avgCycleLength: "30 Days",
                  lastPeriod: "April 2, 2026",
                  cycleType: "Irregular",
                  pcosDiagnosis: "Confirmed",
                ),
                SizedBox(height: 16),
                GoalsCard(
                  goals: [
                    " Fertility Support",
                    " Weight Management",
                    "Better Mood",
                  ],
                ),
                SizedBox(height: 16),
                PreferencesCard(
                  dailyReminders: true,
                  notificationsEnabled: true,
                  privacyEnabled: false,
                ),
                SizedBox(height: 16),
                AchievementsCard(),
                SizedBox(height: 16),
                SignOutButton(
                  onTap: () {
                    debugPrint("Sign out pressed");
                  },
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );

  }
}