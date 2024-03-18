import 'package:flutter/material.dart';

class AppItem {

  static AppItem EmptyApp = AppItem(title: "Empty", developer: "Empty");

  static String titleRef = "title";
  static String developerRef = "developer";
  static String publisherRef = "publisher";
  static String downloadsRef = "downloads";
  static String ratingRef = "ratings";
  static String androidURLRef = "androidURL";
  static String appleURLRef = "appleURL";
  static String windowsURLRef = "windowsURL";

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