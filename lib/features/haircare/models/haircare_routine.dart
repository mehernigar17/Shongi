import 'package:flutter/material.dart';

class HaircareStep {
  final int stepNumber;
  final String title;
  final String howToUse;
  final String? whyItHelps;

  const HaircareStep({
    required this.stepNumber,
    required this.title,
    required this.howToUse,
    this.whyItHelps,
  });
}

class HaircareRoutine {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? iconColor;
  final String frequencyBadge;
  final List<Color> gradientColors;
  final List<HaircareStep> steps;
  final bool isActive;

  const HaircareRoutine({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.iconColor,
    this.frequencyBadge = '2x per week',
    required this.gradientColors,
    required this.steps,
    this.isActive = false,
  });

  HaircareRoutine copyWith({
    String? id,
    String? title,
    String? subtitle,
    IconData? icon,
    Color? iconColor,
    String? frequencyBadge,
    List<Color>? gradientColors,
    List<HaircareStep>? steps,
    bool? isActive,
  }) {
    return HaircareRoutine(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      frequencyBadge: frequencyBadge ?? this.frequencyBadge,
      gradientColors: gradientColors ?? this.gradientColors,
      steps: steps ?? this.steps,
      isActive: isActive ?? this.isActive,
    );
  }
}