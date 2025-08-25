import 'package:audio_widgets/src/audio_slider.dart';
import 'package:audio_widgets/src/audio_widget_shared.dart';
import 'package:flutter/material.dart';

/// A multi-band equalizer control for audio applications.
/// 
/// The [Equalizer] widget provides multiple vertical sliders arranged
/// horizontally, typically used to adjust frequency bands in audio
/// applications. Each band can be adjusted independently within a
/// specified gain range.
class Equalizer extends StatefulWidget {
  /// Creates an [Equalizer] widget.
  ///
  /// The [bands] and [onChanged] parameters are required.
  /// Each value in [bands] must be between [minGain] and [maxGain].
  const Equalizer({
    required this.bands,
    required this.onChanged,
    super.key,
    this.width = 300.0,
    this.height = 200.0,
    this.minGain = -20.0,
    this.maxGain = 20.0,
    this.trackColor = const Color(0xFF1C1C1E),
    this.activeColor = const Color(0xFF007AFF),
    this.thumbColor = Colors.white,
    this.centerLineColor = Colors.grey,
    this.showLabels = true,
    this.bandLabels,
  });

  /// The current gain values for each frequency band.
  /// 
  /// Each value must be between [minGain] and [maxGain].
  final List<double> bands;
  
  /// Called when the user changes any band's gain value.
  final ValueChanged<List<double>> onChanged;
  
  /// The total width of the equalizer widget.
  /// 
  /// Defaults to 300.0.
  final double width;
  
  /// The height of the equalizer sliders.
  /// 
  /// Defaults to 200.0.
  final double height;
  
  /// The minimum gain value for each band (typically negative).
  /// 
  /// Defaults to -20.0.
  final double minGain;
  
  /// The maximum gain value for each band (typically positive).
  /// 
  /// Defaults to 20.0.
  final double maxGain;
  
  /// The color of the inactive portion of each slider track.
  /// 
  /// Defaults to a dark gray color.
  final Color trackColor;
  
  /// The color of the active portion of each slider track.
  /// 
  /// Defaults to blue.
  final Color activeColor;
  
  /// The color of the draggable thumbs on each slider.
  /// 
  /// Defaults to white.
  final Color thumbColor;
  
  /// The color of the center line (0 dB reference).
  /// 
  /// Defaults to gray.
  final Color centerLineColor;
  
  /// Whether to show frequency labels below each band.
  /// 
  /// Defaults to true.
  final bool showLabels;
  
  /// Optional custom labels for each frequency band.
  /// 
  /// If provided, must have the same length as [bands].
  /// If null, default frequency labels will be generated.
  final List<String>? bandLabels;

  @override
  State<Equalizer> createState() => _EqualizerState();
}

class _EqualizerState extends State<Equalizer> {
  late List<double> _currentBands;

  @override
  void initState() {
    super.initState();
    _currentBands = widget.bands
        .map((value) => validateValue(value, widget.minGain, widget.maxGain))
        .toList();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: widget.width,
    height: widget.height + (widget.showLabels ? 40 : 0),
    child: Column(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              _currentBands.length,
              (index) => Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: index == 0 || index == _currentBands.length - 1
                        ? 0
                        : 1,
                  ),
                  child: _buildEQSlider(index),
                ),
              ),
            ),
          ),
        ),
        if (widget.showLabels && widget.bandLabels != null) ...[
          const SizedBox(height: 8),
          SizedBox(
            width: widget.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: widget.bandLabels!
                  .map(
                    (label) => Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            shadows: [
                              Shadow(offset: Offset(0, 1), blurRadius: 2),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ],
    ),
  );

  Widget _buildEQSlider(int index) {
    final colorConfig = createColorConfig(
      trackColor: widget.trackColor,
      activeColor: widget.activeColor,
      thumbColor: widget.thumbColor,
    );

    return Container(
      height: widget.height,
      decoration: createEQContainerDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: AudioSlider(
          value: _currentBands[index],
          min: widget.minGain,
          max: widget.maxGain,
          onChanged: (value) {
            final validatedValue = validateValue(
              value,
              widget.minGain,
              widget.maxGain,
            );
            setState(() {
              _currentBands[index] = validatedValue;
            });
            widget.onChanged(List.from(_currentBands));
          },
          height: widget.height - 16,
          width: 36,
          activeColor: colorConfig.active,
          trackColor: colorConfig.track,
          showValue: false,
          showScale: false,
        ),
      ),
    );
  }
}
