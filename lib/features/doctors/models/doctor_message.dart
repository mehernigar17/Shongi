/// A consultation message the user sent to a doctor.
/// Stored per user under `users/{uid}/messages`.
class DoctorMessage {
  final String id;
  final String doctorId;
  final String doctorName;
  final String body;
  final DateTime sentAt;

  const DoctorMessage({
    this.id = '',
    required this.doctorId,
    required this.doctorName,
    required this.body,
    required this.sentAt,
  });

  Map<String, dynamic> toMap() => {
        'doctorId': doctorId,
        'doctorName': doctorName,
        'body': body,
        'sentAt': sentAt.toIso8601String(),
      };

  factory DoctorMessage.fromMap(String id, Map<String, dynamic> map) =>
      DoctorMessage(
        id: id,
        doctorId: map['doctorId'] as String? ?? '',
        doctorName: map['doctorName'] as String? ?? '',
        body: map['body'] as String? ?? '',
        sentAt: _parseDate(map['sentAt']) ?? DateTime.now(),
      );

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }
}
