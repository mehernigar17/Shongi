import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// UI-only demo: credentials are validated for shape, never sent or stored.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.register = false});
  final bool register;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  bool _hidePassword = true;
  bool _hideConfirmation = true;

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    Navigator.of(context).pushNamedAndRemoveUntil(
      widget.register ? '/onboarding' : '/home',
      (_) => false,
    );
  }

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
      controller: confirmation ? null : _password,
      obscureText: hidden,
      autocorrect: false,
      enableSuggestions: false,
      textInputAction: widget.register && !confirmation
          ? TextInputAction.next
          : TextInputAction.done,
      onFieldSubmitted: (_) {
        if (!widget.register || confirmation) _submit();
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
        if (confirmation && value != _password.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final register = widget.register;
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
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: cardBorderColor),
                    ),
                    child: Form(
                      key: _formKey,
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
                          if (register) ...[
                            TextFormField(
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
                          TextFormField(
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
                          _passwordField(),
                          if (register) ...[
                            const SizedBox(height: 16),
                            _passwordField(confirmation: true),
                          ],
                          const SizedBox(height: 24),
                          FilledButton(
                            onPressed: _submit,
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(54),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(register ? 'Create account' : 'Log in'),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () =>
                                Navigator.of(context).pushReplacementNamed(
                                  register ? '/login' : '/register',
                                ),
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
                  const SizedBox(height: 20),
                  Text(
                    'Demo preview · Use any email and password.\nNo account is created or saved.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: textSecondary,
                      height: 1.6,
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
