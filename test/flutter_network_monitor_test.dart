import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_network_monitor/flutter_network_monitor.dart';

void main() {
  test('Check if network quality is properly classified', () {
    final quality =
        ConnectionQualityDeterminer.determineQuality(0.5); // Example test case
    expect(quality, ConnectionQuality.poor);
  });
}
