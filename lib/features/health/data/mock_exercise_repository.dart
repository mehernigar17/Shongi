import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../models/workout_plan.dart';
import '../repositories/exercise_repository.dart';

class MockExerciseRepository implements ExerciseRepository {
  @override
  Future<List<Exercise>> loadExercises() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _mockExercises;
  }

  @override
  Future<List<WorkoutPlan>> loadWorkoutPlans() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _mockWorkoutPlans;
  }

  static const List<WorkoutPlan> _mockWorkoutPlans = [
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

  static const List<Exercise> _mockExercises = [
    Exercise(
      id: "e1",
      title: "Brisk Walk",
      category: "Walking",
      level: "Beginner",
      duration: "20 min",
      calories: "100 cal",
      icon: Icons.directions_walk_rounded,
      youtubeId: "RmfKqOz6V5Q",
      about: "A simple, low-impact walk done at a brisk pace to raise your heart rate, boost circulation, and regulate insulin sensitivity without stress.",
      benefits: ["Improves heart health", "Boosts mood & energy", "Gentle on joints"],
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
      about: "A relaxed walk outdoors that combines gentle cardio with the grounding, cortisol-lowering benefits of being in nature.",
      benefits: ["Reduces cortisol & stress", "Improves stamina", "Boosts natural Vitamin D"],
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
      about: "A graceful sequence of 12 linked yoga postures performed with deep breathing to energize the spine and stimulate hormonal balance.",
      benefits: ["Enhances body flexibility", "Stimulates thyroid & metabolism", "Calms the nervous system"],
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
      about: "A slow-paced, deeply relaxing style of yoga where gentle poses are held for several minutes to release fascial tension.",
      benefits: ["Increases pelvic mobility", "Reduces anxiety & fatigue", "Promotes restful sleep"],
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
      about: "A continuous flow connecting breath with dynamic movements to build core stability, heat, and lean strength.",
      benefits: ["Builds full-body tone", "Improves posture & balance", "Deepens breath capacity"],
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
      about: "Targeted Pilates mat session focusing on deep core activation, pelvic floor strength, and lower back stability.",
      benefits: ["Strengthens deep abdominal wall", "Improves posture", "Relieves lower back ache"],
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
      about: "Full-body tone workout using progressive elastic resistance to sculpt muscle and enhance insulin sensitivity without joint impact.",
      benefits: ["Builds functional muscle tone", "Enhances joint integrity", "Low-impact on hormones"],
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
      about: "Moderate resistance training targeting all major muscle groups to boost resting metabolic rate and bone density.",
      benefits: ["Supports hormone regulation", "Boosts metabolic burn", "Improves bone strength"],
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
      about: "Gentle morning awakening movements designed to loosen tight muscles, awaken the lymphatic system, and ease morning stiffness.",
      benefits: ["Releases morning stiffness", "Boosts circulation", "Sets a mindful daily tone"],
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
      about: "Focused hip openers and gentle spinal twists to relieve tension around the pelvis, hips, and lower back.",
      benefits: ["Eases pelvic discomfort", "Improves mobility", "Reduces lumbar stiffness"],
    ),
  ];
}
