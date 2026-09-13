import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../features/onboarding/views/onboarding_view.dart';
import 'app_dependencies.dart';
import 'app_shell_view.dart';
import '../features/auth/views/auth_view.dart';

class ShongiApp extends StatelessWidget {
  const ShongiApp({super.key, required this.dependencies});
  final AppDependencies dependencies;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Shongi',
    debugShowCheckedModeBanner: false,
    theme: appTheme,
    initialRoute: '/login',
    routes: {
      '/login': (_) => const AuthScreen(),
      '/register': (_) => const AuthScreen(register: true),
      '/onboarding': (_) => OnboardingScreen(dependencies: dependencies),
      '/home': (_) => const MainScreen(),
    },
  );
}
