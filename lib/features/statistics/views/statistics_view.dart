import 'package:flutter/material.dart';
import 'package:shongi/app/app_dependencies.dart';
import 'package:shongi/core/theme/app_colors.dart';
import 'package:shongi/features/statistics/data/firestore_statistics_repository.dart';
import 'package:shongi/features/statistics/viewmodels/statistics_view_model.dart';
import 'package:shongi/features/statistics/views/widgets/mood_distribution_card.dart';
import 'package:shongi/features/statistics/views/widgets/stats_header.dart';

import 'widgets/cycle_pattern_card.dart';
import 'widgets/sleep_trends_card.dart';
import 'widgets/stats_range_chips.dart';
import 'widgets/stats_summary_cards.dart';

class StatisticsScreen extends StatefulWidget {
  final StatisticsViewModel? viewModel;
  final AppDependencies? dependencies;

  const StatisticsScreen({super.key, this.viewModel, this.dependencies});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late final StatisticsViewModel _vm;
  bool _ownsViewModel = false;

  @override
  void initState() {
    super.initState();
    if (widget.viewModel != null) {
      _vm = widget.viewModel!;
    } else if (widget.dependencies != null) {
      _vm = StatisticsViewModel(widget.dependencies!.statisticsRepository);
      _ownsViewModel = true;
    } else {
      _vm = StatisticsViewModel(FirestoreStatisticsRepository());
      _ownsViewModel = true;
    }
    _vm.selectRange(0);
  }

  @override
  void dispose() {
    if (_ownsViewModel) _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                const StatsHeader(),
                const SizedBox(height: 10),
                ListenableBuilder(
                  listenable: _vm,
                  builder: (context, _) {
                    return StatsRangeChips(
                      selectedIndex: _vm.selectedRange,
                      onSelected: (index) => _vm.selectRange(index),
                    );
                  },
                ),
                const SizedBox(height: 10),
                ListenableBuilder(
                  listenable: _vm,
                  builder: (context, _) {
                    final data = _vm.data;
                    if (_vm.isLoading && data == null) {
                      return const Padding(
                        padding: EdgeInsets.all(40),
                        child: Center(
                          child: CircularProgressIndicator(color: accentColor),
                        ),
                      );
                    }
                    final sleepAvg = data == null || data.sleepHours.isEmpty
                        ? null
                        : data.sleepHours.reduce((a, b) => a + b) / data.sleepHours.length;
                    final cycleAvg = data == null || data.cycleDays.isEmpty
                        ? null
                        : data.cycleDays.reduce((a, b) => a + b) / data.cycleDays.length;
                    final moodPositive = data == null || data.moods.isEmpty
                        ? null
                        : data.moods.where((m) => m == '🙂' || m == '😊' || m == '😄').length /
                            data.moods.length *
                            100;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StatsSummaryCards(
                          sleepAvg: sleepAvg,
                          cycleAvg: cycleAvg,
                          moodPositivePercent: moodPositive,
                        ),
                        const SizedBox(height: 10),
                        SleepTrendsCard(sleepHours: data?.sleepHours ?? const []),
                        const SizedBox(height: 10),
                        CyclePatternsCard(cycleDays: data?.cycleDays ?? const []),
                        const SizedBox(height: 10),
                        MoodDistributionCard(moods: data?.moods ?? const []),
                        const SizedBox(height: 10),
                        const SizedBox(height: 100),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}