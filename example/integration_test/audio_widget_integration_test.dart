import 'package:flutter_test/flutter_test.dart';
import '../../test/audio_widget_test_functions.dart';

void main() {
  group('AudioWidget Integration Tests', () {
    testWidgets('AudioDial renders correctly', (tester) async {
      setupIntegrationTest();
      await testAudioDialRendersCorrectly(tester);
    });

    testWidgets('AudioKnob renders correctly', (tester) async {
      setupIntegrationTest();
      await testAudioKnobRendersCorrectly(tester);
    });

    testWidgets('AudioSlider vertical renders correctly', (tester) async {
      setupIntegrationTest();
      await testAudioSliderVerticalRendersCorrectly(tester);
    });

    testWidgets('VUMeter renders correctly', (tester) async {
      setupIntegrationTest();
      await testVUMeterRendersCorrectly(tester);
    });

    testWidgets('Equalizer renders without overflow', (tester) async {
      setupIntegrationTest();
      await testEqualizerRendersWithoutOverflow(tester);
    });

    testWidgets('AudioKnob responds to gestures', (tester) async {
      setupIntegrationTest();
      await testAudioKnobRespondsToGestures(tester);
    });

    testWidgets('AudioDial handles extreme values', (tester) async {
      setupIntegrationTest();
      await testAudioDialHandlesExtremeValues(tester);
    });

    testWidgets('Mixed custom and default painters work together', (
      tester,
    ) async {
      setupIntegrationTest();
      await testMixedCustomAndDefaultPainters(tester);
    });
  });

  group('AudioWidget Advanced Integration Tests', () {
    testWidgets('Complex widget interaction workflow', (tester) async {
      setupIntegrationTest();
      // Test multiple widgets working together
      await testAudioDialRendersCorrectly(tester);
      await testAudioKnobRendersCorrectly(tester);
      await testVUMeterRendersCorrectly(tester);
    });

    testWidgets('Widget state management workflow', (tester) async {
      setupIntegrationTest();
      await testAudioKnobRespondsToGestures(tester);
      await testAudioDialHandlesExtremeValues(tester);
    });

    testWidgets('Custom painter integration workflow', (tester) async {
      setupIntegrationTest();
      await testMixedCustomAndDefaultPainters(tester);
    });

    testWidgets('Equalizer advanced workflow', (tester) async {
      setupIntegrationTest();
      await testEqualizerRendersWithoutOverflow(tester);
    });
  });
}
