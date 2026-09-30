import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shongi/core/theme/app_colors.dart';

/// Explains that the plans below are matched to the user's real cycle phase.
/// Shows nothing until a period has been logged.
class CyclePhaseBanner extends StatelessWidget {
  final String phaseLabel;
  final String guidance;
  final int cycleDay;

  const CyclePhaseBanner({
    super.key,
    required this.phaseLabel,
    required this.guidance,
    required this.cycleDay,
  });

  @override
  Widget build(BuildContext context) {
    final isTracked = cycleDay > 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cardBorderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: isTracked ? pinkBackground : chipBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isTracked ? Icons.favorite_rounded : Icons.edit_calendar_rounded,
              size: 19,
              color: isTracked ? pinkAccent : accentColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isTracked ? '$phaseLabel • Day $cycleDay' : 'Plans not yet tailored',
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  guidance,
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    height: 1.5,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
