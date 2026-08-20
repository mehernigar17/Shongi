import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';
import '../repositories/profile_repository.dart';
class OnboardingViewModel extends ChangeNotifier {
  OnboardingViewModel(this._repository); final ProfileRepository _repository; bool _isLoading=false; String? _errorMessage; UserProfile? _savedProfile;
  bool get isLoading=>_isLoading; String? get errorMessage=>_errorMessage; UserProfile? get savedProfile=>_savedProfile;
  String? validate(UserProfile p) => p.name.trim().isEmpty ? 'Please enter your name.' : (p.age<=0 || p.heightCm<=0 || p.weightKg<=0 ? 'Please enter valid measurements.' : null);
  Future<bool> save(UserProfile p) async { _errorMessage=validate(p); if(_errorMessage!=null){notifyListeners();return false;} _isLoading=true;notifyListeners(); try {await _repository.save(p);_savedProfile=p;return true;} catch(e){_errorMessage=e.toString();return false;} finally {_isLoading=false;notifyListeners();} }
}
