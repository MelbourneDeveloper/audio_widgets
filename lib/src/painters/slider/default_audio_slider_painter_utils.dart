import 'package:flutter/material.dart';
import 'package:flutter_audio_widgets/src/painters/slider/default_audio_slider_painter_constants.dart';

/// Draws notches and labels for a vertical slider.
void drawSliderNotchesVertical(
  Canvas canvas,
  Size size,
  double trackLeft,
  double trackWidth,
  double min,
  double max,
) {
  final notchSpacing =
      size.height / (DefaultAudioSliderPainterConstants.notchCount - 1);

  for (var i = 0; i < DefaultAudioSliderPainterConstants.notchCount; i++) {
    final y = i * notchSpacing;
    final isMainNotch = i.isEven;
    final value =
        ((max - min) *
                    (1.0 -
                        (i /
                            (DefaultAudioSliderPainterConstants.notchCount -
                                1))) +
                min)
            .round();

    final notchLength = isMainNotch
        ? trackWidth * DefaultAudioSliderPainterConstants.notchMainLengthRatio
        : trackWidth * DefaultAudioSliderPainterConstants.notchMinorLengthRatio;
    final notchPaint = Paint()
      ..color = Colors.white.withValues(
        alpha: isMainNotch
            ? DefaultAudioSliderPainterConstants.notchMainOpacity
            : DefaultAudioSliderPainterConstants.notchMinorOpacity,
      )
      ..strokeWidth = isMainNotch
          ? DefaultAudioSliderPainterConstants.notchMainStrokeWidth
          : DefaultAudioSliderPainterConstants.notchMinorStrokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(
        trackLeft + trackWidth + DefaultAudioSliderPainterConstants.notchOffset,
        y,
      ),
      Offset(
        trackLeft +
            trackWidth +
            DefaultAudioSliderPainterConstants.notchOffset +
            notchLength,
        y,
      ),
      notchPaint,
    );

    if (isMainNotch) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: value.toString(),
          style: TextStyle(
            color: Colors.white.withValues(
              alpha: DefaultAudioSliderPainterConstants.textOpacity,
            ),
            fontSize: DefaultAudioSliderPainterConstants.textSize,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(
          trackLeft +
              trackWidth +
              DefaultAudioSliderPainterConstants.notchSpacing +
              notchLength,
          y - textPainter.height / 2,
        ),
      );
    }
  }
}

/// Draws notches and labels for a horizontal slider.
void drawSliderNotchesHorizontal(
  Canvas canvas,
  Size size,
  double trackTop,
  double trackHeight,
  double min,
  double max,
) {
  final notchSpacing =
      size.width / (DefaultAudioSliderPainterConstants.notchCount - 1);

  for (var i = 0; i < DefaultAudioSliderPainterConstants.notchCount; i++) {
    final x = i * notchSpacing;
    final isMainNotch = i.isEven;
    final value =
        ((max - min) *
                    (i / (DefaultAudioSliderPainterConstants.notchCount - 1)) +
                min)
            .round();

    final notchLength = isMainNotch
        ? trackHeight * DefaultAudioSliderPainterConstants.notchMainLengthRatio
        : trackHeight *
              DefaultAudioSliderPainterConstants.notchMinorLengthRatio;
    final notchPaint = Paint()
      ..color = Colors.white.withValues(
        alpha: isMainNotch
            ? DefaultAudioSliderPainterConstants.notchMainOpacity
            : DefaultAudioSliderPainterConstants.notchMinorOpacity,
      )
      ..strokeWidth = isMainNotch
          ? DefaultAudioSliderPainterConstants.notchMainStrokeWidth
          : DefaultAudioSliderPainterConstants.notchMinorStrokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(
        x,
        trackTop + trackHeight + DefaultAudioSliderPainterConstants.notchOffset,
      ),
      Offset(
        x,
        trackTop +
            trackHeight +
            DefaultAudioSliderPainterConstants.notchOffset +
            notchLength,
      ),
      notchPaint,
    );

    if (isMainNotch) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: value.toString(),
          style: TextStyle(
            color: Colors.white.withValues(
              alpha: DefaultAudioSliderPainterConstants.textOpacity,
            ),
            fontSize: DefaultAudioSliderPainterConstants.textSize,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(
          x - textPainter.width / 2,
          trackTop +
              trackHeight +
              DefaultAudioSliderPainterConstants.notchSpacing +
              notchLength,
        ),
      );
    }
  }
}

