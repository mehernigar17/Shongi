import '../models/appointment_slot.dart';
import '../models/booking_result.dart';

abstract class AppointmentRepository {
  Future<List<AppointmentSlot>> fetchSlots(String doctorId, DateTime date);

  /// Saves a consultation request.
  ///
  /// [consultName] and [consultSpecialty] are stored on the record so the
  /// appointment list can name what was actually requested.
  Future<BookingResult> bookSlot(
    String doctorId,
    DateTime date,
    String slotId, {
    required String consultName,
    required String consultSpecialty,
  });
}
