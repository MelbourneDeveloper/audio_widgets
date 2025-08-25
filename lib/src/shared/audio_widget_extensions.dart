/// Extensions on [double] for audio widget value manipulation.
extension AudioWidgetValues on double {
  /// Normalizes this value to a 0-1 range based on the given min and max.
  ///
  /// Returns a value between 0.0 and 1.0 representing the position of
  /// this value within the specified range.
  double normalizeToRange(double min, double max) => (this - min) / (max - min);

  /// Constrains this value to be within the specified range.
  ///
  /// Returns the value clamped between [min] and [max].
  double constrainToRange(double min, double max) => clamp(min, max).toDouble();
}
