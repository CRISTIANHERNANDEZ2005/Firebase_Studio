// Importa el paquete para almacenamiento persistente local
import 'package:shared_preferences/shared_preferences.dart';

// Clase para gestionar el almacenamiento seguro del token JWT
class TokenStorage {
  // Clave constante para identificar el token en el almacenamiento
  static const String _tokenKey = 'jwt_token';

  // Guarda el token en el almacenamiento local del dispositivo
  static Future<void> saveToken(String token) async {
    // Obtiene la instancia de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    // Almacena el token usando la clave definida
    await prefs.setString(_tokenKey, token);
  }

  // Recupera el token almacenado (devuelve null si no existe)
  static Future<String?> getToken() async {
    // Obtiene la instancia de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    // Recupera el token usando la clave definida
    return prefs.getString(_tokenKey);
  }

  // Elimina el token del almacenamiento (usado en logout)
  static Future<void> deleteToken() async {
    // Obtiene la instancia de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    // Remueve el token almacenado
    await prefs.remove(_tokenKey);
  }
}
