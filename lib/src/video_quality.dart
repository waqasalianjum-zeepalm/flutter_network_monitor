enum VideoQuality {
  low_140p,
  standard_480p,
  hd_720p,
  fullHd_1080p,
}

class VideoQualityDeterminer {
  // Minimum speed requirements for different video qualities in Mbps
  static const double _speedFor480p = 2.5; // 480p requires minimum 2.5 Mbps
  static const double _speedFor720p = 5.0; // 720p requires minimum 5 Mbps
  static const double _speedFor1080p = 8.0; // 1080p requires minimum 8 Mbps

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
