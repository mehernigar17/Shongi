import 'package:flutter/material.dart';

import 'package:shongi/core/theme/app_colors.dart';

class DailyInsightCard extends StatelessWidget {
  const DailyInsightCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: const Color(0xFFE9DEF8),
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.04),
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
              Icon(
                Icons.auto_graph_rounded,
                size: 15,
                color: accentColor,
              ),

              const SizedBox(width: 6),

              Text(
                "TODAY'S INSIGHT",
                style: TextStyle(
                  color: accentColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            "You slept less than usual yesterday 🌙",
            style: TextStyle(
              color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "Try maintaining 7-8 hours for better cycle balance and hormone health.",
            style: TextStyle(
              color: textColor.withOpacity(0.58),
              fontSize: 12,
              height: 1.45,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 14),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF8EEF6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [

                const Text(
                  "💡",
                  style: TextStyle(fontSize: 13),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    "Try a 10 min wind-down routine",
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: accentColor.withOpacity(0.7),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
