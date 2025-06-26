// Importaciones necesarias
import 'dart:convert'; // Para conversión JSON
import 'package:flutter/material.dart'; // Para ChangeNotifier
import '../utils/ruta.dart'; // Rutas de la API
import '../models/producto.dart'; // Modelo de datos Producto
import 'auth_service.dart'; // Servicio de autenticación

// Servicio para gestión de productos con notificación de cambios
class ProductoService with ChangeNotifier {
  // Variables de estado privadas
  List<Producto> _productos = []; // Lista interna de productos
  bool _isLoading = false; // Indicador de carga
  final AuthService? _authService; // Dependencia del servicio de autenticación

  // Getters públicos para acceder al estado
  List<Producto> get productos => _productos; // Obtener lista de productos
  bool get isLoading => _isLoading; // Obtener estado de carga

  // Constructor que recibe el servicio de autenticación
  ProductoService(this._authService);

  // Inicializa el servicio con datos existentes (para MultiProvider)
  void initializeIfNeeded(ProductoService? existingService) {
    if (existingService != null) {
      _productos = existingService._productos; // Copia la lista de productos
      _isLoading = existingService._isLoading; // Copia el estado de carga
    }
  }

  // Obtiene todos los productos desde la API
  Future<String?> fetchProductos() async {
    if (_authService == null) return 'Servicio no inicializado';
    
    _isLoading = true;
    notifyListeners();

    try {
      // Realiza petición GET autenticada
      final response = await _authService!.makeAuthenticatedRequest(
        method: 'GET',
        url: Ruta.productos,
      );

      if (response.statusCode == 200) { // 200 = OK
        // Convierte el JSON a objetos Producto
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

  // Crea un nuevo producto
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
      // Petición POST con los datos del producto
      final response = await _authService!.makeAuthenticatedRequest(
        method: 'POST',
        url: Ruta.productos,
        body: {
          'nombre': nombre,
          'precio': precio,
          'descripcion': descripcion ?? '', // Valor por defecto si es null
          'nombre_categoria': nombreCategoria ?? '', // Valor por defecto si es null
        },
      );

      if (response.statusCode == 201) { // 201 = Created
        final data = jsonDecode(response.body);
        // Agrega el nuevo producto a la lista local
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

  // Actualiza un producto existente
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
      // Petición PUT con los datos actualizados
      final response = await _authService!.makeAuthenticatedRequest(
        method: 'PUT',
        url: '${Ruta.productos}$id',
        body: {
          'nombre': nombre,
          'precio': precio,
          'descripcion': descripcion ?? '',
          'nombre_categoria': nombreCategoria ?? '',
        },
      );

      if (response.statusCode == 200) { // 200 = OK
        final data = jsonDecode(response.body);
        // Busca y actualiza el producto en la lista local
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

  // Elimina un producto
  Future<String?> deleteProducto(int id) async {
    if (_authService == null) return 'Servicio no inicializado';
    
    _isLoading = true;
    notifyListeners();

    try {
      // Petición DELETE para eliminar
      final response = await _authService!.makeAuthenticatedRequest(
        method: 'DELETE',
        url: '${Ruta.productos}$id',
      );

      if (response.statusCode == 200) { // 200 = OK
        // Elimina el producto de la lista local
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