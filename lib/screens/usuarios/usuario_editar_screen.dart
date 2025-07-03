import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/usuario_service.dart';
import '../../utils/validators.dart';
import '../../widgets/bezier_container.dart';
import '../../models/usuario.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/edit_form_container.dart';

// Pantalla para editar usuarios existentes
class UsuarioEditarScreen extends StatefulWidget {
  const UsuarioEditarScreen({super.key});

  @override
  _UsuarioEditarScreenState createState() => _UsuarioEditarScreenState();
}

class _UsuarioEditarScreenState extends State<UsuarioEditarScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _numeroController;
  late TextEditingController _nombreController;
  late TextEditingController _apellidoController;
  late TextEditingController _contrasenaController;
  late Usuario _usuario;
  bool _obscurePassword = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Obtener el usuario pasado como argumento
    _usuario = ModalRoute.of(context)!.settings.arguments as Usuario;
    // Inicializar controladores con los valores actuales del usuario
    _numeroController = TextEditingController(text: _usuario.numero);
    _nombreController = TextEditingController(text: _usuario.nombre);
    _apellidoController = TextEditingController(text: _usuario.apellido);
    _contrasenaController = TextEditingController();
  }

  @override
  void dispose() {
    _numeroController.dispose();
    _nombreController.dispose();
    _apellidoController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  // Función para actualizar los datos del usuario
  void _editarUsuario() async {
    if (_formKey.currentState!.validate()) {
      final usuarioService = Provider.of<UsuarioService>(
        context,
        listen: false,
      );
      final error = await usuarioService.updateUsuario(
        id: _usuario.id,
        numero: _numeroController.text,
        nombre: _nombreController.text,
        apellido: _apellidoController.text,
        contrasena:
            _contrasenaController.text.isEmpty
                ? null
                : _contrasenaController.text,
      );

      if (error == null && mounted) {
        Navigator.pop(context, 'Usuario actualizado correctamente');
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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editar Usuario',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: Colors.white,
        ),
        backgroundColor: Colors.orange,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: BezierContainer(color: Colors.orange, isTop: true),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: EditFormContainer(
              title: 'Editar Usuario', // Título diferente
              isLoading: usuarioService.isLoading,
              onSave: _editarUsuario,
              formFields: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        label: 'Número',
                        controller: _numeroController,
                        validator: Validators.validateNumero,
                        prefixIcon: Icons.phone,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        label: 'Nombre',
                        controller: _nombreController,
                        validator:
                            (value) =>
                                Validators.validateRequired(value, 'Nombre'),
                        prefixIcon: Icons.person,
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        label: 'Apellido',
                        controller: _apellidoController,
                        validator:
                            (value) =>
                                Validators.validateRequired(value, 'Apellido'),
                        prefixIcon: Icons.person_outline,
                      ),
                      const SizedBox(height: 16),

                      // Campo opcional para cambiar contraseña
                      CustomTextField(
                        label: 'Nueva Contraseña (opcional)',
                        controller: _contrasenaController,
                        obscureText: _obscurePassword,
                        validator:
                            (value) =>
                                value!.isEmpty
                                    ? null
                                    : Validators.validatePassword(value),
                        prefixIcon: Icons.lock,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed:
                              () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                        ),
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
