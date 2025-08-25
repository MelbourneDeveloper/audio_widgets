import 'dart:math';
import 'package:flutter/material.dart';

class LedRingKnobPainter extends CustomPainter {
  final double value;
  final Color activeColor;

  const LedRingKnobPainter({required this.value, required this.activeColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const ledCount = 24;
    const startAngle = -pi * 0.75;
    const sweepAngle = pi * 1.5;

    for (int i = 0; i < ledCount; i++) {
      final angle = startAngle + (i / (ledCount - 1)) * sweepAngle;
      final ledRadius = radius * 0.9;
      final ledCenter = Offset(
        center.dx + cos(angle) * ledRadius,
        center.dy + sin(angle) * ledRadius,
      );

      final isActive = (i / (ledCount - 1)) <= (value / 100);
      final paint = Paint()
        ..color = isActive 
            ? activeColor 
            : activeColor.withValues(alpha: 0.2)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(ledCenter, 3, paint);

      if (isActive) {
        final glowPaint = Paint()
          ..color = activeColor.withValues(alpha: 0.5)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
        canvas.drawCircle(ledCenter, 5, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
