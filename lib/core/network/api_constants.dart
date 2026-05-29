class ApiConstants {
  static const String baseUrl = 'https://backtransaccional.serviciocdn.icu';

  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';
  static const String profile = '/api/auth/profile';

  static const String products = '/api/products';

  static String productById(int id) => '/api/products/$id';
}
