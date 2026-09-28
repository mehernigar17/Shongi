import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'subscription_service.dart';

class SubscriptionGate extends StatefulWidget {
  const SubscriptionGate({
    super.key,
    required this.builder,
    this.service,
    this.autoPresent = true,
  });
  final WidgetBuilder builder;
  final SubscriptionService? service;
  final bool autoPresent;
  @override
  State<SubscriptionGate> createState() => _SubscriptionGateState();
}

class _SubscriptionGateState extends State<SubscriptionGate> {
  SubscriptionService get service =>
      widget.service ?? SubscriptionService.instance;
  bool _attempted = false;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: service,
    builder: (context, _) {
      if (service.hasAccess) return widget.builder(context);
      if (widget.autoPresent &&
          !_attempted &&
          service.available &&
          !service.busy &&
          service.error == null) {
        _attempted = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !service.hasAccess) service.purchase();
        });
      }
      return SubscriptionCard(service: service);
    },
  );
}

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({super.key, required this.service});
  final SubscriptionService service;

  Future<void> _restore(BuildContext context) async {
    await service.restore();
    if (!context.mounted || service.error != null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          service.hasAccess
              ? 'Shongi Plus restored.'
              : 'No active Shongi Plus subscription found.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: service,
    builder: (context, _) => Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.health_and_safety_outlined,
              size: 42,
              color: accentColor,
            ),
            const SizedBox(height: 12),
            Text(
              service.hasAccess
                  ? 'Shongi Plus is active'
                  : 'Doctors, with Shongi Plus',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            const Text(
              'Explore doctor profiles and view your personal health report overview.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Consultations and appointment fees are not included.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: textSecondary),
            ),
            if (service.busy)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: LinearProgressIndicator(),
              ),
            if (service.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(service.error!, textAlign: TextAlign.center),
              ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: service.busy
                  ? null
                  : (service.hasAccess ? service.manage : service.purchase),
              child: Text(
                service.hasAccess ? 'Manage subscription' : 'View plans',
              ),
            ),
            TextButton(
              onPressed: service.busy ? null : () => _restore(context),
              child: const Text('Restore purchases'),
            ),
            if (service.error != null)
              TextButton(
                onPressed: service.busy ? null : service.refresh,
                child: const Text('Try again'),
              ),
          ],
        ),
      ),
    ),
  );
}
