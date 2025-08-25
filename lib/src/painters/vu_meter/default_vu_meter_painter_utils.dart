import 'package:flutter/material.dart';

/// Draws an active VU meter segment with glow and gradient effects.
void drawVUActiveSegment(
  Canvas canvas,
  Rect segmentRect,
  double position,
  Color lowColor,
  Color midColor,
  Color highColor,
) {
  final segmentColor = getVUSegmentColor(
    position,
    lowColor,
    midColor,
    highColor,
  );

  final glowPaint = Paint()
    ..color = segmentColor.withValues(alpha: 0.4)
    ..style = PaintingStyle.fill
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

  final glowRect = segmentRect.inflate(1.5);
  canvas.drawRRect(
    RRect.fromRectAndRadius(glowRect, const Radius.circular(3)),
    glowPaint,
  );

  final mainPaint = Paint()
    ..shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.lerp(segmentColor, Colors.white, 0.4)!,
        segmentColor,
        Color.lerp(segmentColor, Colors.black, 0.2)!,
      ],
      stops: const [0.0, 0.6, 1.0],
    ).createShader(segmentRect);

  canvas.drawRRect(
    RRect.fromRectAndRadius(segmentRect, const Radius.circular(2)),
    mainPaint,
  );

  final highlightPaint = Paint()
    ..color = Colors.white.withValues(alpha: 0.6)
    ..style = PaintingStyle.fill;

  final highlightRect = Rect.fromLTWH(
    segmentRect.left,
    segmentRect.top,
    segmentRect.width,
    segmentRect.height * 0.25,
  );

  canvas.drawRRect(
    RRect.fromRectAndRadius(highlightRect, const Radius.circular(2)),
    highlightPaint,
  );
}

/// Draws an inactive VU meter segment with subtle gradient and rim.
void drawVUInactiveSegment(
  Canvas canvas,
  Rect segmentRect,
  Color backgroundColor,
) {
  final inactivePaint = Paint()
    ..shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        backgroundColor.withValues(alpha: 0.3),
        backgroundColor.withValues(alpha: 0.1),
        backgroundColor.withValues(alpha: 0.2),
      ],
      stops: const [0.0, 0.5, 1.0],
    ).createShader(segmentRect);

  canvas.drawRRect(
    RRect.fromRectAndRadius(segmentRect, const Radius.circular(2)),
    inactivePaint,
  );

  final rimPaint = Paint()
    ..color = Colors.white.withValues(alpha: 0.1)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.5;

  canvas.drawRRect(
    RRect.fromRectAndRadius(segmentRect, const Radius.circular(2)),
    rimPaint,
  );
}

/// Gets the color for a VU meter segment based on its position.
Color getVUSegmentColor(
  double position,
  Color lowColor,
  Color midColor,
  Color highColor,
) {
  if (position <= 0.6) {
    return Color.lerp(lowColor, lowColor, position / 0.6)!;
  } else if (position <= 0.85) {
    final yellowProgress = (position - 0.6) / 0.25;
    return Color.lerp(lowColor, midColor, yellowProgress)!;
  } else {
    final redProgress = (position - 0.85) / 0.15;
    return Color.lerp(midColor, highColor, redProgress)!;
  }
}
