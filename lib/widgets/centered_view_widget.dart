import 'package:flutter/material.dart';

class CenteredView extends StatelessWidget {
  CenteredView({
    super.key,
    required this.child,
    this.horizontalPadding = 70.0,
    this.verticalPadding = 60.0
    });

  final Widget child;
  final double horizontalPadding;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: child,
      )
    );
  }
}