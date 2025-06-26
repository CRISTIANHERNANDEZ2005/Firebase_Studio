import 'package:flutter/material.dart';

class BezierContainer extends StatelessWidget {
  final Color color;
  final bool isTop;

  const BezierContainer({super.key, required this.color, this.isTop = false});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.4,
        child: CustomPaint(
          painter: _BezierPainter(color: color, isTop: isTop),
        ),
      ),
    );
  }
}

class _BezierPainter extends CustomPainter {
  final Color color;
  final bool isTop;

  _BezierPainter({required this.color, required this.isTop});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    final path = Path();

    if (isTop) {
      path.moveTo(0, size.height);
      path.quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.7,
        size.width,
        size.height,
      );
      path.lineTo(size.width, 0);
      path.lineTo(0, 0);
    } else {
      path.moveTo(0, 0);
      path.quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.3,
        size.width,
        0,
      );
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
