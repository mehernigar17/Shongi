import '../features/onboarding/data/firestore_profile_repository.dart';
import '../features/onboarding/repositories/profile_repository.dart';

class AppDependencies {
  AppDependencies() : profileRepository = FirestoreProfileRepository();
  final ProfileRepository profileRepository;
}