/// A logged period (start/end dates, flow level, symptoms).
/// Stored per user under `users/{uid}/periods`.
class PeriodEntry {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final int flowLevel; // 1 = light, 2 = medium, 3 = heavy
  final List<String> symptoms;
  final DateTime? createdAt;

  const PeriodEntry({
    this.id = '',
    required this.startDate,
    required this.endDate,
    this.flowLevel = 2,
    this.symptoms = const [],
    this.createdAt,
  });

  int get durationDays {
    final diff = endDate.difference(startDate).inDays;
    return diff < 1 ? 1 : diff + 1;
  }

  Map<String, dynamic> toMap() => {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'flowLevel': flowLevel,
        'symptoms': symptoms,
        'createdAt': createdAt?.toIso8601String(),
      };

  factory PeriodEntry.fromMap(String id, Map<String, dynamic> map) =>
      PeriodEntry(
        id: id,
        startDate: _parseDate(map['startDate']) ?? DateTime.now(),
        endDate: _parseDate(map['endDate']) ?? DateTime.now(),
        flowLevel: (map['flowLevel'] as num?)?.toInt() ?? 2,
        symptoms: (map['symptoms'] as List?)?.map((e) => e.toString()).toList() ?? const [],
        createdAt: _parseDate(map['createdAt']) ?? DateTime.now(),
      );

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }
}