import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shongi/core/theme/app_colors.dart';
import 'package:shongi/features/health/views/widgets/health_tagChip.dart';

class Healthchip extends StatelessWidget {
  final String selectedTag;
  final ValueChanged<String>? onTagSelected;

  const Healthchip({
    super.key,
    this.selectedTag = "Exercise",
    this.onTagSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: chipBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.spa_rounded,
                color: accentColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Health Hub",
                  style: GoogleFonts.poppins(
                    color: textColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.6,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Personalized routines for your wellness journey",
                  style: GoogleFonts.poppins(
                    color: textSecondary,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            HealthTagchip(
              text: "Exercise",
              icon: Icons.fitness_center_rounded,
              isSelected: selectedTag == "Exercise",
              ontap: () => onTagSelected?.call("Exercise"),
            ),
            HealthTagchip(
              text: "Skin Care",
              icon: Icons.auto_awesome,
              isSelected: selectedTag == "Skin Care",
              ontap: () => onTagSelected?.call("Skin Care"),
            ),
            HealthTagchip(
              text: "Hair Care",
              icon: Icons.content_cut_rounded,
              isSelected: selectedTag == "Hair Care",
              ontap: () => onTagSelected?.call("Hair Care"),
            ),
            HealthTagchip(
              text: "Doctor",
              icon: Icons.local_hospital_rounded,
              isSelected: selectedTag == "Doctor",
              ontap: () => onTagSelected?.call("Doctor"),
            ),
          ],
        ),
      ],
    );
  }
}