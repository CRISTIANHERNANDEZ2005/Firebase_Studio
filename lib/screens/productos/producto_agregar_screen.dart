import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/producto_service.dart';
import '../../widgets/bezier_container.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/edit_form_container.dart';

// Pantalla para agregar nuevos productos al sistema
class ProductoAgregarScreen extends StatefulWidget {
  const ProductoAgregarScreen({super.key});

  @override
  _ProductoAgregarScreenState createState() => _ProductoAgregarScreenState();
}

class _ProductoAgregarScreenState extends State<ProductoAgregarScreen> {
  // Clave global para validación del formulario
  final _formKey = GlobalKey<FormState>();

  // Controladores para cada campo del formulario
  final _nombreController =
      TextEditingController(); // Controla el campo de nombre
  final _precioController =
      TextEditingController(); // Controla el campo de precio
  final _descripcionController =
      TextEditingController(); // Controla descripción
  final _nombreCategoriaController =
      TextEditingController(); // Controla categoría

  @override
  void dispose() {
    // Limpieza de todos los controladores al destruir el widget
    _nombreController.dispose();
    _precioController.dispose();
    _descripcionController.dispose();
    _nombreCategoriaController.dispose();
    super.dispose();
  }

  // Validador personalizado para el campo de precio
  String? _validatePrecio(String? value) {
    if (value == null || value.isEmpty) {
      return 'Precio es requerido'; // Validación de campo requerido
    }
    final price = double.tryParse(value); // Intenta convertir a double
    if (price == null || price <= 0) {
      return 'Ingrese un precio válido'; // Debe ser número positivo
    }
    return null; // Retorna null si es válido
  }

  // Función para agregar un nuevo producto
  void _agregarProducto() async {
    if (_formKey.currentState!.validate()) {
      // Primero valida el formulario
      final productoService = Provider.of<ProductoService>(
        context,
        listen: false,
      );

      // Llama al servicio para crear el producto
      final error = await productoService.createProducto(
        nombre: _nombreController.text, // Nombre del producto (requerido)
        precio: double.parse(
          _precioController.text,
        ), // Precio convertido a double
        descripcion:
            _descripcionController.text.isEmpty
                ? null // Descripción opcional
                : _descripcionController.text,
        nombreCategoria:
            _nombreCategoriaController.text.isEmpty
                ? null // Categoría opcional
                : _nombreCategoriaController.text,
      );

      // Manejo de resultados
      if (error == null && mounted) {
        // Si no hay errores
        Navigator.pop(
          context,
          'Producto creado correctamente',
        ); // Cierra con mensaje de éxito
      } else if (mounted) {
        // Si hay error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Error desconocido'), // Muestra error
            backgroundColor: Colors.red, // Color rojo para errores
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final productoService = Provider.of<ProductoService>(
      context,
    ); // Accede al servicio

    // Usa el contenedor de formulario reutilizable
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Agregar Producto',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: Colors.white,
        ),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: BezierContainer(color: Colors.green, isTop: true),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: EditFormContainer(
              title: 'Agregar Producto', // Título específico
              isLoading: productoService.isLoading, // Estado de carga
              onSave: _agregarProducto, // Función al guardar
              formFields: [
                // Lista de campos del formulario
                Form(
                  key: _formKey, // Asigna la clave del formulario
                  child: Column(
                    children: [
                      // Campo para nombre del producto
                      CustomTextField(
                        label: 'Nombre del producto',
                        controller: _nombreController,
                        validator:
                            (value) =>
                                Validators.validateRequired(value, 'Nombre'),
                        prefixIcon: Icons.shopping_bag, // Icono descriptivo
                      ),
                      const SizedBox(height: 16), // Espaciado
                      // Campo para precio del producto
                      CustomTextField(
                        label: 'Precio',
                        controller: _precioController,
                        keyboardType: TextInputType.number, // Teclado numérico
                        validator: _validatePrecio, // Validador personalizado
                        prefixIcon: Icons.attach_money, // Icono de dinero
                      ),
                      const SizedBox(height: 16),

                      // Campo para descripción (opcional)
                      CustomTextField(
                        label: 'Descripción (opcional)',
                        controller: _descripcionController,
                        prefixIcon: Icons.description,
                        minLines: 3, // Altura mínima
                        maxLines: 5, // Altura máxima (permite scroll)
                        keyboardType:
                            TextInputType.multiline, // Teclado multilínea
                      ),
                      const SizedBox(height: 16),

                      // Campo para categoría (opcional)
                      CustomTextField(
                        label: 'Categoría (opcional)',
                        controller: _nombreCategoriaController,
                        prefixIcon: Icons.category,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
