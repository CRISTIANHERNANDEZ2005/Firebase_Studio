import 'package:flutter/material.dart';


// Widget para mostrar mensajes toast personalizados
class MessageToast extends StatelessWidget {
  // Propiedades configurables
  final String message; // Mensaje a mostrar
  final Color backgroundColor; // Color de fondo
  final IconData icon; // Icono
  final Color iconColor; // Color del icono

  const MessageToast({
    super.key,
    required this.message,
    this.backgroundColor = Colors.green, // Verde por defecto (éxito)
    this.icon = Icons.check_circle, // Icono de check por defecto
    this.iconColor = Colors.white, // Icono blanco por defecto
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric( // Espaciado interno
        horizontal: 16.0, 
        vertical: 12.0,
      ),
      margin: const EdgeInsets.symmetric( // Margen exterior
        horizontal: 16.0, 
        vertical: 8.0,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
        boxShadow: [ // Sombra sutil
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),)
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Ocupa mínimo espacio horizontal
        children: [
          Icon(icon, color: iconColor), // Icono
          const SizedBox(width: 8), // Espaciado
          Flexible( // Ajusta el texto al espacio disponible
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white, // Texto blanco
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}