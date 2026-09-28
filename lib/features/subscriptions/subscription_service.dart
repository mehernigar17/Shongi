import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'revenuecat_config.dart';

const plusEntitlement = 'shongi_plus';

/// Small boundary so account changes and purchase races can be tested without a store.
abstract class SubscriptionGateway {
  Future<void> configure(String key, String uid);
  Future<void> identify(String uid);
  Future<bool> access();
  Future<void> paywall();
  Future<void> restore();
  Future<void> manage();
}

class RevenueCatGateway implements SubscriptionGateway {
  @override
  Future<void> configure(String key, String uid) async {
    await Purchases.setLogLevel(kDebugMode ? LogLevel.debug : LogLevel.error);
    await Purchases.configure(PurchasesConfiguration(key)..appUserID = uid);
  }

  @override
  Future<void> identify(String uid) async {
    await Purchases.logIn(uid);
  }

  @override
  Future<bool> access() async => (await Purchases.getCustomerInfo())
      .entitlements
      .active
      .containsKey(plusEntitlement);
  @override
  Future<void> paywall() async {
    final offering = (await Purchases.getOfferings()).current;
    if (offering == null || offering.availablePackages.isEmpty) {
      throw StateError('No current subscription offering');
    }
    final result = await RevenueCatUI.presentPaywallIfNeeded(
      plusEntitlement,
      offering: offering,
      displayCloseButton: true,
    );
    if (result == PaywallResult.error) throw StateError('Paywall unavailable');
  }

  @override
  Future<void> restore() async {
    await Purchases.restorePurchases();
  }

  @override
  Future<void> manage() => RevenueCatUI.presentCustomerCenter();
}

class SubscriptionService extends ChangeNotifier with WidgetsBindingObserver {
  SubscriptionService({
    required SubscriptionGateway gateway,
    required String apiKey,
  }) : _gateway = gateway,
       _apiKey = apiKey;

  static final instance = SubscriptionService(
    gateway: RevenueCatGateway(),
    apiKey: _platformKey(),
  );

  static String _platformKey() => revenueCatApiKey(
    isWeb: kIsWeb,
    isRelease: kReleaseMode,
    platform: defaultTargetPlatform,
    testKey: const String.fromEnvironment(
      'REVENUECAT_TEST_API_KEY',
      defaultValue: shongiTestStoreKey,
    ),
    androidKey: const String.fromEnvironment('REVENUECAT_ANDROID_API_KEY'),
    iosKey: const String.fromEnvironment('REVENUECAT_IOS_API_KEY'),
  );

  final SubscriptionGateway _gateway;
  final String _apiKey;
  StreamSubscription<User?>? _auth;
  Future<void> _queue = Future.value();
  String? _uid;
  String? _sdkUid;
  int _generation = 0;
  bool _configured = false;
  bool _active = false;
  bool _ready = false;
  bool _busy = false;
  bool _disposed = false;
  bool _started = false;
  String? _error;

  bool get hasAccess => _uid != null && _ready && _active;
  bool get busy => _busy;
  bool get available => _apiKey.isNotEmpty;
  String? get error => _error;

  void start() {
    if (_started) return;
    _started = true;
    WidgetsBinding.instance.addObserver(this);
    _auth = FirebaseAuth.instance.authStateChanges().listen((user) {
      unawaited(setUser(user?.uid));
    });
    Purchases.addCustomerInfoUpdateListener(_onCustomerInfo);
  }

  void _onCustomerInfo(CustomerInfo _) {
    // Re-read under the serialized identity rather than trusting a late callback.
    if (!_busy && _uid != null) unawaited(refresh());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_busy) unawaited(refresh());
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  Future<void> setUser(String? uid) {
    if (_uid == uid && (_ready || _busy)) return Future.value();
    _uid = uid;
    _generation++;
    _active = false;
    _ready = false;
    _error = null;
    _busy = uid != null && available;
    _notify();
    // Keep the SDK identity while signed out; no operations are permitted then.
    // logIn switches directly to the next UID, avoiding anonymous restore aliases.
    return _run();
  }

  Future<void> refresh() => _run();
  Future<void> restore() => _run(action: _gateway.restore);
  Future<void> manage() => _run(action: _gateway.manage);
  Future<void> purchase() => _run(action: _gateway.paywall);

  Future<void> _run({Future<void> Function()? action}) {
    final uid = _uid;
    final generation = _generation;
    if (uid == null || !available) {
      _busy = false;
      _error = uid == null
          ? 'Sign in to use Shongi Plus.'
          : 'Subscriptions are unavailable right now. Please try again later.';
      _notify();
      return Future.value();
    }
    // Ignore repeated purchase/restore taps while another operation is active.
    if (action != null && _busy) return Future.value();
    _busy = true;
    _error = null;
    _notify();
    _queue = _queue.then((_) async {
      if (_disposed || generation != _generation) return;
      try {
        if (!_configured) {
          await _gateway.configure(_apiKey, uid);
          _configured = true;
          _sdkUid = uid;
        } else if (_sdkUid != uid) {
          await _gateway.identify(uid);
          _sdkUid = uid;
        }
        if (_disposed || generation != _generation) return;
        if (action != null) await action();
        final active = await _gateway.access();
        if (_disposed || generation != _generation) return;
        _active = active;
        _ready = true;
      } catch (e) {
        if (generation != _generation) return;
        _active = false;
        _ready = false;
        _error = 'Could not check your subscription. Please try again.';
        if (kDebugMode) debugPrint('RevenueCat operation failed: $e');
      } finally {
        if (generation == _generation) {
          _busy = false;
          _notify();
        }
      }
    });
    return _queue;
  }

  @override
  void dispose() {
    _disposed = true;
    _generation++;
    _auth?.cancel();
    if (_started) {
      Purchases.removeCustomerInfoUpdateListener(_onCustomerInfo);
      WidgetsBinding.instance.removeObserver(this);
    }
    super.dispose();
  }
}
