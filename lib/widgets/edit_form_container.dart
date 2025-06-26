// widgets/edit_form_container.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tienda_online/widgets/bezier_container.dart';
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
    final theme = Theme.of(context); // Obtiene el tema actual

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.poppins(
            // Fuente personalizada
            fontWeight: FontWeight.w600, // Negrita
          ),
        ),
        centerTitle: true, // Título centrado
      ),
      body: Stack(
        // Permite superponer widgets
        children: [
          // Fondo decorativo con curva Bezier
          Positioned(
            top: 0,
            left: 0,
            child: BezierContainer(
              color: theme.primaryColor, // Usa el color primario del tema
              isTop: true, // Curva en la parte superior
            ),
          ),

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
                  padding: const EdgeInsets.all(24), // Margen interior
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min, // Ocupa mínimo espacio vertical
                    children: [
                      ...formFields, // Campos del formulario
                      const SizedBox(height: 24), // Espaciado
                      SizedBox(
                        width: double.infinity, // Ancho completo
                        child: CustomButton(
                          // Botón personalizado
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
          ),
        ],
      ),
    );
  }
}
