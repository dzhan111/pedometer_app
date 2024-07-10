import 'package:flutter/material.dart';

class LeaderBoardsScreen extends StatefulWidget {
  const LeaderBoardsScreen({super.key});

  @override
  State<LeaderBoardsScreen> createState() => _LeaderBoardsScreenState();
}

class _LeaderBoardsScreenState extends State<LeaderBoardsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Text("Leaders!!", style: TextStyle(color: Colors.white),)
    );
    
  }
}