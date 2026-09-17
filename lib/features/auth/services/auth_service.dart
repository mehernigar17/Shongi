import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Normalizes an email so "Foo@Bar.com" and "foo@bar.com" are the same account.
  static String normalizeEmail(String email) => email.trim().toLowerCase();

  // ─────────────────────── REGISTER ───────────────────────
  Future<UserCredential> register({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: normalizeEmail(email),
      password: password,
    );
  }

  // ─────────────────────── LOGIN ───────────────────────
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: normalizeEmail(email),
      password: password,
    );
  }

  // ─────────────────────── SIGN OUT ───────────────────────
  Future<void> logout() async {
    await _auth.signOut();
  }

  // ─────────────────────── PASSWORD RESET ───────────────────────
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: normalizeEmail(email));
  }

  // ─────────────────────── DISPLAY NAME ───────────────────────
  Future<void> updateDisplayName(String name) async {
    await _auth.currentUser?.updateDisplayName(name.trim());
  }

  // ─────────────────────── FIRESTORE USER DOC ───────────────────────
  /// Creates (or updates) the Firestore document for a user.
  /// This is where the onboarding-completed flag lives, so it must exist
  /// as soon as the account is created.
  Future<void> createUserDoc(User? user) async {
    if (user == null) return;
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'email': user.email?.trim().toLowerCase(),
      'displayName': user.displayName,
      'onboardingCompleted': false,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}