import 'package:flutter/foundation.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';
import '../../../../core/network/api_client.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository;
  final ApiClient _apiClient;

  UserModel? _user;
  String? _token;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  UserModel? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  AuthViewModel({
    required AuthRepository repository,
    required ApiClient apiClient,
  }) : _repository = repository,
       _apiClient = apiClient;

  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    _clearError();

    try {
      final authResponse = await _repository.login(
        email: email,
        password: password,
      );

      _user = authResponse.user;
      _token = authResponse.token;
      _isAuthenticated = true;

      _apiClient.setToken(_token);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(_parseError(e));
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final authResponse = await _repository.register(
        name: name,
        email: email,
        password: password,
      );

      _user = authResponse.user;
      _token = authResponse.token;
      _isAuthenticated = true;

      _apiClient.setToken(_token);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(_parseError(e));
      _setLoading(false);
      return false;
    }
  }

  void logout() {
    _user = null;
    _token = null;
    _isAuthenticated = false;
    _apiClient.setToken(null);
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  String _parseError(dynamic error) {
    final message = error.toString();
    if (message.startsWith('Exception: ')) {
      return message.substring(11);
    }
    return message;
  }
}
