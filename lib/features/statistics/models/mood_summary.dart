/// Shared mood maths so the summary card and the distribution card can never
/// disagree about what counts as positive or how many moods were logged.
class MoodSummary {
  /// Canonical display order for the five moods the app offers.
  static const List<String> moodOrder = ['😔', '😳', '🙂', '😊', '😄'];

  /// The moods treated as positive when reporting a positive share.
  static const Set<String> positiveMoods = {'🙂', '😊', '😄'};

  /// Occurrence count per mood emoji.
  final Map<String, int> counts;

  /// Only the moods actually logged, in [moodOrder]. Rendering un-logged moods
  /// as 0% bars made the chart look like a mostly-empty scale.
  final List<String> loggedMoods;

  /// Total number of mood entries logged.
  final int total;

  const MoodSummary({
    required this.counts,
    required this.loggedMoods,
    required this.total,
  });

  factory MoodSummary.fromMoods(Iterable<String> moods) {
    final counts = <String, int>{};
    for (final mood in moods) {
      counts[mood] = (counts[mood] ?? 0) + 1;
    }
    // Ignore anything outside the known scale so an unexpected value cannot
    // silently inflate the total.
    final known = <String, int>{
      for (final mood in moodOrder)
        if (counts.containsKey(mood)) mood: counts[mood]!,
    };
    return MoodSummary(
      counts: known,
      loggedMoods: moodOrder.where(known.containsKey).toList(),
      total: known.values.fold(0, (sum, count) => sum + count),
    );
  }

  /// Share of logged moods that were positive, or null when nothing was logged.
  double? get positivePercent {
    if (total == 0) return null;
    final positive = loggedMoods
        .where(positiveMoods.contains)
        .fold(0, (sum, mood) => sum + counts[mood]!);
    return positive / total * 100;
  }

  /// Share of logged moods for [mood], or 0 when it was never logged.
  double shareOf(String mood) => total == 0 ? 0 : counts[mood]! / total;

  bool get isEmpty => total == 0;
}
