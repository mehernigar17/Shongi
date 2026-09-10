import 'package:flutter/material.dart';
import '../models/skincare_routine.dart';
import '../repositories/skincare_repository.dart';

class MockSkincareRepository implements SkincareRepository {
  String _activeRoutineId = '';

  @override
  Future<List<SkincareRoutine>> loadRoutines() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _mockRoutines.map((routine) {
      return routine.copyWith(isActive: routine.id == _activeRoutineId);
    }).toList();
  }

  @override
  Future<String> getPersonalizedSkinType() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return 'Normal Skin';
  }

  @override
  Future<void> saveActiveRoutine(String routineId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    _activeRoutineId = routineId;
  }

  static final List<SkincareRoutine> _mockRoutines = [
    const SkincareRoutine(
      id: 'daily_glow',
      title: 'Daily Glow',
      subtitle: 'Maintain healthy radiant skin',
      icon: Icons.auto_awesome_rounded,
      iconColor: Color(0xFFFFD54F),
      duration: '7 Days',
      gradientColors: [
        Color(0xFF6B42BF),
        Color(0xFF865ED6),
      ],
      steps: [
        SkincareStep(
          stepNumber: 1,
          title: 'Gentle cleanser',
          howToUse:
              'Use a balanced cleanser — not too stripping, not too creamy. Rinse with lukewarm water.',
          whyItHelps:
              'Removes daily buildup without disturbing the natural balance that normal skin already maintains well.',
        ),
        SkincareStep(
          stepNumber: 2,
          title: 'Vitamin C serum',
          howToUse:
              'Apply 3–4 drops each morning. Allow 1 minute to absorb before moisturiser.',
          whyItHelps:
              'Boosts collagen, evens tone, and gives skin an extra radiant glow — the best preventive investment for normal skin.',
        ),
        SkincareStep(
          stepNumber: 3,
          title: 'Lightweight moisturiser',
          howToUse:
              'Apply a small amount — normal skin does not need heavy products to feel comfortable.',
          whyItHelps:
              'Locks in essential hydration and keeps skin supple and soft all day.',
        ),
        SkincareStep(
          stepNumber: 4,
          title: 'SPF 50',
          howToUse:
              'Apply generously as the final step every morning, even on cloudy days.',
          whyItHelps:
              'Protects against UV damage, hyperpigmentation, and premature fine lines.',
        ),
      ],
    ),
    const SkincareRoutine(
      id: 'anti_aging_starter',
      title: 'Anti-Aging Starter',
      subtitle: 'Prevent and protect',
      icon: Icons.local_florist_rounded,
      iconColor: Color(0xFFFF80AB),
      duration: '7 Days',
      gradientColors: [
        Color(0xFFC22575),
        Color(0xFFDE438E),
      ],
      steps: [
        SkincareStep(
          stepNumber: 1,
          title: 'Double cleanse',
          howToUse:
              'Evening only: oil cleanse first, then follow with a water-based cleanser.',
          whyItHelps:
              'Thorough cleansing ensures retinol and actives can fully penetrate in the evening routine.',
        ),
        SkincareStep(
          stepNumber: 2,
          title: 'Retinol serum (1×/wk)',
          howToUse:
              'Start with once a week only. Apply to dry skin at night. Buffer with moisturiser if irritation occurs.',
          whyItHelps:
              'Retinol is the gold standard anti-ageing ingredient — speeds cell turnover, builds collagen, reduces fine lines.',
        ),
        SkincareStep(
          stepNumber: 3,
          title: 'Peptide moisturiser',
          howToUse:
              'Apply after retinol or as a standalone moisturiser on non-retinol nights.',
          whyItHelps:
              'Deeply supports barrier restoration and firming peptide synthesis.',
        ),
        SkincareStep(
          stepNumber: 4,
          title: 'SPF 50+',
          howToUse:
              'Essential daily use. Retinol increases skin sensitivity to UV rays.',
          whyItHelps:
              'Vital protection because retinol increases cellular UV sensitivity.',
        ),
      ],
    ),
    const SkincareRoutine(
      id: 'brightening_ritual',
      title: 'Brightening Ritual',
      subtitle: 'Even skin tone & texture',
      icon: Icons.wb_sunny_rounded,
      iconColor: Color(0xFFFFE082),
      duration: '7 Days',
      gradientColors: [
        Color(0xFFC77800),
        Color(0xFFE29712),
      ],
      steps: [
        SkincareStep(
          stepNumber: 1,
          title: 'AHA cleanser (2×/wk)',
          howToUse:
              'Gently massage into damp skin 2 nights a week. Do not overuse. Rinse thoroughly.',
          whyItHelps:
              'Chemical exfoliation sweeps away dead cells to reveal brighter underlying skin.',
        ),
        SkincareStep(
          stepNumber: 2,
          title: 'Niacinamide serum',
          howToUse:
              'Apply 2–3 drops morning and night before moisturiser.',
          whyItHelps:
              'Regulates sebum, minimizes pore appearance, and fades dark spots.',
        ),
        SkincareStep(
          stepNumber: 3,
          title: 'Vitamin C moisturiser',
          howToUse:
              'Smooth evenly over face and neck morning and evening.',
          whyItHelps:
              'Antioxidant protection combined with deep nourishment for lit-from-within glow.',
        ),
        SkincareStep(
          stepNumber: 4,
          title: 'SPF',
          howToUse:
              'Apply broad-spectrum protection 15 minutes before stepping outdoors.',
          whyItHelps:
              'Shields newly exfoliated skin from sun spots and hyperpigmentation.',
        ),
      ],
    ),
  ];
}
