import 'package:flutter/material.dart';

// ─── Primary palette ───────────────────────────────────────────────
const Color cardBackground = Color(0xFFFCF9FF); // Soft pastel purple
const Color accentColor    = Color(0xFF6B4BA3); // Deep purple for contrast
const Color accentColorDeep= Color(0xFF2D1457); // Dark plum for bold headings
const Color accentColorLight= Color(0xFFDCC8FF); // Soft lavender
const Color textColor      = Color(0xFF1A1A24); // Dark charcoal for readability

// ─── Semantic helpers ──────────────────────────────────────────────
/// Subtitle / secondary body text
Color get textSecondary => textColor.withValues(alpha: 0.55);

/// Card border (1 px lavender)
const Color cardBorderColor = Color(0xFFE9DEF8);

/// Page-level scaffold background
const Color pageBackground = Color(0xFFF8F4FC);

/// Chip / tag background (unselected)
const Color chipBackground = Color(0xFFF2EAFE);

/// Soft pink accent used for period / feminine highlights
const Color pinkAccent = Color(0xFFFF5C8D);
const Color pinkBackground = Color(0xFFFFEEF3);

/// Green accent for healthy statuses / beginner levels / success
const Color greenAccent = Color(0xFF006B4E);
const Color greenBackground = Color(0xFFD5F2DF);

/// Amber accent for streaks / achievements
const Color amberAccent = Color(0xFFE6A400);
const Color amberBackground = Color(0xFFFFF3D6);

/// Soft blue accent for medical info / notes
const Color blueAccent = Color(0xFF3B82F6);
const Color blueBackground = Color(0xFFEFF6FF);