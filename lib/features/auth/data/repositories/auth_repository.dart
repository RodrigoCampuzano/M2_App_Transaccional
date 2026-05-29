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

    return AuthResponseModel.fromJson(response['data']);
  }

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.login,
      body: {'email': email, 'password': password},
    );

    return AuthResponseModel.fromJson(response['data']);
  }

  Future<UserModel> getProfile() async {
    final response = await _apiClient.get(ApiConstants.profile);
    return UserModel.fromJson(response['data']['user']);
  }
}
