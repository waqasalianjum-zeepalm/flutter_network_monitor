import 'dart:async';
import 'package:http/http.dart' as http;

/// A class to measure internet speed by testing download and upload speeds.
///
/// This class provides methods to test download and upload speeds in Mbps (Megabits per second).
class SpeedTest {
  /// Creates a [SpeedTest] instance with a default test URL and file size.
  ///
  /// The default [_testUrl] is a Cloudflare test file of 10MB.
  /// The default [_fileSizeInBytes] is 10MB (10,000,000 bytes).
  SpeedTest({
    String testUrl = 'https://speed.cloudflare.com/__down?bytes=10000000',
    int fileSizeInBytes = 10000000,
  })  : _testUrl = testUrl,
        _fileSizeInBytes = fileSizeInBytes;
  final String _testUrl;
  final int _fileSizeInBytes;

  /// Tests the **download speed** by fetching a test file from the internet.
  ///
  /// Returns the download speed in **Mbps (Megabits per second)**.
  ///
  /// Example usage:
  /// ```dart
  /// final speedTest = SpeedTest();
  /// double downloadSpeed = await speedTest.testDownloadSpeed();
  /// print('Download Speed: $downloadSpeed Mbps');
  /// ```
  ///
  /// Throws an exception if the test fails.
  Future<double> testDownloadSpeed() async {
    try {
      final stopwatch = Stopwatch()..start();

      final response = await http.get(Uri.parse(_testUrl));

      stopwatch.stop();

      if (response.statusCode == 200) {
        // Calculate speed in Mbps (Megabits per second)
        final durationInSeconds = stopwatch.elapsedMilliseconds / 1000;
        final bitsTransferred = response.bodyBytes.length * 8;
        final speedInMbps = (bitsTransferred / durationInSeconds) / 1000000;

        return speedInMbps;
      } else {
        throw Exception('Failed to load test file: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Speed test failed: $e');
    }
  }

  /// Tests the **upload speed** by sending a random data file to a test server.
  ///
  /// Returns the upload speed in **Mbps (Megabits per second)**.
  ///
  /// Example usage:
  /// ```dart
  /// final speedTest = SpeedTest();
  /// double uploadSpeed = await speedTest.testUploadSpeed();
  /// print('Upload Speed: $uploadSpeed Mbps');
  /// ```
  ///
  /// Throws an exception if the test fails.
  Future<double> testUploadSpeed() async {
    try {
      // Generate random data for upload test
      final data = List<int>.filled(_fileSizeInBytes, 0);

      final stopwatch = Stopwatch()..start();

      final response = await http.post(
        Uri.parse('https://httpbin.org/post'),
        body: data,
      );

      stopwatch.stop();

      if (response.statusCode == 200) {
        // Calculate speed in Mbps (Megabits per second)
        final durationInSeconds = stopwatch.elapsedMilliseconds / 1000;
        final bitsTransferred = data.length * 8;
        final speedInMbps = (bitsTransferred / durationInSeconds) / 1000000;

        return speedInMbps;
      } else {
        throw Exception('Failed to upload test file: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Upload speed test failed: $e');
    }
  }
}
