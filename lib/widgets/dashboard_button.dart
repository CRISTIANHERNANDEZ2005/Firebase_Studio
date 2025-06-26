import 'package:flutter/material.dart';

// Botón especializado para el dashboard con icono
class DashboardButton extends StatelessWidget {
  // Propiedades configurables
  final String text; // Texto descriptivo
  final IconData icon; // Icono a mostrar
  final VoidCallback onPressed; // Acción al presionar
  final Color color; // Color base (default: azul)

  // Constructor con parámetros requeridos
  const DashboardButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.color = Colors.blue, // Valor por defecto
  });

  @override
  Widget build(BuildContext context) {
    // Obtiene el tema para consistencia visual
    final theme = Theme.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click, // Cambia cursor al pasar mouse
      child: Card(
        elevation: 6, // Sombra más pronunciada
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Bordes muy redondeados
        ),
        child: InkWell(
          // Efecto de ripple al presionar
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          splashColor: color.withOpacity(0.2), // Color del efecto splash
          highlightColor: color.withOpacity(0.1), // Color de resaltado
          child: Container(
            padding: const EdgeInsets.all(20), // Espaciado interno
            width: 160, // Ancho fijo
            height: 160, // Alto fijo (botón cuadrado)
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                // Degradado sutil
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
              ),
            ),
            child: Column(
              // Organización vertical
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: color), // Icono grande
                const SizedBox(height: 12), // Espaciado
                Text(
                  text,
                  textAlign: TextAlign.center, // Texto centrado
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600, // Semi-negrita
                    fontSize: 20, // Tamaño grande
                    color: theme.colorScheme.onSurface.withOpacity(
                      0.8,
                    ), // Color con opacidad
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
