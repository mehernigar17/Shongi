import 'package:flutter/material.dart';

import 'package:shongi/core/theme/app_colors.dart';

class PeriodTrackerCard extends StatelessWidget {
  final DateTime? nextPeriodDate;
  final int avgCycleLength;
  final int avgPeriodDuration;
  final DateTime? lastPeriodStart;
  final VoidCallback? onLogPeriod;
  final VoidCallback? onViewCalendar;

  const PeriodTrackerCard({
    super.key,
    this.nextPeriodDate,
    this.avgCycleLength = 28,
    this.avgPeriodDuration = 5,
    this.lastPeriodStart,
    this.onLogPeriod,
    this.onViewCalendar,
  });

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  Widget build(BuildContext context) {
    final next = nextPeriodDate;
    final hasData = next != null;

    // Build a 7-day strip centered on the next period date.
    final stripStart = hasData
        ? next.subtract(const Duration(days: 3))
        : DateTime.now().subtract(const Duration(days: 3));
    final days = List.generate(7, (i) => stripStart.add(Duration(days: i)));

    final expectedDuration = avgPeriodDuration > 0 ? avgPeriodDuration : 5;

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
              InkWell(
                onTap: onViewCalendar,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Text(
                    "View history",
                    style: TextStyle(
                      color: accentColor.withOpacity(0.75),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            hasData
                ? 'Next period in ~${next.difference(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)).inDays} days'
                : 'Log your period to see predictions',
            style: const TextStyle(
              color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            hasData
                ? 'Expected: ${_months[next.month - 1]} ${next.day} · Duration: ~$expectedDuration days'
                : 'Your cycle predictions will appear here',
            style: TextStyle(
              color: textColor.withOpacity(0.58),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 18),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: days.map((d) {
              final isPeriod = hasData &&
                  !d.isBefore(next) &&
                  d.isBefore(next.add(Duration(days: expectedDuration)));
              final isToday = d.year == DateTime.now().year &&
                  d.month == DateTime.now().month &&
                  d.day == DateTime.now().day;
              return _DateItem(
                day: "${d.day}",
                isPeriod: isPeriod,
                isSelected: isToday,
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: onLogPeriod,
                  borderRadius: BorderRadius.circular(18),
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
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  onTap: onViewCalendar,
                  borderRadius: BorderRadius.circular(18),
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
            color: isSelected ? Colors.white : textColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}