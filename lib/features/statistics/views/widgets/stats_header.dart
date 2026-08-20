import 'package:flutter/material.dart';

import 'package:shongi/core/theme/app_colors.dart';

class StatsHeader extends StatelessWidget {
  const StatsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [


        Container(
          padding: const EdgeInsets.all(10),

          decoration: BoxDecoration(
            color: const Color(0xFFF2EAFE),
            borderRadius: BorderRadius.circular(16),
          ),

          child: const Icon(
            Icons.insights_rounded,
            color: accentColor,
            size: 22,
          ),
        ),

        const SizedBox(width: 14),


        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Your Insights",
              style: TextStyle(
                color: textColor,
                fontSize: 25,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.6,
                height: 1,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              "Track your progress & patterns",
              style: TextStyle(
                color: textColor.withOpacity(0.55),
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
