import 'dart:convert';
import 'package:flutter/material.dart';
import '../utils/ruta.dart';
import '../models/usuario.dart';
import 'auth_service.dart';

class UsuarioService with ChangeNotifier {
  List<Usuario> _usuarios = [];
  bool _isLoading = false;
  final AuthService? _authService;

  List<Usuario> get usuarios => _usuarios;
  bool get isLoading => _isLoading;

  UsuarioService(this._authService);

  void initializeIfNeeded(UsuarioService? existingService) {
    if (existingService != null) {
      _usuarios = existingService._usuarios;
      _isLoading = existingService._isLoading;
    }
  }

  Future<String?> fetchUsuarios() async {
    if (_authService == null) return 'Servicio no inicializado';
    
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.makeAuthenticatedRequest(
        method: 'GET',
        url: Ruta.usuarios,
      );

      if (response.statusCode == 200) {
        _usuarios = (jsonDecode(response.body) as List)
            .map((json) => Usuario.fromJson(json))
            .toList();
        return null;
      } else {
        return jsonDecode(response.body)['error'] ?? 'Error al obtener usuarios';
      }
    } catch (e) {
      return 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> createUsuario({
    required String numero,
    required String nombre,
    required String apellido,
    required String contrasena,
  }) async {
    if (_authService == null) return 'Servicio no inicializado';
    
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.makeAuthenticatedRequest(
        method: 'POST',
        url: Ruta.usuarios,
        body: {
          'numero': numero,
          'nombre': nombre,
          'apellido': apellido,
          'contrasena': contrasena,
        },
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _usuarios.add(Usuario.fromJson(data['usuario']));
        return null;
      } else {
        return jsonDecode(response.body)['error'] ?? 'Error al crear usuario';
      }
    } catch (e) {
      return 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> updateUsuario({
    required int id,
    required String numero,
    required String nombre,
    required String apellido,
    String? contrasena,
  }) async {
    if (_authService == null) return 'Servicio no inicializado';
    
    _isLoading = true;
    notifyListeners();

    try {
      final body = {
        'numero': numero,
        'nombre': nombre,
        'apellido': apellido,
        if (contrasena != null && contrasena.isNotEmpty) 'contrasena': contrasena,
      };

      final response = await _authService.makeAuthenticatedRequest(
        method: 'PUT',
        url: '${Ruta.usuarios}$id',
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final index = _usuarios.indexWhere((user) => user.id == id);
        if (index != -1) {
          _usuarios[index] = Usuario.fromJson(data['usuario']);
        }
        return null;
      } else {
        return jsonDecode(response.body)['error'] ?? 'Error al actualizar usuario';
      }
    } catch (e) {
      return 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> deleteUsuario(int id) async {
    if (_authService == null) return 'Servicio no inicializado';
    
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.makeAuthenticatedRequest(
        method: 'DELETE',
        url: '${Ruta.usuarios}$id',
      );

      if (response.statusCode == 200) {
        _usuarios.removeWhere((user) => user.id == id);
        return null;
      } else {
        return jsonDecode(response.body)['error'] ?? 'Error al eliminar usuario';
      }
    } catch (e) {
      return 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}