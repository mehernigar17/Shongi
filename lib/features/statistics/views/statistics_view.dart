import 'package:flutter/material.dart';
import 'package:shongi/features/statistics/views/widgets/mood_distribution_card.dart';
import 'package:shongi/features/statistics/views/widgets/stats_header.dart';

import 'widgets/cycle_pattern_card.dart';
import 'widgets/sleep_trends_card.dart';
import 'widgets/stats_range_chips.dart';
import 'widgets/stats_summary_cards.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                StatsHeader(),
                SizedBox(height: 10),
                StatsRangeChips(selectedIndex: 0),
                SizedBox(height: 10),
                StatsSummaryCards(),
                SizedBox(height: 10),
                SleepTrendsCard(),
                SizedBox(height: 10),
                CyclePatternsCard(),
                SizedBox(height: 10),
                MoodDistributionCard(),
                SizedBox(height: 10),
                SizedBox(height: 100),
              ],
            ),
          ),
        )
      ),
    );
  }
}
