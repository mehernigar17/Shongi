import 'package:flutter/material.dart';

import 'package:shongi/core/theme/app_colors.dart';

class StatsSummaryCards extends StatelessWidget {
  const StatsSummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [

        Expanded(
          child: _SummaryCard(
            icon: Icons.nightlight_round,
            value: "7.1h",
            label: "Sleep",
            trend: "+5%",
            trendUp: true,
            tint: Color(0xFFEDE4FF),
          ),
        ),

        SizedBox(width: 8),

        Expanded(
          child: _SummaryCard(
            icon: Icons.sync_rounded,
            value: "30d",
            label: "Cycle",
            trend: "-3%",
            trendUp: false,
            tint: Color(0xFFF3E7FF),
          ),
        ),

        SizedBox(width: 8),

        Expanded(
          child: _SummaryCard(
            icon: Icons.sentiment_very_satisfied_rounded,
            value: "62%",
            label: "Mood",
            trend: "+5%",
            trendUp: true,
            tint: Color(0xFFF0E8FF),
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final String trend;
  final bool trendUp;
  final Color tint;

  const _SummaryCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.trend,
    required this.trendUp,
    required this.tint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22),

        border: Border.all(
          color: const Color(0xFFE9DEF8),
        ),

        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Container(
                padding: const EdgeInsets.all(7),

                decoration: BoxDecoration(
                  color: tint,
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Icon(
                  icon,
                  size: 15,
                  color: accentColor,
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 4,
                ),

                decoration: BoxDecoration(
                  color: trendUp
                      ? const Color(0xFFEAF8F1)
                      : const Color(0xFFFFEEF1),

                  borderRadius: BorderRadius.circular(10),
                ),

                child: Text(
                  trend,
                  style: TextStyle(
                    color: trendUp
                        ? const Color(0xFF3EB97A)
                        : const Color(0xFFFF6B81),

                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),


          Text(
            value,
            style: const TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),

          const SizedBox(height: 5),


          Text(
            label,
            style: TextStyle(
              color: textColor.withOpacity(0.52),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
