import 'package:flutter/material.dart';
import 'package:flutter_audio_widgets/src/shared/audio_widget_extensions.dart';
import 'package:flutter_audio_widgets/src/shared/audio_widget_types.dart';

/// Creates a Paint object with a linear gradient shader.
Paint createGradientPaint({
  required Rect bounds,
  required List<Color> colors,
  required List<double> stops,
  Alignment begin = Alignment.topCenter,
  Alignment end = Alignment.bottomCenter,
}) => Paint()
  ..shader = LinearGradient(
    begin: begin,
    end: end,
    colors: colors,
    stops: stops,
  ).createShader(bounds);

/// Creates a Paint object configured for shadow effects.
Paint createShadowPaint({
  required Color color,
  required double opacity,
  required double blurRadius,
  Offset offset = Offset.zero,
}) => Paint()
  ..color = color.withValues(alpha: opacity)
  ..style = PaintingStyle.fill
  ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius);

/// Draws a glassmorphism background effect.
void drawGlassMorphismBackground(
  Canvas canvas,
  Rect rect,
  Color baseColor, {
  double borderRadius = 12.0,
}) {
  final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

  final shadowPaint = createShadowPaint(
    color: Colors.black,
    opacity: 0.3,
    blurRadius: 20,
  );
  canvas.drawRRect(rrect.shift(const Offset(2, 4)).inflate(2), shadowPaint);

  final glassPaint = createGradientPaint(
    bounds: rect,
    colors: [
      baseColor.withValues(alpha: 0.15),
      baseColor.withValues(alpha: 0.05),
      Colors.white.withValues(alpha: 0.02),
    ],
    stops: const [0.0, 0.7, 1.0],
  );
  canvas.drawRRect(rrect, glassPaint);

  final rimPaint = Paint()
    ..color = Colors.white.withValues(alpha: 0.15)
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;
  canvas.drawRRect(rrect.deflate(0.5), rimPaint);
}

/// Draws a glow effect around active elements.
/// 
/// Creates a subtle glow effect when audio widgets are being
/// interacted with to provide visual feedback.
void drawActiveGlow(
  Canvas canvas,
  RRect rect,
  Color activeColor, {
  required bool isDragging,
  double glowRadius = 8.0,
}) {
  // No glow effect as isDragging is always false
}

/// Validates and constrains a value to the specified range.
/// 
/// Ensures that widget values stay within their defined bounds.
double validateValue(double value, double min, double max) =>
    value.constrainToRange(min, max);

/// Creates a color configuration record for audio widgets.
/// 
/// Generates a standardized color scheme with track, active, and thumb
/// colors, using sensible defaults when specific colors aren't provided.
ColorConfig createColorConfig({
  Color? trackColor,
  Color? activeColor,
  Color? thumbColor,
}) => (
  track: trackColor ?? const Color(0xFF1C1C1E),
  active: activeColor ?? const Color(0xFF007AFF),
  thumb: thumbColor ?? Colors.white,
);

/// Constants used throughout the audio widgets library.
abstract class AudioWidgetConstants {
  /// Default animation duration in milliseconds.
  static const double defaultAnimationDuration = 100;
  
  /// Default glow effect radius in logical pixels.
  static const double defaultGlowRadius = 8;
  
  /// Default shadow blur radius in logical pixels.
  static const double defaultShadowRadius = 20;
  
  /// Default border radius for rounded corners.
  static const double defaultBorderRadius = 12;
  
  /// Default animation curve for smooth transitions.
  static const Curve defaultAnimationCurve = Curves.easeInOut;
  
  /// Animation duration for knob interactions in milliseconds.
  static const double knobAnimationDuration = 150;
  
  /// Animation duration for VU meter peak hold in milliseconds.
  static const double vuPeakAnimationDuration = 2000;
}

/// Creates a box decoration for equalizer container styling.
BoxDecoration createEQContainerDecoration() => BoxDecoration(
  borderRadius: BorderRadius.circular(AudioWidgetConstants.defaultBorderRadius),
  gradient: const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xCC000000), // Colors.black.withValues(alpha: 0.8)
      Color(0xF2000000), // Colors.black.withValues(alpha: 0.95)
      Color(0xB3000000), // Colors.black.withValues(alpha: 0.7)
    ],
    stops: [0.0, 0.5, 1.0],
  ),
  boxShadow: const [
    BoxShadow(
      color: Color(0x99000000), // Colors.black.withValues(alpha: 0.6)
      blurRadius: 8,
      offset: Offset(0, 4),
      spreadRadius: 1,
    ),
    BoxShadow(
      color: Color(0x0DFFFFFF), // Colors.white.withValues(alpha: 0.05)
      blurRadius: 4,
      offset: Offset(0, -2),
    ),
  ],
  border: Border.all(
    color: const Color(0x1AFFFFFF), // Colors.white.withValues(alpha: 0.1)
  ),
);

/// Builds a standardized label widget for audio controls.
/// 
/// Creates consistent text styling for labels across all
/// audio widget types.
Widget buildWidgetLabel(
  String? label, {
  Color color = Colors.grey,
  double fontSize = 12,
}) {
  if (label == null) return const SizedBox.shrink();
  return Text(
    label,
    style: TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
    ),
  );
}

/// Builds a standardized value display widget.
/// 
/// Creates consistent text styling for displaying current
/// values across all audio widget types.
Widget buildValueDisplay(
  double value,
  Color activeColor, {
  bool show = true,
  int decimals = 0,
}) {
  if (!show) return const SizedBox.shrink();
  return Text(
    decimals == 0 ? '${value.round()}' : value.toStringAsFixed(decimals),
    style: TextStyle(
      color: activeColor,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
  );
}
