import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../utils/validators.dart';
import '../../widgets/bezier_container.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

// Pantalla de inicio de sesión con estado
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Clave global para el formulario (para validación)
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto
  final _numeroController = TextEditingController();
  final _contrasenaController = TextEditingController();

  // Estados internos
  bool _obscurePassword = true; // Controla visibilidad de contraseña
  bool _isHovering = false; // Para efecto hover en botón de registro

  @override
  void dispose() {
    // Limpieza de controladores cuando el widget se destruye
    _numeroController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  // Validador de número con limpieza automática de errores
  String? _validateNumeroWithTimer(String? value) {
    final error = Validators.validateNumero(value);
    if (error != null) {
      Validators.clearErrorAfterDelay(
        _formKey,
      ); // Limpia error después de 4 seg
    }
    return error;
  }

  // Validador de contraseña con limpieza automática de errores
  String? _validatePasswordWithTimer(String? value) {
    final error = Validators.validatePassword(value);
    if (error != null) {
      Validators.clearErrorAfterDelay(
        _formKey,
      ); // Limpia error después de 4 seg
    }
    return error;
  }

  // Función para manejar el login
  void _login() async {
    if (_formKey.currentState!.validate()) {
      // Si el formulario es válido
      final authService = Provider.of<AuthService>(context, listen: false);

      // Intento de login con los datos del formulario
      final error = await authService.login(
        _numeroController.text,
        _contrasenaController.text,
      );

      if (error == null) {
        // Si no hay errores
        if (mounted) {
          // Verifica que el widget esté montado
          Navigator.pushReplacementNamed(
            context,
            '/dashboard',
          ); // Navega al dashboard
        }
      } else if (mounted) {
        // Si hay error y el widget está montado
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error))); // Muestra error
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
          if (isDesktop) ...[
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
          ],

          // Contenido principal centrado
          Center(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(), // Física de scroll
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

                        // Avatar/icono de usuario
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: theme.primaryColor.withOpacity(0.2),
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: theme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Título
                        Text(
                          'Iniciar Sesión',
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

                              // Botón de login
                              CustomButton(
                                text: 'Iniciar Sesión',
                                onPressed: _login,
                                isLoading: authService.isLoading,
                              ),
                              const SizedBox(height: 16),

                              // Enlace a registro con efecto hover
                              MouseRegion(
                                onEnter:
                                    (_) => setState(() => _isHovering = true),
                                onExit:
                                    (_) => setState(() => _isHovering = false),
                                child: TextButton(
                                  onPressed:
                                      () => Navigator.pushNamed(
                                        context,
                                        '/register',
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
                                    '¿No tienes cuenta? Regístrate',
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
