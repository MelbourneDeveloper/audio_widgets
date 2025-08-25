# Flutter Audio Widgets

Professional audio controls for Flutter. Create stunning audio interfaces with smooth, interactive widgets inspired by high-end audio equipment. Perfect for virtual instruments (VSTs)

![Example App](https://github.com/MelbourneDeveloper/flutter_audio_widgets/raw/main/Example.png) 
Try the [live sample here](https://melbournedeveloper.github.io/flutter_audio_widgets/)

Coming soon... A full Steinberg VST3 Bridge SDK for Flutter. Watch this space!

## Usage

```dart
import 'package:flutter_audio_widgets/audio_widgets.dart';

// Circular dial
AudioDial(
  value: _dialValue,
  onChanged: (value) => setState(() => _dialValue = value),
  min: 0.0,
  max: 100.0,
)

// Compact knob
AudioKnob(
  value: _knobValue,
  onChanged: (value) => setState(() => _knobValue = value),
  label: 'Gain',
)

// Vertical slider
AudioSlider(
  value: _sliderValue,
  onChanged: (value) => setState(() => _sliderValue = value),
  orientation: Axis.vertical,
  height: 200.0,
)

// VU meter
VUMeter(
  leftLevel: _leftLevel,
  rightLevel: _rightLevel,
  showPeakHold: true,
)

// Multi-band equalizer
Equalizer(
  bands: _eqBands,
  onChanged: (bands) => setState(() => _eqBands = bands),
  bandLabels: ['31Hz', '63Hz', '125Hz', '250Hz', '500Hz'],
)
```

All widgets support extensive customization including colors, sizes, labels, animations, and dark mode themes.