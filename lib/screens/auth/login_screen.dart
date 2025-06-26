import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../utils/validators.dart';
import '../../widgets/bezier_container.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _numeroController = TextEditingController();
  final _contrasenaController = TextEditingController();
  bool _obscurePassword = true;
  bool _isHovering = false;

  @override
  void dispose() {
    _numeroController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  String? _validateNumeroWithTimer(String? value) {
    final error = Validators.validateNumero(value);
    if (error != null) {
      Validators.clearErrorAfterDelay(_formKey);
    }
    return error;
  }

  String? _validatePasswordWithTimer(String? value) {
    final error = Validators.validatePassword(value);
    if (error != null) {
      Validators.clearErrorAfterDelay(_formKey);
    }
    return error;
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final authService = Provider.of<AuthService>(context, listen: false);
      final error = await authService.login(
        _numeroController.text,
        _contrasenaController.text,
      );

      if (error == null) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      } else if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: Stack(
        children: [
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
          Center(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal:
                    isDesktop ? MediaQuery.of(context).size.width * 0.1 : 24,
                vertical: 16,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 16),
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
                        Text(
                          'Iniciar Sesión',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              CustomTextField(
                                label: 'Número',
                                controller: _numeroController,
                                validator: _validateNumeroWithTimer,
                                prefixIcon: Icons.phone,
                                keyboardType: TextInputType.phone,
                              ),
                              const SizedBox(height: 16),
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
                              CustomButton(
                                text: 'Iniciar Sesión',
                                onPressed: _login,
                                isLoading: authService.isLoading,
                              ),
                              const SizedBox(height: 16),
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
