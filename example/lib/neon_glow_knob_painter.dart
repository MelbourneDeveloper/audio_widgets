import 'dart:math';
import 'package:flutter/material.dart';

class NeonGlowKnobPainter extends CustomPainter {
  final double value;
  final Color activeColor;

  const NeonGlowKnobPainter({required this.value, required this.activeColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    for (int i = 0; i < 3; i++) {
      final glowRadius = radius * (0.9 - i * 0.1);
      final glowPaint = Paint()
        ..color = activeColor.withValues(alpha: 0.3 - i * 0.1)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8.0 + i * 4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawCircle(center, glowRadius, glowPaint);
    }

    const startAngle = -pi * 0.75;
    const sweepAngle = pi * 1.5;
    final arcRect = Rect.fromCircle(center: center, radius: radius * 0.8);
    final arcPaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

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
