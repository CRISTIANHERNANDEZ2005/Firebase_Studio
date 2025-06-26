// Campo de texto personalizado con múltiples opciones
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  // Propiedades configurables
  final String label; // Etiqueta del campo
  final TextEditingController controller; // Controlador del texto
  final bool obscureText; // Para contraseñas
  final String? Function(String?)? validator; // Función de validación
  final IconData? prefixIcon; // Icono opcional al inicio
  final Widget? suffixIcon; // Widget opcional al final
  final TextInputType? keyboardType; // Tipo de teclado
  final bool enabled; // Habilita/deshabilita el campo
  final int? maxLines; // Máximo de líneas (1 por defecto)
  final int? minLines; // Mínimo de líneas
  final bool expands; // Expansión vertical
  final TextInputAction? textInputAction; // Acción del teclado
  final FocusNode? focusNode; // Nodo de enfoque
  final void Function(String)? onChanged; // Callback al cambiar texto
  final void Function()? onEditingComplete; // Callback al completar edición
  final void Function(String)? onFieldSubmitted; // Callback al enviar

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.enabled = true,
    this.maxLines = 1, // Valor por defecto cambiado a 1
    this.minLines,
    this.expands = false,
    this.textInputAction,
    this.focusNode,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
  }) : assert(
         // Validación en tiempo de compilación
         maxLines == null || !expands,
         'Expands no puede ser true si maxLines está definido',
       );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      enabled: enabled,
      keyboardType: keyboardType,
      maxLines: expands ? null : maxLines, // Manejo de expansión
      minLines: minLines,
      expands: expands,
      textInputAction: textInputAction,
      focusNode: focusNode,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint:
            maxLines != null && maxLines! > 1, // Alineación para multilínea
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          // Borde estándar
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          // Borde cuando está habilitado
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true, // Fondo relleno
        fillColor: Colors.white.withOpacity(0.9), // Color de fondo
        contentPadding: const EdgeInsets.symmetric(
          // Espaciado interno
          vertical: 16,
          horizontal: 16,
        ),
      ),
      validator: validator,
    );
  }
}
