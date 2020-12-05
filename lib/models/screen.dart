import 'package:bikerr/screens/documentation/documentation_screen.dart';
import 'package:bikerr/screens/explore/explore_screen.dart';
import 'package:bikerr/screens/performance/performance_screen.dart';
import 'package:bikerr/screens/service_tracker/service_tracker_screen.dart';
import 'package:flutter/material.dart';

class Screen {
  final IconData icon, activeIcon;
  final String title, route;
  final Widget page;
  final int index;
  Screen(
      {this.icon,
      this.activeIcon,
      this.title,
      this.page,
      this.index,
      this.route});
  static List<Screen> pages = [
    Screen(
      index: 0,
      title: 'Performance',
      icon: Icons.miscellaneous_services_outlined,
      activeIcon: Icons.miscellaneous_services,
      page: Performance(),
    ),
    Screen(
      index: 1,
      title: 'Service',
      icon: Icons.construction_outlined,
      activeIcon: Icons.construction,
      page: ServiceTracker(),
    ),
    Screen(
      index: 2,
      title: 'Documents',
      icon: Icons.file_copy_outlined,
      activeIcon: Icons.file_copy,
      page: Documentation(),
    ),
    Screen(
      index: 2,
      title: 'Explore',
      icon: Icons.explore_outlined,
      activeIcon: Icons.explore,
      page: Explore(),
    )
  ];
}
