import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileStats extends StatelessWidget {
  const ProfileStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: statCard(
            icon: Icons.local_fire_department_rounded,
            iconColor: const Color(0xFFE85D75),
            value: "14d",
            title: "Streak",
            valueColor: const Color(0xFFE85D75),
            cardColor: const Color(0xFFFFE7EE),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: statCard(
            icon: Icons.favorite_border_rounded,
            iconColor: const Color(0xFF8B5CF6),
            value: "86",
            title: "Logs",
            valueColor: const Color(0xFF6B21A8),
            cardColor: const Color(0xFFF3ECFF),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: statCard(
            icon: Icons.emoji_events_outlined,
            iconColor: const Color(0xFFE6A400),
            value: "Silver",
            title: "Level",
            valueColor: const Color(0xFFC68A00),
            cardColor: const Color(0xFFFFF3D6),
          ),
        ),
      ],
    );
  }

  Widget statCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String title,
    required Color valueColor,
    required Color cardColor,
  }) {
    return Container(
      height: 110,

      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 22,
          ),

          const SizedBox(height: 8),

          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}