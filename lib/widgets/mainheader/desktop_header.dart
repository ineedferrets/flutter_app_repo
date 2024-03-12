import 'package:flutter/material.dart';
import 'package:test_application/widgets/centered_view.dart';
import 'package:test_application/widgets/mainheader/nav_bar.dart';

class DesktopHeader extends StatelessWidget {

  const DesktopHeader({
    super.key,
    required this.controller,
    required this.navItems,
    required this.title,
    required this.height
  });

  final TabController controller;
  final List<NavBarItem> navItems;
  final String title;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColorLight,
      child: CenteredView(
        verticalPadding: height,
        horizontalPadding: MediaQuery.of(context).size.width > 800 ? 70.0 : 20.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 32)
              ),
            NavBar(
              controller: controller, 
              children: navItems),
          ]
        ),
      )
    );
  }
}



