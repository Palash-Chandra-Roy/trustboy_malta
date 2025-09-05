import 'package:flutter/material.dart';





class ServiceStepper extends CustomPainter {
  final Color color;
  const ServiceStepper({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = color.withOpacity(1.0);
    canvas.drawRRect(
        RRect.fromRectAndCorners(
            Rect.fromLTWH(0, 0, size.width, size.height * 0.8363636),
            bottomRight: Radius.circular(size.width * 0.1304348),
            bottomLeft: Radius.circular(size.width * 0.1304348),
            topLeft: Radius.circular(size.width * 0.1304348),
            topRight: Radius.circular(size.width * 0.1304348)),
        paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.5000000, size.height);
    path_1.lineTo(size.width * 0.3117326, size.height * 0.8363636);
    path_1.lineTo(size.width * 0.6882674, size.height * 0.8363636);
    path_1.lineTo(size.width * 0.5000000, size.height);
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = color.withOpacity(1.0);
    canvas.drawPath(path_1, paint1Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
