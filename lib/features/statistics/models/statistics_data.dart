/// Aggregated statistics computed from the signed-in user's real
/// Firestore logs and periods for the selected range.
class StatisticsData {
  const StatisticsData({
    this.sleepHours = const [],
    this.cycleDays = const [],
    this.moods = const [],
  });

  /// Sleep hours per logged day (in date order).
  final List<double> sleepHours;

  /// Cycle lengths in days between consecutive period starts.
  final List<double> cycleDays;

  /// Mood emojis logged in the range (e.g. '🙂', '😄').
  final List<String> moods;

  bool get isEmpty => sleepHours.isEmpty && cycleDays.isEmpty && moods.isEmpty;
}