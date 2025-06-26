// Importa el paquete de Flutter para widgets y herramientas UI
import 'package:flutter/material.dart';

// Clase con validadores reutilizables para formularios
class Validators {
  // Valida que un campo obligatorio no esté vacío
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName es requerido'; // Mensaje de error personalizado
    }
    return null; // Retorna null cuando es válido
  }

  // Valida que la contraseña cumpla con requisitos mínimos
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  // Valida el formato del número de usuario (documento/identificación)
  static String? validateNumero(String? value) {
    if (value == null || value.isEmpty) {
      return 'Número es requerido';
    }
    // Expresión regular para validar mínimo 4 dígitos
    if (!RegExp(r'^\d{4,}$').hasMatch(value)) {
      return 'Número inválido (mínimo 4 dígitos)';
    }
    return null;
  }

  // Limpia automáticamente los errores después de un tiempo
  static void clearErrorAfterDelay(
    GlobalKey<FormState> formKey, { // Clave del formulario a limpiar
    int seconds = 4, // Tiempo predeterminado: 4 segundos
  }) {
    // Programa la acción para después del tiempo especificado
    Future.delayed(Duration(seconds: seconds), () {
      // Verifica que el formulario aún exista en el árbol de widgets
      if (formKey.currentState != null) {
        formKey.currentState!.reset(); // Limpia los campos
        formKey.currentState!.validate(); // Vuelve a validar
      }
    });
  }
}
