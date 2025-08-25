import 'package:flutter/material.dart';
import 'package:flutter_audio_widgets/src/audio_widget_shared.dart';

/// A custom painter that renders an audio slider widget with track and
/// active region.
class DefaultAudioSliderPainter extends CustomPainter {
  /// Creates a default audio slider painter.
  DefaultAudioSliderPainter({
    required this.value,
    required this.min,
    required this.max,
    required this.trackColor,
    required this.activeColor,
    required this.thumbColor,
    required this.isDragging,
    required this.thumbScale,
    required this.orientation,
    required this.showScale,
  });

  /// The current value of the slider.
  final double value;
  /// The minimum value of the slider range.
  final double min;
  /// The maximum value of the slider range.
  final double max;
  /// The color of the slider track background.
  final Color trackColor;
  /// The color of the active portion of the slider.
  final Color activeColor;
  /// The color of the slider thumb.
  final Color thumbColor;
  /// Whether the slider is currently being dragged.
  final bool isDragging;
  /// The scale factor for the thumb size.
  final double thumbScale;
  /// The orientation of the slider (horizontal or vertical).
  final Axis orientation;
  /// Whether to show scale markings on the slider.
  final bool showScale;

  @override
  void paint(Canvas canvas, Size size) {
    final progress = value.normalizeToRange(min, max);

    if (orientation == Axis.vertical) {
      _paintVertical(canvas, size, progress);
    } else {
      _paintHorizontal(canvas, size, progress);
    }
  }

  void _paintVertical(Canvas canvas, Size size, double progress) {
    final trackWidth =
        size.width * DefaultAudioSliderPainterConstants.trackWidthRatio;
    final trackLeft = (size.width - trackWidth) / 2;

    final trackPath = Path()
      ..moveTo(trackLeft, 0)
      ..lineTo(trackLeft + trackWidth, 0)
      ..lineTo(trackLeft + trackWidth, size.height - trackWidth / 2)
      ..arcToPoint(
        Offset(trackLeft, size.height - trackWidth / 2),
        radius: Radius.circular(trackWidth / 2),
      )
      ..close();

    _drawTrackBackgroundPath(canvas, trackPath);

    if (showScale) {
      drawSliderNotchesVertical(canvas, size, trackLeft, trackWidth, min, max);
    }

    final activeHeight = size.height * progress;
    final activeY = size.height - activeHeight;

    if (activeHeight > 0) {
      _drawActiveTrack(
        canvas,
        trackLeft,
        activeY,
        trackWidth,
        activeHeight,
        size,
      );
    }

    final endpointY = size.height - (size.height * progress);
    drawSliderFlatEndpoint(
      canvas,
      size.width / 2,
      endpointY,
      trackWidth,
      activeColor,
    );
  }

