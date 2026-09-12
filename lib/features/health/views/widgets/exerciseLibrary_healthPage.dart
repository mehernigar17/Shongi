import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shongi/core/theme/app_colors.dart';
import 'package:shongi/features/health/models/exercise.dart';
import 'package:shongi/features/health/views/widgets/tagChip_exerciseLibrary_healthPage.dart';
import 'package:shongi/features/health/views/widgets/exercise_card.dart';
import 'package:shongi/features/health/views/widgets/Exercise_detail_sheet.dart';

class ExerciseLibrary extends StatefulWidget {
  final List<Exercise>? exercises;
  final String? selectedCategory;
  final ValueChanged<String>? onCategorySelected;

  const ExerciseLibrary({
    super.key,
    this.exercises,
    this.selectedCategory,
    this.onCategorySelected,
  });

  @override
  State<ExerciseLibrary> createState() => _ExerciseLibraryState();
}

class _ExerciseLibraryState extends State<ExerciseLibrary> {
  String _internalCategory = "All";

  static const List<String> categories = [
    "All",
    "Walking",
    "Yoga",
    "Pilates",
    "Strength Training",
    "Stretching",
  ];

  static const List<Exercise> _defaultExercises = [
    Exercise(
      id: "e1",
      title: "Brisk Walk",
      category: "Walking",
      level: "Beginner",
      duration: "20 min",
      calories: "100 cal",
      icon: Icons.directions_walk_rounded,
      youtubeId: "RmfKqOz6V5Q",
      about: "A simple, low-impact walk done at a faster-than-normal pace to raise your heart rate and improve circulation.",
      benefits: ["Improves heart health", "Boosts mood", "Easy on the joints"],
    ),
    Exercise(
      id: "e2",
      title: "Nature Walk",
      category: "Walking",
      level: "Beginner",
      duration: "30 min",
      calories: "120 cal",
      icon: Icons.nature_people_rounded,
      youtubeId: "ZXt3GTLQU3g",
      about: "A relaxed walk outdoors that combines light cardio with the calming benefits of being in nature.",
      benefits: ["Reduces stress", "Improves stamina", "Boosts vitamin D levels"],
    ),
    Exercise(
      id: "e3",
      title: "Sun Salutation",
      category: "Yoga",
      level: "Intermediate",
      duration: "15 min",
      calories: "80 cal",
      icon: Icons.self_improvement_rounded,
      youtubeId: "6BMTeOOCqHo",
      about: "A flowing sequence of yoga poses performed in a continuous, rhythmic motion to warm up the entire body.",
      benefits: ["Improves flexibility", "Boosts circulation", "Calms the mind"],
    ),
    Exercise(
      id: "e4",
      title: "Yin Yoga",
      category: "Yoga",
      level: "Beginner",
      duration: "30 min",
      calories: "60 cal",
      icon: Icons.spa_rounded,
      youtubeId: "EYsRfDvKKZ4",
      about: "A slow-paced style of yoga where poses are held for longer periods to target deep connective tissue.",
      benefits: ["Increases flexibility", "Reduces anxiety", "Improves sleep quality"],
    ),
    Exercise(
      id: "e5",
      title: "Vinyasa Flow",
      category: "Yoga",
      level: "Intermediate",
      duration: "45 min",
      calories: "150 cal",
      icon: Icons.accessibility_new_rounded,
      youtubeId: "4pKly2JojMw",
      about: "A dynamic style of yoga that links breath with movement, flowing smoothly from one pose to the next.",
      benefits: ["Builds strength", "Improves balance", "Increases lung capacity"],
    ),
    Exercise(
      id: "e6",
      title: "Core Pilates",
      category: "Pilates",
      level: "Beginner",
      duration: "20 min",
      calories: "90 cal",
      icon: Icons.sports_gymnastics_rounded,
      youtubeId: "K56Z92mhioM",
      about: "A targeted Pilates session focusing on strengthening the core muscles including abs, obliques, and lower back.",
      benefits: ["Core strength", "Better posture", "Reduces back pain"],
    ),
    Exercise(
      id: "e7",
      title: "Resistance Band",
      category: "Strength Training",
      level: "Beginner",
      duration: "30 min",
      calories: "130 cal",
      icon: Icons.fitness_center_rounded,
      youtubeId: "lLEodWaUATk",
      about: "A full-body strength workout using resistance bands to build muscle tone without heavy equipment.",
      benefits: ["Builds lean muscle", "Improves joint stability", "Low impact on joints"],
    ),
    Exercise(
      id: "e8",
      title: "Full Body Strength",
      category: "Strength Training",
      level: "Intermediate",
      duration: "40 min",
      calories: "200 cal",
      icon: Icons.fitness_center_rounded,
      youtubeId: "U0bhE67HuDY",
      about: "A comprehensive strength training session targeting all major muscle groups for balanced full-body development.",
      benefits: ["Builds muscle strength", "Boosts metabolism", "Improves bone density"],
    ),
    Exercise(
      id: "e9",
      title: "Morning Stretch",
      category: "Stretching",
      level: "Beginner",
      duration: "10 min",
      calories: "40 cal",
      icon: Icons.wb_sunny_rounded,
      youtubeId: "g_tea8ZNk5A",
      about: "A short, gentle stretching routine designed to wake up the body and ease morning stiffness.",
      benefits: ["Improves flexibility", "Wakes up the body", "Eases muscle tension"],
    ),
    Exercise(
      id: "e10",
      title: "Hip & Lower Back Stretch",
      category: "Stretching",
      level: "Beginner",
      duration: "15 min",
      calories: "50 cal",
      icon: Icons.accessibility_rounded,
      youtubeId: "R5qLnnNCN8w",
      about: "A focused stretching routine that targets tight hips and lower back, common areas of tension.",
      benefits: ["Relieves hip tightness", "Reduces lower back pain", "Improves mobility"],
    ),
  ];

  String get effectiveCategory => widget.selectedCategory ?? _internalCategory;

  List<Exercise> get filteredList {
    final list = (widget.exercises != null && widget.exercises!.isNotEmpty)
        ? widget.exercises!
        : _defaultExercises;

    if (effectiveCategory == "All") return list;
    return list.where((e) => e.category == effectiveCategory).toList();
  }

  void _handleCategoryTap(String category) {
    if (widget.onCategorySelected != null) {
      widget.onCategorySelected!(category);
    } else {
      setState(() {
        _internalCategory = category;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Exercise Library",
                style: GoogleFonts.poppins(
                  fontSize: 18.5,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                  letterSpacing: -0.4,
                ),
              ),
              Text(
                "${filteredList.length} routines",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              children: categories.map((cat) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: TagchipExerciselibraryHealthpage(
                    text: cat,
                    isSelected: effectiveCategory == cat,
                    onTap: () => _handleCategoryTap(cat),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              final exercise = filteredList[index];
              return ExerciseCard(
                exercise: exercise,
                onTap: () {
                  showExerciseDetailSheet(context, exercise);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}