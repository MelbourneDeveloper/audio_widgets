import 'dart:math';
import 'package:flutter/material.dart';

class MetallicKnobPainter extends CustomPainter {
  final double value;
  final Color activeColor;

  const MetallicKnobPainter({required this.value, required this.activeColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final outerGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.grey[300]!,
        Colors.grey[600]!,
        Colors.grey[800]!,
        Colors.grey[500]!,
      ],
    );

    final outerPaint = Paint()
      ..shader = outerGradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      );

    canvas.drawCircle(center, radius, outerPaint);

    for (int i = 0; i < 12; i++) {
      final angle = (i / 12) * 2 * pi;
      final lineStart = Offset(
        center.dx + cos(angle) * radius * 0.85,
        center.dy + sin(angle) * radius * 0.85,
      );
      final lineEnd = Offset(
        center.dx + cos(angle) * radius * 0.95,
        center.dy + sin(angle) * radius * 0.95,
      );

      final markPaint = Paint()
        ..color = Colors.grey[800]!
        ..strokeWidth = 1;

      canvas.drawLine(lineStart, lineEnd, markPaint);
    }

    const startAngle = -pi * 0.75;
    const sweepAngle = pi * 1.5;
    final arcRect = Rect.fromCircle(center: center, radius: radius * 0.9);
    final arcPaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawArc(
      arcRect,
      startAngle,
      sweepAngle * (value / 100),
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
