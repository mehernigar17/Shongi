/// A single daily wellness log entry (sleep, mood, food, health, symptoms).
/// Stored per user under `users/{uid}/logs`.
class DailyLog {
  final String id;
  final DateTime date;
  final double sleepHours;
  final String mood;
  final String food;
  final String health;
  final List<String> symptoms;
  final DateTime? createdAt;

  const DailyLog({
    this.id = '',
    required this.date,
    this.sleepHours = 0,
    this.mood = '',
    this.food = '',
    this.health = '',
    this.symptoms = const [],
    this.createdAt,
  });

  DailyLog copyWith({
    String? id,
    DateTime? date,
    double? sleepHours,
    String? mood,
    String? food,
    String? health,
    List<String>? symptoms,
    DateTime? createdAt,
  }) {
    return DailyLog(
      id: id ?? this.id,
      date: date ?? this.date,
      sleepHours: sleepHours ?? this.sleepHours,
      mood: mood ?? this.mood,
      food: food ?? this.food,
      health: health ?? this.health,
      symptoms: symptoms ?? this.symptoms,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'date': date.toIso8601String(),
        'sleepHours': sleepHours,
        'mood': mood,
        'food': food,
        'health': health,
        'symptoms': symptoms,
        'createdAt': createdAt?.toIso8601String(),
      };

  factory DailyLog.fromMap(String id, Map<String, dynamic> map) => DailyLog(
        id: id,
        date: _parseDate(map['date']) ?? DateTime.now(),
        sleepHours: (map['sleepHours'] as num?)?.toDouble() ?? 0,
        mood: map['mood'] as String? ?? '',
        food: map['food'] as String? ?? '',
        health: map['health'] as String? ?? '',
        symptoms: (map['symptoms'] as List?)?.map((e) => e.toString()).toList() ?? const [],
        createdAt: _parseDate(map['createdAt']) ?? DateTime.now(),
      );

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }
}