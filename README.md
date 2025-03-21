### 🌌 flutter_network_monitor

`flutter_network_monitor` is a **Flutter package** that allows developers to **monitor network speed, connection type, and internet quality in real-time**. This package helps determine **video streaming quality** and classifies network speeds for an optimal user experience.

---

## **🚀 Features**  

✅ **Network Type Detection** → Detects if the user is on **WiFi, Mobile Data, or No Connection**.  
✅ **Real-Time Speed Monitoring** → Measures **download & upload speeds** dynamically.  
✅ **Video Quality Assessment** → Suggests the best video quality based on network speed.  
✅ **Connection Quality Classification** → Categorizes speed into **Poor, Moderate, Good, Excellent**.  
✅ **Live Connectivity Updates** → Listens for **network changes in real-time**.  

---

## **📺 Installation**  

Add the following dependency to your `pubspec.yaml`:  

```yaml
dependencies:
  flutter_network_monitor: ^0.0.1
```  

Then, run:  

```sh
flutter pub get
```

---

## **🔧 Usage**  

### **1️⃣ Import the Package**  
```dart
import 'package:flutter_network_monitor/flutter_network_monitor.dart';
```

### **2️⃣ Monitor Network Type (WiFi/Mobile/etc.)**  
```dart
final connectionMonitor = ConnectionTypeMonitor();

connectionMonitor.onConnectivityChanged.listen((networkType) {
  print('Network Type: $networkType');
});
```

### **3️⃣ Measure Download Speed**  
```dart
final speedTest = SpeedTest();

void checkDownloadSpeed() async {
  double speed = await speedTest.testDownloadSpeed();
  print('Download Speed: \${speed.toStringAsFixed(2)} Mbps');
}
```

### **4️⃣ Determine Video Streaming Quality**  
```dart
double internetSpeed = 6.0; // Example speed in Mbps
VideoQuality quality = VideoQualityDeterminer.determineQuality(internetSpeed);

print('Recommended Video Quality: \${VideoQualityDeterminer.getQualityString(quality)}');
```

### **5️⃣ Get Connection Quality (Poor/Good/Excellent)**  
```dart
double speed = 4.5; // Example speed in Mbps
ConnectionQuality quality = ConnectionQualityDeterminer.determineQuality(speed);

print('Connection Quality: \${ConnectionQualityDeterminer.getQualityString(quality)}');
```

---

## **📝 License**  
This package is licensed under the **MIT License**.  

---

## **📩 Contributions & Issues**  
💡 **Contributions are welcome!** If you find a bug or have a feature request, feel free to [open an issue](https://github.com/Myaseensha/flutter_network_monitor/issues).  

---

### **💙 Like this package?**  
Give it a ⭐ on **pub.dev** and [GitHub](https://github.com/Myaseensha/flutter_network_monitor)! 🎉  

---

