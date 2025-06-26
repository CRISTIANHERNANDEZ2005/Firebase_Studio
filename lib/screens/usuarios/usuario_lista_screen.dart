import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/usuario_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/message_toast.dart';
import '../../widgets/list_item_card.dart';
import '../../widgets/bezier_container.dart';

// Pantalla que muestra la lista de usuarios registrados
class UsuarioListaScreen extends StatefulWidget {
  const UsuarioListaScreen({super.key});

  @override
  _UsuarioListaScreenState createState() => _UsuarioListaScreenState();
}

class _UsuarioListaScreenState extends State<UsuarioListaScreen> {
  String? _successMessage; // Mensaje de éxito
  String? _errorMessage; // Mensaje de error

  @override
  void initState() {
    super.initState();
    // Cargar usuarios después de que la interfaz se haya construido
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUsuarios();
    });
  }

  // Carga los usuarios desde el servicio
  Future<void> _loadUsuarios() async {
    final usuarioService = Provider.of<UsuarioService>(context, listen: false);
    final error = await usuarioService.fetchUsuarios();
    if (error != null && mounted) {
      _showErrorMessage(error);
    }
  }

  // Muestra un mensaje de éxito temporal
  void _showSuccessMessage(String message) {
    setState(() {
      _successMessage = message;
      _errorMessage = null;
    });
    // Oculta el mensaje después de 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _successMessage = null);
    });
  }

  // Muestra un mensaje de error temporal
  void _showErrorMessage(String message) {
    setState(() {
      _errorMessage = message;
      _successMessage = null;
    });
    // Oculta el mensaje después de 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _errorMessage = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final usuarioService = Provider.of<UsuarioService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // Fondo decorativo naranja (tema usuarios)
          Positioned(
            top: 0,
            left: 0,
            child: BezierContainer(color: Colors.orange, isTop: true),
          ),

          // Contenido principal dentro del área segura
          SafeArea(
            child: Column(
              children: [
                // Barra superior personalizada
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Botón para volver atrás
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      // Título de la pantalla
                      Text(
                        'Usuarios',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      // Botón para cerrar sesión
                      IconButton(
                        icon: const Icon(Icons.logout),
                        tooltip: 'Cerrar sesión',
                        onPressed: () async {
                          await authService.logout();
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                      ),
                    ],
                  ),
                ),

                // Lista de usuarios (contenido principal)
                Expanded(child: _buildMainContent(usuarioService, theme)),
              ],
            ),
          ),

          // Mensajes flotantes (éxito/error)
          if (_successMessage != null)
            Positioned(
              top: 16,
              left: 0,
              right: 0,
              child: Center(
                child: MessageToast(
                  message: _successMessage!,
                  backgroundColor: Colors.green,
                  icon: Icons.check_circle,
                ),
              ),
            ),

          if (_errorMessage != null)
            Positioned(
              top: 16,
              left: 0,
              right: 0,
              child: Center(
                child: MessageToast(
                  message: _errorMessage!,
                  backgroundColor: Colors.red,
                  icon: Icons.error,
                ),
              ),
            ),
        ],
      ),
      // Botón flotante para agregar nuevos usuarios
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final result = await Navigator.pushNamed(
            context,
            '/usuarios/agregar',
          );
          if (result != null && mounted) {
            _showSuccessMessage(result as String);
            _loadUsuarios();
          }
        },
      ),
    );
  }

  // Construye el contenido principal según el estado
  Widget _buildMainContent(UsuarioService usuarioService, ThemeData theme) {
    // Mostrar indicador de carga si está cargando
    if (usuarioService.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Mostrar mensaje si no hay usuarios
    if (usuarioService.usuarios.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people, size: 48, color: Colors.orange),
            const SizedBox(height: 16),
            Text(
              'No hay usuarios registrados',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Presiona el botón + para agregar uno',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      );
    }

    // Lista de usuarios con capacidad de "pull to refresh"
    return RefreshIndicator(
      onRefresh: _loadUsuarios,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80), // Espacio para el FAB
        itemCount: usuarioService.usuarios.length,
        itemBuilder: (context, index) {
          final usuario = usuarioService.usuarios[index];
          return ListItemCard(
            title: '${usuario.nombre} ${usuario.apellido}',
            subtitle: 'Número: ${usuario.numero}\nID: ${usuario.id}',
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, color: Colors.orange),
            ),
            actions: [
              // Botón para editar usuario
              IconButton(
                icon: Icon(Icons.edit, color: Colors.orange),
                onPressed: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    '/usuarios/editar',
                    arguments: usuario,
                  );
                  if (result != null && mounted) {
                    _showSuccessMessage(result as String);
                    _loadUsuarios();
                  }
                },
              ),
              // Botón para eliminar usuario
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('Confirmar eliminación'),
                          content: const Text(
                            '¿Estás seguro de eliminar este usuario?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text(
                                'Eliminar',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                  );

                  if (confirm == true && mounted) {
                    final error = await usuarioService.deleteUsuario(
                      usuario.id,
                    );
                    if (error != null) {
                      _showErrorMessage(error);
                    } else {
                      _showSuccessMessage('Usuario eliminado correctamente');
                      _loadUsuarios();
                    }
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
