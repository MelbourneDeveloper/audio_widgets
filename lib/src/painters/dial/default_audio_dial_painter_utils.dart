import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_audio_widgets/src/painters/dial/default_audio_dial_painter_constants.dart';

/// Draws an outer glow ring around the dial for visual enhancement.
/// 
/// Creates a radial gradient glow effect that extends beyond the dial radius
/// to provide depth and highlight the active state.
void drawDialOuterGlowRing(
  Canvas canvas,
  Offset center,
  double radius,
  Color activeColor,
  double glowIntensity,
) {
  final glowPaint = Paint()
    ..shader = RadialGradient(
      colors: [
        activeColor.withValues(alpha: 0),
        activeColor.withValues(
          alpha: DefaultAudioDialPainterConstants.glowAlphaBase * glowIntensity,
        ),
        activeColor.withValues(
          alpha: DefaultAudioDialPainterConstants.glowAlphaMax * glowIntensity,
        ),
        Colors.transparent,
      ],
      stops: const [0.85, 0.9, 0.95, 1.0],
    ).createShader(Rect.fromCircle(center: center, radius: radius + 20));

  canvas.drawCircle(center, radius + 15, glowPaint);
}

/// Draws the gradient track circle that forms the main dial path.
/// 
/// Creates a circular track with a gradient effect and inner shadow
/// to give the dial depth and a professional appearance.
void drawDialGradientTrack(
  Canvas canvas,
  Offset center,
  double radius,
  double strokeWidth,
  Color trackColor,
) {
  final trackPaint = Paint()
    ..shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        trackColor.withValues(
          alpha: DefaultAudioDialPainterConstants.trackAlphaStart,
        ),
        trackColor.withValues(
          alpha: DefaultAudioDialPainterConstants.trackAlphaMid,
        ),
        trackColor.withValues(
          alpha: DefaultAudioDialPainterConstants.trackAlphaEnd,
        ),
      ],
      stops: const [0.0, 0.5, 1.0],
    ).createShader(Rect.fromCircle(center: center, radius: radius))
    ..strokeWidth = strokeWidth
    ..style = PaintingStyle.stroke;

  canvas.drawCircle(center, radius, trackPaint);

  final innerShadowPaint = Paint()
    ..shader =
        RadialGradient(
          colors: [
            Colors.black.withValues(
              alpha: DefaultAudioDialPainterConstants.innerShadowAlpha,
            ),
            Colors.transparent,
          ],
          stops: const [0.0, 1.0],
        ).createShader(
          Rect.fromCircle(center: center, radius: radius - strokeWidth),
        )
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;

  canvas.drawCircle(center, radius - strokeWidth / 2, innerShadowPaint);
}

