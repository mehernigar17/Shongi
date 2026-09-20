import '../features/dashboard/data/firestore_dashboard_repository.dart';
import '../features/dashboard/repositories/dashboard_repository.dart';
import '../features/doctors/data/firestore_appointment_repository.dart';
import '../features/doctors/repositories/appointment_repository.dart';
import '../features/haircare/data/firestore_haircare_repository.dart';
import '../features/haircare/repositories/haircare_repository.dart';
import '../features/logs/data/firestore_log_repository.dart';
import '../features/logs/repositories/log_repository.dart';
import '../features/onboarding/data/firestore_profile_repository.dart';
import '../features/onboarding/repositories/profile_repository.dart';
import '../features/periods/data/firestore_period_repository.dart';
import '../features/periods/repositories/period_repository.dart';
import '../features/profile/data/firestore_user_settings_repository.dart';
import '../features/profile/repositories/user_settings_repository.dart';
import '../features/skincare/data/firestore_skincare_repository.dart';
import '../features/skincare/repositories/skincare_repository.dart';
import '../features/statistics/data/firestore_statistics_repository.dart';
import '../features/statistics/repositories/statistics_repository.dart';

/// Central registry of repositories. Every repository is scoped to the
/// signed-in Firebase user, so all data is per-user by construction.
class AppDependencies {
  AppDependencies()
      : profileRepository = FirestoreProfileRepository(),
        userSettingsRepository = FirestoreUserSettingsRepository(),
        logRepository = FirestoreLogRepository(),
        periodRepository = FirestorePeriodRepository(),
        appointmentRepository = FirestoreAppointmentRepository(),
        dashboardRepository = FirestoreDashboardRepository(),
        statisticsRepository = FirestoreStatisticsRepository(),
        skincareRepository = FirestoreSkincareRepository(),
        haircareRepository = FirestoreHaircareRepository();

  final ProfileRepository profileRepository;
  final UserSettingsRepository userSettingsRepository;
  final LogRepository logRepository;
  final PeriodRepository periodRepository;
  final AppointmentRepository appointmentRepository;
  final DashboardRepository dashboardRepository;
  final StatisticsRepository statisticsRepository;
  final SkincareRepository skincareRepository;
  final HaircareRepository haircareRepository;
}