import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:shongi/core/theme/app_colors.dart';

class CyclePatternsCard extends StatelessWidget {
  const CyclePatternsCard({super.key});

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

          /// HEADER
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
                    "Days per cycle",
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

                child: const Text(
                  "− Irregular",
                  style: TextStyle(
                    color: Color(0xFFFF6B8A),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// BAR CHART
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
                      showTitles: true,

                      getTitlesWidget: (value, meta) {

                        const months = [
                          "Nov",
                          "Dec",
                          "Jan",
                          "Feb",
                          "Mar",
                          "Apr",
                        ];

                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            months[value.toInt()],
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

                barGroups: [

                  _bar(0, 32, const Color(0xFFD8C0F6)),
                  _bar(1, 29, const Color(0xFFA77CE0)),
                  _bar(2, 35, const Color(0xFFCDB0F2)),
                  _bar(3, 27, const Color(0xFF9466D2)),
                  _bar(4, 31, const Color(0xFFA57BDD)),
                  _bar(5, 28, const Color(0xFF8F67CE)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// INSIGHT
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
              "⚠️ Your cycle varies 7–8 days. "
                  "Reducing stress may help regulate it.",

              style: TextStyle(
                color: const Color(0xFFE46B8B),
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

  BarChartGroupData _bar(
      int x,
      double y,
      Color color,
      ) {
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
}
