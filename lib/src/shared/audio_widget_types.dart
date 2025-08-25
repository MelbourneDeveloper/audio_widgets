import 'package:flutter/material.dart';

/// Callback function type for when a widget's value changes.
typedef OnValueChanged = void Function(double value);

/// Record type defining a numeric range with minimum and maximum values.
typedef ValueRange = ({double min, double max});

/// Record type defining colors for track, active, and thumb elements.
typedef ColorConfig = ({Color track, Color active, Color thumb});

/// Callback function type for handling pan start gestures.
/// 
/// Used by audio widgets to handle the beginning of drag gestures.
typedef PanStartCallback =
    Future<void> Function(
      DragStartDetails details,
      void Function(void Function()) setState,
      AnimationController controller,
    );

/// Callback function type for handling pan update gestures.
/// 
/// Used by audio widgets to handle ongoing drag gestures and convert
/// them to value changes.
typedef PanUpdateCallback =
    void Function(
      DragUpdateDetails details,
      BuildContext context,
      double min,
      double max,
      void Function(double) onChanged, {
      Axis? orientation,
      double? width,
      double? height,
      double? size,
      double? previousValue,
      void Function(double)? onPreviousValueChanged,
    });

/// Callback function type for handling pan end gestures.
/// 
/// Used by audio widgets to handle the end of drag gestures.
typedef PanEndCallback =
    void Function(
      DragEndDetails details,
      void Function(void Function()) setState,
      AnimationController controller,
    );

/// Function type for converting angles to values in rotary controls.
/// 
/// Used by knobs and dials to map rotation angles to numeric values.
typedef AngleToValueConverter = double Function(double angle);
