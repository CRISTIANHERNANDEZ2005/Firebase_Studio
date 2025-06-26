// Clase que centraliza todas las rutas/endpoints de la API
class Ruta {
  // URL base del backend (punto único de cambio si se modifica)
  static const String baseUrl = 'https://api-rest-python.onrender.com';

  // Endpoints de autenticación
  static const String login = '$baseUrl/auth/login'; // Inicio de sesión
  static const String register = '$baseUrl/auth/register'; // Registro
  static const String logout = '$baseUrl/auth/logout'; // Cierre de sesión
  static const String refreshToken = '$baseUrl/auth/refresh'; // Refrescar token

  // Endpoints de recursos (CRUD)
  static const String categorias = '$baseUrl/categorias/'; // Gestión categorías
  static const String productos = '$baseUrl/productos/'; // Gestión productos
  static const String usuarios = '$baseUrl/usuarios/'; // Gestión usuarios

  // Construye una URL con parámetros de consulta (query parameters)
  static String buildUrlWithParams(
    String baseUrl, // URL base
    Map<String, dynamic>? params, // Parámetros opcionales
  ) {
    // Si no hay parámetros, devuelve la URL sin cambios
    if (params == null || params.isEmpty) return baseUrl;

    // Parsea la URL y agrega los parámetros
    final uri = Uri.parse(baseUrl);
    return uri.replace(queryParameters: params).toString();
  }

  // Construye una URL con un ID específico para operaciones CRUD
  static String buildUrlWithId(String baseUrl, String id) {
    // Concatena la URL base con el ID y una barra final
    return '$baseUrl$id/';
  }
}