import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Represents different types of network connections.
enum NetworkType {
  /// Connected to a Wi-Fi network.
  wifi,

  /// Connected to a mobile network (cellular).
  mobile,

  /// Connected via an Ethernet cable.
  ethernet,

  /// No active network connection.
  none,
}

/// Monitors the type of network connection in real-time.
///
/// This class uses the [connectivity_plus] package to detect network type changes
/// and provides a stream of [NetworkType] updates.
class ConnectionTypeMonitor {
  /// Creates an instance of [ConnectionTypeMonitor] and starts monitoring network changes.
  ConnectionTypeMonitor() {
    _init();
  }
  final Connectivity _connectivity = Connectivity();
  final StreamController<NetworkType> _controller =
      StreamController<NetworkType>.broadcast();

  /// Initializes network monitoring and emits the initial network type.
  void _init() async {
    // Initial connection check
    NetworkType initialType = await checkConnectionType();
    _controller.add(initialType);

    // Listen for network changes
    _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) async {
      // Use the first result or default to none if empty
      ConnectivityResult result =
          results.isNotEmpty ? results.first : ConnectivityResult.none;
      NetworkType type = _mapConnectivityResult(result);
      _controller.add(type);
    });
  }

  /// Maps [ConnectivityResult] from the `connectivity_plus` package to a [NetworkType].
  NetworkType _mapConnectivityResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return NetworkType.wifi;
      case ConnectivityResult.mobile:
        return NetworkType.mobile;
      case ConnectivityResult.ethernet:
        return NetworkType.ethernet;
      default:
        return NetworkType.none;
    }
  }

  /// Returns the current network type by checking connectivity.
  ///
  /// Example:
  /// ```dart
  /// NetworkType type = await ConnectionTypeMonitor().checkConnectionType();
  /// print(type); // Output: NetworkType.wifi or NetworkType.mobile
  /// ```
  Future<NetworkType> checkConnectionType() async {
    final List<ConnectivityResult> results =
        await _connectivity.checkConnectivity();
    final ConnectivityResult result =
        results.isNotEmpty ? results.first : ConnectivityResult.none;
    return _mapConnectivityResult(result);
  }

  /// A stream that emits network type changes in real-time.
  ///
  /// Example usage:
  /// ```dart
  /// final monitor = ConnectionTypeMonitor();
  /// monitor.onConnectivityChanged.listen((NetworkType type) {
  ///   print('Network changed to: $type');
  /// });
  /// ```
  Stream<NetworkType> get onConnectivityChanged => _controller.stream;

  /// Disposes the stream controller when no longer needed.
  void dispose() {
    _controller.close();
  }
}
