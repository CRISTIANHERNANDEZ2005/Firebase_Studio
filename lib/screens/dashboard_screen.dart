import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../widgets/dashboard_button.dart';
import '../widgets/bezier_container.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: Stack(
        children: [
          // Fondo con efecto Bezier
          Positioned(
            top: 0,
            left: 0,
            child: BezierContainer(color: Colors.blue, isTop: true),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: BezierContainer(color: Colors.green),
          ),
          // Contenido principal
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bienvenido',
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Gestión Comercial',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              // ignore: deprecated_member_use
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        onPressed: () async {
                          await authService.logout();
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: isDesktop ? 3 : 2,
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 24,
                      childAspectRatio: 1,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      children: [
                        DashboardButton(
                          text: 'Categorías',
                          icon: Icons.category_rounded,
                          onPressed: () =>
                              Navigator.pushNamed(context, '/categorias'),
                          color: Colors.blue,
                        ),
                        DashboardButton(
                          text: 'Productos',
                          icon: Icons.shopping_bag_rounded,
                          onPressed: () =>
                              Navigator.pushNamed(context, '/productos'),
                          color: Colors.green,
                        ),
                        DashboardButton(
                          text: 'Usuarios',
                          icon: Icons.people_alt_rounded,
                          onPressed: () =>
                              Navigator.pushNamed(context, '/usuarios'),
                          color: Colors.orange,
                        ),
                        if (isDesktop) ...[
                          DashboardButton(
                            text: 'Reportes',
                            icon: Icons.analytics_rounded,
                            onPressed: () {},
                            color: Colors.purple,
                          ),
                          DashboardButton(
                            text: 'Configuración',
                            icon: Icons.settings_rounded,
                            onPressed: () {},
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
