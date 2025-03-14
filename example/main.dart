import 'package:flutter/material.dart';
import 'package:flutter_network_monitor/flutter_network_monitor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Network Monitor Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const NetworkMonitorPage(),
    );
  }
}

class NetworkMonitorPage extends StatefulWidget {
  const NetworkMonitorPage({super.key});

  @override
  State<NetworkMonitorPage> createState() => _NetworkMonitorPageState();
}

class _NetworkMonitorPageState extends State<NetworkMonitorPage> {
  // Create instances of your package classes
  final ConnectionTypeMonitor _connectionMonitor = ConnectionTypeMonitor();
  final SpeedTest _speedTest = SpeedTest();

  // Track network info
  NetworkInfo? _networkInfo;
  NetworkType _currentNetworkType = NetworkType.none;

  // Track UI state
  bool _isTestingSpeed = false;

  @override
  void initState() {
    super.initState();
    // Initialize connection monitoring
    _initConnectionMonitoring();
  }

  void _initConnectionMonitoring() async {
    // Get initial connection type
    _currentNetworkType = await _connectionMonitor.checkConnectionType();
    setState(() {});

    // Listen for changes in connection type
    _connectionMonitor.onConnectivityChanged.listen((NetworkType type) {
      setState(() {
        _currentNetworkType = type;
      });
    });
  }

  // Run a network speed test
  Future<void> _runSpeedTest() async {
    if (_currentNetworkType == NetworkType.none) {
      if (!mounted) return; // Ensure the widget is still in the tree
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No internet connection available')),
      );
      return;
    }

    if (!mounted) return;
    setState(() {
      _isTestingSpeed = true;
    });

    try {
      // Test download speed
      final downloadSpeed = await _speedTest.testDownloadSpeed();

      // Test upload speed
      final uploadSpeed = await _speedTest.testUploadSpeed();

      if (!mounted) return; // Ensure the widget is still in the tree

      // Determine video quality
      final videoQuality =
          VideoQualityDeterminer.determineQuality(downloadSpeed);

      // Determine connection quality
      final connectionQuality =
          ConnectionQualityDeterminer.determineQuality(downloadSpeed);

      if (!mounted) return; // Ensure the widget is still in the tree

      setState(() {
        _networkInfo = NetworkInfo(
          downloadSpeed: downloadSpeed,
          uploadSpeed: uploadSpeed,
          networkType: _currentNetworkType,
          videoQuality: videoQuality,
          connectionQuality: connectionQuality,
        );
        _isTestingSpeed = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isTestingSpeed = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Speed test failed: $e')),
      );
    }
  }

  @override
  void dispose() {
    _connectionMonitor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Monitor'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Connection type indicator
            _buildConnectionTypeCard(),
            const SizedBox(height: 16),

            // Speed test button
            ElevatedButton(
              onPressed: _isTestingSpeed ? null : _runSpeedTest,
              child: _isTestingSpeed
                  ? const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 8),
                        Text('Testing...'),
                      ],
                    )
                  : const Text('Run Speed Test'),
            ),
            const SizedBox(height: 16),

            // Network info display
            if (_networkInfo != null) _buildNetworkInfoCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionTypeCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Connection Type',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildNetworkTypeIcon(),
                const SizedBox(width: 8),
                Text(
                  _getNetworkTypeString(),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkTypeIcon() {
    IconData iconData;
    Color iconColor;

    switch (_currentNetworkType) {
      case NetworkType.wifi:
        iconData = Icons.wifi;
        iconColor = Colors.blue;
        break;
      case NetworkType.mobile:
        iconData = Icons.signal_cellular_alt;
        iconColor = Colors.green;
        break;
      case NetworkType.ethernet:
        iconData = Icons.settings_ethernet;
        iconColor = Colors.purple;
        break;
      case NetworkType.none:
        iconData = Icons.signal_wifi_off;
        iconColor = Colors.red;
        break;
    }

    return Icon(
      iconData,
      size: 28,
      color: iconColor,
    );
  }

  String _getNetworkTypeString() {
    switch (_currentNetworkType) {
      case NetworkType.wifi:
        return 'Wi-Fi';
      case NetworkType.mobile:
        return 'Mobile Data';
      case NetworkType.ethernet:
        return 'Ethernet';
      case NetworkType.none:
        return 'No Connection';
    }
  }

  Widget _buildNetworkInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Network Speed Test Results',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Download speed
            _buildInfoRow(
              'Download Speed:',
              '${_networkInfo!.downloadSpeed.toStringAsFixed(2)} Mbps',
              Icons.download,
              Colors.blue,
            ),
            const SizedBox(height: 8),

            // Upload speed
            _buildInfoRow(
              'Upload Speed:',
              '${_networkInfo!.uploadSpeed.toStringAsFixed(2)} Mbps',
              Icons.upload,
              Colors.green,
            ),
            const SizedBox(height: 8),

            // Video quality
            _buildInfoRow(
              'Video Quality:',
              VideoQualityDeterminer.getQualityString(
                  _networkInfo!.videoQuality),
              Icons.video_library,
              Colors.orange,
            ),
            const SizedBox(height: 8),

            // Connection quality
            _buildInfoRow(
              'Connection Quality:',
              ConnectionQualityDeterminer.getQualityString(
                  _networkInfo!.connectionQuality),
              Icons.signal_cellular_alt,
              _getConnectionQualityColor(),
            ),
            const SizedBox(height: 16),

            // Video quality explanation
            _buildVideoQualityExplanation(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Color _getConnectionQualityColor() {
    switch (_networkInfo!.connectionQuality) {
      case ConnectionQuality.poor:
        return Colors.red;
      case ConnectionQuality.moderate:
        return Colors.orange;
      case ConnectionQuality.good:
        return Colors.green;
      case ConnectionQuality.excellent:
        return Colors.blue;
    }
  }

  Widget _buildVideoQualityExplanation() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your connection supports:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildVideoQualityIndicator(),
        ],
      ),
    );
  }

  Widget _buildVideoQualityIndicator() {
    List<Widget> indicators = [];

    // Add indicators for each quality level
    void addIndicator(VideoQuality quality, String label, bool isSupported) {
      indicators.add(
        Row(
          children: [
            Icon(
              isSupported ? Icons.check_circle : Icons.cancel,
              color: isSupported ? Colors.green : Colors.red.shade300,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(label),
          ],
        ),
      );
      indicators.add(const SizedBox(height: 4));
    }

    // Add indicators based on current video quality
    addIndicator(VideoQuality.fullHd_1080p, '1080p Full HD',
        _networkInfo!.videoQuality == VideoQuality.fullHd_1080p);

    addIndicator(
        VideoQuality.hd_720p,
        '720p HD',
        _networkInfo!.videoQuality == VideoQuality.fullHd_1080p ||
            _networkInfo!.videoQuality == VideoQuality.hd_720p);

    addIndicator(
        VideoQuality.standard_480p,
        '480p Standard Definition',
        _networkInfo!.videoQuality == VideoQuality.fullHd_1080p ||
            _networkInfo!.videoQuality == VideoQuality.hd_720p ||
            _networkInfo!.videoQuality == VideoQuality.standard_480p);

    addIndicator(VideoQuality.low_140p, '140p Low Definition', true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: indicators,
    );
  }
}
