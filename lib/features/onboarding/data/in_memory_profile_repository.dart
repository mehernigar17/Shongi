import '../models/user_profile.dart';
import '../repositories/profile_repository.dart';
class InMemoryProfileRepository implements ProfileRepository { UserProfile? _profile; @override Future<UserProfile?> load() async => _profile; @override Future<void> save(UserProfile profile) async => _profile = profile; }
