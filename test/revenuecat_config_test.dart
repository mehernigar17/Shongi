import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shongi/features/subscriptions/revenuecat_config.dart';

void main() {
  test('ordinary mobile debug launch enables Test Store without build flags', () {
    for (final platform in [TargetPlatform.android, TargetPlatform.iOS]) {
      expect(revenueCatApiKey(isWeb: false, isRelease: false, platform: platform),
          shongiTestStoreKey);
    }
  });

  test('release requires its own platform key and rejects test keys', () {
    expect(revenueCatApiKey(isWeb: false, isRelease: true,
        platform: TargetPlatform.android), isEmpty);
    expect(revenueCatApiKey(isWeb: false, isRelease: true,
        platform: TargetPlatform.android, androidKey: shongiTestStoreKey), isEmpty);
    expect(revenueCatApiKey(isWeb: false, isRelease: true,
        platform: TargetPlatform.android, androidKey: 'goog_public_key'), 'goog_public_key');
    expect(revenueCatApiKey(isWeb: false, isRelease: true,
        platform: TargetPlatform.iOS, androidKey: 'goog_public_key',
        iosKey: 'appl_public_key'), 'appl_public_key');
  });

  test('web and desktop do not enable native purchases', () {
    expect(revenueCatApiKey(isWeb: true, isRelease: false,
        platform: TargetPlatform.android), isEmpty);
    expect(revenueCatApiKey(isWeb: false, isRelease: false,
        platform: TargetPlatform.windows), isEmpty);
  });
}
