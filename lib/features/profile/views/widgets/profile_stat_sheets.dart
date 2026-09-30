import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:shongi/core/theme/app_colors.dart';
import 'package:shongi/features/logs/models/daily_log.dart';
import 'package:shongi/features/profile/viewmodels/profile_view_model.dart';

/// Bottom sheets behind the profile stat tiles. Each one renders the real
/// values already loaded by [ProfileViewModel] — no placeholders.

Future<void> showStreakSheet(BuildContext context, ProfileViewModel vm) =>
    _showSheet(context, builder: (_) => _StreakSheet(vm: vm));

Future<void> showLogHistorySheet(BuildContext context, ProfileViewModel vm) =>
    _showSheet(context, builder: (_) => _LogHistorySheet(vm: vm));

Future<void> showLevelSheet(BuildContext context, ProfileViewModel vm) =>
    _showSheet(context, builder: (_) => _LevelSheet(vm: vm));

Future<void> _showSheet(
  BuildContext context, {
  required WidgetBuilder builder,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: builder,
  );
}

/// `context` is not available at the top level, so sheets use [_SheetFrame].
class _SheetFrame extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _SheetFrame({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: cardBorderColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 16, 22, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close_rounded, color: textSecondary),
                  ),
                ],
              ),
            ),
            Flexible(child: child),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────── STREAK ───────────────────────

class _StreakSheet extends StatelessWidget {
  final ProfileViewModel vm;
  const _StreakSheet({required this.vm});

  @override
  Widget build(BuildContext context) {
    final logged = vm.loggedDays;
    final today = DateTime.now();
    final start = today.subtract(const Duration(days: 83));

    return _SheetFrame(
      title: 'Your logging streak',
      subtitle: vm.streakDays == 0
          ? 'Log today to start a streak'
          : '${vm.streakDays} day${vm.streakDays == 1 ? '' : 's'} in a row',
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 4, 22, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: chipBackground,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_fire_department_rounded,
                      color: pinkAccent, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      vm.streakDays >= 14
                          ? 'Two-week streak unlocked — keep it going.'
                          : 'Log every day for 14 days to unlock your streak badge.',
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        height: 1.5,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Last 12 weeks',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            _StreakGrid(start: start, logged: logged),
            const SizedBox(height: 12),
            Row(
              children: [
                _legend(color: accentColor, label: 'Logged'),
                const SizedBox(width: 16),
                _legend(color: chipBackground, label: 'Missed'),
                const SizedBox(width: 16),
                _legend(
                  color: accentColor.withValues(alpha: 0.35),
                  label: 'Today',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakGrid extends StatelessWidget {
  final DateTime start;
  final Set<DateTime> logged;

  const _StreakGrid({required this.start, required this.logged});

  @override
  Widget build(BuildContext context) {
    // 12 rows of 7 days = 84 cells.
    final cells = <Widget>[];
    for (var i = 0; i < 84; i++) {
      final day = DateTime(start.year, start.month, start.day + i);
      final isFuture = day.isAfter(
        DateTime.now().subtract(const Duration(hours: 1)),
      );
      final isLogged = logged.contains(day);
      final isToday = DateUtils.isSameDay(day, DateTime.now());
      cells.add(
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: isFuture
                ? Colors.transparent
                : isLogged
                    ? (isToday
                        ? accentColor.withValues(alpha: 0.35)
                        : accentColor)
                    : chipBackground,
            borderRadius: BorderRadius.circular(6),
            border: isFuture
                ? null
                : Border.all(
                    color: isToday ? accentColor : Colors.transparent,
                    width: 1.5,
                  ),
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 6,
      crossAxisSpacing: 6,
      children: cells,
    );
  }
}

class _legend extends StatelessWidget {
  final Color color;
  final String label;
  const _legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 11, color: textSecondary),
          ),
        ],
      );
}

// ─────────────────────── LOG HISTORY ───────────────────────

class _LogHistorySheet extends StatelessWidget {
  final ProfileViewModel vm;
  const _LogHistorySheet({required this.vm});

  @override
  Widget build(BuildContext context) {
    final logs = vm.logs;
    return _SheetFrame(
      title: 'Log history',
      subtitle: logs.isEmpty
          ? 'No entries yet'
          : '${logs.length} ${logs.length == 1 ? 'entry' : 'entries'} recorded',
      child: logs.isEmpty
          ? const _EmptyState(
              icon: Icons.edit_note_rounded,
              message: 'Log sleep, mood and symptoms from the home tab to '
                  'build your history.',
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(22, 4, 22, 24),
              itemCount: logs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) => _LogTile(log: logs[index]),
            ),
    );
  }
}

class _LogTile extends StatelessWidget {
  final DailyLog log;
  const _LogTile({required this.log});

  @override
  Widget build(BuildContext context) {
    final hasSleep = log.sleepHours > 0;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  DateFormat('EEEE, d MMM yyyy').format(log.date),
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ),
              if (log.mood.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: chipBackground,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    log.mood,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: accentColorDeep,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              if (hasSleep)
                _pill(Icons.bedtime_outlined,
                    '${log.sleepHours.toStringAsFixed(1)}h sleep'),
              if (log.food.isNotEmpty)
                _pill(Icons.restaurant_outlined, log.food),
              if (log.health.isNotEmpty)
                _pill(Icons.favorite_outline_rounded, log.health),
              ...log.symptoms.map((s) => _pill(Icons.healing_outlined, s)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pill(IconData icon, String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: chipBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: accentColor),
            const SizedBox(width: 5),
            Text(
              text,
              style: GoogleFonts.poppins(fontSize: 11, color: textColor),
            ),
          ],
        ),
      );
}

// ─────────────────────── LEVEL ───────────────────────

class _LevelSheet extends StatelessWidget {
  final ProfileViewModel vm;
  const _LevelSheet({required this.vm});

