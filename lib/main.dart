import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/categorias/categoria_lista_screen.dart';
import 'screens/categorias/categoria_agregar_screen.dart';
import 'screens/categorias/categoria_editar_screen.dart';
import 'screens/productos/producto_lista_screen.dart';
import 'screens/productos/producto_agregar_screen.dart';
import 'screens/productos/producto_editar_screen.dart';
import 'screens/usuarios/usuario_lista_screen.dart';
import 'screens/usuarios/usuario_agregar_screen.dart';
import 'screens/usuarios/usuario_editar_screen.dart';
import 'services/auth_service.dart';
import 'services/categoria_service.dart';
import 'services/producto_service.dart';
import 'services/usuario_service.dart';

void main() {
  // Asegura que Flutter esté inicializado correctamente para web
  WidgetsFlutterBinding.ensureInitialized();

  // Opcional: Desactivar la verificación de tipos (solo para desarrollo)
  // Provider.debugCheckInvalidValueType = null;

  runApp(
    MultiProvider(
      providers: [
        // AuthService debe ser el primero ya que otros dependen de él
        ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),

        // Usa ChangeNotifierProxyProvider para servicios que son ChangeNotifiers
        ChangeNotifierProxyProvider<AuthService, CategoriaService>(
          create: (_) => CategoriaService(null), // Valor temporal
          update:
              (_, authService, categoriaService) =>
                  CategoriaService(authService)
                    ..initializeIfNeeded(categoriaService),
        ),
        ChangeNotifierProxyProvider<AuthService, ProductoService>(
          create: (_) => ProductoService(null), // Valor temporal
          update:
              (_, authService, productoService) =>
                  ProductoService(authService)
                    ..initializeIfNeeded(productoService),
        ),
        ChangeNotifierProxyProvider<AuthService, UsuarioService>(
          create: (_) => UsuarioService(null), // Valor temporal
          update:
              (_, authService, usuarioService) =>
                  UsuarioService(authService)
                    ..initializeIfNeeded(usuarioService),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // desactivar el modo debug
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/categorias': (context) => const CategoriaListaScreen(),
        '/categorias/agregar': (context) => const CategoriaAgregarScreen(),
        '/categorias/editar': (context) => CategoriaEditarScreen(),
        '/productos': (context) => const ProductoListaScreen(),
        '/productos/agregar': (context) => const ProductoAgregarScreen(),
        '/productos/editar': (context) => ProductoEditarScreen(),
        '/usuarios': (context) => const UsuarioListaScreen(),
        '/usuarios/agregar': (context) => const UsuarioAgregarScreen(),
        '/usuarios/editar': (context) => UsuarioEditarScreen(),
      },
      // Manejo de rutas no definidas
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder:
              (context) => Scaffold(
                appBar: AppBar(title: const Text('Error')),
                body: Center(
                  child: Text('Ruta no encontrada: ${settings.name}'),
                ),
              ),
        );
      },
    );
  }
}
