class ApiConstants {
  static const _baseUrl = 'https://nimbus-api-vtoz.onrender.com/api/v1';

  static const String loginApi = '$_baseUrl/auth/login';
  static const String signupApi = '$_baseUrl/auth/register';
  static const String authApi = '$_baseUrl/auth/me';
  static const String regionApi = '$_baseUrl/cities/regions';

  static String citiesApi({int page = 1}) {
    return '$_baseUrl/cities?page=$page&limit=8';
  }
}
