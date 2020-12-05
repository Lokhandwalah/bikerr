import 'package:bikerr/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServiceTracker extends StatefulWidget {
  @override
  _ServiceTrackerState createState() => _ServiceTrackerState();
}

class _ServiceTrackerState extends State<ServiceTracker> {
  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<CurrentUser>(context);
    print('service');
    return Scaffold(
      body: Center(
        child: Text("Service Tracker"),
      ),
    );
  }
}
