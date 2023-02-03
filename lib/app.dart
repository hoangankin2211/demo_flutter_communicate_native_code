import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_communicate_native_code/battery_level_widget.dart';
import 'package:flutter_communicate_native_code/current_position_widget.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static const platform = MethodChannel('sample.flutter.dev/methodChannel');

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: const BatteryLevelWidget(),
              ),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: const CurrentLocationWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
