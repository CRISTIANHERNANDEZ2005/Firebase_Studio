import 'package:flutter/material.dart';

// Contenedor con curva Bezier para diseños decorativos
class BezierContainer extends StatelessWidget {
  final Color color; // Color de la curva
  final bool isTop; // Posición de la curva (arriba/abajo)

  const BezierContainer({
    super.key,
    required this.color,
    this.isTop = false, // Por defecto curva inferior
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      // Ignora interacciones para no bloquear otros widgets
      child: SizedBox(
        width: MediaQuery.of(context).size.width, // Ancho completo
        height: MediaQuery.of(context).size.height * 0.4, // 40% de altura
        child: CustomPaint(
          painter: _BezierPainter(
            color: color,
            isTop: isTop,
          ), // Pintor personalizado
        ),
      ),
    );
  }
}

// Clase que implementa el dibujo de la curva Bezier
class _BezierPainter extends CustomPainter {
  final Color color;
  final bool isTop;

  _BezierPainter({required this.color, required this.isTop});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..style =
              PaintingStyle
                  .fill // Relleno sólido
          ..color = color;

    final path = Path(); // Objeto para definir el trazado

    if (isTop) {
      // Curva en la parte superior
      path.moveTo(0, size.height); // Inicio abajo-izquierda
      // Curva Bezier cuadrática hacia derecha
      path.quadraticBezierTo(
        size.width * 0.5, // Punto de control en centro horizontal
        size.height * 0.7, // Punto de control a 70% de altura
        size.width, // Fin abajo-derecha
        size.height,
      );
      path.lineTo(size.width, 0); // Linea a arriba-derecha
      path.lineTo(0, 0); // Linea a arriba-izquierda
    } else {
      // Curva en la parte inferior
      path.moveTo(0, 0); // Inicio arriba-izquierda
      // Curva Bezier cuadrática hacia derecha
      path.quadraticBezierTo(
        size.width * 0.5, // Punto de control en centro horizontal
        size.height * 0.3, // Punto de control a 30% de altura
        size.width, // Fin arriba-derecha
        0,
      );
      path.lineTo(size.width, size.height); // Linea a abajo-derecha
      path.lineTo(0, size.height); // Linea a abajo-izquierda
    }

    canvas.drawPath(path, paint); // Dibuja el trazado
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false; // No necesita repintarse
}
