import 'package:flutter/material.dart';

// Botón personalizado reutilizable con soporte para estado de carga
class CustomButton extends StatelessWidget {
  // Propiedades configurables del botón
  final String text; // Texto a mostrar
  final VoidCallback onPressed; // Función al presionar
  final bool isLoading; // Indica si muestra spinner de carga
  final Color? color; // Color personalizado (opcional)
  final double? width; // Ancho personalizado (opcional)

  // Constructor con parámetros requeridos y opcionales
  const CustomButton({
    super.key, // Clave para el widget
    required this.text, // Texto obligatorio
    required this.onPressed, // Acción obligatoria
    this.isLoading = false, // Por defecto no está cargando
    this.color, // Color opcional
    this.width, // Ancho opcional
  });

  @override
  Widget build(BuildContext context) {
    // Obtiene el tema actual para consistencia visual
    final theme = Theme.of(context);

    return SizedBox(
      width: width ?? double.infinity, // Ancho personalizado o máximo posible
      height: 48, // Altura fija estándar
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed, // Desactiva si está cargando
        style: ElevatedButton.styleFrom(
          backgroundColor:
              color ?? theme.primaryColor, // Color personalizado o del tema
          shape: RoundedRectangleBorder(
            // Bordes redondeados
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2, // Sombra sutil
          shadowColor: Colors.black12, // Color de sombra
        ),
        child:
            isLoading
                ? const SizedBox(
                  // Muestra spinner si está cargando
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white, // Spinner blanco
                    strokeWidth: 3, // Grosor del spinner
                  ),
                )
                : Text(
                  // Muestra texto normal
                  text,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white, // Texto blanco
                    fontWeight: FontWeight.bold, // Negrita
                  ),
                ),
      ),
    );
  }
}
