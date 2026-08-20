import 'package:flutter/material.dart';
import 'package:shongi/features/health/views/widgets/header_tagchips_healthPage.dart';
import 'package:shongi/features/health/views/widgets/personalizedplan_healthpage.dart';
import 'package:shongi/features/health/views/widgets/exerciseLibrary_healthPage.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 45, 12, 10),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Healthchip(),
            SizedBox(height: 20),
            PersonalizedplanHealthpage(),
            SizedBox(height: 20),
            ExerciseLibrary(),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}