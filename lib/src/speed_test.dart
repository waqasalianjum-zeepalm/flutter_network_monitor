import 'dart:async';
import 'package:http/http.dart' as http;

class SpeedTest {
  final String _testUrl;
  final int _fileSizeInBytes;

  SpeedTest({
    String testUrl = 'https://speed.cloudflare.com/__down?bytes=10000000',
    int fileSizeInBytes = 10000000,
  })  : _testUrl = testUrl,
        _fileSizeInBytes = fileSizeInBytes;

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
