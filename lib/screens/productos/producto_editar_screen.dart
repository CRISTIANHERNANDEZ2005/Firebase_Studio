import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/producto_service.dart';
import '../../utils/validators.dart';
import '../../models/producto.dart';
import '../../widgets/bezier_container.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/edit_form_container.dart';

// Pantalla para editar productos existentes
class ProductoEditarScreen extends StatefulWidget {
  const ProductoEditarScreen({super.key});

  @override
  _ProductoEditarScreenState createState() => _ProductoEditarScreenState();
}

class _ProductoEditarScreenState extends State<ProductoEditarScreen> {
  final _formKey = GlobalKey<FormState>();
  // Controladores para los campos
  late TextEditingController _nombreController;
  late TextEditingController _precioController;
  late TextEditingController _descripcionController;
  late TextEditingController _nombreCategoriaController;
  late Producto _producto; // Producto a editar

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Obtiene el producto pasado como argumento
    _producto = ModalRoute.of(context)!.settings.arguments as Producto;
    // Inicializa los controladores con los valores actuales del producto
    _nombreController = TextEditingController(text: _producto.nombre);
    _precioController = TextEditingController(
      text: _producto.precio.toString(),
    );
    _descripcionController = TextEditingController(text: _producto.descripcion);
    _nombreCategoriaController = TextEditingController(
      text: _producto.nombreCategoria,
    );
  }

  @override
  void dispose() {
    // Limpieza de controladores
    _nombreController.dispose();
    _precioController.dispose();
    _descripcionController.dispose();
    _nombreCategoriaController.dispose();
    super.dispose();
  }

  // Validador personalizado para precio (igual que en agregar)
  String? _validatePrecio(String? value) {
    if (value == null || value.isEmpty) return 'Precio es requerido';
    final price = double.tryParse(value);
    if (price == null || price <= 0) return 'Ingrese un precio válido';
    return null;
  }

  // Función para actualizar el producto
  void _editarProducto() async {
    if (_formKey.currentState!.validate()) {
      final productoService = Provider.of<ProductoService>(
        context,
        listen: false,
      );

      // Llama al servicio para actualizar
      final error = await productoService.updateProducto(
        id: _producto.id, // ID del producto existente
        nombre: _nombreController.text,
        precio: double.parse(_precioController.text),
        descripcion:
            _descripcionController.text.isEmpty
                ? null
                : _descripcionController.text,
        nombreCategoria:
            _nombreCategoriaController.text.isEmpty
                ? null
                : _nombreCategoriaController.text,
      );

      // Manejo de resultados
      if (error == null && mounted) {
        Navigator.pop(context, 'Producto actualizado correctamente');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Error desconocido'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final productoService = Provider.of<ProductoService>(context);

    // Usa el mismo contenedor de formulario reutilizable
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editar Producto',
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
            top: 10,
            left: 0,
            right: 0,
            bottom: 0,
            child: EditFormContainer(
              title: 'Editar Producto', // Título diferente
              isLoading: productoService.isLoading,
              onSave: _editarProducto,
              formFields: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Campo de nombre (pre-llenado)
                      CustomTextField(
                        label: 'Nombre del producto',
                        controller: _nombreController,
                        validator:
                            (value) =>
                                Validators.validateRequired(value, 'Nombre'),
                        prefixIcon: Icons.shopping_bag,
                      ),
                      const SizedBox(height: 16),

                      // Campo de precio (pre-llenado)
                      CustomTextField(
                        label: 'Precio',
                        controller: _precioController,
                        keyboardType: TextInputType.number,
                        validator: _validatePrecio,
                        prefixIcon: Icons.attach_money,
                      ),
                      const SizedBox(height: 16),

                      // Campo de descripción (pre-llenado)
                      CustomTextField(
                        label: 'Descripción (opcional)',
                        controller: _descripcionController,
                        prefixIcon: Icons.description,
                        maxLines: 3, // Más compacto que en agregar
                      ),
                      const SizedBox(height: 16),

                      // Campo de categoría (pre-llenado)
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
