import 'package:flutter/material.dart';

class WorkoutPlan {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<String> items;

  const WorkoutPlan({
    required this.icon,
    required this.title,
    this.subtitle = '',
    required this.items,
  });
}
