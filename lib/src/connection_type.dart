import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

enum NetworkType {
  wifi,
  mobile,
  ethernet,
  none,
}

class ConnectionTypeMonitor {
  final Connectivity _connectivity = Connectivity();
  final StreamController<NetworkType> _controller =
      StreamController<NetworkType>.broadcast();

  ConnectionTypeMonitor() {
    _init();
  }

  void _init() async {
    // Initial connection check
    NetworkType initialType = await checkConnectionType();
    _controller.add(initialType);

    // Monitor for changes
    _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) async {
      // Use the first result or default to none if empty
      ConnectivityResult result =
          results.isNotEmpty ? results.first : ConnectivityResult.none;
      NetworkType type = _mapConnectivityResult(result);
      _controller.add(type);
    });
  }

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

  Future<NetworkType> checkConnectionType() async {
    final List<ConnectivityResult> results =
        await _connectivity.checkConnectivity();
    final ConnectivityResult result =
        results.isNotEmpty ? results.first : ConnectivityResult.none;
    return _mapConnectivityResult(result);
  }

  Stream<NetworkType> get onConnectivityChanged => _controller.stream;

  void dispose() {
    _controller.close();
  }
}
