import 'package:flutter/material.dart';

import 'package:shongi/core/theme/app_colors.dart';
import 'package:shongi/features/insights/models/wellness_insight.dart';

/// Shows the insight engine's findings for the user's own logs.
///
/// Renders three distinct states so an empty result never looks broken:
/// loading, "not enough logged yet", and the ranked insights themselves.
class SmartInsightsCard extends StatelessWidget {
  final List<WellnessInsight>? insights;
  final bool isLoading;
  final bool hasLoaded;

  const SmartInsightsCard({
    super.key,
    this.insights,
    this.isLoading = false,
    this.hasLoaded = false,
  });

  bool get _isEmpty => hasLoaded && (insights == null || insights!.isEmpty);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: cardBorderColor),
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
            "Smart Insights",
            style: TextStyle(
              color: textColor,
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "Read from your last 30 days of logs",
            style: TextStyle(
              color: textColor.withValues(alpha: 0.5),
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          if (isLoading && insights == null)
            const _InsightsPlaceholder()
          else if (_isEmpty)
            const _EmptyInsights()
          else
            ...(insights ?? const <WellnessInsight>[]).map(
              (insight) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _InsightRow(insight: insight),
              ),
            ),
        ],
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  final WellnessInsight insight;

  const _InsightRow({required this.insight});

  Color get _accent {
    switch (insight.severity) {
      case InsightSeverity.attention:
        return pinkAccent;
      case InsightSeverity.info:
        return blueAccent;
      case InsightSeverity.good:
        return greenAccent;
    }
  }

  Color get _background {
    switch (insight.severity) {
      case InsightSeverity.attention:
        return pinkBackground;
      case InsightSeverity.info:
        return blueBackground;
      case InsightSeverity.good:
        return greenBackground;
    }
  }

  IconData get _icon {
    switch (insight.severity) {
      case InsightSeverity.attention:
        return Icons.warning_amber_rounded;
      case InsightSeverity.info:
        return Icons.lightbulb_outline_rounded;
      case InsightSeverity.good:
        return Icons.check_circle_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: _background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: _accent.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(_icon, size: 16, color: _accent),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: TextStyle(
                    color: _accent,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  insight.detail,
                  style: TextStyle(
                    color: textColor.withValues(alpha: 0.7),
                    fontSize: 11.5,
                    height: 1.45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyInsights extends StatelessWidget {
  const _EmptyInsights();

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
        "Log a few days of sleep, mood and symptoms and this fills in with "
        "patterns picked up from your own history.",
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

class _InsightsPlaceholder extends StatelessWidget {
  const _InsightsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2.2,
            color: accentColor,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          "Reading your logs...",
          style: TextStyle(
            color: textSecondary,
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
