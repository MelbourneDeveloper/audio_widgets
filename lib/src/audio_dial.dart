import 'package:flutter/material.dart';
import 'package:flutter_audio_widgets/src/audio_widget_shared.dart';
import 'package:flutter_audio_widgets/src/painters/dial/default_audio_dial_painter.dart';

/// A circular dial control for audio applications.
/// 
/// The [AudioDial] widget provides a rotary control interface commonly used
/// in audio equipment. Users can drag to adjust values within a specified
/// range.
/// The widget supports customizable colors, size, and visual styling.
class AudioDial extends StatefulWidget {
  /// Creates an [AudioDial] widget.
  ///
  /// The [value] and [onChanged] parameters are required.
  /// The [value] must be between [min] and [max].
  const AudioDial({
    required this.value,
    required this.onChanged,
    super.key,
    this.min = 0.0,
    this.max = 100.0,
    this.size = 120.0,
    this.strokeWidth = 8.0,
    this.dialColor = const Color(0xFF2C2C2E),
    this.trackColor = const Color(0xFF1C1C1E),
    this.thumbColor = Colors.white,
    this.activeColor = const Color(0xFF007AFF),
    this.label,
    this.showValue = true,
    this.painter,
  });

  /// The current value of the dial.
  /// 
  /// Must be between [min] and [max].
  final double value;
  
  /// Called when the user changes the dial's value by dragging.
  final ValueChanged<double> onChanged;
  
  /// The minimum value the dial can represent.
  /// 
  /// Defaults to 0.0.
  final double min;
  
  /// The maximum value the dial can represent.
  /// 
  /// Defaults to 100.0.
  final double max;
  
  /// The size of the dial in logical pixels.
  /// 
  /// Defaults to 120.0.
  final double size;
  
  /// The width of the dial's stroke in logical pixels.
  /// 
  /// Defaults to 8.0.
  final double strokeWidth;
  
  /// The color of the dial's background track.
  /// 
  /// Defaults to a dark gray color.
  final Color dialColor;
  
  /// The color of the inactive portion of the track.
  /// 
  /// Defaults to a darker gray color.
  final Color trackColor;
  
  /// The color of the draggable thumb indicator.
  /// 
  /// Defaults to white.
  final Color thumbColor;
  
  /// The color of the active portion of the track.
  /// 
  /// Defaults to blue.
  final Color activeColor;
  
  /// Optional text label displayed below the dial.
  final String? label;
  
  /// Whether to show the current value below the dial.
  /// 
  /// Defaults to true.
  final bool showValue;
  
  /// Optional custom painter to override the default dial appearance.
  final CustomPainter? painter;

  @override
  State<AudioDial> createState() => _AudioDialState();
}

class _AudioDialState extends State<AudioDial> with TickerProviderStateMixin {
  bool _isDragging = false;
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;
  double _previousValue = 0;

  late final Future<void> Function(DragStartDetails) _handlePanStart;
  late final void Function(DragEndDetails) _handlePanEnd;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.value;

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 1).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _handlePanStart = createPanStartHandler(
      setDragging: (value) => setState(() => _isDragging = value),
      controller: _pulseController,
    );

    _handlePanEnd = createPanEndHandler(
      setDragging: (value) => setState(() => _isDragging = value),
      controller: _pulseController,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
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
          (widget.label != null ? 40 : 0) +
          (widget.showValue ? 20 : 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: AnimatedBuilder(
              animation: Listenable.merge([_pulseAnimation, _glowAnimation]),
              builder: (context, child) => Transform.scale(
                scale: _isDragging ? _pulseAnimation.value : 1.0,
                child: CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter:
                      widget.painter ??
                      DefaultAudioDialPainter(
                        value: widget.value,
                        min: widget.min,
                        max: widget.max,
                        strokeWidth: widget.strokeWidth,
                        dialColor: widget.dialColor,
                        trackColor: widget.trackColor,
                        thumbColor: widget.thumbColor,
                        activeColor: widget.activeColor,
                        isDragging: _isDragging,
                        glowIntensity: _glowAnimation.value,
                      ),
                ),
              ),
            ),
          ),
          if (widget.showValue) ...[
            const SizedBox(height: 8),
            Text(
              '${widget.value.round()}',
              style: TextStyle(
                color: widget.activeColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (widget.label != null) ...[
            const SizedBox(height: 4),
            Text(
              widget.label!,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    ),
  );

  void _handlePanUpdate(DragUpdateDetails details) {
    handleDialPanUpdate(
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
}
