/// How much a wellness insight should pull the user's attention.
enum InsightSeverity {
  /// Something worth acting on.
  attention,

  /// Neutral context the user may find useful.
  info,

  /// A genuine positive worth reinforcing.
  good,
}

/// One evidence-based observation derived from the user's own logs.
///
/// Every insight states the numbers it was computed from, so nothing reads as
/// an unexplained verdict from a black box.
class WellnessInsight {
  final String title;
  final String detail;
  final InsightSeverity severity;

  /// Lower sorts first; used to keep the most useful insight at the top.
  final int priority;

  const WellnessInsight({
    required this.title,
    required this.detail,
    required this.severity,
    required this.priority,
  });
}
