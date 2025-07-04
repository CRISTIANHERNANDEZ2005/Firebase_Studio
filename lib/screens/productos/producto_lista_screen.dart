import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/producto_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/message_toast.dart';
import '../../widgets/list_item_card.dart';
import '../../widgets/bezier_container.dart';

// Pantalla que muestra la lista de productos
class ProductoListaScreen extends StatefulWidget {
  const ProductoListaScreen({super.key});

  @override
  _ProductoListaScreenState createState() => _ProductoListaScreenState();
}

class _ProductoListaScreenState extends State<ProductoListaScreen> {
  // Mensajes para mostrar al usuario
  String? _successMessage;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Cargar los productos después de que el widget se inicialice
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProductos();
    });
  }

  // Función para cargar productos desde el servicio
  Future<void> _loadProductos() async {
    final productoService = Provider.of<ProductoService>(
      context,
      listen: false,
    );
    final error = await productoService.fetchProductos();
    if (error != null && mounted) {
      _showErrorMessage(error);
    }
  }

  // Mostrar mensaje de éxito temporal
  void _showSuccessMessage(String message) {
    setState(() {
      _successMessage = message;
      _errorMessage = null;
    });
    // Ocultar después de 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _successMessage = null;
        });
      }
    });
  }

  // Mostrar mensaje de error temporal
  void _showErrorMessage(String message) {
    setState(() {
      _errorMessage = message;
      _successMessage = null;
    });
    // Ocultar después de 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _errorMessage = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obtener servicios y tema actual
    final productoService = Provider.of<ProductoService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // Fondo decorativo con forma curva
          Positioned(
            top: 0,
            left: 0,
            child: BezierContainer(
              color: Colors.green, // Color verde para productos
              isTop: true,
            ),
          ),

          // Contenido principal seguro para áreas notables
          SafeArea(
            child: Column(
              children: [
                // Barra superior personalizada
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Botón para volver atrás
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      // Título de la pantalla
                      Text(
                        'Productos',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      // Botón para cerrar sesión
                      IconButton(
                        icon: const Icon(Icons.logout),
                        tooltip: 'Cerrar sesión',
                        onPressed: () async {
                          await authService.logout();
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                      ),
                    ],
                  ),
                ),

                // Contenido principal (lista de productos)
                Expanded(child: _buildMainContent(productoService, theme)),
              ],
            ),
          ),

          // Mensajes flotantes de éxito/error
          if (_successMessage != null)
            Positioned(
              top: 16,
              left: 0,
              right: 0,
              child: Center(
                child: MessageToast(
                  message: _successMessage!,
                  backgroundColor: Colors.green,
                  icon: Icons.check_circle,
                ),
              ),
            ),

          if (_errorMessage != null)
            Positioned(
              top: 16,
              left: 0,
              right: 0,
              child: Center(
                child: MessageToast(
                  message: _errorMessage!,
                  backgroundColor: Colors.red,
                  icon: Icons.error,
                ),
              ),
            ),
        ],
      ),
      // Botón flotante para agregar nuevos productos
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final result = await Navigator.pushNamed(
            context,
            '/productos/agregar',
          );
          if (result != null && mounted) {
            _showSuccessMessage(result as String);
            _loadProductos();
          }
        },
      ),
    );
  }

  // Construye el contenido principal según el estado
  Widget _buildMainContent(ProductoService productoService, ThemeData theme) {
    // Mostrar carga si está cargando
    if (productoService.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Mostrar mensaje si no hay productos
    if (productoService.productos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag, size: 48, color: Colors.green),
            const SizedBox(height: 16),
            Text(
              'No hay productos registrados',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Presiona el botón + para agregar uno',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      );
    }

    // Lista de productos con capacidad de refrescar
    return RefreshIndicator(
      onRefresh: _loadProductos,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: productoService.productos.length,
        itemBuilder: (context, index) {
          final producto = productoService.productos[index];
          return ListItemCard(
            title: producto.nombre,
            subtitle: 'Precio: \$${producto.precio.toStringAsFixed(2)}\n'
                'Categoría: ${producto.nombreCategoria ?? 'Sin categoría'}${producto.descripcion != null && producto.descripcion!.isNotEmpty ? '\n${producto.descripcion}' : ''}',





            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.shopping_bag, color: Colors.green),
            ),
            // Botones de acción para cada producto
            actions: [
              // Botón para editar
              IconButton(
                icon: Icon(Icons.edit, color: Colors.green),
                onPressed: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    '/productos/editar',
                    arguments: producto,
                  );
                  if (result != null && mounted) {
                    _showSuccessMessage(result as String);
                    _loadProductos();
                  }
                },
              ),
              // Botón para eliminar
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  // Confirmación antes de eliminar
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('Confirmar eliminación'),
                          content: const Text(
                            '¿Estás seguro de eliminar este producto?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text(
                                'Eliminar',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                  );

                  if (confirm == true && mounted) {
                    final error = await productoService.deleteProducto(
                      producto.id,
                    );
                    if (error != null) {
                      _showErrorMessage(error);
                    } else {
                      _showSuccessMessage('Producto eliminado correctamente');
                      _loadProductos();
                    }
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
