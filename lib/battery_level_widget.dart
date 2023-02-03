import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_communicate_native_code/app.dart';

class BatteryLevelWidget extends StatefulWidget {
  const BatteryLevelWidget({super.key});

  @override
  State<BatteryLevelWidget> createState() => _BatteryLevelWidgetState();
}

class _BatteryLevelWidgetState extends State<BatteryLevelWidget> {
  bool _isLoading = false;
  String _batteryLevel = "Unknow Battery Level";

  Future _getBatteryLevel() async {
    String batteryLevel = _batteryLevel;

    try {
      final int result = await MyApp.platform.invokeMethod('getBatteryLevel');
      batteryLevel = "Battery Level at $result";
    } catch (e) {
      batteryLevel = "Failed to get battery level: $e";
    }

    _batteryLevel = batteryLevel;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Text(
                  _batteryLevel,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          const SizedBox(height: 15),
          ElevatedButton.icon(
            onPressed: () async {
              setState(() {
                _isLoading = true;
              });
              await _getBatteryLevel();
              setState(() {
                _isLoading = false;
              });
            },
            icon: const Icon(Icons.refresh_outlined),
            label: const Text(
              "Refresh",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ],
      ),
    );
  }
}
