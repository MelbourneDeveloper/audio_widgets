/// Constants used by the default audio slider painter for styling and layout.
/// 
/// This class contains all the configuration values for visual styling,
/// dimensions, opacity values, and other parameters used in rendering
/// the audio slider components.
abstract class DefaultAudioSliderPainterConstants {
  /// Ratio of track width relative to the slider height.
  static const double trackWidthRatio = 0.8;
  /// Opacity of the drop shadow effect.
  static const double shadowOpacity = 0.4;
  /// Blur radius for the drop shadow effect in logical pixels.
  static const double shadowBlurRadius = 6;
  /// Starting opacity for the track gradient effect.
  static const double trackGradientStart = 0.3;
  /// Middle opacity for the track gradient effect.
  static const double trackGradientMid = 0.1;
  /// Ending opacity for the track gradient effect.
  static const double trackGradientEnd = 0.2;
  /// Opacity of the rim or border effect.
  static const double rimOpacity = 0.1;
  /// Color interpolation ratio for active state styling.
  static const double activeLerpRatio = 0.3;
  /// Ending opacity for the active state gradient.
  static const double activeGradientEnd = 0.8;
  /// Ratio for positioning the highlight effect offset.
  static const double highlightOffsetRatio = 0.15;
  /// Ratio determining the width of the highlight effect.
  static const double highlightWidthRatio = 0.3;
  /// Opacity of the highlight effect.
  static const double highlightOpacity = 0.4;
  /// Height ratio for horizontal track relative to widget height.
  static const double horizontalTrackHeightRatio = 0.4;
  /// Number of notch marks to display on the slider.
  static const int notchCount = 11;
  /// Height of slider endpoint indicators in logical pixels.
  static const double endpointHeight = 3;
  /// Width of slider endpoint indicators in logical pixels.
  static const double endpointWidth = 3;
  /// Length ratio for main notch marks relative to track width.
  static const double notchMainLengthRatio = 0.4;
  /// Length ratio for minor notch marks relative to track width.
  static const double notchMinorLengthRatio = 0.25;
  /// Stroke width for main notch marks in logical pixels.
  static const double notchMainStrokeWidth = 1.5;
  /// Stroke width for minor notch marks in logical pixels.
  static const double notchMinorStrokeWidth = 1;
  /// Opacity of main notch marks.
  static const double notchMainOpacity = 0.6;
  /// Opacity of minor notch marks.
  static const double notchMinorOpacity = 0.3;
  /// Offset distance for notch marks in logical pixels.
  static const double notchOffset = 4;
  /// Spacing between notch marks in logical pixels.
  static const double notchSpacing = 8;
  /// Opacity of text labels and indicators.
  static const double textOpacity = 0.7;
  /// Font size for text labels in logical pixels.
  static const double textSize = 10;
  /// Starting opacity for endpoint gradient effect.
  static const double endpointGradientStart = 0.95;
  /// Middle opacity for endpoint gradient effect.
  static const double endpointGradientMid = 0.9;
  /// Ending opacity for endpoint gradient effect.
  static const double endpointGradientEnd = 0.8;
  /// Opacity of endpoint highlight effect.
  static const double endpointHighlightOpacity = 0.9;
  /// Opacity of endpoint rim or border effect.
  static const double endpointRimOpacity = 0.3;
  /// Stroke width for endpoint rim in logical pixels.
  static const double endpointRimStrokeWidth = 0.5;
}
