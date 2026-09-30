/// A consultation the user can request.
///
/// The app has no verified practitioner directory, so an entry describes *what
/// a consultation is for* instead of pretending to be a real, rated doctor.
/// Inventing a practitioner name, star rating, review count, fee or clinic
/// address would present made-up facts as real ones, which is not something to
/// do in a health app.
class Doctor {
  final String id;

  /// The consultation to request, e.g. 'Gynaecology consultation'.
  final String name;

  /// The kind of specialist this sort of visit is for.
  final String specialty;

  /// What a visit like this typically covers.
  final String about;

  /// Short labels shown as chips.
  final List<String> tags;

  /// Worth having ready before the visit, so nothing gets forgotten.
  final List<String> bring;

  const Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.about,
    this.tags = const [],
    this.bring = const [],
  });

  String get speciality => specialty;
}
