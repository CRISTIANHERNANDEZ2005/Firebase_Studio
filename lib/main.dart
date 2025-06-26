import 'package:flutter/material.dart';
// Importa el paquete principal de Flutter que contiene los widgets y herramientas básicas
import 'package:provider/provider.dart';
// Importa el paquete Provider para la gestión del estado de la aplicación

// Importaciones de pantallas/screens
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

// Importaciones de servicios
import 'services/auth_service.dart';
import 'services/categoria_service.dart';
import 'services/producto_service.dart';
import 'services/usuario_service.dart';

void main() {
  // Asegura que Flutter esté inicializado correctamente para web
  // Esto es especialmente importante para plataformas web antes de ejecutar la app
  WidgetsFlutterBinding.ensureInitialized();

  // Opcional: Desactivar la verificación de tipos (solo para desarrollo)
  // Provider.debugCheckInvalidValueType = null;

  // Inicia la aplicación con MultiProvider que permite múltiples proveedores de estado
  runApp(
    MultiProvider(
      providers: [
        // AuthService debe ser el primero ya que otros dependen de él
        // Provee el servicio de autenticación como un ChangeNotifier
        ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),

        // Provee CategoriaService que depende de AuthService
        // ChangeNotifierProxyProvider permite crear un servicio que depende de otro
        ChangeNotifierProxyProvider<AuthService, CategoriaService>(
          create: (_) => CategoriaService(null), // Valor temporal null
          update:
              (_, authService, categoriaService) =>
                  CategoriaService(authService)
                    ..initializeIfNeeded(categoriaService),
          // Actualiza el servicio cuando AuthService cambia
          // El operador .. (cascade) permite llamar a initializeIfNeeded en la misma instancia
        ),

        // Provee ProductoService con la misma lógica que CategoriaService
        ChangeNotifierProxyProvider<AuthService, ProductoService>(
          create: (_) => ProductoService(null), // Valor temporal null
          update:
              (_, authService, productoService) =>
                  ProductoService(authService)
                    ..initializeIfNeeded(productoService),
        ),

        // Provee UsuarioService con la misma lógica que los anteriores
        ChangeNotifierProxyProvider<AuthService, UsuarioService>(
          create: (_) => UsuarioService(null), // Valor temporal null
          update:
              (_, authService, usuarioService) =>
                  UsuarioService(authService)
                    ..initializeIfNeeded(usuarioService),
        ),
      ],
      child: const MyApp(), // Widget raíz de la aplicación
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // desactivar el modo debug (elimina la etiqueta "Debug" en la esquina)
      debugShowCheckedModeBanner: false,
      
      // Ruta inicial cuando se abre la aplicación
      initialRoute: '/login',
      
      // Definición de todas las rutas de la aplicación
      routes: {
        '/login': (context) => const LoginScreen(), // Pantalla de inicio de sesión
        '/register': (context) => const RegisterScreen(), // Pantalla de registro
        '/dashboard': (context) => const DashboardScreen(), // Pantalla principal después del login
        '/categorias': (context) => const CategoriaListaScreen(), // Lista de categorías
        '/categorias/agregar': (context) => const CategoriaAgregarScreen(), // Agregar categoría
        '/categorias/editar': (context) => CategoriaEditarScreen(), // Editar categoría (sin const porque puede recibir parámetros)
        '/productos': (context) => const ProductoListaScreen(), // Lista de productos
        '/productos/agregar': (context) => const ProductoAgregarScreen(), // Agregar producto
        '/productos/editar': (context) => ProductoEditarScreen(), // Editar producto (sin const)
        '/usuarios': (context) => const UsuarioListaScreen(), // Lista de usuarios
        '/usuarios/agregar': (context) => const UsuarioAgregarScreen(), // Agregar usuario
        '/usuarios/editar': (context) => UsuarioEditarScreen(), // Editar usuario (sin const)
      },
      
      // Manejo de rutas no definidas (404)
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