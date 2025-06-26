import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../widgets/dashboard_button.dart';
import '../widgets/bezier_container.dart';

// Pantalla principal del dashboard (escritorio de control)
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener el servicio de autenticación para manejar el logout
    final authService = Provider.of<AuthService>(context);

    // Obtener el tema actual (aunque no se usa directamente aquí)
    Theme.of(context);

    // Detectar si estamos en un dispositivo de escritorio (ancho > 600px)
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: Stack(
        children: [
          // --------------------------------------------
          // SECCIÓN 1: FONDOS DECORATIVOS CON FORMA CURVA
          // --------------------------------------------

          // Curva superior izquierda (color azul)
          Positioned(
            top: 0,
            left: 0,
            child: BezierContainer(color: Colors.blue, isTop: true),
          ),

          // Curva inferior derecha (color verde)
          Positioned(
            bottom: 0,
            right: 0,
            child: BezierContainer(color: Colors.green),
          ),

          // --------------------------------------------
          // SECCIÓN 2: CONTENIDO PRINCIPAL
          // --------------------------------------------
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ----------------------
                  // FILA SUPERIOR (Header)
                  // ----------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Títulos de bienvenida
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título principal
                          Text(
                            'Bienvenido',
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color:
                                  Colors.white, // Texto blanco para contraste
                            ),
                          ),

                          // Subtítulo
                          Text(
                            'Gestión Comercial',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              // ignore: deprecated_member_use
                              color: Colors.white.withOpacity(
                                0.9,
                              ), // Blanco semi-transparente
                            ),
                          ),
                        ],
                      ),

                      // Botón de logout (icono de salida)
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        onPressed: () async {
                          await authService.logout();
                          // Redirigir al login después de cerrar sesión
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                      ),
                    ],
                  ),

                  // Espaciador vertical
                  const SizedBox(height: 40),

                  // --------------------------
                  // SECCIÓN DE BOTONES PRINCIPALES
                  // --------------------------
                  Expanded(
                    child: GridView.count(
                      // Configuración responsive: 3 columnas en desktop, 2 en móvil
                      crossAxisCount: isDesktop ? 3 : 2,

                      // Espaciado entre elementos
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 24,

                      // Relación de aspecto cuadrada (1:1)
                      childAspectRatio: 1,

                      // Padding horizontal mínimo
                      padding: const EdgeInsets.symmetric(horizontal: 8),

                      // Lista de botones del dashboard
                      children: [
                        // Botón 1: Categorías
                        DashboardButton(
                          text: 'Categorías',
                          icon: Icons.category_rounded,
                          onPressed:
                              () => Navigator.pushNamed(context, '/categorias'),
                          color: Colors.blue, // Color temático azul
                        ),

                        // Botón 2: Productos
                        DashboardButton(
                          text: 'Productos',
                          icon: Icons.shopping_bag_rounded,
                          onPressed:
                              () => Navigator.pushNamed(context, '/productos'),
                          color: Colors.green, // Color temático verde
                        ),

                        // Botón 3: Usuarios
                        DashboardButton(
                          text: 'Usuarios',
                          icon: Icons.people_alt_rounded,
                          onPressed:
                              () => Navigator.pushNamed(context, '/usuarios'),
                          color: Colors.orange, // Color temático naranja
                        ),

                        // Los siguientes botones solo se muestran en desktop
                        if (isDesktop) ...[
                          // Botón 4: Reportes (solo desktop)
                          DashboardButton(
                            text: 'Reportes',
                            icon: Icons.analytics_rounded,
                            onPressed:
                                () {}, // Función pendiente de implementar
                            color: Colors.purple,
                          ),

                          // Botón 5: Configuración (solo desktop)
                          DashboardButton(
                            text: 'Configuración',
                            icon: Icons.settings_rounded,
                            onPressed:
                                () {}, // Función pendiente de implementar
                            color: Colors.teal,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
