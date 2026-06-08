import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.register,
      body: {'name': name, 'email': email, 'password': password},
    );

    final authResponse = AuthResponseModel.fromJson(response['data']);
    _apiClient.setToken(authResponse.token);
    return authResponse;
  }

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.login,
      body: {'email': email, 'password': password},
    );

    final authResponse = AuthResponseModel.fromJson(response['data']);
    _apiClient.setToken(authResponse.token);
    return authResponse;
  }

  Future<UserModel> getProfile() async {
    final response = await _apiClient.get(ApiConstants.profile);
    return UserModel.fromJson(response['data']['user']);
  }

  void logout() {
    _apiClient.setToken(null);
  }
}
