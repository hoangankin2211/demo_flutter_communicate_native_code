import 'package:flutter/material.dart';
import 'package:flutter_communicate_native_code/app.dart';

class CurrentLocationWidget extends StatefulWidget {
  const CurrentLocationWidget({super.key});

  @override
  State<CurrentLocationWidget> createState() => _CurrentLocationWidgetState();
}

class _CurrentLocationWidgetState extends State<CurrentLocationWidget> {
  bool _isLoading = false;
  String _currentPosition = "Unknow Position";

  Future _getCurrentPosition() async {
    String currentPosition = _currentPosition;

    try {
      final String result =
          await MyApp.platform.invokeMethod('getCurrentLocation');
      currentPosition = "Current position is $result";
    } catch (e) {
      currentPosition = "Failed to get current position: $e";
    }

    _currentPosition = currentPosition;
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
                  _currentPosition,
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
              await _getCurrentPosition();
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
