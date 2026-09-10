import 'package:flutter/material.dart';

class SkincareStep {
  final int stepNumber;
  final String title;
  final String howToUse;
  final String? whyItHelps;

  const SkincareStep({
    required this.stepNumber,
    required this.title,
    required this.howToUse,
    this.whyItHelps,
  });
}

class SkincareRoutine {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? iconColor;
  final String duration;
  final List<Color> gradientColors;
  final List<SkincareStep> steps;
  final bool isActive;

  const SkincareRoutine({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.iconColor,
    this.duration = '7 Days',
    required this.gradientColors,
    required this.steps,
    this.isActive = false,
  });

  SkincareRoutine copyWith({
    String? id,
    String? title,
    String? subtitle,
    IconData? icon,
    Color? iconColor,
    String? duration,
    List<Color>? gradientColors,
    List<SkincareStep>? steps,
    bool? isActive,
  }) {
    return SkincareRoutine(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      duration: duration ?? this.duration,
      gradientColors: gradientColors ?? this.gradientColors,
      steps: steps ?? this.steps,
      isActive: isActive ?? this.isActive,
    );
  }
}
