import 'package:flutter/material.dart';

import '../models/skincare_routine.dart';

/// The skincare routine catalog.
///
/// Content is static, but every routine is a *multi-week plan*: each entry in
/// `weeks` is one phase with its own focus and steps. The phase a user is on is
/// derived from their routine start date (see `care_plan_progress.dart`), so the
/// plan genuinely changes every 7 days instead of repeating a fixed routine.
const List<SkincareRoutine> skincareCatalog = [
  SkincareRoutine(
    id: 'daily_glow',
    title: 'Daily Glow',
    subtitle: 'Maintain healthy radiant skin',
    icon: Icons.auto_awesome_rounded,
    iconColor: Color(0xFFFFD54F),
    gradientColors: [
      Color(0xFF6B42BF),
      Color(0xFF865ED6),
    ],
    weeks: [
      SkincareWeek(
        weekNumber: 1,
        focus: 'Settle and strengthen',
        cadence: 'Daily · AM + PM',
        steps: [
          SkincareStep(
            stepNumber: 1,
            title: 'Gentle cleanser',
            howToUse:
                'Use a balanced, non-stripping cleanser morning and night. Rinse with lukewarm water and pat dry instead of rubbing.',
            whyItHelps:
                'Clears daily buildup without disturbing the oil and moisture normal skin relies on to stay comfortable.',
          ),
          SkincareStep(
            stepNumber: 2,
            title: 'Lightweight moisturiser',
            howToUse:
                'A pea-sized amount on slightly damp skin, morning and night. If it feels heavy by midday, go lighter.',
            whyItHelps:
                'Locks water into the skin and keeps it supple without clogging pores.',
          ),
          SkincareStep(
            stepNumber: 3,
            title: 'SPF 50',
            howToUse:
                'Two finger lengths for face and neck, 15 minutes before sun exposure. Reapply every two hours outdoors.',
            whyItHelps:
                'Blocks the UV damage behind premature fine lines and uneven tone.',
          ),
        ],
      ),
      SkincareWeek(
        weekNumber: 2,
        focus: 'Add a morning antioxidant',
        cadence: 'Vitamin C · every morning',
        steps: [
          SkincareStep(
            stepNumber: 1,
            title: 'Gentle cleanser',
            howToUse:
                'Same as week one. Keep the base routine boring so you can tell what the new serum is doing.',
            whyItHelps:
                'A stable base means any change you see comes from the active you added.',
          ),
          SkincareStep(
            stepNumber: 2,
            title: 'Vitamin C serum',
            howToUse:
                'Three to four drops on clean, dry skin each morning. Wait a full minute before moisturiser.',
            whyItHelps:
                'Neutralises daytime free radicals and supports collagen, so skin looks brighter over weeks rather than hours.',
          ),
          SkincareStep(
            stepNumber: 3,
            title: 'Lightweight moisturiser',
            howToUse: 'Apply straight after the serum has absorbed.',
            whyItHelps: 'Seals the antioxidant in and keeps the barrier topped up.',
          ),
          SkincareStep(
            stepNumber: 4,
            title: 'SPF 50',
            howToUse: 'Final step every morning. Vitamin C and sunscreen work better together than either alone.',
            whyItHelps: 'Vitamin C mops up the free radicals sunscreen cannot block.',
          ),
        ],
      ),
      SkincareWeek(
        weekNumber: 3,
        focus: 'Add evening niacinamide',
        cadence: 'Vitamin C AM · niacinamide PM',
        steps: [
          SkincareStep(
            stepNumber: 1,
            title: 'Gentle cleanser',
            howToUse: 'Morning and night as before.',
            whyItHelps: 'Keeps the routine predictable while you add a second active.',
          ),
          SkincareStep(
            stepNumber: 2,
            title: 'Vitamin C serum',
            howToUse: 'Mornings only, three to four drops.',
            whyItHelps: 'Stays most useful against the free radicals you take in during the day.',
          ),
          SkincareStep(
            stepNumber: 3,
            title: 'Niacinamide serum',
            howToUse:
                'Two to three drops at night, after cleansing and before moisturiser. Start every other night if your skin is new to it.',
            whyItHelps:
                'Calms redness and visibly refines pores over time, and it pairs safely with vitamin C.',
          ),
          SkincareStep(
            stepNumber: 4,
            title: 'Lightweight moisturiser + SPF',
            howToUse: 'Moisturise both mornings and nights, then SPF as the last morning step.',
            whyItHelps: 'Two actives in one day is enough. More than this is what causes irritation.',
          ),
        ],
      ),
      SkincareWeek(
        weekNumber: 4,
        focus: 'Consolidate and glow',
        cadence: 'Full routine · daily',
        steps: [
          SkincareStep(
            stepNumber: 1,
            title: 'Double cleanse at night',
            howToUse:
                'Massage a cleansing balm or oil onto dry skin for 60 seconds, then follow with your usual water-based cleanser.',
            whyItHelps:
                'Removes sunscreen and makeup from the pores without a harsh second scrub.',
          ),
          SkincareStep(
            stepNumber: 2,
            title: 'Vitamin C serum',
            howToUse: 'Mornings only, on clean dry skin.',
            whyItHelps: 'Keeps the brightening effect you built over the previous three weeks.',
          ),
          SkincareStep(
            stepNumber: 3,
            title: 'Niacinamide serum',
            howToUse: 'Nights only, after cleansing.',
            whyItHelps: 'Sustained use is what makes pore and redness improvements actually visible.',
          ),
          SkincareStep(
            stepNumber: 4,
            title: 'Moisturiser + SPF 50',
            howToUse: 'Moisturiser morning and night, SPF every morning on top.',
            whyItHelps: 'Holds both actives in place and protects the work they have done.',
          ),
        ],
      ),
    ],
  ),
  SkincareRoutine(
    id: 'anti_aging_starter',
    title: 'Anti-Aging Starter',
    subtitle: 'Prevent and protect',
    icon: Icons.local_florist_rounded,
    iconColor: Color(0xFFFF80AB),
    gradientColors: [
      Color(0xFFC22575),
      Color(0xFFDE438E),
    ],
    weeks: [
      SkincareWeek(
        weekNumber: 1,
        focus: 'Cleanse and protect',
        cadence: 'Daily · SPF focus',
        steps: [
          SkincareStep(
            stepNumber: 1,
            title: 'Gentle cleanser',
            howToUse: 'Morning and night, lukewarm water, patted dry.',
            whyItHelps:
                'Retinol is coming in week two and it hates a irritated base. Start calm.',
          ),
          SkincareStep(
            stepNumber: 2,
            title: 'Peptide moisturiser',
            howToUse:
                'Morning and night. On drier nights press an extra layer onto the cheeks and around the eyes.',
            whyItHelps:
                'Peptides support firmness and hold water in the upper layers of skin.',
          ),
          SkincareStep(
            stepNumber: 3,
            title: 'Night oil cleanse',
            howToUse:
                'At night, work a cleansing oil over dry skin for 60 seconds before your usual cleanser.',
            whyItHelps:
                'Clears sunscreen and makeup so the night actives reach skin instead of sitting on top of them.',
          ),
          SkincareStep(
            stepNumber: 4,
            title: 'SPF 50+',
            howToUse:
                'Non-negotiable, even indoors by a window and on cloudy days.',
            whyItHelps:
                'UV is the biggest external driver of visible ageing, so this step out-earns every serum.',
          ),
        ],
      ),
      SkincareWeek(
        weekNumber: 2,
        focus: 'Introduce retinol, one night',
        cadence: 'Retinol · 1 night only',
        steps: [
          SkincareStep(
            stepNumber: 1,
            title: 'Gentle cleanser',
            howToUse: 'Double cleanse at night, single cleanse in the morning.',
            whyItHelps: 'Clean dry skin is a requirement for retinol, not a preference.',
          ),
          SkincareStep(
            stepNumber: 2,
            title: 'Retinol, first night',
            howToUse:
                'One night only. A pea-sized amount for the whole face on completely dry skin, avoiding the eye corners and sides of the nose.',
            whyItHelps:
                'The strongest evidence-backed anti-ageing active: it speeds cell turnover and collagen production.',
          ),
          SkincareStep(
            stepNumber: 3,
            title: 'Peptide moisturiser',
            howToUse: 'Apply immediately after the retinol to buffer it.',
            whyItHelps:
                'Buffering is what stops the flaking and tightness most people quit over in week one.',
          ),
          SkincareStep(
            stepNumber: 4,
            title: 'SPF 50+',
            howToUse: 'Every morning. Do not skip the day after a retinol night.',
            whyItHelps: 'Retinol thins the outer layer, so unprotected sun exposure undoes the work.',
          ),
        ],
      ),
      SkincareWeek(
        weekNumber: 3,
        focus: 'Build retinol tolerance',
        cadence: 'Retinol · 2 nights',
        steps: [
          SkincareStep(
            stepNumber: 1,
            title: 'Gentle cleanser',
            howToUse: 'Double cleanse on retinol nights, single cleanse on the others.',
            whyItHelps: 'Keeps the skin clean without over-stripping between applications.',
          ),
          SkincareStep(
            stepNumber: 2,
            title: 'Retinol, two nights',
            howToUse:
                'Two nights spaced at least three days apart, for example Monday and Thursday. Keep every other night retinol-free.',
            whyItHelps:
                'Spaced nights give skin time to recover while your exposure still climbs.',
          ),
          SkincareStep(
            stepNumber: 3,
            title: 'Peptide moisturiser',
            howToUse: 'Every night, heavier on retinol nights.',
            whyItHelps: 'Reduces the peeling that otherwise makes people quit at week three.',
          ),
          SkincareStep(
            stepNumber: 4,
            title: 'SPF 50+',
            howToUse: 'Every morning, generous amount.',
            whyItHelps:
                'The single most important step while retinol is in your routine.',
          ),
        ],
      ),
      SkincareWeek(
        weekNumber: 4,
        focus: 'Full anti-ageing routine',
        cadence: 'Retinol · 3 alternate nights',
        steps: [
          SkincareStep(
            stepNumber: 1,
            title: 'Double cleanse at night',
            howToUse:
                'Oil cleanse for 60 seconds on dry skin, then a water-based cleanser. Morning is a single cleanse.',
            whyItHelps: 'Buildup under retinol is the most common cause of a sudden breakout.',
          ),
          SkincareStep(
            stepNumber: 2,
            title: 'Retinol, three nights',
            howToUse:
                'Three alternate nights a week. If you flake or sting, drop back to two nights rather than pushing through irritation.',
            whyItHelps:
                'Consistency at a dose you can tolerate beats intensity you cannot maintain.',
          ),
          SkincareStep(
            stepNumber: 3,
            title: 'Peptide moisturiser',
            howToUse: 'Every night, and any morning your skin feels tight.',
            whyItHelps: 'Firming results show up only when the barrier stays intact alongside it.',
          ),
          SkincareStep(
            stepNumber: 4,
            title: 'SPF 50+',
            howToUse: 'Every morning, and reapply outdoors.',
            whyItHelps: 'Protects the collagen you are trying to build.',
          ),
        ],
      ),
    ],
  ),
  SkincareRoutine(
    id: 'brightening_ritual',
    title: 'Brightening Ritual',
    subtitle: 'Even skin tone and texture',
    icon: Icons.wb_sunny_rounded,
    iconColor: Color(0xFFFFE082),
    gradientColors: [
      Color(0xFFC77800),
      Color(0xFFE29712),
    ],
    weeks: [
      SkincareWeek(
        weekNumber: 1,
        focus: 'Prep and hydrate',
        cadence: 'Daily · no exfoliation',
        steps: [
          SkincareStep(
            stepNumber: 1,
            title: 'Gentle cleanser',
            howToUse: 'Morning and night. No scrubs or exfoliating acids this week.',
            whyItHelps:
                'A hydrated, uninflamed base is what lets exfoliation in week two go smoothly.',
          ),
          SkincareStep(
            stepNumber: 2,
            title: 'Niacinamide serum',
            howToUse: 'Two to three drops morning and night, before moisturiser.',
            whyItHelps:
                'Fades existing dark marks and blocks new ones, and it is one of the few actives safe twice a day.',
          ),
          SkincareStep(
            stepNumber: 3,
            title: 'Vitamin C moisturiser',
            howToUse: 'Smooth over face and neck morning and night.',
            whyItHelps:
                'Antioxidants alongside nourishment, so brightening does not cost you moisture.',
          ),
          SkincareStep(
            stepNumber: 4,
            title: 'SPF',
            howToUse: 'Broad spectrum, every morning, 15 minutes before going outdoors.',
            whyItHelps: 'Every tone improvement you make is undone by unprotected sun exposure.',
          ),
        ],
      ),
      SkincareWeek(
        weekNumber: 2,
        focus: 'Add exfoliation, one night',
        cadence: 'AHA · 1 night',
        steps: [
          SkincareStep(
            stepNumber: 1,
            title: 'Gentle cleanser',
            howToUse: 'As usual, morning and night.',
            whyItHelps: 'Keeps the base consistent while a new active is introduced.',
          ),
          SkincareStep(
            stepNumber: 2,
            title: 'AHA exfoliant, first night',
            howToUse:
                'Once a week at night on clean dry skin. Leave for the time printed on the label, then rinse. Skip exfoliating for the two nights after.',
            whyItHelps:
                'Dissolves the dead surface cells that make tone look dull and patchy.',
          ),
          SkincareStep(
            stepNumber: 3,
            title: 'Niacinamide serum',
            howToUse:
                'Morning only on your exfoliation night; mornings and nights on all the other nights.',
            whyItHelps:
                'Stacking two strong actives on the same night is the fastest route to irritation.',
          ),
          SkincareStep(
            stepNumber: 4,
            title: 'Moisturiser + SPF',
            howToUse: 'Moisturise immediately after rinsing the acid, then SPF every morning.',
            whyItHelps: 'Moisturiser immediately after an acid is what prevents the tight feeling.',
          ),
        ],
      ),
      SkincareWeek(
        weekNumber: 3,
        focus: 'Two exfoliation nights',
        cadence: 'AHA · 2 nights',
        steps: [
          SkincareStep(
            stepNumber: 1,
            title: 'Gentle cleanser',
            howToUse: 'As usual on non-exfoliation nights.',
            whyItHelps: 'Keeps sebum and buildup in check between exfoliation nights.',
          ),
          SkincareStep(
            stepNumber: 2,
            title: 'AHA exfoliant, two nights',
            howToUse:
                'Two nights a week, spaced apart. Always moisturise straight after rinsing.',
            whyItHelps:
                'A second weekly dose keeps cell turnover moving once week two proved your skin tolerates it.',
          ),
          SkincareStep(
            stepNumber: 3,
            title: 'Niacinamide serum',
            howToUse: 'Mornings on exfoliation nights, mornings and nights otherwise.',
            whyItHelps: 'Keeps working on tone in the gaps between acid nights.',
          ),
          SkincareStep(
            stepNumber: 4,
            title: 'Vitamin C moisturiser + SPF',
            howToUse: 'Both mornings and nights, with SPF on top every morning.',
            whyItHelps: 'Protects new surface cells from the sun before they can pigment.',
          ),
        ],
      ),
      SkincareWeek(
        weekNumber: 4,
        focus: 'Brightening maintenance',
        cadence: 'AHA · 1–2 nights, daily support',
        steps: [
          SkincareStep(
            stepNumber: 1,
            title: 'Double cleanse at night',
            howToUse: 'Cleansing oil for 60 seconds on dry skin, then your usual cleanser.',
            whyItHelps: 'Lifts sunscreen and old pigment so new cells start from a clean surface.',
          ),
          SkincareStep(
            stepNumber: 2,
            title: 'AHA exfoliant, maintenance',
            howToUse:
                'One to two nights a week. Drop back any time skin feels tight or flaky rather than adding a third night.',
            whyItHelps:
                'Long-term maintenance beats short aggressive bursts for even tone.',
          ),
          SkincareStep(
            stepNumber: 3,
            title: 'Niacinamide serum',
            howToUse: 'Every morning and night, without exception.',
            whyItHelps: 'Daily is what keeps new dark marks from forming in the first place.',
          ),
          SkincareStep(
            stepNumber: 4,
            title: 'Vitamin C moisturiser + SPF',
            howToUse: 'Daily, with SPF reapplied every two hours outdoors.',
            whyItHelps: 'The finishing pair that holds the tone gains in place.',
          ),
        ],
      ),
    ],
  ),
];