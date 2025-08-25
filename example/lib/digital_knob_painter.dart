import 'dart:math';
import 'package:flutter/material.dart';

class DigitalKnobPainter extends CustomPainter {
  final double value;
  final Color activeColor;

  const DigitalKnobPainter({required this.value, required this.activeColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const startAngle = -pi * 0.75;
    const sweepAngle = pi * 1.5;
    const segmentCount = 32;
    final normalizedValue = value / 100;

    final borderPaint = Paint()
      ..color = activeColor.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius, borderPaint);

    for (int i = 0; i < segmentCount; i++) {
      final segmentAngle = startAngle + (i / (segmentCount - 1)) * sweepAngle;
      final isActive = (i / (segmentCount - 1)) <= normalizedValue;

      final segmentRadius = radius * 0.85;
      final segmentCenter = Offset(
        center.dx + cos(segmentAngle) * segmentRadius,
        center.dy + sin(segmentAngle) * segmentRadius,
      );

      final segmentPaint = Paint()
        ..color = isActive 
            ? activeColor 
            : activeColor.withValues(alpha: 0.1)
        ..style = PaintingStyle.fill;

      canvas.drawRect(
        Rect.fromCenter(center: segmentCenter, width: 3, height: 8),
        segmentPaint,
      );
    }

    final valueText = '${value.round()}';
    final textPainter = TextPainter(
      text: TextSpan(
        text: valueText,
        style: TextStyle(
          color: activeColor,
          fontSize: radius * 0.25,
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace',
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    final textOffset = Offset(
      center.dx - textPainter.width / 2,
      center.dy - textPainter.height / 2,
    );

    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
