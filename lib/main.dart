import 'package:flutter/widgets.dart';
import 'app/app.dart';
import 'app/app_dependencies.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // The preview flow is local and does not initialize an authentication backend.
  runApp(ShongiApp(dependencies: AppDependencies()));
}
