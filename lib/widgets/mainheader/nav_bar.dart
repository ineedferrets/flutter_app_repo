import 'package:flutter/material.dart';

class NavBarItem extends StatelessWidget {
  
  const NavBarItem({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w100),
      )
    );
  }
}

class NavBar extends StatelessWidget {

  const NavBar({super.key, required this.controller, required this.children});

  final TabController controller;
  final List<NavBarItem> children;

  @override
  Widget build(BuildContext context){
    double screenWidth = MediaQuery.of(context).size.width;
    double tabBarScaling = screenWidth > 1400 ? 0.21 : screenWidth > 1100 ? 0.3 : 0.42;
    return SizedBox(
      width: screenWidth * tabBarScaling,
      child: Theme(
        data: ThemeData(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: TabBar(
          controller: controller, 
          tabs: children,
          indicatorColor: Colors.white,
          dividerColor: Colors.transparent,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black54,
          )
        )
    );
  }
}