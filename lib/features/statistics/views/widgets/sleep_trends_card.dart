import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:shongi/core/theme/app_colors.dart';

class SleepTrendsCard extends StatelessWidget {
  const SleepTrendsCard({super.key});

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

                    const Text(
                      "Avg 7.1h",
                      style: TextStyle(
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

          SizedBox(
            height: 155,

            child: LineChart(
              LineChartData(

                minY: 4,
                maxY: 10,

                gridData: FlGridData(
                  drawVerticalLine: false,
                  horizontalInterval: 2,

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
                      interval: 2,

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

                        const days = [
                          "Mon",
                          "Tue",
                          "Wed",
                          "Thu",
                          "Fri",
                          "Sat",
                          "Sun",
                        ];

                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            days[value.toInt()],
                            style: TextStyle(
                              color: textColor.withOpacity(0.45),
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

                    spots: const [
                      FlSpot(0, 7.5),
                      FlSpot(1, 6),
                      FlSpot(2, 8),
                      FlSpot(3, 5.5),
                      FlSpot(4, 7),
                      FlSpot(5, 8.5),
                      FlSpot(6, 6.5),
                    ],

                    isCurved: true,

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

                      getDotPainter:
                          (spot, percent, barData, index) {
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
              "💡 You sleep best on Saturdays. "
                  "Try sleeping earlier on weekdays.",

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
}
