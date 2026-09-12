import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shongi/core/theme/app_colors.dart';
import 'package:shongi/features/onboarding/data/in_memory_profile_repository.dart';
import 'package:shongi/features/profile/viewmodels/profile_view_model.dart';
import 'package:shongi/features/profile/views/widgets/profile_head.dart';
import 'package:shongi/features/profile/views/widgets/profile_stats.dart';
import 'package:shongi/features/profile/views/widgets/profile_cycle.dart';
import 'package:shongi/features/profile/views/widgets/profile_goal.dart';
import 'package:shongi/features/profile/views/widgets/profile_prefenrences.dart';
import 'package:shongi/features/profile/views/widgets/profile_achievements.dart';
import 'package:shongi/features/profile/views/widgets/profile_logout.dart';

class ProfileScreen extends StatefulWidget {
  final ProfileViewModel? viewModel;

  const ProfileScreen({super.key, this.viewModel});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileViewModel _vm;
  bool _ownsViewModel = false;

  @override
  void initState() {
    super.initState();
    if (widget.viewModel != null) {
      _vm = widget.viewModel!;
    } else {
      _vm = ProfileViewModel(InMemoryProfileRepository());
      _ownsViewModel = true;
    }
  }

  @override
  void dispose() {
    if (_ownsViewModel) _vm.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showEditNameSheet() {
    final controller = TextEditingController(text: _vm.name);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: cardBorderColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Edit Name',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
              decoration: InputDecoration(
                hintText: 'Enter your name',
                hintStyle: GoogleFonts.poppins(
                  color: textSecondary,
                  fontSize: 14,
                ),
                filled: true,
                fillColor: const Color(0xFFF8F4FC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: cardBorderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: cardBorderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: accentColor, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  _vm.updateName(controller.text);
                  Navigator.pop(context);
                  _showSnackBar('Name updated!');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Save',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditCycleSheet() {
    final avgCtrl = TextEditingController(text: _vm.avgCycleLength);
    final periodCtrl = TextEditingController(text: _vm.lastPeriod);
    final typeCtrl = TextEditingController(text: _vm.cycleType);
    final pcosCtrl = TextEditingController(text: _vm.pcosDiagnosis);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cardBorderColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Edit Cycle Details',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(avgCtrl, 'Avg Cycle Length', 'e.g. 30 Days'),
              const SizedBox(height: 14),
              _buildTextField(periodCtrl, 'Last Period', 'e.g. April 2, 2026'),
              const SizedBox(height: 14),
              _buildTextField(typeCtrl, 'Cycle Type', 'e.g. Regular, Irregular'),
              const SizedBox(height: 14),
              _buildTextField(pcosCtrl, 'PCOS Diagnosis', 'e.g. Confirmed'),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    _vm.updateCycleDetails(
                      avgCycleLength: avgCtrl.text,
                      lastPeriod: periodCtrl.text,
                      cycleType: typeCtrl.text,
                      pcosDiagnosis: pcosCtrl.text,
                    );
                    Navigator.pop(context);
                    _showSnackBar('Cycle details updated!');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Save Changes',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(color: textSecondary, fontSize: 13),
            filled: true,
            fillColor: const Color(0xFFF8F4FC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: cardBorderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: cardBorderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: accentColor, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  void _showAddGoalDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Text(
          'Add Goal',
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
          decoration: InputDecoration(
            hintText: 'Enter a goal',
            hintStyle: GoogleFonts.poppins(color: textSecondary, fontSize: 13),
            filled: true,
            fillColor: const Color(0xFFF8F4FC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: cardBorderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: cardBorderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: accentColor, width: 1.5),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                _vm.addGoal(controller.text);
                Navigator.pop(ctx);
                _showSnackBar('Goal added!');
              }
            },
            child: Text(
              'Add',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Text(
          'Sign Out',
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        content: Text(
          'Are you sure you want to sign out?',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _showSnackBar('Signed out successfully');
            },
            child: Text(
              'Sign Out',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: pinkAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F4FB),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _vm,
          builder: (context, _) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ProfileHeader(
                      name: _vm.name,
                      subtitle: _vm.memberSubtitle,
                      onEdit: _showEditNameSheet,
                    ),
                    const SizedBox(height: 16),
                    ProfileStats(
                      streak: _vm.streakDays,
                      logs: _vm.totalLogs,
                      level: _vm.userLevel,
                      onStreakTap: () => _showSnackBar('Streak details coming soon!'),
                      onLogsTap: () => _showSnackBar('Log history coming soon!'),
                      onLevelTap: () => _showSnackBar('Level details coming soon!'),
                    ),
                    const SizedBox(height: 16),
                    CycleProfileCard(
                      avgCycleLength: _vm.avgCycleLength,
                      lastPeriod: _vm.lastPeriod,
                      cycleType: _vm.cycleType,
                      pcosDiagnosis: _vm.pcosDiagnosis,
                      onEdit: _showEditCycleSheet,
                    ),
                    const SizedBox(height: 16),
                    GoalsCard(
                      goals: _vm.goals,
                      onEdit: _showAddGoalDialog,
                      onRemoveGoal: (goal) {
                        _vm.removeGoal(goal);
                        _showSnackBar('Removed "$goal"');
                      },
                    ),
                    const SizedBox(height: 16),
                    PreferencesCard(
                      dailyReminders: _vm.dailyReminders,
                      notificationsEnabled: _vm.notificationsEnabled,
                      privacyEnabled: _vm.privacyEnabled,
                      onDailyRemindersChanged: (v) {
                        _vm.setDailyReminders(v);
                        _showSnackBar(v ? 'Daily reminders enabled' : 'Daily reminders disabled');
                      },
                      onNotificationsChanged: (v) {
                        _vm.setNotifications(v);
                        _showSnackBar(v ? 'Notifications enabled' : 'Notifications disabled');
                      },
                      onPrivacyChanged: (v) {
                        _vm.setPrivacy(v);
                        _showSnackBar(v ? 'Privacy mode enabled' : 'Privacy mode disabled');
                      },
                    ),
                    const SizedBox(height: 16),
                    AchievementsCard(
                      onBadgeTap: (title) {
                        _showSnackBar('Achievement: $title');
                      },
                    ),
                    const SizedBox(height: 16),
                    SignOutButton(
                      onTap: _showSignOutDialog,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}