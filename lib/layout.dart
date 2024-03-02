import 'dart:ui';
import 'package:flutter/material.dart';

class HomePageLayout extends StatefulWidget {
  const HomePageLayout({super.key});

  @override
  State createState() {
    return _HomePageLayoutState();
  }
}

class _HomePageLayoutState extends State {
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            children: [
              Container(
                height: 120,
                color: Colors.lightBlue,
                child: Row(), // This will contain the search bar
              ),
              Container(
                height: 120,
                color: Colors.blue.withOpacity(0.8),
                child: Row(), // This will be the filter section
              ),
              const Expanded(
                child: Center(
                  child: Text("Hello World."), // This will be where the content goes
                )
              )
            ]
          )
        )
      ]
    );
  }
}