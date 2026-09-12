import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shongi/core/theme/app_colors.dart';

class GoalsCard extends StatelessWidget {
  final List<String> goals;
  final VoidCallback? onEdit;
  final ValueChanged<String>? onRemoveGoal;

  const GoalsCard({
    super.key,
    required this.goals,
    this.onEdit,
    this.onRemoveGoal,
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
                  color: amberBackground,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.flag_rounded,
                  color: amberAccent,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "My Goals",
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: onEdit ??
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Add a goal'),
                          backgroundColor: accentColor,
                        ),
                      );
                    },
                icon: const Icon(
                  Icons.add_circle_outline_rounded,
                  size: 16,
                  color: accentColor,
                ),
                label: Text(
                  "Add",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: goals.map((goal) {
              final trimmed = goal.trim();
              return GestureDetector(
                onLongPress: onRemoveGoal != null ? () => onRemoveGoal!(trimmed) : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: chipBackground,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: cardBorderColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        trimmed,
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: accentColor,
                        ),
                      ),
                      if (onRemoveGoal != null) ...[
                        const SizedBox(width: 6),
                        Icon(
                          Icons.close_rounded,
                          size: 14,
                          color: accentColor.withValues(alpha: 0.5),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          if (goals.isNotEmpty && onRemoveGoal != null) ...[
            const SizedBox(height: 10),
            Text(
              "Long-press a goal to remove it",
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}