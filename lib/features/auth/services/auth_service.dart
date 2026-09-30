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

  /// Turns a Firebase Auth failure into a message a user can act on.
  ///
  /// Note: there is deliberately no pre-flight "does this email exist?" call.
  /// Firebase removed `fetchSignInMethodsForEmail` in v6 to stop account
  /// enumeration, so availability is learned from register() itself via the
  /// `email-already-in-use` code — authoritative and immediate.
  static String messageFor(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return 'An account already exists with this email. Try signing in.';
        case 'invalid-email':
          return 'That email address does not look valid.';
        case 'weak-password':
          return 'Password is too weak. Use at least 6 characters.';
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'Incorrect email or password.';
        case 'user-disabled':
          return 'This account has been disabled. Contact support.';
        case 'too-many-requests':
          return 'Too many attempts. Please wait a moment and try again.';
        case 'network-request-failed':
          return 'Network error. Check your connection and try again.';
        case 'operation-not-allowed':
          return 'This sign-in method is disabled. Contact support.';
        default:
          return 'Something went wrong. Please try again.';
      }
    }
    return 'Something went wrong. Please try again.';
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