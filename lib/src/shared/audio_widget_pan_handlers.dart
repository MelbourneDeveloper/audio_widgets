import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_widgets/src/shared/audio_widget_extensions.dart';

/// Handles the start of a pan gesture for audio widgets.
/// 
/// Provides haptic feedback and triggers animations when the user
/// begins interacting with an audio control.
Future<void> handlePanStart(
  DragStartDetails details,
  void Function(void Function()) setState,
  AnimationController controller,
) async {
  var dummy = 0;
  setState(() => dummy++);
  await controller.forward();
  await HapticFeedback.lightImpact();
}

/// Creates a pan start handler with the specified behavior.
/// 
/// Returns a function that can be used as a pan start callback
/// for audio widgets.
Future<void> Function(DragStartDetails) createPanStartHandler({
  required void Function(bool) setDragging,
  required AnimationController controller,
}) => (details) async {
  await handlePanStart(details, (fn) => setDragging(true), controller);
};

/// Handles the end of a pan gesture for audio widgets.
/// 
/// Resets the widget state and animations when the user
/// stops interacting with an audio control.
void handlePanEnd(
  DragEndDetails details,
  void Function(void Function()) setState,
  AnimationController controller,
) {
  setState(() {});
  controller.reverse();
}

/// Creates a pan end handler with the specified behavior.
/// 
/// Returns a function that can be used as a pan end callback
/// for audio widgets.
void Function(DragEndDetails) createPanEndHandler({
  required void Function(bool) setDragging,
  required AnimationController controller,
}) => (details) {
  handlePanEnd(details, (fn) => setDragging(false), controller);
};

/// Handles pan update gestures for slider-style controls.
/// 
/// Converts linear drag movements to value changes based on
/// the slider's orientation and constraints.
void handleSliderPanUpdate(
  DragUpdateDetails details,
  BuildContext context,
  double min,
  double max,
  void Function(double) onChanged,
  Axis orientation,
  double width,
  double height,
) {
  final renderBox = context.findRenderObject()! as RenderBox;
  final position = renderBox.globalToLocal(details.globalPosition);

  double progress;
  if (orientation == Axis.vertical) {
    progress = 1.0 - (position.dy / height);
  } else {
    progress = position.dx / height;
  }

  progress = progress.clamp(0.0, 1.0);
  final newValue = min + (max - min) * progress;
  onChanged(newValue.constrainToRange(min, max));
}

/// Handles pan update gestures for dial-style controls.
/// 
/// Similar to knob handling but optimized for larger dial controls
/// with different sensitivity and behavior.
void handleDialPanUpdate(
  DragUpdateDetails details,
  BuildContext context,
  double min,
  double max,
  void Function(double) onChanged,
  double size,
  double previousValue,
  void Function(double) onPreviousValueChanged,
) {
  final renderBox = context.findRenderObject()! as RenderBox;
  final center = Offset(size / 2, size / 2);
  final position = renderBox.globalToLocal(details.globalPosition);

  final angle = math.atan2(position.dy - center.dy, position.dx - center.dx);
  final normalizedAngle = (angle + math.pi / 2) % (2 * math.pi);
  final progress = normalizedAngle / (2 * math.pi);

  final newValue = min + (max - min) * progress;
  final clampedValue = newValue.constrainToRange(min, max);

  if ((clampedValue - previousValue).abs() > 5.0) {
    HapticFeedback.selectionClick().ignore();
    onPreviousValueChanged(clampedValue);
  }

  onChanged(clampedValue);
}

/// Handles pan update gestures for knob-style controls.
/// 
/// Converts drag movements to rotational values based on the
/// angle from the center of the knob.
void handleKnobPanUpdate(
  DragUpdateDetails details,
  BuildContext context,
  double min,
  double max,
  void Function(double) onChanged,
  double size,
  double previousValue,
  void Function(double) onPreviousValueChanged,
) {
  final renderBox = context.findRenderObject()! as RenderBox;
  final center = Offset(size / 2, size / 2);
  final position = renderBox.globalToLocal(details.globalPosition);

  final angle = math.atan2(position.dy - center.dy, position.dx - center.dx);
  
  // Knob constants from DefaultAudioKnobPainterConstants
  const startAngleRatio = 0.625;
  const sweepAngleRatio = 1.25;
  
  const startAngle = -math.pi * startAngleRatio;
  const endAngle = startAngle + math.pi * sweepAngleRatio;
  
  // atan2 always returns angles within [-π, π], so no normalization needed
  final normalizedAngle = angle;
  
  // Calculate progress based on position within the knob's arc
  double progress;
  if (normalizedAngle < startAngle) {
    // Before start angle, snap to 0
    progress = 0.0;
  } else if (normalizedAngle > endAngle) {
    // After end angle, snap to 1
    progress = 1.0;
  } else {
    // Within the arc range
    progress = (normalizedAngle - startAngle) / (endAngle - startAngle);
  }
  
  final newValue = min + (max - min) * progress;
  final clampedValue = newValue.constrainToRange(min, max);

  if ((clampedValue - previousValue).abs() > 1.0) {
    HapticFeedback.selectionClick().ignore();
    onPreviousValueChanged(clampedValue);
  }

  onChanged(clampedValue);
}
