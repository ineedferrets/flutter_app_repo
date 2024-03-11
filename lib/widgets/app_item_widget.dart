import 'package:flutter/material.dart';

class AppItem {
  AppItem({
    required this.title,
    required this.developer,
    this.publisher = "",
    this.androidAppStoreURL = "",
    this.appleAppStoreURL = "",
    this.windowsAppStoreURL = "",
    this.rating = 3.0,
  });
  
  final String title;
  final String developer;
  final String publisher;
  final String androidAppStoreURL;
  final String appleAppStoreURL;
  final String windowsAppStoreURL;
  final double rating;
}

class AppItemWidget extends StatelessWidget {

  AppItemWidget({super.key, required this.appItem, required this.onPressed});

  final AppItem appItem;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context){
    return OutlinedButton(
      onPressed: onPressed,
      child: Row(),
    );
  }
}