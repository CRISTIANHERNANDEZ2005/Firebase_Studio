import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/producto_service.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/edit_form_container.dart';

class ProductoAgregarScreen extends StatefulWidget {
  const ProductoAgregarScreen({super.key});

  @override
  _ProductoAgregarScreenState createState() => _ProductoAgregarScreenState();
}

class _ProductoAgregarScreenState extends State<ProductoAgregarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _precioController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _nombreCategoriaController = TextEditingController();

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

  void _agregarProducto() async {
    if (_formKey.currentState!.validate()) {
      final productoService = Provider.of<ProductoService>(
        context,
        listen: false,
      );
      final error = await productoService.createProducto(
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
        Navigator.pop(context, 'Producto creado correctamente');
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
      title: 'Agregar Producto',
      isLoading: productoService.isLoading,
      onSave: _agregarProducto,
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
                minLines: 3,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
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
