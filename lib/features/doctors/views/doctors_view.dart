import 'package:flutter/material.dart';
import 'package:shongi/app/app_dependencies.dart';
import 'package:shongi/core/theme/app_colors.dart';
import 'package:shongi/features/doctors/data/mock_doctor_repository.dart';
import 'package:shongi/features/doctors/models/report_data.dart';
import 'package:shongi/features/doctors/viewmodels/doctors_view_model.dart';
import 'package:shongi/features/doctors/views/widgets/Recommended_Doctor.dart';
import 'package:shongi/features/doctors/views/widgets/doctor_header.dart';
import 'package:shongi/features/doctors/views/widgets/doctor_pdf_file.dart';
import 'package:shongi/features/doctors/views/widgets/report_preview.dart';

/// Embedded doctor content used inside the Health Hub, mirroring
/// SkincareView / HaircareView so the Doctor chip behaves like the others.
///
/// The report preview is computed from the signed-in user's real
/// Firestore records (profile + logs + periods); the specialist list is
/// curated static content, but booking writes to the user's own
/// `users/{uid}/appointments` collection.
class DoctorsView extends StatefulWidget {
  final DoctorsViewModel? viewModel;
  final AppDependencies? dependencies;

  const DoctorsView({super.key, this.viewModel, this.dependencies});

  @override
  State<DoctorsView> createState() => _DoctorsViewState();
}

class _DoctorsViewState extends State<DoctorsView> {
  late final DoctorsViewModel _viewModel;
  bool _ownsViewModel = false;

  ReportData _report = ReportData.empty();
  bool _reportLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.viewModel != null) {
      _viewModel = widget.viewModel!;
    } else {
      _viewModel = DoctorsViewModel(MockDoctorRepository());
      _ownsViewModel = true;
    }
    _loadReport();
  }

  @override
  void dispose() {
    if (_ownsViewModel) {
      _viewModel.dispose();
    }
    super.dispose();
  }

  Future<void> _loadReport() async {
    final deps = widget.dependencies;
    if (deps == null) {
      setState(() => _reportLoading = false);
      return;
    }
    try {
      final profile = await deps.profileRepository.load();
      final logs = await deps.logRepository.loadLogs();
      final periods = await deps.periodRepository.loadPeriods();
      if (!mounted) return;
      setState(() {
        _report = ReportData.compute(
          profile: profile,
          logs: logs,
          periods: periods,
        );
        _reportLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _report = ReportData.empty();
        _reportLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DoctorPdfFile(),
            const SizedBox(height: 20),
            if (_reportLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(color: accentColor),
                ),
              )
            else
              ReportPreview(data: _report),
            const SizedBox(height: 24),
            if (_viewModel.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(color: accentColor),
                ),
              )
            else
              RecommendedDoctor(
                doctor: _viewModel.doctors,
                appointmentRepository: widget.dependencies?.appointmentRepository,
              ),
          ],
        );
      },
    );
  }
}

/// Standalone doctor page (pushed as its own screen with a header).
class DoctorsScreen extends StatefulWidget {
  final DoctorsViewModel? viewModel;
  final AppDependencies? dependencies;

  const DoctorsScreen({super.key, this.viewModel, this.dependencies});

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              const DoctorHeader(),
              const SizedBox(height: 20),
              DoctorsView(
                viewModel: _viewModel,
                dependencies: widget.dependencies,
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}