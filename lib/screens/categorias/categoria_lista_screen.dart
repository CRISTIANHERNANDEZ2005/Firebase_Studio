import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/categoria_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/message_toast.dart';
import '../../widgets/list_item_card.dart';
import '../../widgets/bezier_container.dart';

class CategoriaListaScreen extends StatefulWidget {
  const CategoriaListaScreen({super.key});

  @override
  _CategoriaListaScreenState createState() => _CategoriaListaScreenState();
}

class _CategoriaListaScreenState extends State<CategoriaListaScreen> {
  String? _successMessage;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCategorias();
    });
  }

  Future<void> _loadCategorias() async {
    final categoriaService = Provider.of<CategoriaService>(
      context,
      listen: false,
    );
    final error = await categoriaService.fetchCategorias();
    if (error != null && mounted) {
      _showErrorMessage(error);
    }
  }

  void _showSuccessMessage(String message) {
    setState(() {
      _successMessage = message;
      _errorMessage = null;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _successMessage = null;
        });
      }
    });
  }

  void _showErrorMessage(String message) {
    setState(() {
      _errorMessage = message;
      _successMessage = null;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _errorMessage = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoriaService = Provider.of<CategoriaService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // Fondo decorativo
          Positioned(
            top: 0,
            left: 0,
            child: BezierContainer(color: theme.primaryColor, isTop: true),
          ),

          // Contenido principal
          SafeArea(
            child: Column(
              children: [
                // AppBar personalizado
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Categorías',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
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

                // Lista de categorías
                Expanded(child: _buildMainContent(categoriaService, theme)),
              ],
            ),
          ),

          // Mensajes flotantes
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final result = await Navigator.pushNamed(
            context,
            '/categorias/agregar',
          );
          if (result != null && mounted) {
            _showSuccessMessage(result as String);
            _loadCategorias();
          }
        },
      ),
    );
  }

  Widget _buildMainContent(CategoriaService categoriaService, ThemeData theme) {
    if (categoriaService.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (categoriaService.categorias.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category, size: 48, color: theme.primaryColor),
            const SizedBox(height: 16),
            Text(
              'No hay categorías registradas',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Presiona el botón + para agregar una',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadCategorias,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: categoriaService.categorias.length,
        itemBuilder: (context, index) {
          final categoria = categoriaService.categorias[index];
          return ListItemCard(
            title: categoria.nombre,
            subtitle: 'ID: ${categoria.id}',
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.category, color: theme.primaryColor),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.edit, color: theme.primaryColor),
                onPressed: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    '/categorias/editar',
                    arguments: categoria,
                  );
                  if (result != null && mounted) {
                    _showSuccessMessage(result as String);
                    _loadCategorias();
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirmar eliminación'),
                      content: const Text(
                        '¿Estás seguro de eliminar esta categoría?',
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
                    final error = await categoriaService.deleteCategoria(
                      categoria.id,
                    );
                    if (error != null) {
                      _showErrorMessage(error);
                    } else {
                      _showSuccessMessage('Categoría eliminada correctamente');
                      _loadCategorias();
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