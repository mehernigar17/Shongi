import 'package:flutter/material.dart';
import 'package:shongi/core/theme/app_colors.dart';
import 'package:shongi/features/doctors/data/mock_doctor_repository.dart';
import 'package:shongi/features/doctors/viewmodels/doctors_view_model.dart';
import 'package:shongi/features/doctors/views/widgets/Recommended_Doctor.dart';
import 'package:shongi/features/doctors/views/widgets/doctor_header.dart';
import 'package:shongi/features/doctors/views/widgets/doctor_pdf_file.dart';
import 'package:shongi/features/doctors/views/widgets/report_preview.dart';

class DoctorsScreen extends StatefulWidget {
  final DoctorsViewModel? viewModel;

  const DoctorsScreen({super.key, this.viewModel});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  late final DoctorsViewModel _viewModel;
  bool _ownsViewModel = false;

  @override
  void initState() {
    super.initState();
    if (widget.viewModel != null) {
      _viewModel = widget.viewModel!;
    } else {
      _viewModel = DoctorsViewModel(MockDoctorRepository());
      _ownsViewModel = true;
    }
  }

  @override
  void dispose() {
    if (_ownsViewModel) {
      _viewModel.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _viewModel,
          builder: (context, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  const DoctorHeader(),
                  const SizedBox(height: 20),
                  const DoctorPdfFile(),
                  const SizedBox(height: 20),
                  const ReportPreview(),
                  const SizedBox(height: 24),
                  if (_viewModel.isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(color: accentColor),
                      ),
                    )
                  else
                    RecommendedDoctor(doctor: _viewModel.doctors),
                  const SizedBox(height: 100),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