/// Draws the active arc segment indicating the current dial value.
/// 
/// Creates a multi-layered arc with glow effects, gradients, and highlights
/// to visually represent the current position on the dial with enhanced
/// visual feedback.
void drawDialActiveArc(
  Canvas canvas,
  Offset center,
  double radius,
  double startAngle,
  double sweepAngle,
  double progress,
  double strokeWidth,
  Color activeColor,
  double glowIntensity,
) {
  if (sweepAngle <= 0) return;

  final outerGlowPaint = Paint()
    ..shader = SweepGradient(
      startAngle: startAngle,
      endAngle: startAngle + sweepAngle,
      colors: [
        activeColor.withValues(
          alpha:
              DefaultAudioDialPainterConstants.outerGlowAlpha * glowIntensity,
        ),
        activeColor.withValues(
          alpha:
              DefaultAudioDialPainterConstants.mediumGlowAlpha * glowIntensity,
        ),
        activeColor.withValues(
          alpha: DefaultAudioDialPainterConstants.sparkleAlpha * glowIntensity,
        ),
      ],
      stops: const [0.0, 0.5, 1.0],
    ).createShader(Rect.fromCircle(center: center, radius: radius))
    ..strokeWidth =
        strokeWidth + DefaultAudioDialPainterConstants.outerGlowOffset
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

  canvas.drawArc(
    Rect.fromCircle(center: center, radius: radius),
    startAngle,
    sweepAngle,
    false,
    outerGlowPaint,
  );

  final mediumGlowPaint = Paint()
    ..shader = SweepGradient(
      startAngle: startAngle,
      endAngle: startAngle + sweepAngle,
      colors: [
        activeColor.withValues(
          alpha: DefaultAudioDialPainterConstants.mediumGlowAlpha,
        ),
        Color.lerp(activeColor, Colors.white, 0.2)!.withValues(
          alpha: DefaultAudioDialPainterConstants.highlightAlpha + 0.2,
        ),
        activeColor.withValues(alpha: 0.5),
      ],
      stops: const [0.0, 0.5, 1.0],
    ).createShader(Rect.fromCircle(center: center, radius: radius))
    ..strokeWidth =
        strokeWidth + DefaultAudioDialPainterConstants.mediumGlowOffset
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

  canvas.drawArc(
    Rect.fromCircle(center: center, radius: radius),
    startAngle,
    sweepAngle,
    false,
    mediumGlowPaint,
  );

  final mainGradient = SweepGradient(
    startAngle: startAngle,
    endAngle: startAngle + sweepAngle,
    colors: [
      activeColor,
      Color.lerp(activeColor, Colors.white, 0.4)!,
      activeColor.withValues(
        alpha: DefaultAudioDialPainterConstants.mainGradientAlpha,
      ),
      Color.lerp(activeColor, Colors.white, 0.2)!,
    ],
    stops: const [0.0, 0.3, 0.7, 1.0],
  );

  final activePaint = Paint()
    ..shader = mainGradient.createShader(
      Rect.fromCircle(center: center, radius: radius),
    )
    ..strokeWidth = strokeWidth
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  canvas.drawArc(
    Rect.fromCircle(center: center, radius: radius),
    startAngle,
    sweepAngle,
    false,
    activePaint,
  );

  final highlightPaint = Paint()
    ..shader = SweepGradient(
      startAngle: startAngle,
      endAngle: startAngle + sweepAngle,
      colors: [
        Colors.white.withValues(
          alpha: DefaultAudioDialPainterConstants.highlightAlpha,
        ),
        Colors.white.withValues(
          alpha: DefaultAudioDialPainterConstants.mainGradientAlpha,
        ),
        Colors.white.withValues(
          alpha: DefaultAudioDialPainterConstants.mediumGlowAlpha,
        ),
      ],
      stops: const [0.0, 0.5, 1.0],
    ).createShader(Rect.fromCircle(center: center, radius: radius))
    ..strokeWidth =
        strokeWidth * DefaultAudioDialPainterConstants.highlightStrokeRatio
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  canvas.drawArc(
    Rect.fromCircle(center: center, radius: radius),
    startAngle,
    sweepAngle,
    false,
    highlightPaint,
  );

  drawDialEnhancedSparkles(
    canvas,
    center,
    radius,
    startAngle,
    sweepAngle,
    activeColor,
  );
}

/// Draws decorative sparkle effects along the active arc.
/// 
/// Adds small glowing points along the arc path to create a premium
/// visual effect that enhances the dial's appearance.
void drawDialEnhancedSparkles(
  Canvas canvas,
  Offset center,
  double radius,
  double startAngle,
  double sweepAngle,
  Color activeColor,
) {
  final sparkleCount = (sweepAngle / (math.pi / 8)).round().clamp(
    DefaultAudioDialPainterConstants.sparkleMinCount,
    DefaultAudioDialPainterConstants.sparkleMaxCount,
  );

  // Pre-calculate trig values to avoid repeated calculations
  final trigValues = <({double cos, double sin, double intensity})>[];
  for (var i = 0; i < sparkleCount; i++) {
    final progress = i / (sparkleCount - 1);
    final angle = startAngle + (sweepAngle * progress);
    final intensity = math.sin(progress * math.pi) * 0.5 + 0.5;
    trigValues.add((
      cos: math.cos(angle),
      sin: math.sin(angle),
      intensity: intensity,
    ));
  }

  // Create reusable paints
  final outerSparklePaint = Paint()
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
  final innerSparklePaint = Paint()
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);
  final corePaint = Paint();

  // Draw sparkles using pre-calculated values
  for (final values in trigValues) {
    final sparkleCenter = Offset(
      center.dx + radius * values.cos,
      center.dy + radius * values.sin,
    );

    outerSparklePaint.color = activeColor.withValues(
      alpha: DefaultAudioDialPainterConstants.sparkleAlpha * values.intensity,
    );
    canvas.drawCircle(
      sparkleCenter,
      DefaultAudioDialPainterConstants.sparkleRadius,
      outerSparklePaint,
    );

    innerSparklePaint.color = Colors.white.withValues(
      alpha:
          DefaultAudioDialPainterConstants.mainGradientAlpha * values.intensity,
    );
    canvas.drawCircle(
      sparkleCenter,
      DefaultAudioDialPainterConstants.sparkleInnerRadius,
      innerSparklePaint,
    );

    corePaint.color = Colors.white.withValues(alpha: values.intensity);
    canvas.drawCircle(
      sparkleCenter,
      DefaultAudioDialPainterConstants.sparkleCoreRadius,
      corePaint,
    );
  }
}

