import 'package:flutter/material.dart';
import 'package:shongi/app/app_dependencies.dart';
import 'package:shongi/features/dashboard/data/firestore_dashboard_repository.dart';
import 'package:shongi/features/dashboard/viewmodels/dashboard_view_model.dart';
import 'package:shongi/features/dashboard/views/widgets/daily_insight_card.dart';
import 'package:shongi/features/dashboard/views/widgets/home_cycle_status_card.dart';
import 'package:shongi/features/dashboard/views/widgets/home_screen_header.dart';
import 'package:shongi/features/dashboard/views/widgets/log_card.dart';
import 'package:shongi/features/dashboard/views/widgets/period_tracker_card.dart';
import 'package:shongi/features/logs/views/log_sheet.dart';
import 'package:shongi/features/periods/views/period_log_sheet.dart';

class HomeScreen extends StatefulWidget {
  final AppDependencies? dependencies;

  const HomeScreen({super.key, this.dependencies});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late final DashboardViewModel _viewModel;
  bool _ownsViewModel = false;

  @override
  void initState() {
    super.initState();
    if (widget.dependencies != null) {
      _viewModel = DashboardViewModel(widget.dependencies!.dashboardRepository);
    } else {
      _viewModel = DashboardViewModel(FirestoreDashboardRepository());
      _ownsViewModel = true;
    }
    _viewModel.load();
  }

  @override
  void dispose() {
    if (_ownsViewModel) _viewModel.dispose();
    super.dispose();
  }

  /// Called by MainScreen when the user returns to the Home tab so the
  /// dashboard always reflects the latest Firestore records.
  void reload() {
    _viewModel.load();
  }

  Future<void> _openLogSheet() async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LogSheet(repository: widget.dependencies?.logRepository),
    );
    if (saved == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Today\'s log saved!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      _viewModel.load();
    }
  }

  Future<void> _openPeriodLogSheet() async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PeriodLogSheet(repository: widget.dependencies?.periodRepository),
    );
    if (saved == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Period logged!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      _viewModel.load();
    }
  }

  void _showPeriodHistory() {
    final data = _viewModel.data;
    if (data == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PeriodHistorySheet(periods: data.recentPeriods),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            final data = _viewModel.data;
            if (data == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeScreenHeader(name: data.userName),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        HomeCycleStatusCard(
                          cycleDay: data.cycleDay,
                          avgCycleLength: data.avgCycleLength,
                          daysUntilNextPeriod: data.daysUntilNextPeriod,
                          statusLabel: data.cycleStatusLabel,
                        ),
                        const SizedBox(height: 10),
                        LogCard(onStartLogging: _openLogSheet),
                        const SizedBox(height: 10),
                        DailyInsightCard(
                          title: data.insightTitle,
                          body: data.insightBody,
                          tip: data.insightTip,
                        ),
                        const SizedBox(height: 10),
                        PeriodTrackerCard(
                          nextPeriodDate: data.nextPeriodDate,
                          avgCycleLength: data.avgCycleLength,
                          avgPeriodDuration: data.avgPeriodDuration,
                          lastPeriodStart: data.lastPeriodStart,
                          onLogPeriod: _openPeriodLogSheet,
                          onViewCalendar: _showPeriodHistory,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Simple list of the user's logged periods (the "Full Calendar" view).
class _PeriodHistorySheet extends StatelessWidget {
  final List periods;

  const _PeriodHistorySheet({required this.periods});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE9DEF8),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Period History',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: periods.isEmpty
                ? const Center(
                    child: Text(
                      'No periods logged yet.\nTap "Log Period" to add your first entry.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    itemCount: periods.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final p = periods[index];
                      return ListTile(
                        leading: const Icon(
                          Icons.water_drop_rounded,
                          color: Color(0xFFFF5C8D),
                        ),
                        title: Text(
                          '${_fmt(p.startDate)} – ${_fmt(p.endDate)}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text('${p.durationDays} days'),
                        trailing: Text(
                          p.flowLevel == 1
                              ? 'Light'
                              : p.flowLevel == 3
                                  ? 'Heavy'
                                  : 'Medium',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFFF5C8D),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]} ${d.year}';

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
}