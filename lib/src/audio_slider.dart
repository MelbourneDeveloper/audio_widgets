import 'package:audio_widgets/src/audio_widget_shared.dart';
import 'package:audio_widgets/src/painters/slider/default_audio_slider_painter.dart';
import 'package:flutter/material.dart';

/// A linear slider control for audio applications.
///
/// The [AudioSlider] widget provides a linear control interface
/// that can be oriented vertically or horizontally. It includes
/// optional scale markings and supports customizable appearance.
class AudioSlider extends StatefulWidget {
  /// Creates an [AudioSlider] widget.
  ///
  /// The [value] and [onChanged] parameters are required.
  /// The [value] must be between [min] and [max].
  const AudioSlider({
    required this.value,
    required this.onChanged,
    super.key,
    this.min = 0.0,
    this.max = 100.0,
    this.height = 200.0,
    this.width = 40.0,
    this.trackColor = const Color(0xFF1C1C1E),
    this.activeColor = const Color(0xFF007AFF),
    this.thumbColor = Colors.white,
    this.label,
    this.showValue = true,
    this.orientation = Axis.vertical,
    this.showScale = true,
    this.painter,
  });

  /// The current value of the slider.
  ///
  /// Must be between [min] and [max].
  final double value;

  /// Called when the user changes the slider's value by dragging.
  final ValueChanged<double> onChanged;

  /// The minimum value the slider can represent.
  ///
  /// Defaults to 0.0.
  final double min;

  /// The maximum value the slider can represent.
  ///
  /// Defaults to 100.0.
  final double max;

  /// The height of the slider when vertical, or track thickness when horizontal
  /// .
  ///
  /// Defaults to 200.0.
  final double height;

  /// The width of the slider when horizontal, or track thickness when
  /// vertical.
  ///
  /// Defaults to 40.0.
  final double width;

  /// The color of the inactive portion of the track.
  ///
  /// Defaults to a dark gray color.
  final Color trackColor;

  /// The color of the active portion of the track.
  ///
  /// Defaults to blue.
  final Color activeColor;

  /// The color of the draggable thumb.
  ///
  /// Defaults to white.
  final Color thumbColor;

  /// Optional text label displayed next to the slider.
  final String? label;

  /// Whether to show the current value next to the slider.
  ///
  /// Defaults to true.
  final bool showValue;

  /// The orientation of the slider (vertical or horizontal).
  ///
  /// Defaults to [Axis.vertical].
  final Axis orientation;

  /// Whether to show scale markings along the slider track.
  ///
  /// Defaults to true.
  final bool showScale;

  /// Optional custom painter to override the default slider appearance.
  final CustomPainter? painter;

  @override
  State<AudioSlider> createState() => _AudioSliderState();
}

class _AudioSliderState extends State<AudioSlider>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isDragging = false;

  late final Future<void> Function(DragStartDetails) _handlePanStart;
  late final void Function(DragEndDetails) _handlePanEnd;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 1.2).animate(
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

  @override
  Widget build(BuildContext context) {
    final isVertical = widget.orientation == Axis.vertical;

    return GestureDetector(
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      child: SizedBox(
        width: isVertical ? widget.width : widget.height,
        height: isVertical
            ? widget.height + (widget.label != null ? 30 : 0)
            : widget.width +
                  (widget.showValue || widget.label != null ? 50 : 0),
        child: isVertical ? _buildVerticalSlider() : _buildHorizontalSlider(),
      ),
    );
  }

  Widget _buildVerticalSlider() => Column(
    children: [
      if (widget.label != null) ...[
        Text(
          widget.label!,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
      ],
      Expanded(
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) => CustomPaint(
            size: Size(widget.width, widget.height),
            painter:
                widget.painter ??
                DefaultAudioSliderPainter(
                  value: widget.value,
                  min: widget.min,
                  max: widget.max,
                  trackColor: widget.trackColor,
                  activeColor: widget.activeColor,
                  thumbColor: widget.thumbColor,
                  isDragging: _isDragging,
                  thumbScale: _scaleAnimation.value,
                  orientation: widget.orientation,
                  showScale: widget.showScale,
                ),
          ),
        ),
      ),
    ],
  );

  Widget _buildHorizontalSlider() => Column(
    children: [
      if (widget.label != null) ...[
        Text(
          widget.label!,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
      ],
      AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => CustomPaint(
          size: Size(widget.height, widget.width),
          painter:
              widget.painter ??
              DefaultAudioSliderPainter(
                value: widget.value,
                min: widget.min,
                max: widget.max,
                trackColor: widget.trackColor,
                activeColor: widget.activeColor,
                thumbColor: widget.thumbColor,
                isDragging: _isDragging,
                thumbScale: _scaleAnimation.value,
                orientation: widget.orientation,
                showScale: widget.showScale,
              ),
        ),
      ),
      if (widget.showValue) ...[
        const SizedBox(height: 4),
        Text(
          '${widget.value.round()}',
          style: TextStyle(
            color: widget.activeColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ],
  );

  void _handlePanUpdate(DragUpdateDetails details) {
    handleSliderPanUpdate(
      details,
      context,
      widget.min,
      widget.max,
      widget.onChanged,
      widget.orientation,
      widget.width,
      widget.height,
    );
  }
}
