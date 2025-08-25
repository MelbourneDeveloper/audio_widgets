import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Custom test painter for AudioSlider that draws a simple red rectangle
class TestAudioSliderPainter extends CustomPainter {
  TestAudioSliderPainter({
    required this.value,
    required this.min,
    required this.max,
    required this.orientation,
  });

  final double value;
  final double min;
  final double max;
  final Axis orientation;

  @override
  void paint(Canvas canvas, Size size) {
    final progress = (value - min) / (max - min);
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    if (orientation == Axis.vertical) {
      final activeHeight = size.height * progress;
      final rect = Rect.fromLTWH(
        0,
        size.height - activeHeight,
        size.width,
        activeHeight,
      );
      canvas.drawRect(rect, paint);
    } else {
      final activeWidth = size.width * progress;
      final rect = Rect.fromLTWH(0, 0, activeWidth, size.height);
      canvas.drawRect(rect, paint);
    }

    // Draw border
    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Custom test painter for AudioDial that draws a simple blue circle with arc
class TestAudioDialPainter extends CustomPainter {
  TestAudioDialPainter({
    required this.value,
    required this.min,
    required this.max,
  });

  final double value;
  final double min;
  final double max;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    final progress = (value - min) / (max - min);

    // Draw background circle
    final bgPaint = Paint()
      ..color = Colors.blue.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    // Draw active arc
    final arcPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    const startAngle = -3.14159 / 2; // -90 degrees
    final sweepAngle = progress * 3.14159 * 1.5; // 270 degrees max

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      arcPaint,
    );

    // Draw center dot
    final centerPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 5, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Custom test painter for AudioKnob that draws a simple green circle
class TestAudioKnobPainter extends CustomPainter {
  TestAudioKnobPainter({
    required this.value,
    required this.min,
    required this.max,
  });

  final double value;
  final double min;
  final double max;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;
    final progress = (value - min) / (max - min);

    // Draw main knob circle
    final knobPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, knobPaint);

    // Draw indicator line
    const startAngle = -3.14159 / 2; // -90 degrees
    final indicatorAngle = startAngle + (progress * 3.14159 * 1.5);

    final indicatorStart = Offset(
      center.dx + (radius * 0.3) * math.cos(indicatorAngle),
      center.dy + (radius * 0.3) * math.sin(indicatorAngle),
    );
    final indicatorEnd = Offset(
      center.dx + (radius * 0.8) * math.cos(indicatorAngle),
      center.dy + (radius * 0.8) * math.sin(indicatorAngle),
    );

    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(indicatorStart, indicatorEnd, linePaint);

    // Draw border
    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Custom test painter for VUMeter that draws simple purple bars
class TestVUMeterPainter extends CustomPainter {
  TestVUMeterPainter({
    required this.leftLevel,
    required this.rightLevel,
    required this.segmentCount,
  });

  final double leftLevel;
  final double rightLevel;
  final int segmentCount;

  @override
  void paint(Canvas canvas, Size size) {
    const spacing = 2.0;
    final channelHeight = (size.height - spacing) / 2;
    final segmentWidth = size.width / segmentCount;

    // Draw left channel
    _drawChannel(canvas, 0, channelHeight, leftLevel, segmentWidth);

    // Draw right channel
    _drawChannel(
      canvas,
      channelHeight + spacing,
      channelHeight,
      rightLevel,
      segmentWidth,
    );
  }

  void _drawChannel(
    Canvas canvas,
    double y,
    double height,
    double level,
    double segmentWidth,
  ) {
    final activeSegments = (segmentCount * level).round();

    for (var i = 0; i < segmentCount; i++) {
      final x = i * segmentWidth;
      final rect = Rect.fromLTWH(x, y, segmentWidth - 1, height);

      final paint = Paint()
        ..color = i < activeSegments
            ? Colors.purple
            : Colors.grey.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill;

      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
