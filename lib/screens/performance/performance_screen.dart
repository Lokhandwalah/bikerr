import 'package:flutter/material.dart';

class Performance extends StatefulWidget {
  @override
  _PerformanceState createState() => _PerformanceState();
}

class _PerformanceState extends State<Performance> {
  @override
  Widget build(BuildContext context) {
    print('performance');
    return Scaffold(
      body: Center(
        child: Text("Performance"),
      ),
    );
  }
}