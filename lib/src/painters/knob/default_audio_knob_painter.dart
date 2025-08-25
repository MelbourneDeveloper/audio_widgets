import 'dart:math' as math;

import 'package:audio_widgets/src/audio_widget_shared.dart';
import 'package:flutter/material.dart';

/// A custom painter that renders an audio knob widget.
class DefaultAudioKnobPainter extends CustomPainter {
  /// Creates a default audio knob painter.
  DefaultAudioKnobPainter({
    required this.value,
    required this.min,
    required this.max,
    required this.knobColor,
    required this.indicatorColor,
    required this.activeColor,
    required this.isDragging,
  });

  /// The current value of the knob.
  final double value;
  /// The minimum value of the knob range.
  final double min;
  /// The maximum value of the knob range.
  final double max;
  /// The color of the knob body.
  final Color knobColor;
  /// The color of the knob indicator.
  final Color indicatorColor;
  /// The color used when the knob is active.
  final Color activeColor;
  /// Whether the knob is currently being dragged.
  final bool isDragging;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    drawKnobGlassMorphismBase(canvas, center, radius, knobColor);
    drawKnobOuterGlow(canvas, center, radius, activeColor, isDragging);
    drawKnobBody(canvas, center, radius, knobColor);
    drawKnobTickMarks(canvas, center, radius);

    final progress = value.normalizeToRange(min, max);
    const startAngle =
        -math.pi * DefaultAudioKnobPainterConstants.startAngleRatio;
    final sweepAngle =
        progress * math.pi * DefaultAudioKnobPainterConstants.sweepAngleRatio;

    drawKnobActiveArc(
      canvas,
      center,
      radius,
      startAngle,
      sweepAngle,
      activeColor,
    );

    drawKnobIndicator(
      canvas,
      center,
      radius,
      startAngle + sweepAngle,
      indicatorColor,
      activeColor,
      isDragging,
    );

    drawKnobCenterReflection(
      canvas,
      center,
      radius,
      indicatorColor,
      activeColor,
      isDragging,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is! DefaultAudioKnobPainter) return true;
    return value != oldDelegate.value ||
           min != oldDelegate.min ||
           max != oldDelegate.max ||
           knobColor != oldDelegate.knobColor ||
           indicatorColor != oldDelegate.indicatorColor ||
           activeColor != oldDelegate.activeColor ||
           isDragging != oldDelegate.isDragging;
  }
}
