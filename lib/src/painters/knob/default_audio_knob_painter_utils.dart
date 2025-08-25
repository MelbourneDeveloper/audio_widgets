import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Draws the glass morphism base effect for the knob.
void drawKnobGlassMorphismBase(
  Canvas canvas,
  Offset center,
  double radius,
  Color knobColor,
) {
  final shadowPaint = Paint()
    ..color = Colors.black.withValues(alpha: 0.4)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

  canvas.drawCircle(center + const Offset(1, 2), radius, shadowPaint);

  final glassPaint = Paint()
    ..shader = RadialGradient(
      colors: [
        knobColor.withValues(alpha: 0.2),
        knobColor.withValues(alpha: 0.1),
        Colors.white.withValues(alpha: 0.05),
      ],
      stops: const [0.0, 0.7, 1.0],
    ).createShader(Rect.fromCircle(center: center, radius: radius));

  canvas.drawCircle(center, radius - 1, glassPaint);
}

/// Draws the outer glow effect around the knob when active.
void drawKnobOuterGlow(
  Canvas canvas,
  Offset center,
  double radius,
  Color activeColor,
  bool isDragging,
) {
  // No glow effect as isDragging is always false
}

/// Draws the main body of the knob with gradient and rim.
void drawKnobBody(
  Canvas canvas,
  Offset center,
  double radius,
  Color knobColor,
) {
  final knobPaint = Paint()
    ..shader = RadialGradient(
      center: const Alignment(-0.3, -0.4),
      colors: [
        Color.lerp(knobColor, Colors.white, 0.3)!,
        knobColor,
        Color.lerp(knobColor, Colors.black, 0.3)!,
      ],
      stops: const [0.0, 0.6, 1.0],
    ).createShader(Rect.fromCircle(center: center, radius: radius));

  canvas.drawCircle(center, radius - 2, knobPaint);

  final rimPaint = Paint()
    ..color = Colors.white.withValues(alpha: 0.2)
    ..strokeWidth = 1.5
    ..style = PaintingStyle.stroke;

  canvas.drawCircle(center, radius - 3, rimPaint);
}

/// Draws tick marks around the knob perimeter.
void drawKnobTickMarks(Canvas canvas, Offset center, double radius) {
  const tickCount = 11;

  for (var i = 0; i < tickCount; i++) {
    final angle = -math.pi * 0.625 + (i * math.pi * 1.25 / (tickCount - 1));
    final isMainTick = i.isEven;

    final tickLength = isMainTick ? 6.0 : 3.0;
    final tickWidth = isMainTick ? 1.5 : 1.0;
    final tickOpacity = isMainTick ? 0.6 : 0.3;

    final startRadius = radius - tickLength - 4;
    final endRadius = radius - 4;

    final startPoint = Offset(
      center.dx + startRadius * math.cos(angle),
      center.dy + startRadius * math.sin(angle),
    );
    final endPoint = Offset(
      center.dx + endRadius * math.cos(angle),
      center.dy + endRadius * math.sin(angle),
    );

    final tickPaint = Paint()
      ..color = Colors.white.withValues(alpha: tickOpacity)
      ..strokeWidth = tickWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(startPoint, endPoint, tickPaint);
  }
}

/// Draws the active arc indicating the knob's current value range.
void drawKnobActiveArc(
  Canvas canvas,
  Offset center,
  double radius,
  double startAngle,
  double sweepAngle,
  Color activeColor,
) {
  if (sweepAngle <= 0) return;

  final arcRadius = radius + 4;

  final glowPaint = Paint()
    ..shader = SweepGradient(
      startAngle: startAngle,
      endAngle: startAngle + sweepAngle,
      colors: [
        activeColor.withValues(alpha: 0.3),
        activeColor.withValues(alpha: 0.6),
        activeColor.withValues(alpha: 0.3),
      ],
      stops: const [0.0, 0.5, 1.0],
    ).createShader(Rect.fromCircle(center: center, radius: arcRadius))
    ..strokeWidth = 4
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

  canvas.drawArc(
    Rect.fromCircle(center: center, radius: arcRadius),
    startAngle,
    sweepAngle,
    false,
    glowPaint,
  );

  final activePaint = Paint()
    ..shader = SweepGradient(
      startAngle: startAngle,
      endAngle: startAngle + sweepAngle,
      colors: [
        activeColor,
        Color.lerp(activeColor, Colors.white, 0.4)!,
        activeColor,
      ],
      stops: const [0.0, 0.5, 1.0],
    ).createShader(Rect.fromCircle(center: center, radius: arcRadius))
    ..strokeWidth = 2.5
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  canvas.drawArc(
    Rect.fromCircle(center: center, radius: arcRadius),
    startAngle,
    sweepAngle,
    false,
    activePaint,
  );
}

/// Draws the knob indicator pointer showing the current position.
void drawKnobIndicator(
  Canvas canvas,
  Offset center,
  double radius,
  double angle,
  Color indicatorColor,
  Color activeColor,
  bool isDragging,
) {
  final pointerStart = Offset(
    center.dx + (radius * 0.2) * math.cos(angle),
    center.dy + (radius * 0.2) * math.sin(angle),
  );
  final pointerEnd = Offset(
    center.dx + (radius * 0.75) * math.cos(angle),
    center.dy + (radius * 0.75) * math.sin(angle),
  );

  final shadowPaint = Paint()
    ..color = Colors.black.withValues(alpha: 0.3)
    ..strokeWidth = 3
    ..strokeCap = StrokeCap.round
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

  canvas.drawLine(
    pointerStart + const Offset(0.5, 1),
    pointerEnd + const Offset(0.5, 1),
    shadowPaint,
  );

  final pointerPaint = Paint()
    ..shader = LinearGradient(
      colors: [
        if (isDragging) activeColor else indicatorColor,
        Colors.white.withValues(alpha: 0.9),
        if (isDragging) activeColor else indicatorColor,
      ],
      stops: const [0.0, 0.5, 1.0],
    ).createShader(Rect.fromPoints(pointerStart, pointerEnd))
    ..strokeWidth = 2.5
    ..strokeCap = StrokeCap.round;

  canvas.drawLine(pointerStart, pointerEnd, pointerPaint);
}

/// Draws the center reflection and dot on the knob.
void drawKnobCenterReflection(
  Canvas canvas,
  Offset center,
  double radius,
  Color indicatorColor,
  Color activeColor,
  bool isDragging,
) {
  final centerPaint = Paint()
    ..shader = RadialGradient(
      colors: [
        Colors.white.withValues(alpha: 0.4),
        Colors.white.withValues(alpha: 0.1),
        Colors.transparent,
      ],
      stops: const [0.0, 0.5, 1.0],
    ).createShader(Rect.fromCircle(center: center, radius: radius * 0.3));

  canvas.drawCircle(center, radius * 0.25, centerPaint);

  final dotPaint = Paint()
    ..color = isDragging ? activeColor : indicatorColor.withValues(alpha: 0.8)
    ..style = PaintingStyle.fill;

  canvas.drawCircle(center, 2, dotPaint);
}
