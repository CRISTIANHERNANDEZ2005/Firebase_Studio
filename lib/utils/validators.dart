import 'package:flutter/material.dart';

class Validators {
  // Valida que el campo no esté vacío
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName es requerido';
    }
    return null;
  }

  // Valida la contraseña
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  // Valida el número de usuario
  static String? validateNumero(String? value) {
    if (value == null || value.isEmpty) {
      return 'Número es requerido';
    }
    if (!RegExp(r'^\d{4,}$').hasMatch(value)) {
      return 'Número inválido (mínimo 4 dígitos)';
    }
    return null;
  }

  // Maneja el temporizador para limpiar errores
  static void clearErrorAfterDelay(
    GlobalKey<FormState> formKey, {
    int seconds = 4,
  }) {
    Future.delayed(Duration(seconds: seconds), () {
      if (formKey.currentState != null) {
        formKey.currentState!.reset();
        formKey.currentState!.validate();
      }
    });
  }
}
