import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shongi/features/auth/views/auth_view.dart';
import 'package:shongi/features/profile/views/profile_view.dart';

void main() {
  setUp(() => GoogleFonts.config.allowRuntimeFetching = false);

  Widget app() => MaterialApp(
    initialRoute: '/login',
    routes: {
      '/login': (_) => const AuthScreen(),
      '/register': (_) => const AuthScreen(register: true),
      '/home': (_) => const ProfileScreen(),
      '/onboarding': (_) =>
          const Scaffold(body: Text('Onboarding destination')),
    },
  );

  testWidgets('Login validates input and logout clears navigation history', (
    tester,
  ) async {
    await tester.pumpWidget(app());
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a valid email address'), findsOneWidget);
    expect(find.text('Enter a password'), findsOneWidget);
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'demo@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'demo');
    await tester.ensureVisible(find.text('Log in'));
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();
    expect(find.byType(ProfileScreen), findsOneWidget);
    await tester.ensureVisible(find.text('Sign Out'));
    await tester.tap(find.text('Sign Out'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Sign Out'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome back'), findsOneWidget);
    expect(
      Navigator.of(tester.element(find.byType(AuthScreen))).canPop(),
      isFalse,
    );
  });

  testWidgets('Register checks confirmation and opens onboarding', (
    tester,
  ) async {
    await tester.pumpWidget(app());
    await tester.ensureVisible(find.text('New to Shongi? Register'));
    await tester.tap(find.text('New to Shongi? Register'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'Demo User');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'demo@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(2), 'demo');
    await tester.enterText(find.byType(TextFormField).at(3), 'different');
    await tester.ensureVisible(find.text('Create account'));
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();
    expect(find.text('Passwords do not match'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(3), 'demo');
    await tester.ensureVisible(find.text('Create account'));
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();
    expect(find.text('Onboarding destination'), findsOneWidget);
  });
}
