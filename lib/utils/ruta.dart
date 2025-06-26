class Ruta {
  // URL base del backend
  static const String baseUrl = 'https://api-rest-python.onrender.com';

  // Endpoints de autenticación
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';
  static const String logout = '$baseUrl/auth/logout';
  static const String refreshToken = '$baseUrl/auth/refresh';

  // Endpoints de recursos
  static const String categorias = '$baseUrl/categorias/';
  static const String productos = '$baseUrl/productos/';
  static const String usuarios = '$baseUrl/usuarios/';

  // Método helper para construir URLs con parámetros
  static String buildUrlWithParams(
    String baseUrl,
    Map<String, dynamic>? params,
  ) {
    if (params == null || params.isEmpty) return baseUrl;

    final uri = Uri.parse(baseUrl);
    return uri.replace(queryParameters: params).toString();
  }

  // Método helper para construir URLs con ID
  static String buildUrlWithId(String baseUrl, String id) {
    return '$baseUrl$id/';
  }
}
