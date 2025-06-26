// Importaciones necesarias para el servicio
import 'dart:convert'; // Para trabajar con JSON
import 'package:flutter/foundation.dart'; // Para ChangeNotifier
import 'package:http/http.dart' as http; // Para hacer peticiones HTTP
import 'package:shared_preferences/shared_preferences.dart'; // Para almacenamiento local
import '../utils/ruta.dart'; // Importa las rutas de la API

// Servicio de autenticación que notifica cambios (para actualizar la UI)
class AuthService with ChangeNotifier {
  // Variables privadas para el estado
  String? _token; // Token de autenticación JWT
  bool _isLoading = false; // Indica si hay una operación en curso
  String? _error; // Mensaje de error si ocurre alguno

  // Getters públicos para acceder al estado
  String? get token => _token; // Obtener el token actual
  bool get isLoading => _isLoading; // Saber si está cargando
  String? get error => _error; // Obtener el último error

  // Guarda el token en el almacenamiento local del dispositivo
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance(); // Obtiene la instancia
    await prefs.setString(
      'auth_token',
      token,
    ); // Guarda el token con clave 'auth_token'
  }

  // Elimina el token del almacenamiento local
  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token'); // Remueve el token guardado
  }

  // Intenta cargar la sesión automáticamente al iniciar la app
  Future<void> autoLogin() async {
    _isLoading = true; // Activa el indicador de carga
    notifyListeners(); // Notifica a los oyentes (UI) que hubo cambios

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(
        'auth_token',
      ); // Intenta obtener el token guardado

      if (token != null) {
        _token = token; // Si existe, lo asigna
      }
    } catch (e) {
      _error = 'Error al cargar sesión'; // Manejo de errores
    } finally {
      _isLoading = false; // Desactiva el indicador de carga
      notifyListeners(); // Notifica que terminó la operación
    }
  }

  // Método para iniciar sesión con número y contraseña
  Future<String?> login(String numero, String contrasena) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Realiza la petición POST al endpoint de login
      final response = await http.post(
        Uri.parse(Ruta.login), // URL del endpoint
        body: jsonEncode({
          'numero': numero,
          'contrasena': contrasena,
        }), // Datos en JSON
        headers: {'Content-Type': 'application/json'}, // Cabeceras
      );

      // Debug: Muestra información en consola (solo en desarrollo)
      if (kDebugMode) print('Status code: ${response.statusCode}');
      if (kDebugMode) print('Response body: ${response.body}');

      final data = jsonDecode(response.body); // Convierte la respuesta a JSON

      if (response.statusCode == 200) {
        // Si la respuesta es exitosa
        _token = data['access_token']; // Obtiene el token de la respuesta
        await _saveToken(_token!); // Guarda el token localmente
        _error = null; // Limpia cualquier error previo
        return null; // Retorna null indicando éxito
      } else {
        // Si hay error, obtiene el mensaje o crea uno genérico
        _error = data['error'] ?? 'Error en el login (${response.statusCode})';
        return _error; // Retorna el mensaje de error
      }
    } catch (e) {
      if (kDebugMode) print('Error details: $e'); // Debug
      _error = 'Error de conexión: ${e.toString()}'; // Error de red
      return _error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Método para registrar un nuevo usuario
  Future<String?> register(
    String numero,
    String nombre,
    String apellido,
    String contrasena,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(Ruta.register),
        body: jsonEncode({
          'numero': numero,
          'nombre': nombre,
          'apellido': apellido,
          'contrasena': contrasena,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Opcional: login automático después del registro
        _token = data['access_token'];
        if (_token != null) {
          await _saveToken(_token!);
        }
        _error = null;
        return null;
      } else {
        _error = data['error'] ?? 'Error en el registro';
        return _error;
      }
    } catch (e) {
      _error = 'Error de conexión';
      return _error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cierra la sesión actual
  Future<void> logout() async {
    _token = null; // Elimina el token en memoria
    await _clearToken(); // Elimina el token del almacenamiento
    notifyListeners(); // Notifica a la UI
  }

  // Método genérico para hacer peticiones autenticadas
  Future<http.Response> makeAuthenticatedRequest({
    required String method, // GET, POST, PUT, DELETE
    required String url, // URL del endpoint
    Map<String, dynamic>? body, // Cuerpo para POST/PUT
  }) async {
    // Configura las cabeceras con el token si existe
    final headers = {
      'Content-Type': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };

    final uri = Uri.parse(url); // Parsea la URL

    // Ejecuta la petición según el método
    switch (method.toUpperCase()) {
      case 'GET':
        return await http.get(uri, headers: headers);
      case 'POST':
        return await http.post(uri, headers: headers, body: jsonEncode(body));
      case 'PUT':
        return await http.put(uri, headers: headers, body: jsonEncode(body));
      case 'DELETE':
        return await http.delete(uri, headers: headers);
      default:
        throw Exception('Método HTTP no soportado');
    }
  }
}
