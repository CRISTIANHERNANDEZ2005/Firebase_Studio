import 'package:flutter/material.dart';

// Tarjeta reutilizable para items de lista
class ListItemCard extends StatelessWidget {
  // Propiedades configurables
  final String title; // Texto principal
  final String? subtitle; // Texto secundario opcional
  final Widget? leading; // Widget inicial (icono/avatar)
  final List<Widget> actions; // Acciones (botones)
  final Color? color; // Color personalizado
  final VoidCallback? onTap; // Callback al presionar

  const ListItemCard({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions = const [], // Lista vacía por defecto
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Obtiene el tema actual

    return Card(
      elevation: 2, // Sombra ligera
      margin: const EdgeInsets.symmetric(
        // Margen uniforme
        vertical: 8,
        horizontal: 16,
      ),
      shape: RoundedRectangleBorder(
        // Bordes redondeados
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        // Efecto de ripple al tocar
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16), // Espaciado interno
          child: Row(
            // Organización horizontal
            children: [
              if (leading != null) ...[
                // Si hay leading widget
                leading!,
                const SizedBox(width: 16), // Espaciado
              ],
              Expanded(
                // Toma todo el espacio disponible
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Alineación izquierda
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600, // Negrita
                      ),
                    ),
                    if (subtitle != null) ...[
                      // Si hay subtítulo
                      const SizedBox(height: 4), // Espaciado pequeño
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(
                            0.6,
                          ), // Color secundario
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (actions.isNotEmpty) ...[
                // Si hay acciones
                const SizedBox(width: 8), // Espaciado
                Row(
                  // Organiza acciones horizontalmente
                  mainAxisSize: MainAxisSize.min, // Ocupa mínimo espacio
                  children: actions,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
