import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:shongi/core/theme/app_colors.dart';
import 'package:shongi/features/doctors/data/firestore_doctor_message_repository.dart';
import 'package:shongi/features/doctors/models/doctor.dart';
import 'package:shongi/features/doctors/models/doctor_message.dart';

/// Compose-and-history sheet behind the doctor's "Message" action.
///
/// Messages are real: they are written to `users/{uid}/messages` and listed
/// back newest-first, so nothing is a placeholder.
Future<void> showDoctorMessageSheet(
  BuildContext context,
  Doctor doctor, {
  FirestoreDoctorMessageRepository? repository,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => DoctorMessageSheet(
      doctor: doctor,
      repository: repository ?? FirestoreDoctorMessageRepository(),
    ),
  );
}

class DoctorMessageSheet extends StatefulWidget {
  final Doctor doctor;
  final FirestoreDoctorMessageRepository repository;

  const DoctorMessageSheet({
    super.key,
    required this.doctor,
    required this.repository,
  });

  @override
  State<DoctorMessageSheet> createState() => _DoctorMessageSheetState();
}

class _DoctorMessageSheetState extends State<DoctorMessageSheet> {
  final TextEditingController _controller = TextEditingController();
  List<DoctorMessage> _messages = const [];
  bool _loading = true;
  bool _sending = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final messages = await widget.repository.loadMessages();
      if (!mounted) return;
      setState(() {
        _messages = messages;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Could not load your messages.';
        _loading = false;
      });
    }
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;

    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      await widget.repository.send(
        doctorId: widget.doctor.id,
        doctorName: widget.doctor.name,
        body: text,
      );
      _controller.clear();
      await _load();
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Could not send your message. Please try again.');
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _delete(DoctorMessage message) async {
    try {
      await widget.repository.deleteMessage(message.id);
      await _load();
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Could not delete that message.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final ownMessages = _messages
        .where((m) => m.doctorId == widget.doctor.id)
        .toList();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: cardBorderColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 14, 12, 6),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: chipBackground,
                    child: Text(
                      _initials(widget.doctor.name),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: accentColorDeep,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.doctor.name,
                          style: GoogleFonts.poppins(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                        Text(
                          widget.doctor.specialty,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 11.5,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close_rounded, color: textSecondary),
                  ),
                ],
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 4, 22, 0),
                child: Text(
                  _error!,
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.red.shade700),
                ),
              ),
            Flexible(
              child: _loading
                  ? const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : ownMessages.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(28, 24, 28, 28),
                          child: Column(
                            children: [
                              Icon(Icons.forum_outlined,
                                  size: 40, color: accentColorLight),
                              const SizedBox(height: 10),
                              Text(
                                'No messages sent yet. Ask about symptoms, '
                                'medications or your report.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 12.5,
                                  height: 1.6,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(22, 10, 22, 10),
                          itemCount: ownMessages.length,
                          itemBuilder: (context, index) => _MessageBubble(
                            message: ownMessages[index],
                            onDelete: () => _delete(ownMessages[index]),
                          ),
                        ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(22, 8, 22, 12 + bottomInset * 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(
                        hintText: 'Write your message…',
                        filled: true,
                        fillColor: pageBackground,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 46,
                    width: 46,
                    child: FilledButton(
                      onPressed: _sending ? null : _send,
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: const CircleBorder(),
                        backgroundColor: accentColor,
                      ),
                      child: _sending
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.send_rounded,
                              size: 19, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _initials(String name) {
    final parts = name
        .replaceAll('Dr.', '')
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }
}

class _MessageBubble extends StatelessWidget {
  final DoctorMessage message;
  final VoidCallback onDelete;

  const _MessageBubble({required this.message, required this.onDelete});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 300),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: Text(
                message.body,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  height: 1.5,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('d MMM yyyy, h:mm a').format(message.sentAt),
                  style: GoogleFonts.poppins(fontSize: 10.5, color: textSecondary),
                ),
                const SizedBox(width: 6),
                InkWell(
                  onTap: onDelete,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Icon(Icons.delete_outline_rounded,
                        size: 15, color: textSecondary),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
