import '../models/wellness_insight.dart';

abstract class WellnessInsightRepository {
  /// Insights derived from the signed-in user's own recent logs.
  Future<List<WellnessInsight>> loadInsights();
}
