import 'package:flutter/material.dart';

class Scheduling extends StatefulWidget {
  // Constructor to receive the user information
  const Scheduling({super.key});

  @override
  _SchedulingState createState() => _SchedulingState();
}

class _SchedulingState extends State<Scheduling> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Scheduling",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown,
      ),
      body: const Expanded(
        child: Column(
          children: [
            
          ],
        ),
      ),
    );
  }
}
