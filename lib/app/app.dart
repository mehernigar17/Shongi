import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../features/onboarding/views/onboarding_view.dart';
import 'app_dependencies.dart';

class ShongiApp extends StatelessWidget {
  const ShongiApp({super.key, required this.dependencies});
  final AppDependencies dependencies;
  @override
  Widget build(BuildContext context) => MaterialApp(title: 'Shongi', debugShowCheckedModeBanner: false, theme: appTheme, home: OnboardingScreen(dependencies: dependencies));
}
