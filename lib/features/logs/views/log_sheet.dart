import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shongi/core/theme/app_colors.dart';
import 'package:shongi/features/logs/data/firestore_log_repository.dart';
import 'package:shongi/features/logs/models/daily_log.dart';
import 'package:shongi/features/logs/repositories/log_repository.dart';

/// Bottom sheet for logging a day: sleep, mood, food, health, symptoms.
/// Saves to the signed-in user's Firestore `logs` collection.
class LogSheet extends StatefulWidget {
  final LogRepository? repository;

  const LogSheet({super.key, this.repository});

  @override
  State<LogSheet> createState() => _LogSheetState();
}

class _LogSheetState extends State<LogSheet> {
  late final LogRepository _repository;
  late final TextEditingController _foodController;
  late final TextEditingController _healthController;

  DateTime _date = DateTime.now();
  double _sleepHours = 7;
  String _mood = '🙂';
  final Set<String> _symptoms = {};
  bool _saving = false;

  static const _moods = ['😔', '😳', '🙂', '😊', '😄'];
  static const _symptomOptions = [
    'Fatigue',
    'Mood swings',
    'Cramps',
    'Headache',
    'Bloating',
    'Acne',
    'Insomnia',
  ];

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? FirestoreLogRepository();
    _foodController = TextEditingController();
    _healthController = TextEditingController();
  }

  @override
  void dispose() {
    _foodController.dispose();
    _healthController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await _repository.saveLog(
        DailyLog(
          date: DateTime(_date.year, _date.month, _date.day),
          sleepHours: _sleepHours,
          mood: _mood,
          food: _foodController.text.trim(),
          health: _healthController.text.trim(),
          symptoms: _symptoms.toList(),
          createdAt: DateTime.now(),
        ),
      );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not save log: $e'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: cardBorderColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Log Your Day',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Saved privately to your account',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: textSecondary,
              ),
            ),
            const SizedBox(height: 18),

            // Date
            Row(
              children: [
                const Icon(Icons.calendar_today_rounded, size: 16, color: accentColor),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _date,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) setState(() => _date = picked);
                  },
                  icon: const Icon(Icons.edit_calendar_rounded, size: 16),
                  label: Text(
                    '${_date.day}/${_date.month}/${_date.year}',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Sleep
            _label('Sleep (hours)'),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _sleepHours,
                    min: 0,
                    max: 12,
                    divisions: 24,
                    activeColor: accentColor,
                    onChanged: (v) => setState(() => _sleepHours = v),
                  ),
                ),
                SizedBox(
                  width: 44,
                  child: Text(
                    _sleepHours.toStringAsFixed(1),
                    textAlign: TextAlign.right,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: accentColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Mood
            _label('Mood'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _moods.map((m) {
                final selected = _mood == m;
                return GestureDetector(
                  onTap: () => setState(() => _mood = m),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: selected ? chipBackground : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected ? accentColor : cardBorderColor,
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Text(m, style: const TextStyle(fontSize: 20)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),

            // Symptoms
            _label('Symptoms'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _symptomOptions.map((s) {
                final selected = _symptoms.contains(s);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selected) {
                        _symptoms.remove(s);
                      } else {
                        _symptoms.add(s);
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? accentColor : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: selected ? accentColor : cardBorderColor,
                      ),
                    ),
                    child: Text(
                      s,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : textColor,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),

            // Food
            _label('Food'),
            const SizedBox(height: 8),
            TextField(
              controller: _foodController,
              decoration: _inputDecoration('What did you eat today?'),
            ),
            const SizedBox(height: 12),

            // Health
            _label('Health notes'),
            const SizedBox(height: 8),
            TextField(
              controller: _healthController,
              decoration: _inputDecoration('Any health notes...'),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Save Log',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      );

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: textSecondary, fontSize: 13),
        filled: true,
        fillColor: const Color(0xFFF8F4FC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: cardBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: cardBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: accentColor, width: 1.5),
        ),
      );
}