  void _drawTrackBackgroundPath(Canvas canvas, Path trackPath) {
    final bounds = trackPath.getBounds();

    // Optimize shadow drawing by avoiding Path.from and transform
    final shadowPaint = createShadowPaint(
      color: Colors.black,
      opacity: DefaultAudioSliderPainterConstants.shadowOpacity,
      blurRadius: DefaultAudioSliderPainterConstants.shadowBlurRadius,
    );

    canvas
      ..save()
      ..translate(0, 2)
      ..drawPath(trackPath, shadowPaint)
      ..restore();

    final trackPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          trackColor.withValues(
            alpha: DefaultAudioSliderPainterConstants.trackGradientStart,
          ),
          trackColor.withValues(
            alpha: DefaultAudioSliderPainterConstants.trackGradientMid,
          ),
          trackColor.withValues(
            alpha: DefaultAudioSliderPainterConstants.trackGradientEnd,
          ),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(bounds);

    canvas.drawPath(trackPath, trackPaint);

    final rimPaint = Paint()
      ..color = Colors.white.withValues(
        alpha: DefaultAudioSliderPainterConstants.rimOpacity,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawPath(trackPath, rimPaint);
  }

  void _drawActiveTrack(
    Canvas canvas,
    double trackLeft,
    double activeY,
    double trackWidth,
    double activeHeight,
    Size size,
  ) {
    final activeRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(trackLeft, activeY, trackWidth, activeHeight),
      bottomLeft: Radius.circular(trackWidth / 2),
      bottomRight: Radius.circular(trackWidth / 2),
    );

    drawActiveGlow(canvas, activeRect, activeColor, isDragging: isDragging);

    final activePaint = createGradientPaint(
      bounds: activeRect.outerRect,
      colors: [
        activeColor,
        Color.lerp(
          activeColor,
          Colors.white,
          DefaultAudioSliderPainterConstants.activeLerpRatio,
        )!,
        activeColor.withValues(alpha: 
          DefaultAudioSliderPainterConstants.activeGradientEnd,
        ),
      ],
      stops: const [0.0, 0.5, 1.0],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    );

    canvas.drawRRect(activeRect, activePaint);

    final highlightRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(
        trackLeft +
            trackWidth *
                DefaultAudioSliderPainterConstants.highlightOffsetRatio,
        activeY,
        trackWidth * DefaultAudioSliderPainterConstants.highlightWidthRatio,
        activeHeight,
      ),
      bottomLeft: Radius.circular(trackWidth / 4),
      bottomRight: Radius.circular(trackWidth / 4),
    );

    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 
        DefaultAudioSliderPainterConstants.highlightOpacity,
      )
      ..style = PaintingStyle.fill;

    canvas.drawRRect(highlightRect, highlightPaint);
  }

  void _paintHorizontal(Canvas canvas, Size size, double progress) {
    final trackHeight =
        size.height *
        DefaultAudioSliderPainterConstants.horizontalTrackHeightRatio;
    final trackTop = (size.height - trackHeight) / 2;
    final trackRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, trackTop, size.width, trackHeight),
      Radius.circular(trackHeight / 2),
    );

    drawGlassMorphismBackground(canvas, trackRect.outerRect, trackColor);

    if (showScale) {
      drawSliderNotchesHorizontal(
        canvas,
        size,
        trackTop,
        trackHeight,
        min,
        max,
      );
    }

    final activeWidth = size.width * progress;

    if (activeWidth > 0) {
      _drawActiveTrackHorizontal(
        canvas,
        trackTop,
        trackHeight,
        activeWidth,
        size,
      );
    }

    final endpointX = size.width * progress;
    drawSliderFlatEndpointHorizontal(
      canvas,
      endpointX,
      size.height / 2,
      trackHeight,
      activeColor,
    );
  }

  void _drawActiveTrackHorizontal(
    Canvas canvas,
    double trackTop,
    double trackHeight,
    double activeWidth,
    Size size,
  ) {
    final activeRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, trackTop, activeWidth, trackHeight),
      Radius.circular(trackHeight / 2),
    );

    final activePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          activeColor,
          Color.lerp(
            activeColor,
            Colors.white,
            DefaultAudioSliderPainterConstants.activeLerpRatio,
          )!,
          activeColor.withValues(
            alpha: DefaultAudioSliderPainterConstants.activeGradientEnd,
          ),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(activeRect.outerRect);

    canvas.drawRRect(activeRect, activePaint);

    final highlightRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        0,
        trackTop +
            trackHeight *
                DefaultAudioSliderPainterConstants.highlightOffsetRatio,
        activeWidth,
        trackHeight * DefaultAudioSliderPainterConstants.highlightWidthRatio,
      ),
      Radius.circular(trackHeight / 6),
    );

    final highlightPaint = Paint()
      ..color = Colors.white.withValues(
        alpha: DefaultAudioSliderPainterConstants.highlightOpacity,
      )
      ..style = PaintingStyle.fill;

    canvas.drawRRect(highlightRect, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is! DefaultAudioSliderPainter) return true;
    return value != oldDelegate.value ||
           min != oldDelegate.min ||
           max != oldDelegate.max ||
           orientation != oldDelegate.orientation ||
           trackColor != oldDelegate.trackColor ||
           activeColor != oldDelegate.activeColor ||
           thumbColor != oldDelegate.thumbColor;
  }
}
