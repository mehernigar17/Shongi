import 'package:flutter/foundation.dart';

/// RevenueCat SDK keys are public identifiers, not secret API credentials.
/// This fallback only enables simulated purchases in non-release mobile builds.
const shongiTestStoreKey = 'test_eGpEFynbEGxFrbeAsfYXReisVOz';

String revenueCatApiKey({
  required bool isWeb,
  required bool isRelease,
  required TargetPlatform platform,
  String testKey = shongiTestStoreKey,
  String androidKey = '',
  String iosKey = '',
}) {
  if (isWeb ||
      (platform != TargetPlatform.android && platform != TargetPlatform.iOS)) {
    return '';
  }
  if (!isRelease && testKey.isNotEmpty) return testKey;
  final key = platform == TargetPlatform.android ? androidKey : iosKey;
  return key.startsWith('test_') && isRelease ? '' : key;
}
