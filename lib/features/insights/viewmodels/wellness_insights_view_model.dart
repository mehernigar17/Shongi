import 'package:flutter/foundation.dart';

import '../models/wellness_insight.dart';
import '../repositories/wellness_insight_repository.dart';

class WellnessInsightsViewModel extends ChangeNotifier {
  WellnessInsightsViewModel(this._repository);

  final WellnessInsightRepository _repository;

  List<WellnessInsight>? _insights;
  bool _isLoading = false;
  bool _hasLoaded = false;

  /// Null until the first load finishes, which lets the card tell "still
  /// loading" apart from "no insights".
  List<WellnessInsight>? get insights => _insights;
  bool get isLoading => _isLoading;
  bool get hasLoaded => _hasLoaded;

  Future<void> load() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    try {
      _insights = await _repository.loadInsights();
    } catch (_) {
      // Insights are supplementary, so a failed read must not break the page.
      _insights = const [];
    } finally {
      _isLoading = false;
      _hasLoaded = true;
      notifyListeners();
    }
  }
}
