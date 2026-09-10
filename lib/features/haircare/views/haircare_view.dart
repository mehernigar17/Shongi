import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shongi/core/theme/app_colors.dart';
import '../data/mock_haircare_repository.dart';
import '../viewmodels/haircare_view_model.dart';
import 'widgets/haircare_reminder_dialog.dart';
import 'widgets/haircare_routine_card.dart';

class HaircareView extends StatefulWidget {
  final HaircareViewModel? viewModel;

  const HaircareView({super.key, this.viewModel});

  @override
  State<HaircareView> createState() => _HaircareViewState();
}

class _HaircareViewState extends State<HaircareView> {
  late final HaircareViewModel _viewModel;
  bool _ownsViewModel = false;

  @override
  void initState() {
    super.initState();
    if (widget.viewModel != null) {
      _viewModel = widget.viewModel!;
    } else {
      _viewModel = HaircareViewModel(MockHaircareRepository());
      _ownsViewModel = true;
    }
  }

  @override
  void dispose() {
    if (_ownsViewModel) {
      _viewModel.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        if (_viewModel.isLoading && _viewModel.routines.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(color: accentColor),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Personalized Plan Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF381B6D),
                    Color(0xFF4C278C),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF381B6D).withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'YOUR PERSONALIZED PLAN',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withValues(alpha: 0.65),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Your hair care starts with',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _viewModel.personalizedTitle,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Routines are tailored to your hair type from onboarding.',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Section Header
            Text(
              'Hair Care Routines',
              style: GoogleFonts.poppins(
                color: textColor,
                fontSize: 18.5,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 14),

            // Routines list
            ..._viewModel.routines.map((routine) {
              return HaircareRoutineCard(
                routine: routine,
                onStartRoutine: () async {
                  await _viewModel.startRoutine(routine.id);
                  if (context.mounted) {
                    HaircareReminderDialog.show(context, routine);
                  }
                },
              );
            }),
          ],
        );
      },
    );
  }
}