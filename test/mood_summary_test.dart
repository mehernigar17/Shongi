import 'package:flutter_test/flutter_test.dart';
import 'package:shongi/features/statistics/models/mood_summary.dart';

void main() {
  group('MoodSummary', () {
    test('is empty when nothing was logged', () {
      final summary = MoodSummary.fromMoods(const []);

      expect(summary.isEmpty, isTrue);
      expect(summary.total, 0);
      expect(summary.positivePercent, isNull);
      expect(summary.loggedMoods, isEmpty);
    });

    test('counts occurrences per mood', () {
      final summary = MoodSummary.fromMoods(['🙂', '🙂', '😔']);

      expect(summary.counts, {'🙂': 2, '😔': 1});
      expect(summary.total, 3);
    });

    test('lists only the moods actually logged, in scale order', () {
      final summary = MoodSummary.fromMoods(['😄', '😔', '🙂']);

      expect(summary.loggedMoods, ['😔', '🙂', '😄']);
    });

    test('reports the positive share', () {
      final summary = MoodSummary.fromMoods(['🙂', '😊', '😄', '😔', '😔']);

      expect(summary.positivePercent, closeTo(60, 0.001));
    });

    test('treats only the positive scale entries as positive', () {
      // 😔, 😳 and a neutral face are all outside the positive set.
      final summary = MoodSummary.fromMoods(['😔', '😳', '😐']);

      expect(summary.positivePercent, 0);
    });

    test('shares always sum to 100% across the logged moods', () {
      final summary = MoodSummary.fromMoods(['🙂', '🙂', '😔', '😄', '😳']);

      final totalShare = summary.loggedMoods
          .map(summary.shareOf)
          .reduce((a, b) => a + b);

      expect(totalShare, closeTo(1, 0.0001));
    });

    test('ignores an unexpected mood instead of inflating the total', () {
      final summary = MoodSummary.fromMoods(['🙂', '🤖']);

      expect(summary.total, 1);
      expect(summary.counts.containsKey('🤖'), isFalse);
    });

    test('returns a zero share for anything when empty', () {
      final summary = MoodSummary.fromMoods(const []);

      expect(summary.shareOf('🙂'), 0);
    });
  });
}
