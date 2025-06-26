import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/usuario_service.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/edit_form_container.dart';

// Pantalla para agregar nuevos usuarios
class UsuarioAgregarScreen extends StatefulWidget {
  const UsuarioAgregarScreen({super.key});

  @override
  _UsuarioAgregarScreenState createState() => _UsuarioAgregarScreenState();
}

class _UsuarioAgregarScreenState extends State<UsuarioAgregarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _numeroController = TextEditingController();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    // Limpiar los controladores al destruir el widget
    _numeroController.dispose();
    _nombreController.dispose();
    _apellidoController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  // Función para enviar los datos del nuevo usuario
  void _agregarUsuario() async {
    if (_formKey.currentState!.validate()) {
      final usuarioService = Provider.of<UsuarioService>(
        context,
        listen: false,
      );
      final error = await usuarioService.createUsuario(
        numero: _numeroController.text,
        nombre: _nombreController.text,
        apellido: _apellidoController.text,
        contrasena: _contrasenaController.text,
      );

      if (error == null && mounted) {
        Navigator.pop(context, 'Usuario creado correctamente');
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
    final usuarioService = Provider.of<UsuarioService>(context);

    return EditFormContainer(
      title: 'Agregar Usuario',
      isLoading: usuarioService.isLoading,
      onSave: _agregarUsuario,
      formFields: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo para número de teléfono
              CustomTextField(
                label: 'Número',
                controller: _numeroController,
                validator: Validators.validateNumero,
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // Campo para nombre
              CustomTextField(
                label: 'Nombre',
                controller: _nombreController,
                validator:
                    (value) => Validators.validateRequired(value, 'Nombre'),
                prefixIcon: Icons.person,
              ),
              const SizedBox(height: 16),

              // Campo para apellido
              CustomTextField(
                label: 'Apellido',
                controller: _apellidoController,
                validator:
                    (value) => Validators.validateRequired(value, 'Apellido'),
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 16),

              // Campo para contraseña con toggle de visibilidad
              CustomTextField(
                label: 'Contraseña',
                controller: _contrasenaController,
                obscureText: _obscurePassword,
                validator: Validators.validatePassword,
                prefixIcon: Icons.lock,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed:
                      () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
