import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:shongi/core/theme/app_colors.dart';

class CyclePatternsCard extends StatelessWidget {
  /// Cycle lengths in days between consecutive period starts.
  final List<double> cycleDays;

  const CyclePatternsCard({super.key, this.cycleDays = const []});

  double? get _avg {
    if (cycleDays.isEmpty) return null;
    return cycleDays.reduce((a, b) => a + b) / cycleDays.length;
  }

  bool get _isRegular {
    final avg = _avg;
    if (avg == null) return false;
    return cycleDays.every((d) => (d - avg).abs() <= 5);
  }

  @override
  Widget build(BuildContext context) {
    final avg = _avg;
    final bars = <BarChartGroupData>[
      for (var i = 0; i < cycleDays.length; i++)
        _bar(i, cycleDays[i], _barColor(i)),
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
                    "Cycle Patterns",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Days per cycle · full history",
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
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEEF3),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  avg == null
                      ? "No data"
                      : _isRegular
                          ? "− Regular · ${cycleDays.length} cycles"
                          : "− Irregular · ${cycleDays.length} cycles",
                  style: const TextStyle(
                    color: Color(0xFFFF6B8A),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (bars.isEmpty)
            _emptyState("Log at least two periods to see your cycle pattern.")
          else
            SizedBox(
              height: 150,
              child: BarChart(
                BarChartData(
                  maxY: 40,
                  minY: 20,
                  alignment: BarChartAlignment.spaceAround,
                  gridData: FlGridData(
                    drawVerticalLine: false,
                    horizontalInterval: 5,
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
                        reservedSize: 24,
                        interval: 5,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              color: textColor.withOpacity(0.42),
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: cycleDays.length <= 8,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              'C${value.toInt() + 1}',
                              style: TextStyle(
                                color: textColor.withOpacity(0.5),
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: bars,
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
              color: const Color(0xFFFFF1F4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              avg == null
                  ? "⚠️ Log your periods to track cycle regularity."
                  : _isRegular
                      ? "✅ Your cycle is regular at ~${avg.round()} days. Great consistency!"
                      : "⚠️ Your cycle varies around ${avg.round()} days. Reducing stress may help regulate it.",
              style: const TextStyle(
                color: Color(0xFFE46B8B),
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

  Color _barColor(int index) {
    const colors = [
      Color(0xFFD8C0F6),
      Color(0xFFA77CE0),
      Color(0xFFCDB0F2),
      Color(0xFF9466D2),
      Color(0xFFA57BDD),
      Color(0xFF8F67CE),
    ];
    return colors[index % colors.length];
  }

  BarChartGroupData _bar(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 28,
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color.withOpacity(0.95),
              color,
            ],
          ),
        ),
      ],
    );
  }

  Widget _emptyState(String message) {
    return Container(
      height: 150,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F4),
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