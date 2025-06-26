// Importaciones necesarias
import 'dart:convert'; // Para conversión JSON
import 'package:flutter/material.dart'; // Para ChangeNotifier
import '../utils/ruta.dart'; // Rutas de la API
import '../models/usuario.dart'; // Modelo de datos Usuario
import 'auth_service.dart'; // Servicio de autenticación

// Servicio para gestión de usuarios con notificación de cambios
class UsuarioService with ChangeNotifier {
  // Variables de estado privadas
  List<Usuario> _usuarios = []; // Lista interna de usuarios
  bool _isLoading = false; // Indicador de carga
  final AuthService? _authService; // Dependencia del servicio de autenticación

  // Getters públicos para acceder al estado
  List<Usuario> get usuarios => _usuarios; // Obtener lista de usuarios
  bool get isLoading => _isLoading; // Obtener estado de carga

  // Constructor que recibe el servicio de autenticación
  UsuarioService(this._authService);

  // Inicializa el servicio con datos existentes (para MultiProvider)
  void initializeIfNeeded(UsuarioService? existingService) {
    if (existingService != null) {
      _usuarios = existingService._usuarios; // Copia la lista de usuarios
      _isLoading = existingService._isLoading; // Copia el estado de carga
    }
  }

  // Obtiene todos los usuarios desde la API
  Future<String?> fetchUsuarios() async {
    if (_authService == null) return 'Servicio no inicializado';
    
    _isLoading = true; // Activa el indicador de carga
    notifyListeners(); // Notifica a los listeners (UI)

    try {
      // Realiza petición GET autenticada
      final response = await _authService.makeAuthenticatedRequest(
        method: 'GET',
        url: Ruta.usuarios,
      );

      if (response.statusCode == 200) { // Si la respuesta es exitosa
        // Convierte el JSON a objetos Usuario
        _usuarios = (jsonDecode(response.body) as List)
            .map((json) => Usuario.fromJson(json))
            .toList();
        return null; // Retorna null indicando éxito
      } else {
        // Retorna mensaje de error del servidor o uno genérico
        return jsonDecode(response.body)['error'] ?? 'Error al obtener usuarios';
      }
    } catch (e) {
      return 'Error de conexión: ${e.toString()}'; // Error de red
    } finally {
      _isLoading = false; // Desactiva el indicador de carga
      notifyListeners(); // Notifica a los listeners
    }
  }

  // Crea un nuevo usuario
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
      // Petición POST con los datos del nuevo usuario
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

      if (response.statusCode == 201) { // 201 = Created
        final data = jsonDecode(response.body);
        // Agrega el nuevo usuario a la lista local
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

  // Actualiza un usuario existente
  Future<String?> updateUsuario({
    required int id,
    required String numero,
    required String nombre,
    required String apellido,
    String? contrasena, // Contraseña opcional (para no actualizarla si es null)
  }) async {
    if (_authService == null) return 'Servicio no inicializado';
    
    _isLoading = true;
    notifyListeners();

    try {
      // Prepara el cuerpo de la petición
      final body = {
        'numero': numero,
        'nombre': nombre,
        'apellido': apellido,
        // Solo incluye la contraseña si se proporcionó
        if (contrasena != null && contrasena.isNotEmpty) 'contrasena': contrasena,
      };

      // Petición PUT para actualizar
      final response = await _authService.makeAuthenticatedRequest(
        method: 'PUT',
        url: '${Ruta.usuarios}$id',
        body: body,
      );

      if (response.statusCode == 200) { // 200 = OK
        final data = jsonDecode(response.body);
        // Busca y actualiza el usuario en la lista local
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

  // Elimina un usuario
  Future<String?> deleteUsuario(int id) async {
    if (_authService == null) return 'Servicio no inicializado';
    
    _isLoading = true;
    notifyListeners();

    try {
      // Petición DELETE para eliminar
      final response = await _authService.makeAuthenticatedRequest(
        method: 'DELETE',
        url: '${Ruta.usuarios}$id',
      );

      if (response.statusCode == 200) { // 200 = OK
        // Elimina el usuario de la lista local
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