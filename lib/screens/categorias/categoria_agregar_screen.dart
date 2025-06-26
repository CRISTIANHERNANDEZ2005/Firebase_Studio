import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/categoria_service.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/edit_form_container.dart';

// Pantalla para agregar nuevas categorías
class CategoriaAgregarScreen extends StatefulWidget {
  const CategoriaAgregarScreen({super.key});

  @override
  _CategoriaAgregarScreenState createState() => _CategoriaAgregarScreenState();
}

class _CategoriaAgregarScreenState extends State<CategoriaAgregarScreen> {
  // Clave para el formulario
  final _formKey = GlobalKey<FormState>();

  // Controlador para el campo de nombre
  final _nombreController = TextEditingController();

  @override
  void dispose() {
    // Limpieza del controlador
    _nombreController.dispose();
    super.dispose();
  }

  // Función para agregar nueva categoría
  void _agregarCategoria() async {
    if (_formKey.currentState!.validate()) {
      // Valida el formulario
      final categoriaService = Provider.of<CategoriaService>(
        context,
        listen: false,
      );

      // Intenta crear la categoría
      final error = await categoriaService.createCategoria(
        _nombreController.text,
      );

      if (error == null && mounted) {
        // Si es exitoso
        Navigator.pop(
          context,
          'Categoría creada correctamente',
        ); // Cierra con mensaje
      } else if (mounted) {
        // Si hay error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Error desconocido'),
            backgroundColor: Colors.red, // Muestra error en rojo
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriaService = Provider.of<CategoriaService>(context);

    // Usa el contenedor de formulario reutilizable
    return EditFormContainer(
      title: 'Agregar Categoría', // Título específico
      isLoading: categoriaService.isLoading, // Estado de carga
      onSave: _agregarCategoria, // Función al guardar
      formFields: [
        // Campos del formulario
        Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                label: 'Nombre de la categoría',
                controller: _nombreController,
                validator:
                    (value) => Validators.validateRequired(value, 'Nombre'),
                prefixIcon: Icons.category, // Icono descriptivo
              ),
            ],
          ),
        ),
      ],
    );
  }
}
