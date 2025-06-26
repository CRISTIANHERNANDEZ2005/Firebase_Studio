import 'package:shared_preferences/shared_preferences.dart';

// Clase para gestionar el token JWT
class TokenStorage {
  static const String _tokenKey = 'jwt_token';

  // Guarda el token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Obtiene el token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Elimina el token (logout)
  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}