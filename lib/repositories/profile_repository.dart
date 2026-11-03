import '../models/profile_model.dart';
import '../services/api_service.dart';

class ProfileRepository {
  final ApiService _api;

  ProfileRepository({ApiService? api}) : _api = api ?? ApiService();

  Future<Profile> getProfile() => _api.fetchProfile();

  Future<void> updateProfile(Profile profile) => _api.updateProfile(profile);
}
