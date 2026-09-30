import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shongi/core/theme/app_colors.dart';
import 'package:shongi/features/dev_tools/services/demo_data_service.dart';

/// Debug-only panel for filling an account with realistic demo history.
///
/// This is a development aid for running the app on a fresh emulator or a new
/// account. It is gated on [kDebugMode] at the call site so it can never appear
/// in a release build.
class DevToolsCard extends StatefulWidget {
  const DevToolsCard({super.key, this.service, this.onChanged});

  final DemoDataService? service;

  /// Called after a successful seed or clear so the host screen can reload the
  /// figures it derives from the same data.
  final Future<void> Function()? onChanged;

  @override
  State<DevToolsCard> createState() => _DevToolsCardState();
}

class _DevToolsCardState extends State<DevToolsCard> {
  late final DemoDataService _service = widget.service ?? DemoDataService();
  bool _busy = false;

  Future<void> _run(Future<String> Function() action) async {
    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);
    String message;
    var changed = false;
    try {
      message = await action();
      changed = true;
    } catch (error) {
      message = 'Failed: $error';
    }
    if (changed) {
      // The profile stats, streak and achievements all derive from this data.
      try {
        await widget.onChanged?.call();
      } catch (_) {
        // A reload failure should not mask the seed result.
      }
    }
    if (!mounted) return;
    setState(() => _busy = false);
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: cardBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bug_report_outlined, size: 18, color: blueAccent),
              const SizedBox(width: 8),
              Text(
                "Developer tools",
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                "debug only",
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Fills this account with ~3 months of logs and periods so the '
            'statistics, insights and cycle screens have real data to show.',
            style: GoogleFonts.poppins(
              fontSize: 11.5,
              height: 1.45,
              color: textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _busy ? null : () => _run(_service.seed),
                  icon: const Icon(Icons.download_rounded, size: 16),
                  label: const Text('Seed demo data'),
                  style: FilledButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: _busy ? null : () => _run(_service.clear),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Clear'),
                ),
              ),
            ],
          ),
          if (_busy) ...[
            const SizedBox(height: 12),
            const LinearProgressIndicator(
              minHeight: 2,
              color: accentColor,
              backgroundColor: cardBorderColor,
            ),
          ],
        ],
      ),
    );
  }
}

/// True when the current build may show developer tools.
bool get devToolsEnabled => kDebugMode;