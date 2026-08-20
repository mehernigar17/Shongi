import '../features/onboarding/data/in_memory_profile_repository.dart';
import '../features/onboarding/repositories/profile_repository.dart';

class AppDependencies {
  AppDependencies() : profileRepository = InMemoryProfileRepository();
  final ProfileRepository profileRepository;
}
