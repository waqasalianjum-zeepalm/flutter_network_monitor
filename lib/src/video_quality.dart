/// Defines different video quality levels based on internet speed.
enum VideoQuality {
  /// Represents low quality video at 140p.
  low_140p,

  /// Represents standard definition (SD) video at 480p.
  standard_480p,

  /// Represents high definition (HD) video at 720p.
  hd_720p,

  /// Represents full high definition (Full HD) video at 1080p.
  fullHd_1080p,
}

/// A utility class to determine the appropriate [VideoQuality] based on internet speed.
class VideoQualityDeterminer {
  /// Minimum internet speed required (in Mbps) for different video qualities.
  static const double _speedFor480p = 2.5; // 480p requires at least 2.5 Mbps.
  static const double _speedFor720p = 5.0; // 720p requires at least 5 Mbps.
  static const double _speedFor1080p = 8.0; // 1080p requires at least 8 Mbps.

  /// Determines the best possible [VideoQuality] based on the given [speedInMbps].
  ///
  /// Returns:
  /// - [VideoQuality.fullHd_1080p] if speed is **8 Mbps or higher**.
  /// - [VideoQuality.hd_720p] if speed is **between 5 Mbps and 7.99 Mbps**.
  /// - [VideoQuality.standard_480p] if speed is **between 2.5 Mbps and 4.99 Mbps**.
  /// - [VideoQuality.low_140p] if speed is **below 2.5 Mbps**.
  ///
  /// Example:
  /// ```dart
  /// double internetSpeed = 6.0; // 6 Mbps
  /// VideoQuality quality = VideoQualityDeterminer.determineQuality(internetSpeed);
  /// print(quality); // Output: VideoQuality.hd_720p
  /// ```
  static VideoQuality determineQuality(double speedInMbps) {
    if (speedInMbps >= _speedFor1080p) {
      return VideoQuality.fullHd_1080p;
    } else if (speedInMbps >= _speedFor720p) {
      return VideoQuality.hd_720p;
    } else if (speedInMbps >= _speedFor480p) {
      return VideoQuality.standard_480p;
    } else {
      return VideoQuality.low_140p;
    }
  }

  /// Converts a [VideoQuality] enum into a user-friendly string.
  ///
  /// Example:
  /// ```dart
  /// VideoQuality quality = VideoQuality.hd_720p;
  /// String qualityStr = VideoQualityDeterminer.getQualityString(quality);
  /// print(qualityStr); // Output: "720p"
  /// ```
  static String getQualityString(VideoQuality quality) {
    switch (quality) {
      case VideoQuality.low_140p:
        return "144p";
      case VideoQuality.standard_480p:
        return "480p";
      case VideoQuality.hd_720p:
        return "720p";
      case VideoQuality.fullHd_1080p:
        return "1080p";
    }
  }
}
