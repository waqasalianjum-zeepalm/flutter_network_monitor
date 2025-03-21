import '../src/connection_quality.dart';
import '../src/connection_type.dart';
import '../src/video_quality.dart';

/// Represents network information, including speed, type, video quality,
/// connection quality, and timestamp.
class NetworkInfo {
  /// Creates a new instance of [NetworkInfo].
  ///
  /// If no [timestamp] is provided, the current time is used.
  NetworkInfo({
    required this.downloadSpeed,
    required this.uploadSpeed,
    required this.networkType,
    required this.videoQuality,
    required this.connectionQuality,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// The measured download speed in Mbps.
  final double downloadSpeed;

  /// The measured upload speed in Mbps.
  final double uploadSpeed;

  /// The type of network (e.g., WiFi, Mobile).
  final NetworkType networkType;

  /// The estimated video quality based on network speed.
  final VideoQuality videoQuality;

  /// The determined connection quality.
  final ConnectionQuality connectionQuality;

  /// The timestamp when the network information was recorded.
  final DateTime timestamp;

  /// Converts the network info to a JSON-friendly format.
  Map<String, dynamic> toJson() {
    return {
      'downloadSpeed': downloadSpeed,
      'uploadSpeed': uploadSpeed,
      'networkType': networkType.toString().split('.').last,
      'videoQuality': VideoQualityDeterminer.getQualityString(videoQuality),
      'connectionQuality':
          ConnectionQualityDeterminer.getQualityString(connectionQuality),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Returns a human-readable string representation of the network info.
  @override
  String toString() {
    return '''
NetworkInfo {
  downloadSpeed: ${downloadSpeed.toStringAsFixed(2)} Mbps,
  uploadSpeed: ${uploadSpeed.toStringAsFixed(2)} Mbps,
  networkType: ${networkType.toString().split('.').last},
  videoQuality: ${VideoQualityDeterminer.getQualityString(videoQuality)},
  connectionQuality: ${ConnectionQualityDeterminer.getQualityString(connectionQuality)},
  timestamp: $timestamp
}''';
  }
}
