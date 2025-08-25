/// Constants used by the default audio knob painter for arc positioning.
/// 
/// This class defines the angular configuration for the knob's arc,
/// including the starting position and sweep angle for the interactive
/// range of the audio knob control.
abstract class DefaultAudioKnobPainterConstants {
  /// Ratio determining the starting angle of the knob arc.
  /// 
  /// This value is multiplied by 2π to get the actual starting angle
  /// in radians. A value of 0.625 positions the start at approximately
  /// the 5 o'clock position.
  static const double startAngleRatio = 0.625;
  /// Ratio determining the sweep angle of the knob arc.
  /// 
  /// This value is multiplied by 2π to get the actual sweep angle
  /// in radians. A value of 1.25 creates an arc that spans 270 degrees
  /// (3/4 of a full circle), providing a good range for knob control.
  static const double sweepAngleRatio = 1.25;
}
