import 'package:flutter/material.dart';

import 'package:shongi/core/theme/app_colors.dart';

class PeriodTrackerCard extends StatelessWidget {
  const PeriodTrackerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
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

          //top row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Row(
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    size: 16,
                    color: const Color(0xFFFF5C8D),
                  ),

                  const SizedBox(width: 6),

                  const Text(
                    "PERIOD TRACKER",
                    style: TextStyle(
                      color: Color(0xFFFF5C8D),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),

              Text(
                "View calendar",
                style: TextStyle(
                  color: accentColor.withOpacity(0.75),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          //title
          const Text(
            "Next period in ~7 days",
            style: TextStyle(
              color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 5),

         //subtitle
          Text(
            "Expected: April 27 · Duration: ~5 days",
            style: TextStyle(
              color: textColor.withOpacity(0.58),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 18),

          //week days
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _WeekDay(day: "S"),
              _WeekDay(day: "M"),
              _WeekDay(day: "T"),
              _WeekDay(day: "W"),
              _WeekDay(day: "T"),
              _WeekDay(day: "F"),
              _WeekDay(day: "S"),
            ],
          ),

          const SizedBox(height: 8),

          // date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _DateItem(day: "24"),
              _DateItem(day: "25"),
              _DateItem(
                day: "26",
                isPeriod: true,
              ),
              _DateItem(
                day: "27",
                isPeriod: true,
              ),
              _DateItem(
                day: "28",
                isPeriod: true,
              ),
              _DateItem(
                day: "29",
                isSelected: true,
              ),
              _DateItem(day: "30"),
            ],
          ),

          const SizedBox(height: 20),

          // button
          Row(
            children: [

              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9DDE7),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "🩸",
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(width: 6),

                      Text(
                        "Log Period",
                        style: TextStyle(
                          color: Color(0xFFFF5C8D),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFECE4FA),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_view_month_rounded,
                        size: 16,
                        color: accentColor,
                      ),

                      const SizedBox(width: 6),

                      Text(
                        "Full Calendar",
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeekDay extends StatelessWidget {
  final String day;

  const _WeekDay({
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      child: Center(
        child: Text(
          day,
          style: TextStyle(
            color: textColor.withOpacity(0.45),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _DateItem extends StatelessWidget {
  final String day;
  final bool isSelected;
  final bool isPeriod;

  const _DateItem({
    required this.day,
    this.isSelected = false,
    this.isPeriod = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: isSelected
            ? accentColor
            : isPeriod
            ? const Color(0xFFFFEEF3)
            : Colors.transparent,
        shape: BoxShape.circle,
        border: isPeriod
            ? Border.all(
          color: const Color(0xFFFFB8CB),
        )
            : null,
      ),
      child: Center(
        child: Text(
          day,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : textColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
