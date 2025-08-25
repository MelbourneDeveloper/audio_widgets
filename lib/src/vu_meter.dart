import 'package:audio_widgets/src/audio_widget_shared.dart';
import 'package:audio_widgets/src/painters/vu_meter/default_vu_meter_painter.dart';
import 'package:flutter/material.dart';

/// A VU (Volume Unit) meter for displaying audio levels.
/// 
/// The [VUMeter] widget displays stereo audio levels using segmented
/// meters with configurable colors. It supports peak hold functionality
/// and customizable appearance for professional audio applications.
class VUMeter extends StatefulWidget {
  /// Creates a [VUMeter] widget.
  ///
  /// The [leftLevel] and [rightLevel] parameters are required and should
  /// be values between 0.0 (silence) and 1.0 (maximum level).
  const VUMeter({
    required this.leftLevel,
    required this.rightLevel,
    super.key,
    this.width = 200.0,
    this.height = 60.0,
    this.segmentCount = 20,
    this.spacing = 2.0,
    this.lowColor = const Color(0xFF00FF00),
    this.midColor = const Color(0xFFFFFF00),
    this.highColor = const Color(0xFFFF0000),
    this.backgroundColor = const Color(0xFF1C1C1E),
    this.label,
    this.showPeakHold = true,
    this.painter,
  });

  /// The current level for the left channel (0.0 to 1.0).
  final double leftLevel;
  
  /// The current level for the right channel (0.0 to 1.0).
  final double rightLevel;
  
  /// The width of the VU meter in logical pixels.
  /// 
  /// Defaults to 200.0.
  final double width;
  
  /// The height of the VU meter in logical pixels.
  /// 
  /// Defaults to 60.0.
  final double height;
  
  /// The number of segments in each meter.
  /// 
  /// More segments provide higher resolution. Defaults to 20.
  final int segmentCount;
  
  /// The spacing between segments in logical pixels.
  /// 
  /// Defaults to 2.0.
  final double spacing;
  
  /// The color for low-level segments (typically green).
  /// 
  /// Defaults to green.
  final Color lowColor;
  
  /// The color for mid-level segments (typically yellow).
  /// 
  /// Defaults to yellow.
  final Color midColor;
  
  /// The color for high-level segments (typically red).
  /// 
  /// Defaults to red.
  final Color highColor;
  
  /// The background color for inactive segments.
  /// 
  /// Defaults to a dark gray color.
  final Color backgroundColor;
  
  /// Optional text label displayed with the meter.
  final String? label;
  
  /// Whether to show peak hold indicators.
  /// 
  /// When enabled, the highest reached level is temporarily held
  /// and displayed. Defaults to true.
  final bool showPeakHold;
  
  /// Optional custom painter to override the default VU meter appearance.
  final CustomPainter? painter;

  @override
  State<VUMeter> createState() => _VUMeterState();
}

class _VUMeterState extends State<VUMeter> with TickerProviderStateMixin {
  late AnimationController _leftPeakController;
  late AnimationController _rightPeakController;
  final double _leftPeak = 0;
  final double _rightPeak = 0;

  @override
  void initState() {
    super.initState();
    _leftPeakController = AnimationController(
      duration: Duration(
        milliseconds: AudioWidgetConstants.vuPeakAnimationDuration.toInt(),
      ),
      vsync: this,
    );
    _rightPeakController = AnimationController(
      duration: Duration(
        milliseconds: AudioWidgetConstants.vuPeakAnimationDuration.toInt(),
      ),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _leftPeakController.dispose();
    _rightPeakController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: widget.width,
    height: widget.height + (widget.label != null ? 25 : 0),
    child: Column(
      children: [
        if (widget.label != null) ...[
          buildWidgetLabel(widget.label),
          const SizedBox(height: 5),
        ],
        Expanded(
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _leftPeakController,
              _rightPeakController,
            ]),
            builder: (context, child) {
              final leftPeakLevel =
                  _leftPeak * (1.0 - _leftPeakController.value);
              final rightPeakLevel =
                  _rightPeak * (1.0 - _rightPeakController.value);

              return CustomPaint(
                size: Size(widget.width, widget.height),
                painter:
                    widget.painter ??
                    DefaultVUMeterPainter(
                      leftLevel: widget.leftLevel,
                      rightLevel: widget.rightLevel,
                      leftPeak: widget.showPeakHold ? leftPeakLevel : 0.0,
                      rightPeak: widget.showPeakHold ? rightPeakLevel : 0.0,
                      segmentCount: widget.segmentCount,
                      spacing: widget.spacing,
                      lowColor: widget.lowColor,
                      midColor: widget.midColor,
                      highColor: widget.highColor,
                      backgroundColor: widget.backgroundColor,
                    ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
