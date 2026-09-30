import 'package:flutter/material.dart';

import 'package:shongi/core/theme/app_colors.dart';
import 'package:shongi/features/statistics/models/mood_summary.dart';

class MoodDistributionCard extends StatelessWidget {
  /// Mood emojis logged in the selected range.
  final List<String> moods;

  const MoodDistributionCard({super.key, this.moods = const []});

  @override
  Widget build(BuildContext context) {
    final summary = MoodSummary.fromMoods(moods);

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
            color: accentColor.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Mood Distribution",
            style: TextStyle(
              color: textColor,
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "This period",
            style: TextStyle(
              color: textColor.withValues(alpha: 0.5),
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 18),
          if (summary.isEmpty)
            const _NoMoodPlaceholder()
          else ...[
            for (final emoji in summary.loggedMoods) ...[
              _MoodBar(
                emoji: emoji,
                value: summary.shareOf(emoji),
                percent: '${(summary.shareOf(emoji) * 100).round()}%',
              ),
              const SizedBox(height: 14),
            ],
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
                _summaryLine(summary),
                style: TextStyle(
                  color: accentColor.withValues(alpha: 0.88),
                  fontSize: 11.5,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _summaryLine(MoodSummary summary) {
    final percent = summary.positivePercent!;
    final days = summary.total;
    return '💜 $percent% of your $days logged ${days == 1 ? "day was" : "days were"} '
        'positive. ${percent >= 50 ? "Keep it up!" : "Self-care can help lift your mood."}';
  }
}

class _NoMoodPlaceholder extends StatelessWidget {
  const _NoMoodPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F2FC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        "💜 No mood logged in this period yet. Pick one when you add your next entry.",
        style: TextStyle(
          color: accentColor.withValues(alpha: 0.88),
          fontSize: 11.5,
          height: 1.45,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _MoodBar extends StatelessWidget {
  final String emoji;
  final double value;
  final String percent;

  const _MoodBar({
    required this.emoji,
    required this.value,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Container(
                  height: 10,
                  color: const Color(0xFFF0E7FA),
                ),
                FractionallySizedBox(
                  widthFactor: value,
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          accentColor.withValues(alpha: 0.95),
                          accentColor.withValues(alpha: 0.75),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 32,
          child: Text(
            percent,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: textColor.withValues(alpha: 0.58),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