/// Draws the inner face of the dial with gradient and reflection effects.
/// 
/// Creates the central circular area inside the dial track with radial
/// gradients and reflections to simulate a 3D appearance.
void drawDialInnerFace(
  Canvas canvas,
  Offset center,
  double radius,
  double strokeWidth,
  Color dialColor,
) {
  final innerRadius =
      radius - strokeWidth - DefaultAudioDialPainterConstants.innerDialOffset;

  final innerPaint = Paint()
    ..shader = RadialGradient(
      colors: [
        dialColor.withValues(
          alpha: DefaultAudioDialPainterConstants.innerDialAlphaStart,
        ),
        dialColor.withValues(
          alpha: DefaultAudioDialPainterConstants.innerDialAlphaMid,
        ),
        dialColor.withValues(
          alpha: DefaultAudioDialPainterConstants.innerDialAlphaEnd,
        ),
        Colors.black.withValues(
          alpha: DefaultAudioDialPainterConstants.innerDialAlphaBlack,
        ),
      ],
      stops: const [0.0, 0.3, 0.7, 1.0],
    ).createShader(Rect.fromCircle(center: center, radius: innerRadius));

  canvas.drawCircle(center, innerRadius, innerPaint);

  final reflectionPaint = Paint()
    ..shader = RadialGradient(
      center: const Alignment(-0.3, -0.5),
      colors: [
        Colors.white.withValues(
          alpha: DefaultAudioDialPainterConstants.reflectionAlpha,
        ),
        Colors.white.withValues(
          alpha: DefaultAudioDialPainterConstants.reflectionAlphaMid,
        ),
        Colors.transparent,
      ],
      stops: const [0.0, 0.5, 1.0],
    ).createShader(Rect.fromCircle(center: center, radius: innerRadius));

  canvas.drawCircle(center, innerRadius, reflectionPaint);
}

/// Draws tick marks around the dial perimeter for value indication.
/// 
/// Creates major and minor tick marks at regular intervals around
/// the dial to help users gauge the current position and available range.
void drawDialTickMarks(
  Canvas canvas,
  Offset center,
  double radius,
  double strokeWidth,
) {
  final tickRadius = radius - strokeWidth / 2;

  for (var i = 0; i < DefaultAudioDialPainterConstants.tickCount; i++) {
    final angle =
        (2 * math.pi * i / DefaultAudioDialPainterConstants.tickCount) -
        math.pi / 2;
    final isMainTick = i % 3 == 0;

    final tickLength = isMainTick
        ? DefaultAudioDialPainterConstants.mainTickLength
        : DefaultAudioDialPainterConstants.minorTickLength;
    final tickWidth = isMainTick
        ? DefaultAudioDialPainterConstants.mainTickWidth
        : DefaultAudioDialPainterConstants.minorTickWidth;

    final startPoint = Offset(
      center.dx + (tickRadius - tickLength) * math.cos(angle),
      center.dy + (tickRadius - tickLength) * math.sin(angle),
    );

    final endPoint = Offset(
      center.dx + tickRadius * math.cos(angle),
      center.dy + tickRadius * math.sin(angle),
    );

    final tickPaint = Paint()
      ..color = Colors.white.withValues(
        alpha: isMainTick
            ? DefaultAudioDialPainterConstants.mainTickAlpha
            : DefaultAudioDialPainterConstants.minorTickAlpha,
      )
      ..strokeWidth = tickWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(startPoint, endPoint, tickPaint);
  }
}

