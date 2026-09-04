import 'package:flutter/material.dart';

class Exercise {
  final String id;
  final String title;
  final String category;
  final String level;
  final String duration;
  final String calories;
  final IconData icon;
  final String youtubeId;
  final String about;
  final List<String> benefits;

  const Exercise({
    required this.id,
    required this.title,
    required this.category,
    required this.level,
    required this.duration,
    required this.calories,
    this.icon = Icons.fitness_center,
    required this.youtubeId,
    required this.about,
    required this.benefits,
  });
}
