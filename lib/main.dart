import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app/app.dart';
import 'app/app_dependencies.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Show the real error on screen instead of a blank page
    runApp(FirebaseErrorScreen(error: e.toString()));
    return;
  }
  runApp(ShongiApp(dependencies: AppDependencies()));
}

/// Shows the Firebase initialization error so it can be diagnosed.
class FirebaseErrorScreen extends StatelessWidget {
  const FirebaseErrorScreen({super.key, required this.error});
  final String error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFF8F4FC),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 56, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Firebase failed to initialize',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                SelectableText(
                  error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}