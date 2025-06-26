import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/producto_service.dart';
import '../../utils/validators.dart';
import '../../models/producto.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/edit_form_container.dart';

class ProductoEditarScreen extends StatefulWidget {
  const ProductoEditarScreen({super.key});

  @override
  _ProductoEditarScreenState createState() => _ProductoEditarScreenState();
}

class _ProductoEditarScreenState extends State<ProductoEditarScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _precioController;
  late TextEditingController _descripcionController;
  late TextEditingController _nombreCategoriaController;
  late Producto _producto;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _producto = ModalRoute.of(context)!.settings.arguments as Producto;
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
    _nombreController.dispose();
    _precioController.dispose();
    _descripcionController.dispose();
    _nombreCategoriaController.dispose();
    super.dispose();
  }

  String? _validatePrecio(String? value) {
    if (value == null || value.isEmpty) return 'Precio es requerido';
    final price = double.tryParse(value);
    if (price == null || price <= 0) return 'Ingrese un precio válido';
    return null;
  }

  void _editarProducto() async {
    if (_formKey.currentState!.validate()) {
      final productoService = Provider.of<ProductoService>(
        context,
        listen: false,
      );
      final error = await productoService.updateProducto(
        id: _producto.id,
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

    return EditFormContainer(
      title: 'Editar Producto',
      isLoading: productoService.isLoading,
      onSave: _editarProducto,
      formFields: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                label: 'Nombre del producto',
                controller: _nombreController,
                validator:
                    (value) => Validators.validateRequired(value, 'Nombre'),
                prefixIcon: Icons.shopping_bag,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Precio',
                controller: _precioController,
                keyboardType: TextInputType.number,
                validator: _validatePrecio,
                prefixIcon: Icons.attach_money,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Descripción (opcional)',
                controller: _descripcionController,
                prefixIcon: Icons.description,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Categoría (opcional)',
                controller: _nombreCategoriaController,
                prefixIcon: Icons.category,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
