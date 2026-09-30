import '../models/doctor.dart';
import '../repositories/doctor_repository.dart';

/// The catalogue of consultations the app can help you prepare for and request.
///
/// These are deliberately categories of visit rather than named practitioners:
/// the app has no verified doctor directory, so listing real-looking names with
/// star ratings and fees would be presenting invented data as fact. Booking a
/// request saves it to the user's own `users/{uid}/appointments` collection.
class ConsultCatalogRepository implements DoctorRepository {
  @override
  Future<List<Doctor>> loadDoctors() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _consults;
  }

  static const List<Doctor> _consults = [
    Doctor(
      id: 'gynaecology',
      name: 'Gynaecology consultation',
      specialty: 'Periods, fertility and reproductive health',
      tags: ['Periods', 'PCOS', 'Fertility'],
      about: 'For period changes, painful or irregular bleeding, fertility '
          'questions, or a PCOS diagnosis you want a second opinion on.',
      bring: [
        'The dates your last few periods started',
        'Any test results or letters from a previous visit',
        'A list of medicines or supplements you currently take',
      ],
    ),
    Doctor(
      id: 'nutrition',
      name: 'Nutrition consultation',
      specialty: 'Diet, blood sugar and weight',
      tags: ['Diet', 'Blood sugar', 'Weight'],
      about: 'For eating patterns, blood-sugar balance, or a weight goal you '
          'have struggled to hold on your own.',
      bring: [
        'A rough idea of a normal day of eating',
        'Any recent blood work results',
        'Recent weight readings, if you track them',
      ],
    ),
    Doctor(
      id: 'skin',
      name: 'Skin and hair consultation',
      specialty: 'Skin, hair and hormonal breakouts',
      tags: ['Skin', 'Hair fall', 'Breakouts'],
      about: 'For persistent or hormonal breakouts, hair fall, or a skin '
          'change that has not settled on its own.',
      bring: [
        'Photos of the area as it looks now',
        'Products and medicines you are currently using',
        'Whether it worsens around your period',
      ],
    ),
    Doctor(
      id: 'thyroid',
      name: 'Thyroid and metabolism consultation',
      specialty: 'Thyroid, energy and metabolism',
      tags: ['Thyroid', 'Energy', 'Metabolism'],
      about: 'For ongoing fatigue, unexplained weight change, or thyroid test '
          'results that need explaining.',
      bring: [
        'Recent thyroid test results with reference ranges',
        'How your energy levels have changed, and over what period',
        'Medicines affecting thyroid or hormone levels',
      ],
    ),
  ];
}
