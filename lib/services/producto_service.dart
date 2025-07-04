// Importaciones necesarias
import 'dart:convert'; // Para conversión JSON
import 'package:flutter/material.dart'; // Para ChangeNotifier
import '../utils/ruta.dart'; // Rutas de la API
import '../models/producto.dart'; // Modelo de datos Producto
import 'auth_service.dart'; // Servicio de autenticación
import 'package:flutter/foundation.dart';

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
      final response = await _authService.makeAuthenticatedRequest(
        method: 'GET',
        url: Ruta.productos,
      );

      if (response.statusCode == 200) {
        // 200 = OK
        // Convierte el JSON a objetos Producto
        _productos =
            (jsonDecode(response.body) as List)
                .map((json) => Producto.fromJson(json))
                .toList();
        return null;
      } else {
        return jsonDecode(response.body)['error'] ??
            'Error al obtener productos';
      }
    } catch (e) {
      return 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Crea un nuevo producto
  // Agrega este import al inicio del archivo

  // Modifica el método createProducto
  Future<String?> createProducto({
    required String nombre,
    required double precio,
    String? descripcion,
    int? categoriaId,
  }) async {
    if (_authService == null) return 'Servicio no inicializado';

    _isLoading = true;
    notifyListeners();

    try {
      final body = {
        'nombre': nombre,
        'precio': precio,
        'descripcion': descripcion ?? '',
      };

      if (categoriaId != null) {
        body['categoria'] = {'id': categoriaId, 'ref': 'categorias'};
      }

      debugPrint('Enviando datos para crear producto: $body');

      final response = await _authService.makeAuthenticatedRequest(
        method: 'POST',
        url: Ruta.productos,
        body: body,
      );

      debugPrint(
        'Respuesta del servidor: ${response.statusCode} - ${response.body}',
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final nuevoProducto = Producto.fromJson(data['producto']);
        debugPrint('Producto creado: ${nuevoProducto.toJson()}');
        _productos.add(nuevoProducto);
        return null;
      } else {
        final error =
            jsonDecode(response.body)['error'] ?? 'Error al crear producto';
        debugPrint('Error al crear producto: $error');
        return error;
      }
    } catch (e) {
      debugPrint('Excepción al crear producto: $e');
      return 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Modifica el método updateProducto
  Future<String?> updateProducto({
    required int id,
    required String nombre,
    required double precio,
    String? descripcion,
    int? categoriaId,
  }) async {
    if (_authService == null) return 'Servicio no inicializado';

    _isLoading = true;
    notifyListeners();

    try {
      final body = {
        'nombre': nombre,
        'precio': precio,
        'descripcion': descripcion ?? '',
      };

      // Manejo mejorado de categoría
      if (categoriaId != null) {
        body['categoria'] = {'id': categoriaId};
      }

      debugPrint('Enviando datos para actualizar producto (ID: $id): $body');

      final response = await _authService!.makeAuthenticatedRequest(
        method: 'PUT',
        url: '${Ruta.productos}$id', // Quita la barra final
        body: body,
      );

      debugPrint(
        'Respuesta del servidor: ${response.statusCode} - ${response.body}',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final productoActualizado = Producto.fromJson(data['producto']);
        debugPrint('Producto actualizado: ${productoActualizado.toJson()}');

        final index = _productos.indexWhere((prod) => prod.id == id);
        if (index != -1) {
          _productos[index] = productoActualizado;
        }
        return null;
      } else {
        final error =
            jsonDecode(response.body)['error'] ??
            'Error al actualizar producto';
        debugPrint('Error al actualizar producto: $error');
        return error;
      }
    } catch (e) {
      debugPrint('Excepción al actualizar producto: $e');
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
      final response = await _authService.makeAuthenticatedRequest(
        method: 'DELETE',
        url: '${Ruta.productos}$id',
      );

      if (response.statusCode == 200) {
        // 200 = OK
        // Elimina el producto de la lista local
        _productos.removeWhere((prod) => prod.id == id);
        return null;
      } else {
        return jsonDecode(response.body)['error'] ??
            'Error al eliminar producto';
      }
    } catch (e) {
      return 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
