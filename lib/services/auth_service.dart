import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/ruta.dart';

class AuthService with ChangeNotifier {
  String? _token;
  bool _isLoading = false;
  String? _error;

  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<void> autoLogin() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token != null) {
        _token = token;
      }
    } catch (e) {
      _error = 'Error al cargar sesión';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> login(String numero, String contrasena) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(Ruta.login),
        body: jsonEncode({'numero': numero, 'contrasena': contrasena}),
        headers: {'Content-Type': 'application/json'},
      );

      if (kDebugMode) {
        print('Status code: ${response.statusCode}');
      } // Debug
      if (kDebugMode) {
        print('Response body: ${response.body}');
      } // Debug

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _token = data['access_token'];
        await _saveToken(_token!);
        _error = null;
        return null;
      } else {
        _error = data['error'] ?? 'Error en el login (${response.statusCode})';
        return _error;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error details: $e');
      } // Debug
      _error = 'Error de conexión: ${e.toString()}';
      return _error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

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
        // Opcional: puedes hacer login automático después del registro
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

  Future<void> logout() async {
    _token = null;
    await _clearToken();
    notifyListeners();
  }

  Future<http.Response> makeAuthenticatedRequest({
    required String method,
    required String url,
    Map<String, dynamic>? body,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };

    final uri = Uri.parse(url);

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
