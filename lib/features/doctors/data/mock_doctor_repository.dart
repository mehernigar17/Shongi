import '../models/doctor.dart';
import '../repositories/doctor_repository.dart';

class MockDoctorRepository implements DoctorRepository {
  @override
  Future<List<Doctor>> loadDoctors() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _mockDoctors;
  }

  static const List<Doctor> _mockDoctors = [
    Doctor(
      id: 'doc1',
      name: 'Dr. Sarah Mitchell',
      specialty: 'Gynecologist & PCOS Specialist',
      clinic: 'City Women\'s Hospital',
      rating: 4.9,
      reviewCount: 312,
      experienceYears: 12,
      location: 'Nearby (0.8 km)',
      feePerVisit: 85,
      nextSlot: 'Tomorrow, 10:00 AM',
      tags: ['PCOS', 'Hormones', 'Fertility'],
      about: 'Dr. Mitchell specializes in PCOS management and hormonal imbalances. She takes a holistic approach combining lifestyle interventions with evidence-based medicine.',
    ),
    Doctor(
      id: 'doc2',
      name: 'Dr. Emily Stone',
      specialty: 'Clinical Nutritionist & Dietitian',
      clinic: 'Wellness & Care Clinic',
      rating: 4.8,
      reviewCount: 220,
      experienceYears: 8,
      location: '1.5 km away',
      feePerVisit: 65,
      nextSlot: 'Tomorrow, 1:00 PM',
      tags: ['Diet Plans', 'Weight Management', 'Gut Health'],
      about: 'Dr. Emily is passionate about hormone-balancing diets and insulin resistance nutrition strategies for women with PCOS.',
    ),
    Doctor(
      id: 'doc3',
      name: 'Dr. Ayesha Rahman',
      specialty: 'Dermatologist & Skin Specialist',
      clinic: 'Skin & Aesthetic Center',
      rating: 4.9,
      reviewCount: 245,
      experienceYears: 9,
      location: '1.1 km away',
      feePerVisit: 95,
      nextSlot: 'Today, 5:30 PM',
      tags: ['Hormonal Acne', 'Skin Care', 'Hair Fall'],
      about: 'Dr. Rahman focuses on medical and cosmetic dermatology. She is renowned for her patient-centered care in managing hormonal acne.',
    ),
    Doctor(
      id: 'doc4',
      name: 'Dr. James Patel',
      specialty: 'Endocrinologist & Metabolism',
      clinic: 'Metabolic Health Institute',
      rating: 4.7,
      reviewCount: 198,
      experienceYears: 15,
      location: '2.4 km away',
      feePerVisit: 110,
      nextSlot: 'Thursday, 11:30 AM',
      tags: ['Thyroid', 'Insulin Resistance', 'Hormones'],
      about: 'Dr. Patel is a board-certified endocrinologist specializing in thyroid disorders and metabolic hormonal regulation.',
    ),
  ];
}
