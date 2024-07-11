import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    DateTime currentDate = DateTime.now().add(Duration(days: 1));
    //DateTime tomorrow = currentDate.add(Duration(days: 1));
    print(currentDate);
    if (currentDate.day != _lastUpdate.day ||
        currentDate.month != _lastUpdate.month ||
        currentDate.year != _lastUpdate.year) {
      setState(() {
        start = event.steps;
        _steps = '0';  // Reset steps at the start of a new day
        _lastUpdate = currentDate;  // Update last update time to now
      });
    } else {
      setState(() {
        _steps = (event.steps - start).toString();
        
        _lastUpdate = currentDate;
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
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pedometer Example'),
          backgroundColor: Colors.transparent,
          elevation: 100,
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Steps Taken',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
              Text(
                _steps,
                style: const TextStyle(fontSize: 60, color: Colors.green),
              ),
              const Divider(height: 100, thickness: 0, color: Colors.white),
              const Text(
                'Pedestrian Status',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
              Icon(
                _status == 'walking'
                    ? Icons.directions_walk
                    : Icons.accessibility_new,
                size: 100,
                color: Colors.white,
              ),
              Text(
                _status,
                style: TextStyle(
                  fontSize: 30,
                  color: _status == 'walking' || _status == 'stopped'
                      ? Colors.lightGreenAccent
                      : Colors.redAccent,
                ),
              ),
            ],
          ),
        ),
        
      ),
    );
  }
}
