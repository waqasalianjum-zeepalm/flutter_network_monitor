import '../src/connection_quality.dart';
import '../src/connection_type.dart';
import '../src/video_quality.dart';

class NetworkInfo {
  final double downloadSpeed;
  final double uploadSpeed;
  final NetworkType networkType;
  final VideoQuality videoQuality;
  final ConnectionQuality connectionQuality;
  final DateTime timestamp;

  NetworkInfo({
    required this.downloadSpeed,
    required this.uploadSpeed,
    required this.networkType,
    required this.videoQuality,
    required this.connectionQuality,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

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
