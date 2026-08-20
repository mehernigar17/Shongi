import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CycleProfileCard extends StatelessWidget {
  final String avgCycleLength;
  final String lastPeriod;
  final String cycleType;
  final String pcosDiagnosis;

  const CycleProfileCard({
    super.key,
    required this.avgCycleLength,
    required this.lastPeriod,
    required this.cycleType,
    required this.pcosDiagnosis,
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

          /// TITLE
          Row(
            children: [
              Container(
                height: 42,
                width: 42,

                decoration: BoxDecoration(
                  color: const Color(0xFFFFEEF2),
                  borderRadius: BorderRadius.circular(14),
                ),

                child: const Icon(
                  Icons.favorite_rounded,
                  color: Color(0xFFE86D8B),
                  size: 20,
                ),
              ),

              const SizedBox(width: 12),

              Text(
                "Cycle Profile",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2D1457),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          CycleInfoRow(
            title: "Avg Cycle Length",
            value: avgCycleLength,
          ),

          const Divider(),

          CycleInfoRow(
            title: "Last Period",
            value: lastPeriod,
          ),

          const Divider(),

          CycleInfoRow(
            title: "Cycle Type",
            value: cycleType,
          ),

          const Divider(),

          CycleInfoRow(
            title: "PCOS Diagnosis",
            value: pcosDiagnosis,
          ),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,
            height: 48,

            decoration: BoxDecoration(
              color: const Color(0xFFF7F1FF),
              borderRadius: BorderRadius.circular(14),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: const Color(0xFF9A63F7),
                ),

                const SizedBox(width: 8),

                Text(
                  "Edit Cycle Details",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF9A63F7),
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

class CycleInfoRow extends StatelessWidget {
  final String title;
  final String value;

  const CycleInfoRow({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [

          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF8B8B9A),
            ),
          ),

          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2D1457),
            ),
          ),
        ],
      ),
    );
  }
}