  static const _ladder = [
    ('New', 0, Icons.eco_rounded),
    ('Bronze', 1, Icons.workspace_premium_rounded),
    ('Silver', 10, Icons.workspace_premium_rounded),
    ('Gold', 30, Icons.workspace_premium_rounded),
    ('Platinum', 60, Icons.diamond_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final current = vm.userLevel;
    final next = vm.nextLevelLabel;

    return _SheetFrame(
      title: 'Your level',
      subtitle: '$current • ${vm.totalLogs} total logs',
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 4, 22, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: vm.levelProgress,
                minHeight: 10,
                backgroundColor: chipBackground,
                valueColor: const AlwaysStoppedAnimation(accentColor),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              next == null
                  ? 'You reached the highest level.'
                  : '${vm.logsToNextLevel} more ${
                      vm.logsToNextLevel == 1 ? 'log' : 'logs'
                    } to reach $next',
              style: GoogleFonts.poppins(fontSize: 12.5, color: textSecondary),
            ),
            const SizedBox(height: 20),
            ..._ladder.map((entry) {
              final unlocked = vm.totalLogs >= entry.$2;
              final isCurrent = entry.$1 == current;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      height: 38,
                      width: 38,
                      decoration: BoxDecoration(
                        color: unlocked ? chipBackground : const Color(0xFFF5F3F8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        entry.$3,
                        size: 19,
                        color: unlocked ? accentColor : textSecondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.$1,
                            style: GoogleFonts.poppins(
                              fontSize: 13.5,
                              fontWeight: isCurrent
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                              color: unlocked ? textColor : textSecondary,
                            ),
                          ),
                          Text(
                            entry.$2 == 0
                                ? 'From your first log'
                                : '${entry.$2}+ logs',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isCurrent)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Current',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      )
                    else if (unlocked)
                      const Icon(Icons.check_circle_rounded,
                          size: 18, color: greenAccent),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(28, 20, 28, 40),
        child: Column(
          children: [
            Icon(icon, size: 44, color: accentColorLight),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                height: 1.6,
                color: textSecondary,
              ),
            ),
          ],
        ),
      );
}
