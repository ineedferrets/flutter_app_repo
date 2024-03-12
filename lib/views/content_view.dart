import 'package:flutter/material.dart';
import 'package:test_application/widgets/mainheader/nav_bar.dart';

class ContentView {

  ContentView({required this.tab, required this.content});

  final NavBarItem tab;
  final Widget content;
}