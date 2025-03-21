/// Defines different levels of connection quality.
enum ConnectionQuality {
  /// Poor connection quality (below 2 Mbps).
  poor,

  /// Moderate connection quality (2 Mbps - 5 Mbps).
  moderate,

  /// Good connection quality (5 Mbps - 10 Mbps).
  good,

  /// Excellent connection quality (above 10 Mbps).
  excellent,
}

/// A utility class to determine network connection quality based on speed.
class ConnectionQualityDeterminer {
  /// Speed threshold for a **poor** connection (below 2 Mbps).
  static const double _poorThreshold = 2.0;

  /// Speed threshold for a **moderate** connection (2 - 5 Mbps).
  static const double _moderateThreshold = 5.0;

  /// Speed threshold for a **good** connection (5 - 10 Mbps).
  /// Anything above is considered **excellent**.
  static const double _goodThreshold = 10.0;

  /// Determines the [ConnectionQuality] based on the given [speedInMbps].
  ///
  /// - **< 2 Mbps** → `poor`
  /// - **2 - 5 Mbps** → `moderate`
  /// - **5 - 10 Mbps** → `good`
  /// - **> 10 Mbps** → `excellent`
  ///
  /// Example:
  /// ```dart
  /// ConnectionQuality quality = ConnectionQualityDeterminer.determineQuality(6.5);
  /// print(quality); // Output: ConnectionQuality.good
  /// ```
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

  /// Returns a user-friendly string representation of a [ConnectionQuality] value.
  ///
  /// Example:
  /// ```dart
  /// String qualityText = ConnectionQualityDeterminer.getQualityString(ConnectionQuality.good);
  /// print(qualityText); // Output: Good
  /// ```
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
