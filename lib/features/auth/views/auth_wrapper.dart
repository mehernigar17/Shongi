import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../app/app_dependencies.dart';
import '../../../app/app_shell_view.dart';
import '../../onboarding/views/onboarding_view.dart';
import 'auth_view.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key, required this.dependencies});
  final AppDependencies dependencies;

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _loadingOnboarding = true;
  bool _onboardingDone = false;
  String? _currentUid;
  StreamSubscription<User?>? _authSub;

  @override
  void initState() {
    super.initState();
    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) {
      final uid = user?.uid;
      if (uid == _currentUid) return;
      _currentUid = uid;
      if (uid == null) {
        // Signed out → back to login
        if (mounted) {
          setState(() {
            _loadingOnboarding = true;
            _onboardingDone = false;
          });
        }
      } else {
        // Signed in → check if this account already finished onboarding
        _checkOnboarding(uid);
      }
    });
  }

  Future<void> _checkOnboarding(String uid) async {
    if (mounted) setState(() => _loadingOnboarding = true);
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      final done = doc.data()?['onboardingCompleted'] == true;
      if (mounted) {
        setState(() {
          _onboardingDone = done;
          _loadingOnboarding = false;
        });
      }
    } catch (_) {
      // Firestore read failed → show onboarding (safe default for new users).
      // If Firestore rules block reads, onboarding will show until rules
      // allow the user to read their own document.
      if (mounted) {
        setState(() {
          _onboardingDone = false;
          _loadingOnboarding = false;
        });
      }
    }
  }

  /// Called by OnboardingScreen after it has persisted the profile and the
  /// `onboardingCompleted` flag to Firestore — only local state changes here.
  void _completeOnboarding() {
    if (mounted) {
      setState(() {
        _onboardingDone = true;
        _loadingOnboarding = false;
      });
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Loading while Firebase checks auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // User is logged in
        if (snapshot.hasData) {
          // Still checking the saved onboarding flag
          if (_loadingOnboarding) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // First time for this account → onboarding pages
          if (!_onboardingDone) {
            return OnboardingScreen(
              dependencies: widget.dependencies,
              onDone: _completeOnboarding,
            );
          }

          // Already completed onboarding → straight to dashboard
          return const MainScreen();
        }

        // Not logged in → AuthScreen
        return const AuthScreen();
      },
    );
  }
}