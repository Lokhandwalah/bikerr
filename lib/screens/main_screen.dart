import 'package:bikerr/models/screen.dart';
import 'package:bikerr/utilities/constants.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: primary,
          currentIndex: _currentIndex,
          selectedItemColor: Colors.white,
          onTap: (index) => setState(() => _currentIndex = index),
          elevation: 10,
          type: BottomNavigationBarType.fixed,
          items: Screen.pages
              .map(
                (p) => BottomNavigationBarItem(
                  icon: Icon(p.icon),
                  activeIcon: Icon(p.activeIcon),
                  label: p.title,
                ),
              )
              .toList()),
      body: IndexedStack(
        index: _currentIndex,
        children: Screen.pages.map((p) => p.page).toList(),
      ),
    );
  }
}
