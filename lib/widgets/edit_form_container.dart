// widgets/edit_form_container.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tienda_online/widgets/bezier_container.dart';
import 'package:tienda_online/widgets/custom_button.dart';

class EditFormContainer extends StatelessWidget {
  final String title;
  final List<Widget> formFields;
  final VoidCallback onSave;
  final bool isLoading;

  const EditFormContainer({
    super.key,
    required this.title,
    required this.formFields,
    required this.onSave,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Fondo decorativo
          Positioned(
            top: 0,
            left: 0,
            child: BezierContainer(
              color: theme.primaryColor,
              isTop: true,
            ),
          ),
          
          // Contenido principal
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
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
          ),
        ],
      ),
    );
  }
}