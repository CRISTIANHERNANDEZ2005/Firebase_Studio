import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../utils/validators.dart';
import '../../widgets/bezier_container.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

// Pantalla de registro de nuevos usuarios
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Clave global para el formulario
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos del formulario
  final _numeroController = TextEditingController();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _contrasenaController = TextEditingController();

  // Estados internos
  bool _obscurePassword = true; // Controla visibilidad de contraseña
  bool _isHovering = false; // Para efecto hover en el botón de login

  @override
  void dispose() {
    // Limpieza de controladores al destruir el widget
    _numeroController.dispose();
    _nombreController.dispose();
    _apellidoController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  // Validador de número con limpieza automática de errores
  String? _validateNumeroWithTimer(String? value) {
    final error = Validators.validateNumero(value);
    if (error != null) {
      Validators.clearErrorAfterDelay(_formKey);
    }
    return error;
  }

  // Validador genérico para campos requeridos
  String? _validateRequiredWithTimer(String? value, String fieldName) {
    final error = Validators.validateRequired(value, fieldName);
    if (error != null) {
      Validators.clearErrorAfterDelay(_formKey);
    }
    return error;
  }

  // Validador de contraseña con limpieza automática
  String? _validatePasswordWithTimer(String? value) {
    final error = Validators.validatePassword(value);
    if (error != null) {
      Validators.clearErrorAfterDelay(_formKey);
    }
    return error;
  }

  // Función para manejar el registro
  void _register() async {
    if (_formKey.currentState!.validate()) {
      // Valida el formulario
      try {
        final authService = Provider.of<AuthService>(context, listen: false);

        // Intento de registro
        final error = await authService.register(
          _numeroController.text,
          _nombreController.text,
          _apellidoController.text,
          _contrasenaController.text,
        );

        if (error == null && mounted) {
          // Registro exitoso
          Navigator.pushReplacementNamed(context, '/login'); // Redirige a login
        } else if (mounted) {
          // Error en el registro
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error ?? 'Error desconocido'),
              backgroundColor: Colors.red, // Color rojo para errores
            ),
          );
        }
      } catch (e) {
        // Error de conexión
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error al conectar con el servidor'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtiene instancias necesarias
    final authService = Provider.of<AuthService>(context);
    final theme = Theme.of(context);

    // Detecta si es desktop basado en el ancho de pantalla
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: Stack(
        children: [
          // Fondo decorativo solo para desktop
            Positioned(
              top: 0,
              left: 0,
              child: BezierContainer(color: theme.primaryColor, isTop: true),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: BezierContainer(color: theme.primaryColor),
            ),

          // Contenido principal centrado
          Center(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal:
                    isDesktop
                        ? MediaQuery.of(context).size.width *
                            0.1 // Más ancho en desktop
                        : 24, // Menos ancho en móvil
                vertical: 16,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 500,
                ), // Ancho máximo
                child: Card(
                  elevation: 8, // Sombra pronunciada
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      16,
                    ), // Bordes redondeados
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Ocupa mínimo espacio
                      children: [
                        const SizedBox(height: 16),

                        // Avatar/icono de registro
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: theme.primaryColor.withOpacity(0.2),
                          child: Icon(
                            Icons.person_add, // Icono diferente al login
                            size: 40,
                            color: theme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Título
                        Text(
                          'Registrarse',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Formulario
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Campo de número
                              CustomTextField(
                                label: 'Número',
                                controller: _numeroController,
                                validator: _validateNumeroWithTimer,
                                prefixIcon: Icons.phone,
                                keyboardType: TextInputType.phone,
                              ),
                              const SizedBox(height: 16),

                              // Campo de nombre
                              CustomTextField(
                                label: 'Nombre',
                                controller: _nombreController,
                                validator:
                                    (value) => _validateRequiredWithTimer(
                                      value,
                                      'Nombre',
                                    ),
                                prefixIcon: Icons.person,
                              ),
                              const SizedBox(height: 16),

                              // Campo de apellido
                              CustomTextField(
                                label: 'Apellido',
                                controller: _apellidoController,
                                validator:
                                    (value) => _validateRequiredWithTimer(
                                      value,
                                      'Apellido',
                                    ),
                                prefixIcon: Icons.person_outline,
                              ),
                              const SizedBox(height: 16),

                              // Campo de contraseña
                              CustomTextField(
                                label: 'Contraseña',
                                controller: _contrasenaController,
                                obscureText: _obscurePassword,
                                validator: _validatePasswordWithTimer,
                                prefixIcon: Icons.lock,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Botón de registro
                              CustomButton(
                                text: 'Registrarse',
                                onPressed: _register,
                                isLoading: authService.isLoading,
                              ),
                              const SizedBox(height: 16),

                              // Enlace a login con efecto hover
                              MouseRegion(
                                onEnter:
                                    (_) => setState(() => _isHovering = true),
                                onExit:
                                    (_) => setState(() => _isHovering = false),
                                child: TextButton(
                                  onPressed:
                                      () => Navigator.pushNamed(
                                        context,
                                        '/login',
                                      ),
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        _isHovering
                                            ? theme.primaryColor.withOpacity(
                                              0.8,
                                            )
                                            : theme.primaryColor,
                                  ),
                                  child: Text(
                                    '¿Ya tienes cuenta? Inicia sesión',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
