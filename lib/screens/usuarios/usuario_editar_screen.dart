import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/usuario_service.dart';
import '../../utils/validators.dart';
import '../../models/usuario.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/edit_form_container.dart';

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _usuario = ModalRoute.of(context)!.settings.arguments as Usuario;
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

    return EditFormContainer(
      title: 'Editar Usuario',
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
                    (value) => Validators.validateRequired(value, 'Nombre'),
                prefixIcon: Icons.person,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Apellido',
                controller: _apellidoController,
                validator:
                    (value) => Validators.validateRequired(value, 'Apellido'),
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Nueva Contraseña (opcional)',
                controller: _contrasenaController,
                obscureText: true,
                validator:
                    (value) =>
                        value!.isEmpty
                            ? null
                            : Validators.validatePassword(value),
                prefixIcon: Icons.lock,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
