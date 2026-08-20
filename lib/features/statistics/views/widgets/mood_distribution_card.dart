import 'package:flutter/material.dart';

import 'package:shongi/core/theme/app_colors.dart';

class MoodDistributionCard extends StatelessWidget {
  const MoodDistributionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(26),

        border: Border.all(
          color: const Color(0xFFE9DEF8),
        ),

        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Mood Distribution",
            style: TextStyle(
              color: textColor,
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            "This week",
            style: TextStyle(
              color: textColor.withOpacity(0.5),
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 18),

          const _MoodBar(
            emoji: "😔",
            value: 0.12,
            percent: "12%",
          ),

          SizedBox(height: 14),

          const _MoodBar(
            emoji: "😳",
            value: 0.19,
            percent: "19%",
          ),

          SizedBox(height: 14),

          const _MoodBar(
            emoji: "🙂",
            value: 0.31,
            percent: "31%",
          ),

          SizedBox(height: 14),

          const _MoodBar(
            emoji: "😊",
            value: 0.23,
            percent: "23%",
          ),

          SizedBox(height: 14),

          const _MoodBar(
            emoji: "😄",
            value: 0.15,
            percent: "15%",
          ),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,

            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 12,
            ),

            decoration: BoxDecoration(
              color: const Color(0xFFF8F2FC),
              borderRadius: BorderRadius.circular(16),
            ),

            child: Text(
              "💜 62% of your days this week were positive. "
                  "Keep it up!",

              style: TextStyle(
                color: accentColor.withOpacity(0.88),
                fontSize: 11.5,
                height: 1.45,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoodBar extends StatelessWidget {
  final String emoji;
  final double value;
  final String percent;

  const _MoodBar({
    required this.emoji,
    required this.value,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        SizedBox(
          width: 24,
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 16),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),

            child: Stack(
              children: [

                Container(
                  height: 10,
                  color: const Color(0xFFF0E7FA),
                ),

                FractionallySizedBox(
                  widthFactor: value,

                  child: Container(
                    height: 10,

                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          accentColor.withOpacity(0.95),
                          accentColor.withOpacity(0.75),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 12),

        SizedBox(
          width: 32,

          child: Text(
            percent,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: textColor.withOpacity(0.58),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
