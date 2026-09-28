import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shongi/features/subscriptions/subscription_service.dart';
import 'package:shongi/features/subscriptions/subscription_gate.dart';

class FakeGateway implements SubscriptionGateway {
  String? uid;
  final paying = <String>{};
  Completer<void>? pendingPurchase;
  bool fail = false;
  int paywalls = 0;
  @override
  Future<void> configure(String key, String uid) async {
    this.uid = uid;
  }

  @override
  Future<void> identify(String uid) async {
    this.uid = uid;
  }

  @override
  Future<bool> access() async {
    if (fail) throw StateError('Offline');
    return paying.contains(uid);
  }

  @override
  Future<void> paywall() async {
    paywalls++;
    await pendingPurchase?.future;
  }

  @override
  Future<void> restore() async {
    paying.add(uid!);
  }

  @override
  Future<void> manage() async {}
}

void main() {
  late FakeGateway gateway;
  late SubscriptionService service;
  setUp(() {
    gateway = FakeGateway();
    service = SubscriptionService(gateway: gateway, apiKey: 'test_key');
  });
  tearDown(() => service.dispose());

  test(
    'sign-out and account switch immediately remove previous access',
    () async {
      gateway.paying.add('alice');
      await service.setUser('alice');
      expect(service.hasAccess, isTrue);
      final logout = service.setUser(null);
      expect(service.hasAccess, isFalse);
      await logout;
      await service.setUser('bob');
      expect(gateway.uid, 'bob');
      expect(service.hasAccess, isFalse);
    },
  );

  test('late purchase result cannot unlock another Firebase account', () async {
    await service.setUser('alice');
    gateway.pendingPurchase = Completer<void>();
    final purchase = service.purchase();
    await Future<void>.delayed(Duration.zero);
    final switchAccount = service.setUser('bob');
    gateway.paying.add('alice');
    gateway.pendingPurchase!.complete();
    await purchase;
    await switchAccount;
    expect(service.hasAccess, isFalse);
    expect(gateway.uid, 'bob');
  });

  test(
    'dismissal stays locked; restore unlocks; expired access relocks',
    () async {
      await service.setUser('alice');
      await service.purchase();
      expect(service.hasAccess, isFalse);
      await service.restore();
      expect(service.hasAccess, isTrue);
      gateway.paying.clear();
      await service.refresh();
      expect(service.hasAccess, isFalse);
    },
  );

  test('failed status check is retryable and does not grant access', () async {
    gateway.fail = true;
    await service.setUser('alice');
    expect(service.error, isNotNull);
    expect(service.hasAccess, isFalse);
    gateway.fail = false;
    gateway.paying.add('alice');
    await service.refresh();
    expect(service.hasAccess, isTrue);
    expect(service.error, isNull);
  });

  testWidgets('gate builds protected content only for active entitlement', (
    tester,
  ) async {
    service.dispose();
    service = SubscriptionService(gateway: gateway, apiKey: 'test_key');
    await service.setUser('alice');
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SubscriptionGate(
            service: service,
            autoPresent: false,
            builder: (_) => const Text('Protected doctor content'),
          ),
        ),
      ),
    );
    expect(find.text('Protected doctor content'), findsNothing);
    await tester.tap(find.text('Restore purchases'));
    await tester.pumpAndSettle();
    expect(find.text('Protected doctor content'), findsOneWidget);
    await service.setUser('bob');
    await tester.pumpAndSettle();
    expect(find.text('Protected doctor content'), findsNothing);
  });
}
