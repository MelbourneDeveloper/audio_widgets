import 'package:audio_widgets_example/app_root.dart';
import 'package:audio_widgets_example/digital_knob_painter.dart';
import 'package:audio_widgets_example/led_ring_knob_painter.dart';
import 'package:audio_widgets_example/metallic_knob_painter.dart';
import 'package:audio_widgets_example/neon_glow_knob_painter.dart';
import 'package:flutter/material.dart';
import 'package:audio_widgets/audio_widgets.dart';

void main() {
  runApp(const AppRoot());
}

class AudioWidgetDemo extends StatefulWidget {
  const AudioWidgetDemo({super.key});

  @override
  State<AudioWidgetDemo> createState() => _AudioWidgetDemoState();
}

class _AudioWidgetDemoState extends State<AudioWidgetDemo>
    with TickerProviderStateMixin {
  // 4 shared values that bind to all widgets (except EQ)
  double _value1 = 50.0;
  double _value2 = 75.0;
  double _value3 = 25.0;
  double _value4 = 80.0;

  List<double> _eqBands = [0, 2, -1, 5, -3, 1, 4, -2, 3, 0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0A0A),
              Color(0xFF16213E),
              Color(0xFF0E3A5E),
              Color(0xFF0A0A0A),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            children: [
              const Text(
                'audio_widgets',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Professional-grade audio widgets for Flutter',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 40),

              // Audio Dials Section
              _buildSection('Audio Dials', [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: AudioDial(
                          value: _value1,
                          onChanged: (value) => setState(() => _value1 = value),
                          label: 'Value 1',
                          activeColor: const Color(0xFF007AFF),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AudioDial(
                          value: _value2,
                          onChanged: (value) => setState(() => _value2 = value),
                          label: 'Value 2',
                          size: 100,
                          activeColor: const Color(0xFF34C759),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AudioDial(
                          value: _value3,
                          onChanged: (value) => setState(() => _value3 = value),
                          label: 'Value 3',
                          size: 100,
                          activeColor: const Color(0xFFFF9500),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AudioDial(
                          value: _value4,
                          onChanged: (value) => setState(() => _value4 = value),
                          label: 'Value 4',
                          size: 100,
                          activeColor: const Color(0xFFFF453A),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),

              const SizedBox(height: 40),

              // Audio Knobs Section
              _buildSection('Audio Knobs', [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: AudioKnob(
                          value: _value1,
                          onChanged: (value) => setState(() => _value1 = value),
                          label: 'Value 1',
                          activeColor: const Color(0xFF007AFF),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AudioKnob(
                          value: _value2,
                          onChanged: (value) => setState(() => _value2 = value),
                          label: 'Value 2',
                          size: 70,
                          activeColor: const Color(0xFF34C759),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AudioKnob(
                          value: _value3,
                          onChanged: (value) => setState(() => _value3 = value),
                          label: 'Value 3',
                          size: 70,
                          activeColor: const Color(0xFFFF9500),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AudioKnob(
                          value: _value4,
                          onChanged: (value) => setState(() => _value4 = value),
                          label: 'Value 4',
                          size: 70,
                          activeColor: const Color(0xFFFF453A),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),

              const SizedBox(height: 40),

              // Custom Painted Knobs Section
              _buildSection('Custom Painted Knobs', [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: AudioKnob(
                          value: _value1,
                          onChanged: (value) => setState(() => _value1 = value),
                          label: 'LED Ring',
                          activeColor: const Color(0xFF00FF41),
                          size: 85,
                          painter: LedRingKnobPainter(
                            value: _value1,
                            activeColor: const Color(0xFF00FF41),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AudioKnob(
                          value: _value2,
                          onChanged: (value) => setState(() => _value2 = value),
                          label: 'Neon Glow',
                          activeColor: const Color(0xFF9D00FF),
                          size: 85,
                          painter: NeonGlowKnobPainter(
                            value: _value2,
                            activeColor: const Color(0xFF9D00FF),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AudioKnob(
                          value: _value3,
                          onChanged: (value) => setState(() => _value3 = value),
                          label: 'Metallic',
                          activeColor: const Color(0xFFFFB000),
                          size: 85,
                          painter: MetallicKnobPainter(
                            value: _value3,
                            activeColor: const Color(0xFFFFB000),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AudioKnob(
                          value: _value4,
                          onChanged: (value) => setState(() => _value4 = value),
                          label: 'Digital',
                          activeColor: const Color(0xFF00D4FF),
                          size: 85,
                          painter: DigitalKnobPainter(
                            value: _value4,
                            activeColor: const Color(0xFF00D4FF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),

              const SizedBox(height: 40),

              // Sliders Section
              _buildSection('Audio Sliders', [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        child: AudioSlider(
                          value: _value1,
                          onChanged: (value) => setState(() => _value1 = value),
                          label: 'Value 1',
                          activeColor: const Color(0xFF007AFF),
                          height: 180,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: AudioSlider(
                          value: _value2,
                          onChanged: (value) => setState(() => _value2 = value),
                          label: 'Value 2',
                          activeColor: const Color(0xFF34C759),
                          height: 160,
                          width: 35,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: AudioSlider(
                          value: _value3,
                          onChanged: (value) => setState(() => _value3 = value),
                          label: 'Value 3',
                          activeColor: const Color(0xFFFF9500),
                          height: 160,
                          width: 35,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: AudioSlider(
                          value: _value4,
                          onChanged: (value) => setState(() => _value4 = value),
                          label: 'Value 4',
                          activeColor: const Color(0xFFFF453A),
                          height: 160,
                          width: 35,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'Value 1',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            AudioSlider(
                              value: _value1,
                              onChanged: (value) =>
                                  setState(() => _value1 = value),
                              activeColor: const Color(0xFF007AFF),
                              height: 350,
                              width: 20,
                              orientation: Axis.horizontal,
                              showScale: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'Value 2',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            AudioSlider(
                              value: _value2,
                              onChanged: (value) =>
                                  setState(() => _value2 = value),
                              activeColor: const Color(0xFF34C759),
                              height: 350,
                              width: 20,
                              orientation: Axis.horizontal,
                              showScale: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'Value 3',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            AudioSlider(
                              value: _value3,
                              onChanged: (value) =>
                                  setState(() => _value3 = value),
                              activeColor: const Color(0xFFFF9500),
                              height: 350,
                              width: 20,
                              orientation: Axis.horizontal,
                              showScale: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'Value 4',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            AudioSlider(
                              value: _value4,
                              onChanged: (value) =>
                                  setState(() => _value4 = value),
                              activeColor: const Color(0xFFFF453A),
                              height: 350,
                              width: 20,
                              orientation: Axis.horizontal,
                              showScale: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),

              const SizedBox(height: 40),

              // VU Meter Section
              _buildSection('VU Meters', [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: VUMeter(
                          leftLevel: _value1 / 100,
                          rightLevel: _value1 / 100,
                          label: 'Value 1',
                          width: 70,
                          height: 40,
                          segmentCount: 10,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: VUMeter(
                          leftLevel: _value2 / 100,
                          rightLevel: _value2 / 100,
                          label: 'Value 2',
                          width: 70,
                          height: 40,
                          segmentCount: 10,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: VUMeter(
                          leftLevel: _value3 / 100,
                          rightLevel: _value3 / 100,
                          label: 'Value 3',
                          width: 70,
                          height: 40,
                          segmentCount: 10,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: VUMeter(
                          leftLevel: _value4 / 100,
                          rightLevel: _value4 / 100,
                          label: 'Value 4',
                          width: 70,
                          height: 40,
                          segmentCount: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),

              const SizedBox(height: 40),

              // Equalizer Section
              _buildSection('Equalizer', [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Center(
                    child: Equalizer(
                      bands: _eqBands,
                      onChanged: (bands) => setState(() => _eqBands = bands),
                      width: 320,
                      height: 180,
                      bandLabels: const [
                        '31Hz',
                        '63Hz',
                        '125Hz',
                        '250Hz',
                        '500Hz',
                        '1kHz',
                        '2kHz',
                        '4kHz',
                        '8kHz',
                        '16kHz',
                      ],
                    ),
                  ),
                ),
              ]),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.05),
            Colors.white.withOpacity(0.02),
            Colors.black.withOpacity(0.1),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: -2,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white.withOpacity(0.1), Colors.transparent],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }
}
