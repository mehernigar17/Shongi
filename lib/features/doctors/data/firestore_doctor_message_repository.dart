import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/doctor_message.dart';

/// Persists consultation messages the user sends to a doctor, per user under
/// `users/{uid}/messages`.
class FirestoreDoctorMessageRepository {
  FirestoreDoctorMessageRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _collection() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw StateError('No signed-in user to send messages.');
    }
    return _firestore.collection('users').doc(uid).collection('messages');
  }

  /// All messages sent by the signed-in user, newest first.
  Future<List<DoctorMessage>> loadMessages() async {
    final snap = await _collection().orderBy('sentAt', descending: true).get();
    return snap.docs
        .map((d) => DoctorMessage.fromMap(d.id, d.data()))
        .toList();
  }

  /// Sends one message and returns the stored record (with its Firestore id).
  Future<DoctorMessage> send({
    required String doctorId,
    required String doctorName,
    required String body,
  }) async {
    final text = body.trim();
    if (text.isEmpty) {
      throw StateError('Message cannot be empty.');
    }
    final ref = _collection().doc();
    final message = DoctorMessage(
      id: ref.id,
      doctorId: doctorId,
      doctorName: doctorName,
      body: text,
      sentAt: DateTime.now(),
    );
    await ref.set(message.toMap());
    return message;
  }

  /// Removes a sent message.
  Future<void> deleteMessage(String id) async {
    await _collection().doc(id).delete();
  }
}
