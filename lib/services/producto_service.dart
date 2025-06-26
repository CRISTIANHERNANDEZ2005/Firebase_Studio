import 'dart:convert';
import 'package:flutter/material.dart';
import '../utils/ruta.dart';
import '../models/producto.dart';
import 'auth_service.dart';

class ProductoService with ChangeNotifier {
  List<Producto> _productos = [];
  bool _isLoading = false;
  final AuthService? _authService;

  List<Producto> get productos => _productos;
  bool get isLoading => _isLoading;

  ProductoService(this._authService);

  void initializeIfNeeded(ProductoService? existingService) {
    if (existingService != null) {
      _productos = existingService._productos;
      _isLoading = existingService._isLoading;
    }
  }

  Future<String?> fetchProductos() async {
    if (_authService == null) return 'Servicio no inicializado';
    
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.makeAuthenticatedRequest(
        method: 'GET',
        url: Ruta.productos,
      );

      if (response.statusCode == 200) {
        _productos = (jsonDecode(response.body) as List)
            .map((json) => Producto.fromJson(json))
            .toList();
        return null;
      } else {
        return jsonDecode(response.body)['error'] ?? 'Error al obtener productos';
      }
    } catch (e) {
      return 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> createProducto({
    required String nombre,
    required double precio,
    String? descripcion,
    String? nombreCategoria,
  }) async {
    if (_authService == null) return 'Servicio no inicializado';
    
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.makeAuthenticatedRequest(
        method: 'POST',
        url: Ruta.productos,
        body: {
          'nombre': nombre,
          'precio': precio,
          'descripcion': descripcion ?? '',
          'nombre_categoria': nombreCategoria ?? '',
        },
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _productos.add(Producto.fromJson(data['producto']));
        return null;
      } else {
        return jsonDecode(response.body)['error'] ?? 'Error al crear producto';
      }
    } catch (e) {
      return 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> updateProducto({
    required int id,
    required String nombre,
    required double precio,
    String? descripcion,
    String? nombreCategoria,
  }) async {
    if (_authService == null) return 'Servicio no inicializado';
    
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.makeAuthenticatedRequest(
        method: 'PUT',
        url: '${Ruta.productos}$id',
        body: {
          'nombre': nombre,
          'precio': precio,
          'descripcion': descripcion ?? '',
          'nombre_categoria': nombreCategoria ?? '',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final index = _productos.indexWhere((prod) => prod.id == id);
        if (index != -1) {
          _productos[index] = Producto.fromJson(data['producto']);
        }
        return null;
      } else {
        return jsonDecode(response.body)['error'] ?? 'Error al actualizar producto';
      }
    } catch (e) {
      return 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> deleteProducto(int id) async {
    if (_authService == null) return 'Servicio no inicializado';
    
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.makeAuthenticatedRequest(
        method: 'DELETE',
        url: '${Ruta.productos}$id',
      );

      if (response.statusCode == 200) {
        _productos.removeWhere((prod) => prod.id == id);
        return null;
      } else {
        return jsonDecode(response.body)['error'] ?? 'Error al eliminar producto';
      }
    } catch (e) {
      return 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}