import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shongi/features/health/views/widgets/health_tagChip.dart';

class Healthchip extends StatefulWidget {
  const Healthchip({super.key});

  @override
  State<Healthchip> createState() => _HealthchipState();
}

class _HealthchipState extends State<Healthchip> {
  String selectedTag = "Exercise";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Health Hub",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.deepPurple,
          ),
        ),
        Text(
          "Personalized routines for your wellness journey",
          style: GoogleFonts.poppins(color: Colors.grey),
        ),
        const SizedBox(height: 5),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            HealthTagchip(
              text: "Exercise",
              icon: Icons.fitness_center,
              isSelected: selectedTag == "Exercise",
              ontap: () => setState(() => selectedTag = "Exercise"),
            ),
            HealthTagchip(
              text: "Skin Care",
              icon: Icons.face_retouching_natural,
              isSelected: selectedTag == "Skin Care",
              ontap: () => setState(() => selectedTag = "Skin Care"),
            ),
            HealthTagchip(
              text: "Hair Care",
              icon: Icons.dry,
              isSelected: selectedTag == "Hair Care",
              ontap: () => setState(() => selectedTag = "Hair Care"),
            ),
            HealthTagchip(
              text: "Doctor",
              icon: Icons.local_hospital,
              isSelected: selectedTag == "Doctor",
              ontap: () => setState(() => selectedTag = "Doctor"),
            ),
          ],
        ),
      ],
    );
  }
}