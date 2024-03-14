import 'package:flutter/material.dart';

class AppItem {
  AppItem({
    required this.title,
    required this.developer,
    this.publisher,
    this.androidAppStoreURL,
    this.appleAppStoreURL,
    this.windowsAppStoreURL,
    this.rating = 3.0,
    this.appIcon,
    this.numOfDownloads = 0
  });
  
  final String title;
  final String developer;
  String? publisher;
  String? androidAppStoreURL;
  String? appleAppStoreURL;
  String? windowsAppStoreURL;
  final double rating;
  IconData? appIcon;
  IconData? posterImage;
  double numOfDownloads;
}