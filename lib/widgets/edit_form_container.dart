import 'package:flutter/material.dart';
import 'package:tienda_online/widgets/custom_button.dart';

// Contenedor reutilizable para formularios de edición
class EditFormContainer extends StatelessWidget {
  // Propiedades configurables
  final String title; // Título del formulario
  final List<Widget> formFields; // Campos del formulario
  final VoidCallback onSave; // Función al guardar
  final bool isLoading; // Estado de carga

  const EditFormContainer({
    super.key,
    required this.title,
    required this.formFields,
    required this.onSave,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return
    // Permite superponer widgets
    // Fondo decorativo con curva Bezier
    // Contenido principal del formulario
    SafeArea(
      // Asegura que el contenido no se solape con notches
      child: SingleChildScrollView(
        // Permite desplazamiento
        padding: const EdgeInsets.all(24), // Margen exterior
        child: Card(
          // Tarjeta que contiene el formulario
          elevation: 4, // Sombra moderada
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ), // Bordes redondeados
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...formFields,
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'Guardar',
                    onPressed: onSave,
                    isLoading: isLoading,
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
