import 'package:flutter/material.dart';
import 'package:flutter_audio_widgets/src/audio_widget_shared.dart';

/// A custom painter that renders a VU meter with left and right channels.
class DefaultVUMeterPainter extends CustomPainter {
  /// Creates a VU meter painter with the specified parameters.
  DefaultVUMeterPainter({
    required this.leftLevel,
    required this.rightLevel,
    required this.leftPeak,
    required this.rightPeak,
    required this.segmentCount,
    required this.spacing,
    required this.lowColor,
    required this.midColor,
    required this.highColor,
    required this.backgroundColor,
  });

  /// The current level of the left channel (0.0 to 1.0).
  final double leftLevel;
  /// The current level of the right channel (0.0 to 1.0).
  final double rightLevel;
  /// The peak level of the left channel (0.0 to 1.0).
  final double leftPeak;
  /// The peak level of the right channel (0.0 to 1.0).
  final double rightPeak;
  /// The number of segments to display in the meter.
  final int segmentCount;
  /// The spacing between segments in pixels.
  final double spacing;
  /// The color for low-level segments.
  final Color lowColor;
  /// The color for mid-level segments.
  final Color midColor;
  /// The color for high-level segments.
  final Color highColor;
  /// The background color for inactive segments.
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final channelHeight = (size.height - spacing) / 2;
    final segmentWidth =
        (size.width - (segmentCount - 1) * spacing) / segmentCount;

    _drawChannel(
      canvas,
      Offset.zero,
      Size(size.width, channelHeight),
      leftLevel,
      leftPeak,
      segmentWidth,
    );

    _drawChannel(
      canvas,
      Offset(0, channelHeight + spacing),
      Size(size.width, channelHeight),
      rightLevel,
      rightPeak,
      segmentWidth,
    );
  }

  void _drawChannel(
    Canvas canvas,
    Offset offset,
    Size channelSize,
    double level,
    double peak,
    double segmentWidth,
  ) {
    for (var i = 0; i < segmentCount; i++) {
      final segmentPosition = i / (segmentCount - 1);
      final segmentRect = Rect.fromLTWH(
        offset.dx + i * (segmentWidth + spacing),
        offset.dy,
        segmentWidth,
        channelSize.height,
      );

      final isActive = segmentPosition <= level;

      if (isActive) {
        drawVUActiveSegment(
          canvas,
          segmentRect,
          segmentPosition,
          lowColor,
          midColor,
          highColor,
        );
      } else {
        drawVUInactiveSegment(canvas, segmentRect, backgroundColor);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is! DefaultVUMeterPainter) return true;
    return leftLevel != oldDelegate.leftLevel ||
           rightLevel != oldDelegate.rightLevel ||
           lowColor != oldDelegate.lowColor ||
           midColor != oldDelegate.midColor ||
           highColor != oldDelegate.highColor ||
           backgroundColor != oldDelegate.backgroundColor ||
           segmentCount != oldDelegate.segmentCount;
  }
}
