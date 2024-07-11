import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social_pedometer/mobile_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MobileLayout()
    );
  }
}
