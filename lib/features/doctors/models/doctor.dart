class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String clinic;
  final double rating;
  final int reviewCount;
  final int experienceYears;
  final String location;
  final double feePerVisit;
  final String nextSlot;
  final List<String> tags;
  final String about;
  final String? avatarAsset;

  const Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.clinic,
    required this.rating,
    this.reviewCount = 120,
    this.experienceYears = 8,
    this.location = 'Nearby clinic',
    this.feePerVisit = 80,
    required this.nextSlot,
    required this.tags,
    this.about = 'Experienced specialist dedicated to comprehensive women\'s health and hormonal wellness.',
    this.avatarAsset,
  });

  String get speciality => specialty;
  String get time => nextSlot;
}
