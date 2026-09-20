/// A doctor appointment booked by the signed-in user.
/// Stored per user under `users/{uid}/appointments`.
class Appointment {
  final String id;
  final String doctorId;
  final String doctorName;
  final String doctorSpecialty;
  final String doctorClinic;
  final DateTime date;
  final String slotId;
  final String slotTime;
  final DateTime? bookedAt;

  const Appointment({
    this.id = '',
    required this.doctorId,
    required this.doctorName,
    this.doctorSpecialty = '',
    this.doctorClinic = '',
    required this.date,
    required this.slotId,
    required this.slotTime,
    this.bookedAt,
  });

  Map<String, dynamic> toMap() => {
        'doctorId': doctorId,
        'doctorName': doctorName,
        'doctorSpecialty': doctorSpecialty,
        'doctorClinic': doctorClinic,
        'dateKey': _dateKey(date),
        'date': date.toIso8601String(),
        'slotId': slotId,
        'slotTime': slotTime,
        'bookedAt': bookedAt?.toIso8601String(),
      };

  factory Appointment.fromMap(String id, Map<String, dynamic> map) =>
      Appointment(
        id: id,
        doctorId: map['doctorId'] as String? ?? '',
        doctorName: map['doctorName'] as String? ?? '',
        doctorSpecialty: map['doctorSpecialty'] as String? ?? '',
        doctorClinic: map['doctorClinic'] as String? ?? '',
        date: _parseDate(map['date']) ?? DateTime.now(),
        slotId: map['slotId'] as String? ?? '',
        slotTime: map['slotTime'] as String? ?? '',
        bookedAt: _parseDate(map['bookedAt']) ?? DateTime.now(),
      );

  static String _dateKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }
}