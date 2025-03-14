enum ConnectionQuality {
  poor,
  moderate,
  good,
  excellent,
}

class ConnectionQualityDeterminer {
  static const double _poorThreshold = 2.0; // Below 2 Mbps is poor
  static const double _moderateThreshold = 5.0; // Below 5 Mbps is moderate
  static const double _goodThreshold =
      10.0; // Below 10 Mbps is good, above is excellent

  static ConnectionQuality determineQuality(double speedInMbps) {
    if (speedInMbps < _poorThreshold) {
      return ConnectionQuality.poor;
    } else if (speedInMbps < _moderateThreshold) {
      return ConnectionQuality.moderate;
    } else if (speedInMbps < _goodThreshold) {
      return ConnectionQuality.good;
    } else {
      return ConnectionQuality.excellent;
    }
  }

  static String getQualityString(ConnectionQuality quality) {
    switch (quality) {
      case ConnectionQuality.poor:
        return "Poor";
      case ConnectionQuality.moderate:
        return "Moderate";
      case ConnectionQuality.good:
        return "Good";
      case ConnectionQuality.excellent:
        return "Excellent";
    }
  }
}
