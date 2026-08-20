import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoalsCard extends StatelessWidget {
  final List<String> goals;

  const GoalsCard({
    super.key,
    required this.goals,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),

        border: Border.all(
          color: const Color(0xFFEDE4FA),
          width: 1.2,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// HEADER
          Row(
            children: [

              Container(
                height: 42,
                width: 42,

                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3D9),
                  borderRadius: BorderRadius.circular(14),
                ),

                child: const Icon(
                  Icons.flag_outlined,
                  color: Color(0xFFE7A61A),
                  size: 20,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  "My Goals",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2D1457),
                  ),
                ),
              ),

              TextButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 16,
                  color: Color(0xFF9A63F7),
                ),
                label: Text(
                  "Edit",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF9A63F7),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Wrap(
            spacing: 10,
            runSpacing: 10,

            children: goals.map((goal) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),

                decoration: BoxDecoration(
                  color: const Color(0xFFF5EEFF),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Text(
                  goal,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF6B4BA3),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}