import 'package:flutter/material.dart';
import 'package:flutter_audio_widgets/flutter_audio_widgets.dart';
import 'package:flutter_audio_widgets/src/painters/knob/default_audio_knob_painter.dart';

/// A compact knob control for audio applications.
///
/// The [AudioKnob] widget provides a small rotary control interface
/// similar to those found on audio equipment. Users can drag to adjust
/// values within a specified range. The knob is smaller than [AudioDial]
/// and includes a pointer indicator.
class AudioKnob extends StatefulWidget {
  /// Creates an [AudioKnob] widget.
  ///
  /// The [value] and [onChanged] parameters are required.
  /// The [value] must be between [min] and [max].
  const AudioKnob({
    required this.value,
    required this.onChanged,
    super.key,
    this.min = 0.0,
    this.max = 100.0,
    this.size = 80.0,
    this.knobColor = const Color(0xFF2C2C2E),
    this.indicatorColor = Colors.white,
    this.activeColor = const Color(0xFF007AFF),
    this.label,
    this.showValue = true,
    this.painter,
  });

  /// The current value of the knob.
  ///
  /// Must be between [min] and [max].
  final double value;

  /// Called when the user changes the knob's value by dragging.
  final ValueChanged<double> onChanged;

  /// The minimum value the knob can represent.
  ///
  /// Defaults to 0.0.
  final double min;

  /// The maximum value the knob can represent.
  ///
  /// Defaults to 100.0.
  final double max;

  /// The size of the knob in logical pixels.
  ///
  /// Defaults to 80.0.
  final double size;

  /// The color of the knob body.
  ///
  /// Defaults to a dark gray color.
  final Color knobColor;

  /// The color of the knob's pointer indicator.
  ///
  /// Defaults to white.
  final Color indicatorColor;

  /// The color used for active elements and value display.
  ///
  /// Defaults to blue.
  final Color activeColor;

  /// Optional text label displayed below the knob.
  final String? label;

  /// Whether to show the current value below the knob.
  ///
  /// Defaults to true.
  final bool showValue;

  /// Optional custom painter to override the default knob appearance.
  final CustomPainter? painter;

  @override
  State<AudioKnob> createState() => _AudioKnobState();
}

class _AudioKnobState extends State<AudioKnob>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isDragging = false;
  double _previousValue = 0;

  late final Future<void> Function(DragStartDetails) _handlePanStart;
  late final void Function(DragEndDetails) _handlePanEnd;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.value;

    _animationController = AnimationController(
      duration: Duration(
        milliseconds: AudioWidgetConstants.knobAnimationDuration.toInt(),
      ),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _handlePanStart = createPanStartHandler(
      setDragging: (value) => setState(() => _isDragging = value),
      controller: _animationController,
    );

    _handlePanEnd = createPanEndHandler(
      setDragging: (value) => setState(() => _isDragging = value),
      controller: _animationController,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    handleKnobPanUpdate(
      details,
      context,
      widget.min,
      widget.max,
      widget.onChanged,
      widget.size,
      _previousValue,
      (value) => _previousValue = value,
    );
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onPanStart: _handlePanStart,
    onPanUpdate: _handlePanUpdate,
    onPanEnd: _handlePanEnd,
    child: SizedBox(
      width: widget.size,
      height:
          widget.size +
          (widget.label != null ? 35 : 0) +
          (widget.showValue ? 20 : 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) => Transform.scale(
                scale: _scaleAnimation.value,
                child: CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter:
                      widget.painter ??
                      DefaultAudioKnobPainter(
                        value: widget.value,
                        min: widget.min,
                        max: widget.max,
                        knobColor: widget.knobColor,
                        indicatorColor: widget.indicatorColor,
                        activeColor: widget.activeColor,
                        isDragging: _isDragging,
                      ),
                ),
              ),
            ),
          ),
          if (widget.showValue) ...[
            const SizedBox(height: 6),
            buildValueDisplay(widget.value, widget.activeColor),
          ],
          if (widget.label != null) ...[
            const SizedBox(height: 2),
            buildWidgetLabel(widget.label, fontSize: 10),
          ],
        ],
      ),
    ),
  );
}
