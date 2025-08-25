import 'package:audio_widgets/audio_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'custom_test_painters.dart';

// Reusable test functions
Future<void> testAudioDialRendersCorrectly(WidgetTester tester) async {
  var testValue = 50.0;

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: AudioDial(
            value: testValue,
            onChanged: (value) => testValue = value,
            label: 'Test Dial',
          ),
        ),
      ),
    ),
  );

  expect(find.text('Test Dial'), findsOneWidget);
  expect(find.text('50'), findsOneWidget);

  // Generate golden only in widget test mode, not integration test mode
  if (!isIntegrationTestMode()) {
    await expectLater(
      find.byType(AudioDial),
      matchesGoldenFile('goldens/audio_dial_default.png'),
    );
  }
}

Future<void> testAudioKnobRendersCorrectly(WidgetTester tester) async {
  var testValue = 30.0;

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: AudioKnob(
            value: testValue,
            onChanged: (value) => testValue = value,
            label: 'Test Knob',
          ),
        ),
      ),
    ),
  );

  expect(find.text('Test Knob'), findsOneWidget);
  expect(find.text('30'), findsOneWidget);

  // Generate golden only in widget test mode, not integration test mode
  if (!isIntegrationTestMode()) {
    await expectLater(
      find.byType(AudioKnob),
      matchesGoldenFile('goldens/audio_knob_default.png'),
    );
  }
}

Future<void> testEqualizerRendersWithoutOverflow(WidgetTester tester) async {
  // Build the equalizer widget
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: Equalizer(
            bands: const [0, 2, -1, 5, -3, 1, 4, -2, 3, 0],
            onChanged: (bands) {},
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
    ),
  );

  // Check for render overflow errors
  expect(tester.takeException(), isNull);

  // Verify the equalizer is rendered
  expect(find.byType(Equalizer), findsOneWidget);

  // Verify all sliders are created
  expect(find.byType(AudioSlider), findsNWidgets(10));

  // Generate golden only in widget test mode, not integration test mode
  if (!isIntegrationTestMode()) {
    await expectLater(
      find.byType(Equalizer),
      matchesGoldenFile('goldens/equalizer_default.png'),
    );
  }
}

Future<void> testAudioSliderVerticalRendersCorrectly(
  WidgetTester tester,
) async {
  var testValue = 60.0;

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: AudioSlider(
            value: testValue,
            onChanged: (value) => testValue = value,
            label: 'Volume',
          ),
        ),
      ),
    ),
  );

  expect(find.text('Volume'), findsOneWidget);
  expect(find.byType(AudioSlider), findsNWidgets(1));

  // Generate golden only in widget test mode, not integration test mode
  if (!isIntegrationTestMode()) {
    await expectLater(
      find.byType(AudioSlider),
      matchesGoldenFile('goldens/audio_slider_vertical.png'),
    );
  }
}

Future<void> testVUMeterRendersCorrectly(WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: Scaffold(
        body: Center(
          child: VUMeter(
            leftLevel: 0.6,
            rightLevel: 0.8,
            label: 'Main Output',
            width: 300,
            height: 50,
          ),
        ),
      ),
    ),
  );

  expect(find.text('Main Output'), findsOneWidget);
  expect(find.byType(VUMeter), findsOneWidget);

  // Generate golden only in widget test mode, not integration test mode
  if (!isIntegrationTestMode()) {
    await expectLater(
      find.byType(VUMeter),
      matchesGoldenFile('goldens/vu_meter_default.png'),
    );
  }
}

Future<void> testAudioKnobRespondsToGestures(WidgetTester tester) async {
  var currentValue = 50.0;
  var changeCount = 0;

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: AudioKnob(
            value: currentValue,
            onChanged: (value) {
              currentValue = value;
              changeCount++;
            },
            label: 'Interactive Knob',
          ),
        ),
      ),
    ),
  );

  // Capture initial state
  expect(find.byType(AudioKnob), findsOneWidget);

  // Test pan gesture with proper sequence 
  final customPaintWidget = find.descendant(
    of: find.byType(AudioKnob),
    matching: find.byType(CustomPaint),
  );
  expect(customPaintWidget, findsOneWidget);
  
  // Try a direct drag approach on the CustomPaint area
  await tester.drag(customPaintWidget, const Offset(50, 0));
  await tester.pumpAndSettle();

  // Verify the knob actually changed value
  expect(currentValue, isNot(equals(50.0)));
  expect(changeCount, greaterThan(0));

  // Verify knob still exists and interaction worked
  expect(find.byType(AudioKnob), findsOneWidget);
}

Future<void> testAudioDialHandlesExtremeValues(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: AudioDial(
            value: 0,
            onChanged: (value) {},
            label: 'Zero Value',
          ),
        ),
      ),
    ),
  );

  expect(find.text('0'), findsOneWidget);
  expect(tester.takeException(), isNull);
}

Future<void> testMixedCustomAndDefaultPainters(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Default painter
            AudioDial(
              value: 50,
              onChanged: (value) {},
              label: 'Default',
              size: 80,
            ),
            // Custom painter
            AudioDial(
              value: 50,
              onChanged: (value) {},
              painter: TestAudioDialPainter(value: 50, min: 0, max: 100),
              label: 'Custom',
              size: 80,
            ),
          ],
        ),
      ),
    ),
  );

  await tester.pump();
  expect(find.byType(AudioDial), findsNWidgets(2));
  expect(find.text('Default'), findsOneWidget);
  expect(find.text('Custom'), findsOneWidget);
  expect(tester.takeException(), isNull);

  // Generate golden only in widget test mode, not integration test mode
  if (!isIntegrationTestMode()) {
    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/mixed_default_custom_painters.png'),
    );
  }
}

// Global flag to track integration test mode
bool _isIntegrationTestMode = false;

void setupIntegrationTest() {
  // Integration test setup - can be customized as needed
  _isIntegrationTestMode = true;
}

bool isIntegrationTestMode() => _isIntegrationTestMode;
