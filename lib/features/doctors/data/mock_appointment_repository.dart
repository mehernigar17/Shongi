import '../models/appointment_slot.dart';
import '../models/booking_result.dart';
import '../repositories/appointment_repository.dart';

class MockAppointmentRepository implements AppointmentRepository {
  @override
  Future<List<AppointmentSlot>> fetchSlots(String doctorId, DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _mockSlots;
  }

  @override
  Future<BookingResult> bookSlot(
    String doctorId,
    DateTime date,
    String slotId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return const BookingResult(
      success: true,
      message: 'Appointment confirmed! Details have been sent to your email.',
    );
  }

  static const List<AppointmentSlot> _mockSlots = [
    AppointmentSlot(id: 's1', time: '9:00 AM', bookedCount: 3, totalSlots: 3),
    AppointmentSlot(id: 's2', time: '9:30 AM', bookedCount: 2, totalSlots: 3),
    AppointmentSlot(id: 's3', time: '10:00 AM', bookedCount: 1, totalSlots: 3),
    AppointmentSlot(id: 's4', time: '10:30 AM', bookedCount: 0, totalSlots: 3),
    AppointmentSlot(id: 's5', time: '11:00 AM', bookedCount: 3, totalSlots: 3),
    AppointmentSlot(id: 's6', time: '11:30 AM', bookedCount: 1, totalSlots: 3),
    AppointmentSlot(id: 's7', time: '2:00 PM', bookedCount: 0, totalSlots: 3),
    AppointmentSlot(id: 's8', time: '2:30 PM', bookedCount: 2, totalSlots: 3),
    AppointmentSlot(id: 's9', time: '3:00 PM', bookedCount: 0, totalSlots: 3),
    AppointmentSlot(id: 's10', time: '3:30 PM', bookedCount: 1, totalSlots: 3),
    AppointmentSlot(id: 's11', time: '4:00 PM', bookedCount: 0, totalSlots: 3),
    AppointmentSlot(id: 's12', time: '4:30 PM', bookedCount: 2, totalSlots: 3),
  ];
}
