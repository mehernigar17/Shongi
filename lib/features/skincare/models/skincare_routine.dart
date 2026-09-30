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

/// One week of a skincare plan.
///
/// Each week is a separate phase with its own focus and its own steps, so the
/// plan keeps changing as the user works through it instead of repeating one
/// static routine forever.
class SkincareWeek {
  final int weekNumber;

  /// What this week is about, e.g. `Build retinol tolerance`.
  final String focus;

  /// How hard the plan runs this week, e.g. `Retinol 2 nights`.
  final String cadence;

  final List<SkincareStep> steps;

  const SkincareWeek({
    required this.weekNumber,
    required this.focus,
    required this.cadence,
    required this.steps,
  });
}

class SkincareRoutine {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? iconColor;
  final List<Color> gradientColors;
  final List<SkincareWeek> weeks;
  final bool isActive;

  const SkincareRoutine({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.iconColor,
    required this.gradientColors,
    required this.weeks,
    this.isActive = false,
  });

  int get totalWeeks => weeks.length;

  /// Badge text for the plan length, e.g. `4-Week Plan`.
  String get planLengthLabel => '$totalWeeks-Week Plan';

  /// Returns the week at [weekNumber] (1-based), clamped to the plan length.
  SkincareWeek? weekAt(int weekNumber) {
    if (weeks.isEmpty) return null;
    final index = (weekNumber - 1).clamp(0, weeks.length - 1);
    return weeks[index];
  }

  /// Steps previewed on a card before a plan is started.
  List<SkincareStep> get previewSteps =>
      weeks.isEmpty ? const [] : weeks.first.steps;

  SkincareRoutine copyWith({
    String? id,
    String? title,
    String? subtitle,
    IconData? icon,
    Color? iconColor,
    List<Color>? gradientColors,
    List<SkincareWeek>? weeks,
    bool? isActive,
  }) {
    return SkincareRoutine(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      gradientColors: gradientColors ?? this.gradientColors,
      weeks: weeks ?? this.weeks,
      isActive: isActive ?? this.isActive,
    );
  }
}