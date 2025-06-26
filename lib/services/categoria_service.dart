import 'dart:convert';
import 'package:flutter/material.dart';
import '../utils/ruta.dart';
import '../models/categoria.dart';
import 'auth_service.dart';

class CategoriaService with ChangeNotifier {
  List<Categoria> _categorias = [];
  bool _isLoading = false;
  final AuthService? _authService;

  List<Categoria> get categorias => _categorias;
  bool get isLoading => _isLoading;

  CategoriaService(this._authService);

  void initializeIfNeeded(CategoriaService? existingService) {
    if (existingService != null) {
      _categorias = existingService._categorias;
      _isLoading = existingService._isLoading;
    }
  }

  Future<String?> fetchCategorias() async {
    if (_authService == null) return 'Servicio no inicializado';
    
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.makeAuthenticatedRequest(
        method: 'GET',
        url: Ruta.categorias,
      );

      if (response.statusCode == 200) {
        _categorias = (jsonDecode(response.body) as List)
            .map((json) => Categoria.fromJson(json))
            .toList();
        return null;
      } else {
        return jsonDecode(response.body)['error'] ?? 'Error al obtener categorías';
      }
    } catch (e) {
      return 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> createCategoria(String nombre) async {
    if (_authService == null) return 'Servicio no inicializado';
    
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.makeAuthenticatedRequest(
        method: 'POST',
        url: Ruta.categorias,
        body: {'nombre': nombre},
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
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

  Future<String?> updateCategoria(int id, String nombre) async {
    if (_authService == null) return 'Servicio no inicializado';
    
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.makeAuthenticatedRequest(
        method: 'PUT',
        url: '${Ruta.categorias}$id',
        body: {'nombre': nombre},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final index = _categorias.indexWhere((cat) => cat.id == id);
        if (index != -1) {
          _categorias[index] = Categoria.fromJson(data['categoria']);
        }
        return null;
      } else {
        return jsonDecode(response.body)['error'] ?? 'Error al actualizar categoría';
      }
    } catch (e) {
      return 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> deleteCategoria(int id) async {
    if (_authService == null) return 'Servicio no inicializado';
    
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.makeAuthenticatedRequest(
        method: 'DELETE',
        url: '${Ruta.categorias}$id',
      );

      if (response.statusCode == 200) {
        _categorias.removeWhere((cat) => cat.id == id);
        return null;
      } else {
        return jsonDecode(response.body)['error'] ?? 'Error al eliminar categoría';
      }
    } catch (e) {
      return 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}