import 'dart:math' as math;

import 'package:audio_widgets/audio_widgets.dart';
import 'package:flutter/material.dart';

/// Default painter implementation for [AudioDial] widgets.
class DefaultAudioDialPainter extends CustomPainter {
  /// Creates a default audio dial painter.
  DefaultAudioDialPainter({
    required this.value,
    required this.min,
    required this.max,
    required this.strokeWidth,
    required this.dialColor,
    required this.trackColor,
    required this.thumbColor,
    required this.activeColor,
    required this.isDragging,
    required this.glowIntensity,
  });

  /// The current value of the dial.
  final double value;
  /// The minimum value of the dial.
  final double min;
  /// The maximum value of the dial.
  final double max;
  /// The width of the stroke for drawing the dial.
  final double strokeWidth;
  /// The color of the dial face.
  final Color dialColor;
  /// The color of the track.
  final Color trackColor;
  /// The color of the thumb.
  final Color thumbColor;
  /// The active color for the progress arc.
  final Color activeColor;
  /// Whether the dial is currently being dragged.
  final bool isDragging;
  /// The intensity of the glow effect.
  final double glowIntensity;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final rect = Rect.fromCircle(center: center, radius: radius);
    drawGlassMorphismBackground(canvas, rect, dialColor, borderRadius: radius);
    drawDialOuterGlowRing(canvas, center, radius, activeColor, glowIntensity);
    drawDialGradientTrack(canvas, center, radius, strokeWidth, trackColor);

    final progress = value.normalizeToRange(min, max);
    final sweepAngle =
        2 *
        math.pi *
        progress *
        DefaultAudioDialPainterConstants.activeArcRatio;
    const startAngle =
        -math.pi / 2 +
        (math.pi * DefaultAudioDialPainterConstants.arcStartOffset);

    drawDialActiveArc(
      canvas,
      center,
      radius,
      startAngle,
      sweepAngle,
      progress,
      strokeWidth,
      activeColor,
      glowIntensity,
    );

    drawDialInnerFace(canvas, center, radius, strokeWidth, dialColor);
    drawDialTickMarks(canvas, center, radius, strokeWidth);
    drawDialElegantEndpoint(
      canvas,
      center,
      radius,
      startAngle,
      sweepAngle,
      strokeWidth,
      activeColor,
    );
    drawDialCenterReflection(canvas, center);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is! DefaultAudioDialPainter) return true;
    return value != oldDelegate.value ||
        min != oldDelegate.min ||
        max != oldDelegate.max ||
        activeColor != oldDelegate.activeColor;
  }
}
