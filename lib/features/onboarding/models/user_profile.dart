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
}
