import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/categoria_service.dart';
import '../../utils/validators.dart';
import '../../models/categoria.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/edit_form_container.dart';

class CategoriaEditarScreen extends StatefulWidget {
  const CategoriaEditarScreen({super.key});

  @override
  _CategoriaEditarScreenState createState() => _CategoriaEditarScreenState();
}

class _CategoriaEditarScreenState extends State<CategoriaEditarScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late Categoria _categoria;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _categoria = ModalRoute.of(context)!.settings.arguments as Categoria;
    _nombreController = TextEditingController(text: _categoria.nombre);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  void _editarCategoria() async {
    if (_formKey.currentState!.validate()) {
      final categoriaService = Provider.of<CategoriaService>(
        context,
        listen: false,
      );
      final error = await categoriaService.updateCategoria(
        _categoria.id,
        _nombreController.text,
      );

      if (error == null && mounted) {
        Navigator.pop(context, 'Categoría actualizada correctamente');
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
      title: 'Editar Categoría',
      isLoading: categoriaService.isLoading,
      onSave: _editarCategoria,
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
