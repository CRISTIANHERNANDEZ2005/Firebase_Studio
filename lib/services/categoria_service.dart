import 'dart:convert'; // Para JSON
import 'package:flutter/material.dart'; // Para ChangeNotifier
import '../utils/ruta.dart'; // Rutas API
import '../models/categoria.dart'; // Modelo de datos
import 'auth_service.dart'; // Servicio de autenticación

// Servicio para gestionar categorías
class CategoriaService with ChangeNotifier {
  List<Categoria> _categorias = []; // Lista de categorías en memoria
  bool _isLoading = false; // Estado de carga
  final AuthService? _authService; // Dependencia del servicio de auth

  // Getters para acceder al estado
  List<Categoria> get categorias => _categorias;
  bool get isLoading => _isLoading;

  // Constructor que recibe el authService
  CategoriaService(this._authService);

  // Método para inicializar el servicio con datos existentes (usado en MultiProvider)
  void initializeIfNeeded(CategoriaService? existingService) {
    if (existingService != null) {
      _categorias = existingService._categorias; // Copia las categorías
      _isLoading = existingService._isLoading; // Copia el estado de carga
    }
  }

  // Modifica el método fetchCategorias para mejor manejo de errores
  Future<String?> fetchCategorias() async {
    if (_authService == null) return 'Servicio no inicializado';

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.makeAuthenticatedRequest(
        method: 'GET',
        url: Ruta.categorias,
      );

      debugPrint(
        'Respuesta de categorías: ${response.statusCode} - ${response.body}',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _categorias = data.map((json) => Categoria.fromJson(json)).toList();
        debugPrint('Categorías obtenidas: ${_categorias.length}');
        return null;
      } else {
        final error =
            jsonDecode(response.body)['error'] ?? 'Error al obtener categorías';
        debugPrint('Error al obtener categorías: $error');
        return error;
      }
    } catch (e) {
      debugPrint('Excepción al obtener categorías: $e');
      return 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Crea una nueva categoría
  Future<String?> createCategoria(String nombre) async {
    if (_authService == null) return 'Servicio no inicializado';

    _isLoading = true;
    notifyListeners();

    try {
      // Petición POST con el nombre de la categoría
      final response = await _authService.makeAuthenticatedRequest(
        method: 'POST',
        url: Ruta.categorias,
        body: {'nombre': nombre},
      );

      if (response.statusCode == 201) {
        // 201 = Created
        final data = jsonDecode(response.body);
        // Agrega la nueva categoría a la lista local
        _categorias.add(Categoria.fromJson(data['categoria']));
        return null;
      } else {
        return jsonDecode(response.body)['error'] ?? 'Error al crear categoría';
      }
    } catch (e) {
      return 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Actualiza una categoría existente
  Future<String?> updateCategoria(int id, String nombre) async {
    if (_authService == null) return 'Servicio no inicializado';

    _isLoading = true;
    notifyListeners();

    try {
      // Petición PUT a la URL específica de la categoría
      final response = await _authService.makeAuthenticatedRequest(
        method: 'PUT',
        url: '${Ruta.categorias}$id',
        body: {'nombre': nombre},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Busca y actualiza la categoría en la lista local
        final index = _categorias.indexWhere((cat) => cat.id == id);
        if (index != -1) {
          _categorias[index] = Categoria.fromJson(data['categoria']);
        }
        return null;
      } else {
        return jsonDecode(response.body)['error'] ??
            'Error al actualizar categoría';
      }
    } catch (e) {
      return 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Elimina una categoría
  Future<String?> deleteCategoria(int id) async {
    if (_authService == null) return 'Servicio no inicializado';

    _isLoading = true;
    notifyListeners();

    try {
      // Petición DELETE a la URL de la categoría
      final response = await _authService.makeAuthenticatedRequest(
        method: 'DELETE',
        url: '${Ruta.categorias}$id',
      );

      if (response.statusCode == 200) {
        // Remueve la categoría de la lista local
        _categorias.removeWhere((cat) => cat.id == id);
        return null;
      } else {
        return jsonDecode(response.body)['error'] ??
            'Error al eliminar categoría';
      }
    } catch (e) {
      return 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
