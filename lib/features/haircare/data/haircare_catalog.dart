import 'package:flutter/material.dart';

import '../models/haircare_routine.dart';

/// The haircare routine catalog.
///
/// Content is static, but every routine is a *multi-week plan*: each entry in
/// `weeks` is one phase with its own focus, session cadence and steps. The phase
/// a user is on is derived from their routine start date (see
/// `care_plan_progress.dart`), so the plan genuinely changes every 7 days
/// instead of repeating a fixed routine.
const List<HaircareRoutine> haircareCatalog = [
  HaircareRoutine(
    id: 'oil_scalp_massage',
    title: 'Oil and Scalp Massage',
    subtitle: 'Nourish roots and boost circulation',
    icon: Icons.spa_rounded,
    iconColor: Color(0xFFFFD54F),
    frequencyBadge: '2x per week',
    gradientColors: [
      Color(0xFF6B42BF),
      Color(0xFF865ED6),
    ],
    weeks: [
      HaircareWeek(
        weekNumber: 1,
        focus: 'Start light',
        cadence: '1 session · 20 min',
        steps: [
          HaircareStep(
            stepNumber: 1,
            title: 'Warm the oil',
            howToUse:
                'Warm two to three tablespoons of coconut or argan oil between your palms. Test the temperature on your wrist first.',
            whyItHelps: 'Warm oil spreads further and absorbs better than cold oil.',
          ),
          HaircareStep(
            stepNumber: 2,
            title: 'Part and massage',
            howToUse:
                'Part your hair into sections and massage the scalp with your fingertips in small circles for three to four minutes.',
            whyItHelps:
                'Gentle pressure is enough to stimulate circulation without irritating the scalp.',
          ),
          HaircareStep(
            stepNumber: 3,
            title: 'Coat the lengths lightly',
            howToUse:
                'Run a thin amount through the mid-lengths and ends. Skip the roots if your hair is fine or gets oily fast.',
            whyItHelps:
                'A light coat smooths the cuticle without flattening fine hair.',
          ),
          HaircareStep(
            stepNumber: 4,
            title: 'Leave and rinse',
            howToUse: 'Leave on for 30 minutes, then wash out with a gentle shampoo.',
            whyItHelps:
                'Short contact still nourishes, and it is much easier to sustain than a long soak.',
          ),
        ],
      ),
      HaircareWeek(
        weekNumber: 2,
        focus: 'Build the habit',
        cadence: '2 sessions · 45 min',
        steps: [
          HaircareStep(
            stepNumber: 1,
            title: 'Warm the oil',
            howToUse:
                'Same as week one, warmed between your palms. Have it ready before you start parting.',
            whyItHelps: 'Oil that goes on cold sits on the surface instead of soaking in.',
          ),
          HaircareStep(
            stepNumber: 2,
            title: 'Part and massage',
            howToUse:
                'Five to seven minutes of fingertip circles, working section by section from the front hairline back.',
            whyItHelps:
                'More time on the scalp is what turns this from a conditioner into a circulation workout.',
          ),
          HaircareStep(
            stepNumber: 3,
            title: 'Coat the lengths',
            howToUse:
                'Work the remaining oil through the mid-lengths and ends, squeezing gently rather than combing.',
            whyItHelps: 'Seals the cuticle where hair is oldest and driest, which is where split ends start.',
          ),
          HaircareStep(
            stepNumber: 4,
            title: 'Leave and rinse',
            howToUse: 'Leave on for 45 to 60 minutes, then wash out with a gentle shampoo.',
            whyItHelps:
                'Longer contact gives the oil time to reach the scalp rather than just the surface.',
          ),
        ],
      ),
      HaircareWeek(
        weekNumber: 3,
        focus: 'Deepen the massage',
        cadence: '2 sessions · 60 min',
        steps: [
          HaircareStep(
            stepNumber: 1,
            title: 'Warm the oil',
            howToUse:
                'Warm it as before, but split the amount into two bowls so the second half stays warm.',
            whyItHelps:
                'Oil that cools halfway through stops being able to spread evenly.',
          ),
          HaircareStep(
            stepNumber: 2,
            title: 'Part and massage, seven minutes',
            howToUse:
                'Slow down and press with the pads of your fingers rather than your nails. Finish with a few long strokes from the base of the scalp up to the crown.',
            whyItHelps:
                'Long pressure strokes move lymph and settle scalp tension better than fast circles.',
          ),
          HaircareStep(
            stepNumber: 3,
            title: 'Coat the lengths',
            howToUse: 'As week two, paying extra attention to the ends.',
            whyItHelps: 'Damage concentrates at the ends, so that is where the oil does the most good.',
          ),
          HaircareStep(
            stepNumber: 4,
            title: 'Leave and rinse',
            howToUse:
                'Leave on for up to an hour, or overnight with a towel over your pillow. Rinse with a gentle shampoo twice if it feels greasy.',
            whyItHelps:
                'A double wash is what prevents a heavy, coated feeling the next day.',
          ),
        ],
      ),
      HaircareWeek(
        weekNumber: 4,
        focus: 'Maintain and observe',
        cadence: '1–2 sessions · adjust',
        steps: [
          HaircareStep(
            stepNumber: 1,
            title: 'Warm the oil, lighter this time',
            howToUse:
                'Use half the amount, or a lighter oil such as jojoba, if your hair felt flat or greasy after week three.',
            whyItHelps:
                'Matching the oil to your own hair type matters more than which oil it is.',
          ),
          HaircareStep(
            stepNumber: 2,
            title: 'Part and massage, five minutes',
            howToUse:
                'Five minutes is enough now. Keep the pressure, drop the duration.',
            whyItHelps:
                'Circulation responds to regular short sessions more than to occasional long ones.',
          ),
          HaircareStep(
            stepNumber: 3,
            title: 'Coat the lengths',
            howToUse: 'Focus on the ends only, since that is where you are aiming.',
            whyItHelps: 'Ends benefit most from oil and get greasy at the roots first.',
          ),
          HaircareStep(
            stepNumber: 4,
            title: 'Leave and rinse, then note it down',
            howToUse:
                'Rinse as usual, then note how your scalp felt and how long until your roots got oily. Use that to set your spacing next month.',
            whyItHelps:
                'Feedback from your own scalp is more accurate than any fixed schedule.',
          ),
        ],
      ),
    ],
  ),
  HaircareRoutine(
    id: 'deep_conditioning',
    title: 'Deep Conditioning',
    subtitle: 'Restore moisture and repair damage',
    icon: Icons.sanitizer_rounded,
    iconColor: Color(0xFFB3E0FF),
    frequencyBadge: '1x per week',
    gradientColors: [
      Color(0xFF1E6FD9),
      Color(0xFF4A9BE8),
    ],
    weeks: [
      HaircareWeek(
        weekNumber: 1,
        focus: 'First mask',
        cadence: '1 session · 10 min',
        steps: [
          HaircareStep(
            stepNumber: 1,
            title: 'Shampoo first',
            howToUse: 'Wash with a sulfate-free shampoo so the mask can reach clean strands.',
            whyItHelps:
                'Removes buildup that would otherwise block the mask from reaching the hair shaft.',
          ),
          HaircareStep(
            stepNumber: 2,
            title: 'Apply the mask',
            howToUse:
                'Squeeze out the water, then apply from mid-length to ends. Comb through with a wide-tooth comb.',
            whyItHelps:
                'Even distribution means every strand gets the same hydration and repair.',
          ),
          HaircareStep(
            stepNumber: 3,
            title: 'Let it sit',
            howToUse: 'Leave on for ten minutes with no heat.',
            whyItHelps:
                'Gives the conditioner time to bond to the hair without any extra risk of damage.',
          ),
          HaircareStep(
            stepNumber: 4,
            title: 'Rinse cool',
            howToUse: 'Rinse thoroughly with cool water, then air-dry or blow-dry on low.',
            whyItHelps: 'Cool water seals the cuticle, which is what adds the shine.',
          ),
        ],
      ),
      HaircareWeek(
        weekNumber: 2,
        focus: 'Add warmth',
        cadence: '1 session · 15 min + warm towel',
        steps: [
          HaircareStep(
            stepNumber: 1,
            title: 'Shampoo first',
            howToUse: 'As week one. Do not skip it, even when you are in a hurry.',
            whyItHelps: 'A mask applied over buildup mostly treats the buildup.',
          ),
          HaircareStep(
            stepNumber: 2,
            title: 'Apply the mask',
            howToUse:
                'Apply from mid-length to ends as before, and comb through to distribute evenly.',
            whyItHelps: 'Consistent application is what makes the week to week difference visible.',
          ),
          HaircareStep(
            stepNumber: 3,
            title: 'Add a warm towel',
            howToUse:
                'Wrap your head in a warm towel for ten minutes while the mask sits.',
            whyItHelps:
                'Heat lifts the cuticle so water and proteins sink in rather than sitting on the surface.',
          ),
          HaircareStep(
            stepNumber: 4,
            title: 'Rinse cool',
            howToUse: 'Rinse for a full minute with cool water, then dry on low heat.',
            whyItHelps: 'A long cool rinse is what stops conditioner residue making hair look dull.',
          ),
        ],
      ),
      HaircareWeek(
        weekNumber: 3,
        focus: 'Full-length repair',
        cadence: '1 session · 20 min',
        steps: [
          HaircareStep(
            stepNumber: 1,
            title: 'Shampoo first',
            howToUse: 'Wash with a sulfate-free shampoo, as before.',
            whyItHelps: 'Same reason as week one: clean strands absorb, coated strands do not.',
          ),
          HaircareStep(
            stepNumber: 2,
            title: 'Apply the mask through the lengths',
            howToUse:
                'This week work it all the way through to the ends, and spend extra time on whatever feels roughest to your fingers.',
            whyItHelps:
                'Damage concentrates at the ends, so targeted application repairs where it actually shows.',
          ),
          HaircareStep(
            stepNumber: 3,
            title: 'Let it sit under a cap',
            howToUse:
                'Leave on for twenty minutes under a shower cap or a warm towel.',
            whyItHelps:
                'The covering traps warmth and stops the mask drying out before it has absorbed.',
          ),
          HaircareStep(
            stepNumber: 4,
            title: 'Rinse cool, thoroughly',
            howToUse:
                'Rinse for a full minute. If your hair feels coated, rinse a second time.',
            whyItHelps:
                'Thorough rinsing is the difference between soft hair and heavy hair.',
          ),
        ],
      ),
      HaircareWeek(
        weekNumber: 4,
        focus: 'Maintenance mask',
        cadence: '1 session · 15 min + daily spot repair',
        steps: [
          HaircareStep(
            stepNumber: 1,
            title: 'Shampoo first',
            howToUse: 'Wash with a sulfate-free shampoo.',
            whyItHelps: 'Keeps the weekly mask doing real work instead of coating buildup.',
          ),
          HaircareStep(
            stepNumber: 2,
            title: 'Apply the mask',
            howToUse:
                'Mid-length to ends as usual, then comb through with a wide-tooth comb.',
            whyItHelps: 'Maintains the repair gains from the previous three weeks.',
          ),
          HaircareStep(
            stepNumber: 3,
            title: 'Let it sit',
            howToUse: 'Fifteen minutes, warm towel if your hair is very dry.',
            whyItHelps:
                'Long enough to absorb, short enough to stay a habit you will actually keep.',
          ),
          HaircareStep(
            stepNumber: 4,
            title: 'Rinse cool, then spot repair daily',
            howToUse:
                'Rinse cool as usual. From here on, add a small dab of leave-in or oil to your dry ends after every wash between sessions.',
            whyItHelps:
                'Weekly masks plus daily split-end care stop repaired hair breaking back down.',
          ),
        ],
      ),
    ],
  ),
  HaircareRoutine(
    id: 'scalp_refresh',
    title: 'Scalp Refresh',
    subtitle: 'Cleanse, exfoliate and balance',
    icon: Icons.shower_rounded,
    iconColor: Color(0xFFB2F0E8),
    frequencyBadge: '3x per week',
    gradientColors: [
      Color(0xFF0E8A7D),
      Color(0xFF2BB3A4),
    ],
    weeks: [
      HaircareWeek(
        weekNumber: 1,
        focus: 'Cleanse only',
        cadence: '3 washes · no scrub',
        steps: [
          HaircareStep(
            stepNumber: 1,
            title: 'Pre-brush',
            howToUse:
                'Gently brush or finger-comb your hair to loosen dead skin and product before washing.',
            whyItHelps: 'Loosens flakes so the cleanse can actually reach the scalp surface.',
          ),
          HaircareStep(
            stepNumber: 2,
            title: 'Gentle shampoo',
            howToUse:
                'Use a sulfate-free shampoo and massage into the scalp for about 60 seconds. No scrub this week.',
            whyItHelps:
                'Establishes a clean baseline so you can tell what the scrub actually changes later.',
          ),
          HaircareStep(
            stepNumber: 3,
            title: 'Rinse and condition',
            howToUse:
                'Rinse thoroughly, then follow with a lightweight conditioner on the lengths only.',
            whyItHelps:
                'A clean scalp with conditioned lengths avoids the tight, flaky feeling.',
          ),
          HaircareStep(
            stepNumber: 4,
            title: 'Dry gently',
            howToUse:
                'Pat dry with a microfiber towel and keep your hair loose while it dries.',
            whyItHelps: 'Less friction means less new flaking tomorrow.',
          ),
        ],
      ),
      HaircareWeek(
        weekNumber: 2,
        focus: 'Add a gentle scrub',
        cadence: '3 washes · scrub 1x',
        steps: [
          HaircareStep(
            stepNumber: 1,
            title: 'Pre-brush',
            howToUse: 'As week one, before every wash.',
            whyItHelps: 'The scrub only works if dead skin has been loosened first.',
          ),
          HaircareStep(
            stepNumber: 2,
            title: 'Scalp scrub',
            howToUse:
                'Once this week, massage a gentle scalp scrub or exfoliating shampoo into the scalp for two minutes, focusing on the hairline. Keep the other two washes scrub-free.',
            whyItHelps:
                'Clears dead skin cells and excess oil that can otherwise clog follicles.',
          ),
          HaircareStep(
            stepNumber: 3,
            title: 'Rinse and condition',
            howToUse:
                'Rinse thoroughly, then a lightweight conditioner on the lengths only.',
            whyItHelps: 'Keeps the scalp balanced while the lengths stay hydrated.',
          ),
          HaircareStep(
            stepNumber: 4,
            title: 'Dry gently',
            howToUse:
                'Pat with a microfiber towel and avoid tight hairstyles while the scalp settles.',
            whyItHelps: 'Reduces friction and irritation while the scalp recovers.',
          ),
        ],
      ),
      HaircareWeek(
        weekNumber: 3,
        focus: 'Balance the scalp',
        cadence: '3 washes · scrub 1–2x',
        steps: [
          HaircareStep(
            stepNumber: 1,
            title: 'Pre-brush',
            howToUse: 'Before every wash, as before.',
            whyItHelps: 'Keeps the cleanse effective even as you increase scrub frequency.',
          ),
          HaircareStep(
            stepNumber: 2,
            title: 'Scalp scrub',
            howToUse:
                'One or two scrubs this week depending on how your scalp feels. Back off the moment it feels raw.',
            whyItHelps:
                'Frequency that matches your scalp is the only frequency worth keeping.',
          ),
          HaircareStep(
            stepNumber: 3,
            title: 'Rinse and condition',
            howToUse:
                'Rinse well and condition the lengths on every wash, including scrub days.',
            whyItHelps: 'Scrubbing dries the lengths even when the scalp feels great.',
          ),
          HaircareStep(
            stepNumber: 4,
            title: 'Dry gently',
            howToUse:
                'Pat dry with a microfiber towel, and let your scalp breathe for the rest of the day.',
            whyItHelps: 'Sweat and trapped heat are the most common causes of flaking.',
          ),
        ],
      ),
      HaircareWeek(
        weekNumber: 4,
        focus: 'Steady routine',
        cadence: '3 washes · scrub 2x',
        steps: [
          HaircareStep(
            stepNumber: 1,
            title: 'Pre-brush',
            howToUse: 'Before every wash, as before.',
            whyItHelps: 'The first half of a routine that actually keeps flakes away.',
          ),
          HaircareStep(
            stepNumber: 2,
            title: 'Scalp scrub',
            howToUse:
                'Two scrubs a week. If flaking returns between them, widen the gap rather than scrubbing harder.',
            whyItHelps:
                'Flaking is almost always a frequency problem, not a strength problem.',
          ),
          HaircareStep(
            stepNumber: 3,
            title: 'Rinse and condition',
            howToUse: 'Rinse thoroughly and condition the lengths every wash.',
            whyItHelps: 'A settled scalp plus healthy lengths is the whole goal.',
          ),
          HaircareStep(
            stepNumber: 4,
            title: 'Dry gently',
            howToUse:
                'Pat dry, keep hair loose, and drop back to one scrub if your scalp feels tight.',
            whyItHelps:
                'Knowing how to step down is what keeps a two-scrub routine sustainable.',
          ),
        ],
      ),
    ],
  ),
];