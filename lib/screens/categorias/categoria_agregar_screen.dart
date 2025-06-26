import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/categoria_service.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/edit_form_container.dart';

class CategoriaAgregarScreen extends StatefulWidget {
  const CategoriaAgregarScreen({super.key});

  @override
  _CategoriaAgregarScreenState createState() => _CategoriaAgregarScreenState();
}

class _CategoriaAgregarScreenState extends State<CategoriaAgregarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  void _agregarCategoria() async {
    if (_formKey.currentState!.validate()) {
      final categoriaService = Provider.of<CategoriaService>(
        context,
        listen: false,
      );
      final error = await categoriaService.createCategoria(
        _nombreController.text,
      );

      if (error == null && mounted) {
        Navigator.pop(context, 'Categoría creada correctamente');
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
    final categoriaService = Provider.of<CategoriaService>(context);

    return EditFormContainer(
      title: 'Agregar Categoría',
      isLoading: categoriaService.isLoading,
      onSave: _agregarCategoria,
      formFields: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                label: 'Nombre de la categoría',
                controller: _nombreController,
                validator:
                    (value) => Validators.validateRequired(value, 'Nombre'),
                prefixIcon: Icons.category,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
