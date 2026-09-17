import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.register = false});
  final bool register;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  /// Login/register mode. Toggled with setState — NEVER with Navigator,
  /// because this screen lives inside AuthWrapper (the home route) and
  /// replacing that route destroys the auth listener that routes the app
  /// to onboarding/dashboard after sign-in.
  late bool _registerMode = widget.register;

  bool _hidePassword = true;
  bool _hideConfirmation = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ─────────────────────── FIREBASE LOGIN ───────────────────────
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      _showError('Please fix the highlighted fields.');
      return;
    }
    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);

    try {
      await _authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      // No manual navigation — AuthWrapper listens to Firebase
      // authStateChanges and routes to MainScreen automatically.
    } on FirebaseAuthException catch (e) {
      _showError(_friendlyError(e));
    } catch (_) {
      _showError('Something went wrong. Please try again.');
    } finally {
      // Always reset the button state, even on unexpected errors.
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ─────────────────────── FIREBASE REGISTER ───────────────────────
  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      _showError('Please fix the highlighted fields.');
      return;
    }
    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);

    try {
      final credential = await _authService.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Display name is cosmetic — a failure here must NEVER make the user
      // think signup failed (the account already exists at this point).
      try {
        await credential.user?.updateDisplayName(
          _nameController.text.trim(),
        );
      } catch (_) {
        // Ignore: the account was created successfully.
      }

      // Create the Firestore user doc so the onboarding flag is tracked.
      // If this fails, onboarding will simply show again next login.
      try {
        await _authService.createUserDoc(credential.user);
      } catch (_) {
        // Ignore: auth succeeded; Firestore will be retried on onboarding.
      }

      if (mounted) {
        _showSuccess('Account created! Complete your profile to continue.');
      }
    } on FirebaseAuthException catch (e) {
      _showError(_friendlyError(e));
    } catch (_) {
      _showError('Something went wrong. Please try again.');
    } finally {
      // Always reset the button state, even on unexpected errors.
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ─────────────────────── FRIENDLY ERROR MESSAGES ───────────────────────
  String _friendlyError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'invalid-credential':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'This email is already registered. Try logging in.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
      case 'network_error':
        return 'No internet connection. Check your network.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    final isDuplicate = message.contains('already registered');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: isDuplicate
            ? SnackBarAction(
                label: 'Log in',
                textColor: Colors.white,
                onPressed: () => setState(() => _registerMode = false),
              )
            : null,
      ),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ─────────────────────── UI HELPERS ───────────────────────
  InputDecoration _decoration(String label, IconData icon) => InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: accentColor),
    filled: true,
    fillColor: pageBackground,
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: cardBorderColor),
    ),
  );

  Widget _passwordField({bool confirmation = false}) {
    final hidden = confirmation ? _hideConfirmation : _hidePassword;
    return TextFormField(
      controller: confirmation ? null : _passwordController,
      obscureText: hidden,
      autocorrect: false,
      enableSuggestions: false,
      textInputAction: _registerMode && !confirmation
          ? TextInputAction.next
          : TextInputAction.done,
      onFieldSubmitted: (_) {
        if (!_registerMode || confirmation) {
          _registerMode ? _register() : _login();
        }
      },
      decoration:
          _decoration(
            confirmation ? 'Confirm password' : 'Password',
            Icons.lock_outline_rounded,
          ).copyWith(
            suffixIcon: IconButton(
              tooltip: hidden ? 'Show password' : 'Hide password',
              onPressed: () => setState(() {
                if (confirmation) {
                  _hideConfirmation = !_hideConfirmation;
                } else {
                  _hidePassword = !_hidePassword;
                }
              }),
              icon: Icon(
                hidden
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
            ),
          ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Enter a password';
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        if (confirmation && value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final register = _registerMode;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ─── Logo ───
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: accentColorLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.spa_rounded,
                        size: 40,
                        color: accentColorDeep,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Shongi',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: accentColorDeep,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'A little care, every day.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // ─── Form Card ───
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: cardBorderColor),
                    ),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            register ? 'Create your account' : 'Welcome back',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: accentColorDeep,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            register
                                ? 'Start your personal wellness journey.'
                                : 'Make a little time for yourself today.',
                            style: TextStyle(color: textSecondary, height: 1.6),
                          ),
                          const SizedBox(height: 24),

                          // ─── Full name (register only) ───
                          if (register) ...[
                            TextFormField(
                              controller: _nameController,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              decoration: _decoration(
                                'Full name',
                                Icons.person_outline_rounded,
                              ),
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                  ? 'Enter your name'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                          ],

                          // ─── Email ───
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                            decoration: _decoration(
                              'Email address',
                              Icons.mail_outline_rounded,
                            ),
                            validator: (value) =>
                                RegExp(
                                  r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                                ).hasMatch(value?.trim() ?? '')
                                ? null
                                : 'Enter a valid email address',
                          ),
                          const SizedBox(height: 16),

                          // ─── Password ───
                          _passwordField(),

                          // ─── Confirm password (register only) ───
                          if (register) ...[
                            const SizedBox(height: 16),
                            _passwordField(confirmation: true),
                          ],
                          const SizedBox(height: 24),

                          // ─── Submit button ───
                          FilledButton(
                            onPressed: _isLoading
                                ? null
                                : (register ? _register : _login),
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(54),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(register ? 'Create account' : 'Log in'),
                          ),
                          const SizedBox(height: 16),

                          // ─── Toggle login / register ───
                          TextButton(
                            onPressed: _isLoading
                                ? null
                                : () => setState(() => _registerMode = !_registerMode),
                            child: Text(
                              register
                                  ? 'Already have an account? Log in'
                                  : 'New to Shongi? Register',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}