/// Draws a flat endpoint for a vertical slider.
void drawSliderFlatEndpoint(
  Canvas canvas,
  double centerX,
  double y,
  double trackWidth,
  Color activeColor,
) {
  final endpointWidth = trackWidth;

  final endpointRect = Rect.fromCenter(
    center: Offset(centerX, y),
    width: endpointWidth,
    height: DefaultAudioSliderPainterConstants.endpointHeight,
  );

  final endpointPaint = Paint()
    ..shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.white.withValues(
          alpha: DefaultAudioSliderPainterConstants.endpointGradientStart,
        ),
        Colors.white.withValues(
          alpha: DefaultAudioSliderPainterConstants.endpointGradientMid,
        ),
        Colors.grey.withValues(
          alpha: DefaultAudioSliderPainterConstants.endpointGradientEnd,
        ),
      ],
      stops: const [0.0, 0.5, 1.0],
    ).createShader(endpointRect);

  canvas.drawRect(endpointRect, endpointPaint);

  final highlightPaint = Paint()
    ..color = Colors.white.withValues(
      alpha: DefaultAudioSliderPainterConstants.endpointHighlightOpacity,
    )
    ..strokeWidth = 1.0;

  canvas.drawLine(
    Offset(
      centerX - endpointWidth / 2,
      y - DefaultAudioSliderPainterConstants.endpointHeight / 2,
    ),
    Offset(
      centerX + endpointWidth / 2,
      y - DefaultAudioSliderPainterConstants.endpointHeight / 2,
    ),
    highlightPaint,
  );

  final rimPaint = Paint()
    ..color = activeColor.withValues(
      alpha: DefaultAudioSliderPainterConstants.endpointRimOpacity,
    )
    ..style = PaintingStyle.stroke
    ..strokeWidth = DefaultAudioSliderPainterConstants.endpointRimStrokeWidth;

  canvas.drawRect(endpointRect, rimPaint);
}

/// Draws a flat endpoint for a horizontal slider.
void drawSliderFlatEndpointHorizontal(
  Canvas canvas,
  double x,
  double centerY,
  double trackHeight,
  Color activeColor,
) {
  final endpointHeight = trackHeight;

  final endpointRect = Rect.fromCenter(
    center: Offset(x, centerY),
    width: DefaultAudioSliderPainterConstants.endpointWidth,
    height: endpointHeight,
  );

  final endpointPaint = Paint()
    ..shader = LinearGradient(
      colors: [
        Colors.white.withValues(
          alpha: DefaultAudioSliderPainterConstants.endpointGradientStart,
        ),
        Colors.white.withValues(
          alpha: DefaultAudioSliderPainterConstants.endpointGradientMid,
        ),
        Colors.grey.withValues(
          alpha: DefaultAudioSliderPainterConstants.endpointGradientEnd,
        ),
      ],
      stops: const [0.0, 0.5, 1.0],
    ).createShader(endpointRect);

  canvas.drawRect(endpointRect, endpointPaint);

  final highlightPaint = Paint()
    ..color = Colors.white.withValues(
      alpha: DefaultAudioSliderPainterConstants.endpointHighlightOpacity,
    )
    ..strokeWidth = 1.0;

  canvas.drawLine(
    Offset(
      x + DefaultAudioSliderPainterConstants.endpointWidth / 2,
      centerY - endpointHeight / 2,
    ),
    Offset(
      x + DefaultAudioSliderPainterConstants.endpointWidth / 2,
      centerY + endpointHeight / 2,
    ),
    highlightPaint,
  );

  final rimPaint = Paint()
    ..color = activeColor.withValues(
      alpha: DefaultAudioSliderPainterConstants.endpointRimOpacity,
    )
    ..style = PaintingStyle.stroke
    ..strokeWidth = DefaultAudioSliderPainterConstants.endpointRimStrokeWidth;

  canvas.drawRect(endpointRect, rimPaint);
}
