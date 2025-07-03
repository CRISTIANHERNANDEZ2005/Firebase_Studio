import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/categoria_service.dart';
import '../../utils/validators.dart';
import '../../models/categoria.dart';
import '../../widgets/bezier_container.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/edit_form_container.dart';

// Pantalla para editar categorías existentes
class CategoriaEditarScreen extends StatefulWidget {
  const CategoriaEditarScreen({super.key});

  @override
  _CategoriaEditarScreenState createState() => _CategoriaEditarScreenState();
}

class _CategoriaEditarScreenState extends State<CategoriaEditarScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late Categoria _categoria; // Categoría a editar

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Obtiene la categoría pasada como argumento
    _categoria = ModalRoute.of(context)!.settings.arguments as Categoria;
    // Inicializa el controlador con el valor actual
    _nombreController = TextEditingController(text: _categoria.nombre);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  // Función para guardar cambios
  void _editarCategoria() async {
    if (_formKey.currentState!.validate()) {
      final categoriaService = Provider.of<CategoriaService>(
        context,
        listen: false,
      );

      // Intenta actualizar la categoría
      final error = await categoriaService.updateCategoria(
        _categoria.id, // ID de la categoría existente
        _nombreController.text, // Nuevo nombre
      );

      if (error == null && mounted) {
        // Si es exitoso
        Navigator.pop(context, 'Categoría actualizada correctamente');
      } else if (mounted) {
        // Si hay error
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editar Categoría',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: Colors.white,
        ),
        backgroundColor: theme.primaryColor,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: BezierContainer(color: theme.primaryColor, isTop: true),
          ),
          Positioned(
            top: 10, // Ajusta según la altura del AppBar
            left: 0,
            right: 0,
            bottom: 0,
            child: EditFormContainer(
              // No necesitamos el título aquí ya que está en el AppBar
              title: '',

              isLoading: categoriaService.isLoading,
              onSave: _editarCategoria,
              formFields: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        label: 'Nombre de la categoría',
                        controller:
                            _nombreController, // Controlador con valor inicial
                        validator:
                            (value) =>
                                Validators.validateRequired(value, 'Nombre'),
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
