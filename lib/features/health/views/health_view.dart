import 'package:flutter/material.dart';
import 'package:shongi/core/theme/app_colors.dart';
import 'package:shongi/features/doctors/views/doctors_view.dart';
import 'package:shongi/features/health/data/mock_exercise_repository.dart';
import 'package:shongi/features/health/viewmodels/health_view_model.dart';
import 'package:shongi/features/health/views/widgets/header_tagchips_healthPage.dart';
import 'package:shongi/features/health/views/widgets/personalizedplan_healthpage.dart';
import 'package:shongi/features/health/views/widgets/exerciseLibrary_healthPage.dart';

import 'package:shongi/features/haircare/views/haircare_view.dart';
import 'package:shongi/features/skincare/views/skincare_view.dart';

class HealthScreen extends StatefulWidget {
  final HealthViewModel? viewModel;

  const HealthScreen({super.key, this.viewModel});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  late final HealthViewModel _viewModel;
  bool _ownsViewModel = false;

  @override
  void initState() {
    super.initState();
    if (widget.viewModel != null) {
      _viewModel = widget.viewModel!;
    } else {
      _viewModel = HealthViewModel(MockExerciseRepository());
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
    return Scaffold(
      backgroundColor: pageBackground,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _viewModel,
          builder: (context, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Healthchip(
                    selectedTag: _viewModel.hubTag,
                    onTagSelected: (tag) {
                      _viewModel.selectHubTag(tag);
                    },
                  ),
                  const SizedBox(height: 16),
                  if (_viewModel.hubTag == "Skin Care")
                    const SkincareView()
                  else if (_viewModel.hubTag == "Hair Care")
                    const HaircareView()
                  else if (_viewModel.hubTag == "Doctor")
                    const DoctorsView()
                  else ...[
                    PersonalizedplanHealthpage(
                      plans: _viewModel.workoutPlans,
                    ),
                    const SizedBox(height: 20),
                    ExerciseLibrary(
                      exercises: _viewModel.allExercises,
                      selectedCategory: _viewModel.selectedCategory,
                      onCategorySelected: (cat) => _viewModel.selectCategory(cat),
                    ),
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}