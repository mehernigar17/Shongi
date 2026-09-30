import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:shongi/core/theme/app_colors.dart';

class SleepTrendsCard extends StatelessWidget {
  /// Sleep hours per logged day, in date order.
  final List<double> sleepHours;

  const SleepTrendsCard({super.key, this.sleepHours = const []});

  double? get _avg {
    if (sleepHours.isEmpty) return null;
    return sleepHours.reduce((a, b) => a + b) / sleepHours.length;
  }

  /// Chart bounds derived from the real data.
  ///
  /// A hardcoded 4–10 window silently hid any night outside that range, so
  /// the bounds are padded around the observed minimum and maximum instead.
  ({double minY, double maxY, double interval}) _yScale() {
    if (sleepHours.isEmpty) return (minY: 4, maxY: 10, interval: 2);
    var lo = sleepHours.reduce((a, b) => a < b ? a : b);
    var hi = sleepHours.reduce((a, b) => a > b ? a : b);
    // Keep a sane band even when every night is identical.
    if (hi - lo < 1) {
      lo -= 1;
      hi += 1;
    }
    final minY = (lo - 0.5).floorToDouble().clamp(0, 24).toDouble();
    final maxY = (hi + 0.5).ceilToDouble().clamp(minY + 1, 24).toDouble();
    final span = maxY - minY;
    // Aim for roughly 4 gridlines regardless of the range.
    final interval = (span / 4).ceilToDouble().clamp(0.5, 6).toDouble();
    return (minY: minY, maxY: maxY, interval: interval);
  }

  @override
  Widget build(BuildContext context) {
    final avg = _avg;
    final scale = _yScale();
    final spots = <FlSpot>[
      for (var i = 0; i < sleepHours.length; i++) FlSpot(i.toDouble(), sleepHours[i]),
    ];

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Sleep Trends",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Hours per night",
                    style: TextStyle(
                      color: textColor.withOpacity(0.5),
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3EAFE),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.trending_up_rounded,
                      size: 12,
                      color: accentColor.withOpacity(0.8),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      avg != null ? "Avg ${avg.toStringAsFixed(1)}h" : "No data",
                      style: const TextStyle(
                        color: accentColor,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (spots.isEmpty)
            _emptyState("Log your sleep to see your sleep trend here.")
          else
            SizedBox(
              height: 155,
              child: LineChart(
                LineChartData(
                  // A single data point still needs a valid x-axis span.
                  minX: 0,
                  maxX: spots.length > 1 ? (spots.length - 1).toDouble() : 1,
                  minY: scale.minY,
                  maxY: scale.maxY,
                  gridData: FlGridData(
                    drawVerticalLine: false,
                    horizontalInterval: scale.interval,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: const Color(0xFFE9DEF8),
                        strokeWidth: 1,
                        dashArray: [4, 4],
                      );
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 18,
                        interval: scale.interval,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              color: textColor.withValues(alpha: 0.42),
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: spots.length <= 7,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              'Day ${value.toInt() + 1}',
                              style: TextStyle(
                                color: textColor.withValues(alpha: 0.45),
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      // Curving a lone point produces a flat, meaningless
                      // line, so it is only smoothed with 2+ points.
                      isCurved: spots.length > 2,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFB388FF),
                          Color(0xFF8E63D9),
                          Color(0xFF6D3CCB),
                        ],
                      ),
                      barWidth: 2.8,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 3.5,
                            color: Colors.white,
                            strokeWidth: 2.5,
                            strokeColor: accentColor,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            accentColor.withOpacity(0.22),
                            accentColor.withOpacity(0.02),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
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
              avg == null
                  ? "💡 Log your sleep each day to unlock personalized insights."
                  : avg >= 7
                      ? "💡 Great job! You're averaging ${avg.toStringAsFixed(1)}h of sleep."
                      : "💡 You're averaging ${avg.toStringAsFixed(1)}h — aim for 7–9h for better energy.",
              style: TextStyle(
                color: accentColor.withOpacity(0.85),
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

  Widget _emptyState(String message) {
    return Container(
      height: 155,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F2FC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor.withOpacity(0.55),
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}