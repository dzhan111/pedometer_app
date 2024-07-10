import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:social_pedometer/mobile_layout.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';
  var start = 0;
  DateTime _lastUpdate = DateTime.now();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
  }

  void onStepCount(StepCount event) {
    DateTime currentDate = DateTime.now();
    DateTime tomorrow = currentDate.add(Duration(days: 1));
    print(currentDate);
    if (tomorrow.day != _lastUpdate.day ||
        currentDate.month != _lastUpdate.month ||
        currentDate.year != _lastUpdate.year) {
      setState(() {
        start = event.steps;
        _steps = '0';  // Reset steps at the start of a new day
        _lastUpdate = tomorrow;  // Update last update time to now
      });
    } else {
      setState(() {
        _steps = (event.steps - start).toString();
        
        _lastUpdate = tomorrow;
      });
    }
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    setState(() {
      _status = 'unknown';
    });
  }

  void onStepCountError(error) {
    setState(() {
      _steps = 'unknown';
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MobileLayout()
    );
  }
}
