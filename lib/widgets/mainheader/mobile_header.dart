import 'package:flutter/material.dart';
import 'package:test_application/widgets/centered_view_widget.dart';

class MobileHeader extends StatelessWidget {

  const MobileHeader({
    super.key,
    required this.title,
    required this.height,
    required this.scaffoldState
  });

  final String title;
  final double height;
  final GlobalKey<ScaffoldState> scaffoldState;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      color: Theme.of(context).primaryColorLight,
      child: CenteredView(
        verticalPadding: height,
        horizontalPadding: screenWidth * 0.05,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
              Text(
                title,
                style: const TextStyle(fontSize: 24)
              ),
              IconButton(
                onPressed: scaffoldState.currentState?.openEndDrawer, 
                iconSize: MediaQuery.of(context).size.width * 0.1,
                icon: const Icon(Icons.menu_rounded), 
                color: Colors.white)
          ],
        ),
      ),
    );
  }
}



