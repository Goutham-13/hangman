import 'package:flutter/material.dart';

class HangmanPainter extends CustomPainter {
  final int wrongAttempts;
  HangmanPainter(this.wrongAttempts);

  @override
  void paint(Canvas canvas, Size size) {
    final ink = Paint()
      ..color = const Color(0xFF0047AB) // Blue ink
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(20, size.height - 20), Offset(size.width - 20, size.height - 20), ink);
    canvas.drawLine(Offset(40, size.height - 20), Offset(40, 20), ink);
    canvas.drawLine(Offset(40, 20), Offset(size.width / 2, 20), ink);
    canvas.drawLine(Offset(size.width / 2, 20), Offset(size.width / 2, 50), ink);

    if (wrongAttempts > 0) canvas.drawCircle(Offset(size.width / 2, 70), 20, ink);
    if (wrongAttempts > 1) canvas.drawLine(Offset(size.width / 2, 90), Offset(size.width / 2, 140), ink);
    if (wrongAttempts > 2) canvas.drawLine(Offset(size.width / 2, 100), Offset(size.width / 2 - 20, 120), ink);
    if (wrongAttempts > 3) canvas.drawLine(Offset(size.width / 2, 100), Offset(size.width / 2 + 20, 120), ink);
    if (wrongAttempts > 4) canvas.drawLine(Offset(size.width / 2, 140), Offset(size.width / 2 - 20, 170), ink);
    if (wrongAttempts > 5) canvas.drawLine(Offset(size.width / 2, 140), Offset(size.width / 2 + 20, 170), ink);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
