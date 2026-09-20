import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/appointment.dart';
import '../models/appointment_slot.dart';
import '../models/booking_result.dart';
import '../repositories/appointment_repository.dart';

/// Real appointment repository backed by Firestore.
///
/// Slots are generated per doctor per day; the booked count for each slot
/// comes from the signed-in user's own `users/{uid}/appointments` records,
/// so a user can never double-book the same slot.
class FirestoreAppointmentRepository implements AppointmentRepository {
  FirestoreAppointmentRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  static const int totalSlotsPerTime = 3;

  static const List<String> _slotTimes = [
    '9:00 AM', '9:30 AM', '10:00 AM', '10:30 AM', '11:00 AM', '11:30 AM',
    '2:00 PM', '2:30 PM', '3:00 PM', '3:30 PM', '4:00 PM', '4:30 PM',
  ];

  String? get _uid => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> _collection() {
    final uid = _uid;
    if (uid == null) {
      throw StateError('No signed-in user to book appointments.');
    }
    return _firestore.collection('users').doc(uid).collection('appointments');
  }

  static String _dateKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Future<List<AppointmentSlot>> fetchSlots(String doctorId, DateTime date) async {
    final dateKey = _dateKey(date);
    final snap = await _collection()
        .where('doctorId', isEqualTo: doctorId)
        .where('dateKey', isEqualTo: dateKey)
        .get();

    final counts = <String, int>{};
    for (final doc in snap.docs) {
      final slotId = doc.data()['slotId'] as String? ?? '';
      counts[slotId] = (counts[slotId] ?? 0) + 1;
    }

    return List.generate(_slotTimes.length, (i) {
      final slotId = 'slot_${i + 1}';
      return AppointmentSlot(
        id: slotId,
        time: _slotTimes[i],
        bookedCount: counts[slotId] ?? 0,
        totalSlots: totalSlotsPerTime,
      );
    });
  }

  @override
  Future<BookingResult> bookSlot(
    String doctorId,
    DateTime date,
    String slotId,
  ) async {
    final slots = await fetchSlots(doctorId, date);
    AppointmentSlot? slot;
    for (final s in slots) {
      if (s.id == slotId) {
        slot = s;
        break;
      }
    }
    if (slot == null) {
      return const BookingResult(success: false, message: 'Invalid slot selected.');
    }
    if (slot.isFull) {
      return BookingResult(
        success: false,
        message: 'This slot is now full. Please pick another time.',
      );
    }

    await _collection().add({
      'doctorId': doctorId,
      'doctorName': '',
      'doctorSpecialty': '',
      'doctorClinic': '',
      'dateKey': _dateKey(date),
      'date': date.toIso8601String(),
      'slotId': slotId,
      'slotTime': slot.time,
      'bookedAt': FieldValue.serverTimestamp(),
    });

    return const BookingResult(
      success: true,
      message: 'Appointment confirmed! Details have been saved to your account.',
    );
  }

  /// All appointments booked by the signed-in user, newest first.
  Future<List<Appointment>> loadAppointments() async {
    final snap = await _collection().orderBy('date', descending: true).get();
    return snap.docs.map((d) => Appointment.fromMap(d.id, d.data())).toList();
  }

  /// Cancels an appointment by id.
  Future<void> cancelAppointment(String id) async {
    await _collection().doc(id).delete();
  }
}