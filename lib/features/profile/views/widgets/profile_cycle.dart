import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shongi/core/theme/app_colors.dart';

class CycleProfileCard extends StatelessWidget {
  final String avgCycleLength;
  final String lastPeriod;
  final String cycleType;
  final String pcosDiagnosis;
  final VoidCallback? onEdit;

  const CycleProfileCard({
    super.key,
    required this.avgCycleLength,
    required this.lastPeriod,
    required this.cycleType,
    required this.pcosDiagnosis,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cardBorderColor),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: pinkBackground,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  color: pinkAccent,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "Cycle Profile",
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          CycleInfoRow(
            title: "Avg Cycle Length",
            value: avgCycleLength,
          ),
          Divider(color: cardBorderColor.withValues(alpha: 0.6), height: 16),
          CycleInfoRow(
            title: "Last Period",
            value: lastPeriod,
          ),
          Divider(color: cardBorderColor.withValues(alpha: 0.6), height: 16),
          CycleInfoRow(
            title: "Cycle Type",
            value: cycleType,
          ),
          Divider(color: cardBorderColor.withValues(alpha: 0.6), height: 16),
          CycleInfoRow(
            title: "PCOS Diagnosis",
            value: pcosDiagnosis,
          ),
          const SizedBox(height: 16),
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onEdit ??
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Edit Cycle Details coming soon!'),
                      backgroundColor: accentColor,
                    ),
                  );
                },
            child: Container(
              width: double.infinity,
              height: 46,
              decoration: BoxDecoration(
                color: chipBackground,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: cardBorderColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.edit_outlined,
                    size: 17,
                    color: accentColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Edit Cycle Details",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: textSecondary,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}