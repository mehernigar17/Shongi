import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shongi/features/health/views/widgets/tagChip_exerciseLibrary_healthPage.dart';
import 'package:shongi/features/health/views/widgets/exercise_modal.dart';
import 'package:shongi/features/health/views/widgets/exercise_card.dart';
import 'package:shongi/features/health/views/widgets/Exercise_detail_sheet.dart';

class ExerciseLibrary extends StatefulWidget {
  const ExerciseLibrary({super.key});

  @override
  State<ExerciseLibrary> createState() => _ExerciseLibraryState();
}

class _ExerciseLibraryState extends State<ExerciseLibrary> {

  String selectedCategory = "All";

  final List<ExerciseModel> allExercises = [
    ExerciseModel(
      title: "Brisk Walk",
      category: "Walking",
      level: "Beginner",
      duration: "20 min",
      calories: "100 cal",
      icon: Icons.directions_walk,
      youtubeId: "RmfKqOz6V5Q",
      about: "A simple, low-impact walk done at a faster-than-normal pace to raise your heart rate and improve circulation.",
      benefits: ["Improves heart health", "Boosts mood", "Easy on the joints"],
    ),
    ExerciseModel(
      title: "Nature Walk",
      category: "Walking",
      level: "Beginner",
      duration: "30 min",
      calories: "120 cal",
      icon: Icons.directions_walk,
      youtubeId: "ZXt3GTLQU3g",
      about: "A relaxed walk outdoors that combines light cardio with the calming benefits of being in nature.",
      benefits: ["Reduces stress", "Improves stamina", "Boosts vitamin D levels"],
    ),
    ExerciseModel(
      title: "Sun Salutation",
      category: "Yoga",
      level: "Intermediate",
      duration: "15 min",
      calories: "80 cal",
      icon: Icons.self_improvement,
      youtubeId: "6BMTeOOCqHo",
      about: "A flowing sequence of yoga poses performed in a continuous, rhythmic motion to warm up the entire body.",
      benefits: ["Improves flexibility", "Boosts circulation", "Calms the mind"],
    ),
    ExerciseModel(
      title: "Yin Yoga",
      category: "Yoga",
      level: "Beginner",
      duration: "30 min",
      calories: "60 cal",
      icon: Icons.self_improvement,
      youtubeId: "EYsRfDvKKZ4",
      about: "A slow-paced style of yoga where poses are held for longer periods to target deep connective tissue.",
      benefits: ["Increases flexibility", "Reduces anxiety", "Improves sleep quality"],
    ),
    ExerciseModel(
      title: "Vinyasa Flow",
      category: "Yoga",
      level: "Intermediate",
      duration: "45 min",
      calories: "150 cal",
      icon: Icons.self_improvement,
      youtubeId: "4pKly2JojMw",
      about: "A dynamic style of yoga that links breath with movement, flowing smoothly from one pose to the next.",
      benefits: ["Builds strength", "Improves balance", "Increases lung capacity"],
    ),
    ExerciseModel(
      title: "Core Pilates",
      category: "Pilates",
      level: "Beginner",
      duration: "20 min",
      calories: "90 cal",
      icon: Icons.sports_gymnastics,
      youtubeId: "K56Z92mhioM",
      about: "A targeted Pilates session focusing on strengthening the core muscles including abs, obliques, and lower back.",
      benefits: ["Core strength", "Better posture", "Reduces back pain"],
    ),
    ExerciseModel(
      title: "Resistance Band",
      category: "Strength Training",
      level: "Beginner",
      duration: "30 min",
      calories: "130 cal",
      icon: Icons.fitness_center,
      youtubeId: "lLEodWaUATk",
      about: "A full-body strength workout using resistance bands to build muscle tone without heavy equipment.",
      benefits: ["Builds lean muscle", "Improves joint stability", "Low impact on joints"],
    ),
    ExerciseModel(
      title: "Full Body Strength",
      category: "Strength Training",
      level: "Intermediate",
      duration: "40 min",
      calories: "200 cal",
      icon: Icons.fitness_center,
      youtubeId: "U0bhE67HuDY",
      about: "A comprehensive strength training session targeting all major muscle groups for balanced full-body development.",
      benefits: ["Builds muscle strength", "Boosts metabolism", "Improves bone density"],
    ),
    ExerciseModel(
      title: "Morning Stretch",
      category: "Stretching",
      level: "Beginner",
      duration: "10 min",
      calories: "40 cal",
      icon: Icons.accessibility_new,
      youtubeId: "g_tea8ZNk5A",
      about: "A short, gentle stretching routine designed to wake up the body and ease morning stiffness.",
      benefits: ["Improves flexibility", "Wakes up the body", "Eases muscle tension"],
    ),
    ExerciseModel(
      title: "Hip & Lower Back Stretch",
      category: "Stretching",
      level: "Beginner",
      duration: "15 min",
      calories: "50 cal",
      icon: Icons.accessibility_new,
      youtubeId: "R5qLnnNCN8w",
      about: "A focused stretching routine that targets tight hips and lower back, common areas of tension.",
      benefits: ["Relieves hip tightness", "Reduces lower back pain", "Improves mobility"],
    ),
    ExerciseModel(
      title: "Zumba",
      category: "Dance Fitness",
      level: "Beginner",
      duration: "30 min",
      calories: "200 cal",
      icon: Icons.music_note,
      youtubeId: "qaSiBR40HKk",
      about: "A fun, high-energy dance workout set to Latin and international music for a full-body cardio session.",
      benefits: ["Burns calories fast", "Improves coordination", "Boosts mood"],
    ),
    ExerciseModel(
      title: "Dance Cardio",
      category: "Dance Fitness",
      level: "Intermediate",
      duration: "40 min",
      calories: "220 cal",
      icon: Icons.music_note,
      youtubeId: "p1J27FF1AzM",
      about: "An upbeat cardio workout built around dance moves, designed to maximize calorie burn while having fun.",
      benefits: ["Improves cardiovascular health", "Burns calories", "Enhances coordination"],
    ),
  ];

  List<ExerciseModel> get filteredExercises {
    if (selectedCategory == "All") return allExercises;

    return allExercises
        .where((e) => e.category == selectedCategory)
        .toList();
  }

  void changeCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            "Exercise Library",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),

          const SizedBox(height: 10),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              TagchipExerciselibraryHealthpage(
                text: "All",
                isSelected: selectedCategory == "All",
                onTap: () => changeCategory("All"),
              ),
              TagchipExerciselibraryHealthpage(
                text: "Walking",
                isSelected: selectedCategory == "Walking",
                onTap: () => changeCategory("Walking"),
              ),
              TagchipExerciselibraryHealthpage(
                text: "Yoga",
                isSelected: selectedCategory == "Yoga",
                onTap: () => changeCategory("Yoga"),
              ),
              TagchipExerciselibraryHealthpage(
                text: "Pilates",
                isSelected: selectedCategory == "Pilates",
                onTap: () => changeCategory("Pilates"),
              ),
              TagchipExerciselibraryHealthpage(
                text: "Strength Training",
                isSelected: selectedCategory == "Strength Training",
                onTap: () => changeCategory("Strength Training"),
              ),

            ],
          ),

          const SizedBox(height: 15),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredExercises.length,
            itemBuilder: (context, index) {
              final exercise = filteredExercises[index];

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