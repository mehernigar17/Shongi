import 'package:flutter/material.dart';
import '../models/haircare_routine.dart';
import '../repositories/haircare_repository.dart';

class MockHaircareRepository implements HaircareRepository {
  String _activeRoutineId = '';

  @override
  Future<List<HaircareRoutine>> loadRoutines() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _mockRoutines.map((routine) {
      return routine.copyWith(isActive: routine.id == _activeRoutineId);
    }).toList();
  }

  @override
  Future<String> getPersonalizedPlanTitle() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return 'Hair & Scalp Care';
  }

  @override
  Future<void> saveActiveRoutine(String routineId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    _activeRoutineId = routineId;
  }

  static final List<HaircareRoutine> _mockRoutines = [
    const HaircareRoutine(
      id: 'oil_scalp_massage',
      title: 'Oil & Scalp Massage',
      subtitle: 'Nourish roots & boost circulation',
      icon: Icons.spa_rounded,
      iconColor: Color(0xFFFFD54F),
      frequencyBadge: '2x per week',
      gradientColors: [
        Color(0xFF6B42BF),
        Color(0xFF865ED6),
      ],
      steps: [
        HaircareStep(
          stepNumber: 1,
          title: 'Warm the oil',
          howToUse:
              'Warm 2–3 tablespoons of coconut or argan oil between your palms or in a small bowl of warm water. Test the temperature on your wrist first.',
          whyItHelps:
              'Warm oil penetrates the hair shaft and scalp more easily, improving absorption and comfort.',
        ),
        HaircareStep(
          stepNumber: 2,
          title: 'Part & massage',
          howToUse:
              'Part your hair into sections and massage the oil into your scalp with your fingertips using small circular motions for 5–7 minutes.',
          whyItHelps:
              'Massage stimulates blood flow to hair follicles, encouraging growth and relieving scalp tension.',
        ),
        HaircareStep(
          stepNumber: 3,
          title: 'Coat the lengths',
          howToUse:
              'Run the remaining oil through the mid-lengths and ends of your hair. Skip the roots if your hair is fine or oily.',
          whyItHelps:
              'Seals the cuticle and prevents split ends and frizz where hair is oldest and driest.',
        ),
        HaircareStep(
          stepNumber: 4,
          title: 'Leave & rinse',
          howToUse:
              'Leave on for 30–60 minutes (or overnight with a towel over your pillow), then wash with a gentle shampoo.',
          whyItHelps:
              'Gives the oil time to nourish the scalp and strands before being washed away.',
        ),
      ],
    ),
    const HaircareRoutine(
      id: 'deep_conditioning',
      title: 'Deep Conditioning',
      subtitle: 'Restore moisture & repair damage',
      icon: Icons.sanitizer_rounded,
      iconColor: Color(0xFFB3E0FF),
      frequencyBadge: '1x per week',
      gradientColors: [
        Color(0xFF1E6FD9),
        Color(0xFF4A9BE8),
      ],
      steps: [
        HaircareStep(
          stepNumber: 1,
          title: 'Shampoo first',
          howToUse:
              'Wash your hair with a sulfate-free shampoo so the conditioner can penetrate clean strands.',
          whyItHelps:
              'Removes buildup that would otherwise block the mask from reaching the hair shaft.',
        ),
        HaircareStep(
          stepNumber: 2,
          title: 'Apply the mask',
          howToUse:
              'Squeeze out excess water, then apply a deep conditioner from mid-length to ends. Comb through with a wide-tooth comb.',
          whyItHelps:
              'Even distribution ensures every strand receives the same repair and hydration.',
        ),
        HaircareStep(
          stepNumber: 3,
          title: 'Let it sit',
          howToUse:
              'Leave on for 10–15 minutes. For extra penetration, cover with a shower cap or warm towel.',
          whyItHelps:
              'Heat opens the cuticle so moisture and proteins can sink deeper into the hair.',
        ),
        HaircareStep(
          stepNumber: 4,
          title: 'Rinse cool',
          howToUse:
              'Rinse thoroughly with cool water, then air-dry or blow-dry on low heat.',
          whyItHelps:
              'Cool water seals the cuticle, locking in moisture and adding shine.',
        ),
      ],
    ),
    const HaircareRoutine(
      id: 'scalp_refresh',
      title: 'Scalp Refresh',
      subtitle: 'Cleanse, exfoliate & balance',
      icon: Icons.shower_rounded,
      iconColor: Color(0xFFB2F0E8),
      frequencyBadge: '3x per week',
      gradientColors: [
        Color(0xFF0E8A7D),
        Color(0xFF2BB3A4),
      ],
      steps: [
        HaircareStep(
          stepNumber: 1,
          title: 'Pre-brush',
          howToUse:
              'Gently brush or finger-comb your hair to loosen dead skin and product buildup before washing.',
          whyItHelps:
              'Loosens flakes and buildup so the cleanse can reach the scalp surface.',
        ),
        HaircareStep(
          stepNumber: 2,
          title: 'Scalp scrub',
          howToUse:
              'Massage a gentle scalp scrub or exfoliating shampoo into your scalp for 2–3 minutes, focusing on the hairline.',
          whyItHelps:
              'Removes dead skin cells and excess oil that can clog hair follicles.',
        ),
        HaircareStep(
          stepNumber: 3,
          title: 'Rinse & condition',
          howToUse:
              'Rinse thoroughly, then follow with a lightweight conditioner only on the lengths.',
          whyItHelps:
              'Keeps the scalp clean and balanced while the lengths stay hydrated.',
        ),
        HaircareStep(
          stepNumber: 4,
          title: 'Dry gently',
          howToUse:
              'Pat hair dry with a microfiber towel and avoid tight hairstyles while the scalp settles.',
          whyItHelps:
              'Reduces friction and irritation, letting the scalp breathe and recover.',
        ),
      ],
    ),
  ];
}