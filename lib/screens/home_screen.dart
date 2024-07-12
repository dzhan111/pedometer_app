import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:social_pedometer/firebase_methods/steps_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = 'stopped';
  var _steps = 0;
  var start = 0;
  DateTime _lastUpdate = DateTime.now();
  StepsService _stepsService = StepsService();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    fetchTodaySteps();
  }

  Future<void> fetchTodaySteps() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var date =
          DateTime.now().toString().substring(0, 10); // Format: YYYY-MM-DD
      var stepDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('steps')
          .doc(date);

      var doc = await stepDoc.get();
      if (doc.exists) {
        setState(() {
          _steps = doc.data()?['steps'] ?? 0;
          _lastUpdate = DateTime.now(); // Ensure the last update is today
        });
      } else {
        // No steps recorded yet for today
        setState(() {
          _steps = 0;
          _lastUpdate = DateTime.now(); // Reset last update to now
        });
      }
    }
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
    //DateTime tomorrow = currentDate.add(Duration(days: 1));
    print(currentDate);
    if (currentDate.day != _lastUpdate.day ||
        currentDate.month != _lastUpdate.month ||
        currentDate.year != _lastUpdate.year) {
      //calls to save steps to a collection

      if (mounted) {
        setState(() {
          start = event.steps;
          _steps = 0; // Reset steps at the start of a new day
          _lastUpdate = currentDate; // Update last update time to now
        });
      }
      print("new day update");
      _stepsService.saveDailySteps(_steps);
    } else {
      if (mounted) {
        setState(() {
          _steps = (event.steps - start);

          _lastUpdate = currentDate;
        });
      }
      print("current day update");
      _stepsService.saveDailySteps(_steps);
    }
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    if (mounted) {
      setState(() {
        _status = event.status;
      });
    }
  }

  void onPedestrianStatusError(error) {
    if (mounted) {
      setState(() {
        _status = 'unknown';
      });
    }
  }

  void onStepCountError(error) {
    if (mounted) {
      setState(() {
        _steps = -1;
      });
    }
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
                _steps.toString(),
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
