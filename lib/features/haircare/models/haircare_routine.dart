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

/// One week of a haircare plan.
///
/// Each week is a separate phase with its own focus and its own steps, so the
/// plan keeps changing as the user works through it instead of repeating one
/// static routine forever.
class HaircareWeek {
  final int weekNumber;

  /// What this week is about, e.g. `Deepen the massage`.
  final String focus;

  /// How many sessions this week runs at, e.g. `2 sessions · 45 min`.
  final String cadence;

  final List<HaircareStep> steps;

  const HaircareWeek({
    required this.weekNumber,
    required this.focus,
    required this.cadence,
    required this.steps,
  });
}

class HaircareRoutine {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? iconColor;

  /// Plan-level frequency, e.g. `2x per week`. The per-week `cadence` is more
  /// specific and is what the progress UI shows while a plan is running.
  final String frequencyBadge;
  final List<Color> gradientColors;
  final List<HaircareWeek> weeks;
  final bool isActive;

  const HaircareRoutine({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.iconColor,
    this.frequencyBadge = '2x per week',
    required this.gradientColors,
    required this.weeks,
    this.isActive = false,
  });

  int get totalWeeks => weeks.length;

  /// Badge text for the plan length, e.g. `4-Week Plan`.
  String get planLengthLabel => '$totalWeeks-Week Plan';

  /// Returns the week at [weekNumber] (1-based), clamped to the plan length.
  HaircareWeek? weekAt(int weekNumber) {
    if (weeks.isEmpty) return null;
    final index = (weekNumber - 1).clamp(0, weeks.length - 1);
    return weeks[index];
  }

  /// Steps previewed on a card before a plan is started.
  List<HaircareStep> get previewSteps =>
      weeks.isEmpty ? const [] : weeks.first.steps;

  HaircareRoutine copyWith({
    String? id,
    String? title,
    String? subtitle,
    IconData? icon,
    Color? iconColor,
    String? frequencyBadge,
    List<Color>? gradientColors,
    List<HaircareWeek>? weeks,
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
      weeks: weeks ?? this.weeks,
      isActive: isActive ?? this.isActive,
    );
  }
}