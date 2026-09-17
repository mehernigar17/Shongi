class UserOnboardingData {
  String name = "";
  int age = 18;
  double weight = 60;
  double height = 165;

  String skinType = "Combination";
  String cycleType = "Regular";
  String selfCareDay = "Sunday";

  String medications = "";

  DateTime? lastPeriodStart;
  DateTime? lastPeriodEnd;

  double get bmi => weight / ((height / 100) * (height / 100));

  String get bmiCategory {
    if (bmi < 18.5) return "Underweight";
    if (bmi < 25) return "Healthy";
    if (bmi < 30) return "Overweight";
    return "Obese";
  }
}

/// Immutable profile persisted by the onboarding feature.
class UserProfile {
  const UserProfile({required this.name, required this.age, required this.weightKg, required this.heightCm, required this.skinType, required this.cycleType, required this.selfCareDay, this.medications = '', this.lastPeriodStart, this.lastPeriodEnd});
  final String name; final int age; final double weightKg; final double heightCm; final String skinType; final String cycleType; final String selfCareDay; final String medications; final DateTime? lastPeriodStart; final DateTime? lastPeriodEnd;
  double get bmi => weightKg / ((heightCm / 100) * (heightCm / 100));
  String get bmiCategory => bmi < 18.5 ? 'Underweight' : bmi < 25 ? 'Healthy' : bmi < 30 ? 'Overweight' : 'Obese';

  /// Plain map for Firestore storage (dates as ISO-8601 strings).
  Map<String, dynamic> toMap() => {
    'name': name,
    'age': age,
    'weightKg': weightKg,
    'heightCm': heightCm,
    'skinType': skinType,
    'cycleType': cycleType,
    'selfCareDay': selfCareDay,
    'medications': medications,
    'lastPeriodStart': lastPeriodStart?.toIso8601String(),
    'lastPeriodEnd': lastPeriodEnd?.toIso8601String(),
  };

  /// Rebuilds a profile from a Firestore document map.
  factory UserProfile.fromMap(Map<String, dynamic> map) => UserProfile(
    name: map['name'] as String? ?? '',
    age: (map['age'] as num?)?.toInt() ?? 18,
    weightKg: (map['weightKg'] as num?)?.toDouble() ?? 60,
    heightCm: (map['heightCm'] as num?)?.toDouble() ?? 165,
    skinType: map['skinType'] as String? ?? 'Combination',
    cycleType: map['cycleType'] as String? ?? 'Regular',
    selfCareDay: map['selfCareDay'] as String? ?? 'Sunday',
    medications: map['medications'] as String? ?? '',
    lastPeriodStart: _parseDate(map['lastPeriodStart']),
    lastPeriodEnd: _parseDate(map['lastPeriodEnd']),
  );

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }
}