/// Draws an elegant endpoint indicator at the end of the active arc.
/// 
/// Creates a glowing endpoint with multiple layers of effects to clearly
/// mark where the active arc ends, providing visual feedback for the
/// current value.
void drawDialElegantEndpoint(
  Canvas canvas,
  Offset center,
  double radius,
  double startAngle,
  double sweepAngle,
  double strokeWidth,
  Color activeColor,
) {
  if (sweepAngle <= 0) return;

  final endAngle = startAngle + sweepAngle;

  final endPoint = Offset(
    center.dx + radius * math.cos(endAngle),
    center.dy + radius * math.sin(endAngle),
  );

  final endpointPaint = Paint()
    ..shader = RadialGradient(
      colors: [
        activeColor.withValues(alpha: 1),
        activeColor.withValues(
          alpha: DefaultAudioDialPainterConstants.endpointAlpha,
        ),
        activeColor.withValues(
          alpha: DefaultAudioDialPainterConstants.mediumGlowAlpha,
        ),
        Colors.transparent,
      ],
      stops: const [0.0, 0.3, 0.7, 1.0],
    ).createShader(Rect.fromCircle(center: endPoint, radius: strokeWidth * 2))
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

  canvas.drawCircle(
    endPoint,
    strokeWidth * DefaultAudioDialPainterConstants.endpointGlowRatio,
    endpointPaint,
  );

  final innerGlowPaint = Paint()
    ..color = Colors.white.withValues(
      alpha: DefaultAudioDialPainterConstants.highlightAlpha,
    )
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

  canvas.drawCircle(
    endPoint,
    strokeWidth * DefaultAudioDialPainterConstants.endpointInnerRatio,
    innerGlowPaint,
  );

  final indicatorLength =
      strokeWidth * DefaultAudioDialPainterConstants.endpointIndicatorRatio;
  final indicatorStart = Offset(
    center.dx + (radius - indicatorLength) * math.cos(endAngle),
    center.dy + (radius - indicatorLength) * math.sin(endAngle),
  );

  final indicatorPaint = Paint()
    ..shader = LinearGradient(
      colors: [
        Colors.transparent,
        activeColor.withValues(
          alpha: DefaultAudioDialPainterConstants.endpointAlpha,
        ),
        Colors.white.withValues(
          alpha: DefaultAudioDialPainterConstants.mainGradientAlpha,
        ),
      ],
      stops: const [0.0, 0.5, 1.0],
    ).createShader(Rect.fromPoints(indicatorStart, endPoint))
    ..strokeWidth =
        strokeWidth * DefaultAudioDialPainterConstants.endpointStrokeRatio
    ..strokeCap = StrokeCap.round;

  canvas.drawLine(indicatorStart, endPoint, indicatorPaint);
}

/// Draws a center reflection effect for added visual polish.
/// 
/// Creates a small radial gradient reflection at the dial's center
/// to enhance the 3D appearance and provide a finishing touch.
void drawDialCenterReflection(Canvas canvas, Offset center) {
  final reflectionPaint = Paint()
    ..shader =
        RadialGradient(
          colors: [
            Colors.white.withValues(
              alpha: DefaultAudioDialPainterConstants.centerReflectionAlpha,
            ),
            Colors.white.withValues(
              alpha: DefaultAudioDialPainterConstants.reflectionAlphaMid,
            ),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(
          Rect.fromCircle(
            center: center,
            radius: DefaultAudioDialPainterConstants.centerReflectionRadius,
          ),
        );

  canvas.drawCircle(
    center,
    DefaultAudioDialPainterConstants.centerReflectionRadius,
    reflectionPaint,
  );
}
