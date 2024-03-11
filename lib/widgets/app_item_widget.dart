import 'dart:math';

import 'package:flutter/material.dart';
import 'package:test_application/widgets/star_rating_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class AppItem {
  AppItem({
    required this.title,
    required this.developer,
    this.publisher,
    this.androidAppStoreURL,
    this.appleAppStoreURL,
    this.windowsAppStoreURL,
    this.rating = 3.0,
    this.appIcon = null,
    this.numOfDownloads
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
  double? numOfDownloads;
}

class AppItemWidget extends StatelessWidget {

  const AppItemWidget({super.key, required this.appItem, required this.onPressed});

  final AppItem appItem;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context){
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            appItem.appIcon != null ? appItem.appIcon! : Icons.image_outlined, 
            size: 110.0, 
            color: Colors.black45
            ),
          _drawAppTitleDevPubRatingInfo(context),
          const Spacer(),
          _drawAppDownloadsLocations(context)
        ],
      ),
    );
  }

  Widget _drawAppTitleDevPubRatingInfo(BuildContext context)
  {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text( // Title of game
          appItem.title,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.left,
        ),
        Text( // Developer and publisher
          appItem.developer + (appItem.publisher != null ? ", " + appItem.publisher! : ""),
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.left,
        ),
        StarRatingWidget(rating: appItem.rating)
      ],
    );
  }

  Widget _drawAppDownloadsLocations(BuildContext context)
  {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "Number of Downloads:",
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.right,
        ),
        Text(
          _downloadParser(appItem.numOfDownloads),
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 20.0),
        Text(
          "Available Platforms:",
          style: Theme.of(context).textTheme.bodyLarge
        ),
        _availableAppLocations(context)
      ]
    );
  }

  String _downloadParser(double? downloads)
  {
    if (downloads == null)
    {
      return "Data not available.";
    }

    if (downloads < pow(10, 3))
    {
      return downloads.toString();
    }
    else if (downloads < pow(10, 6))
    {
      double downlodsInThousands = downloads % 1000;
      return "$downlodsInThousands k+";
    }
    else if (downloads < pow(10, 9))
    {
      double downloadsInMillions = downloads % pow(10, 6);
      return "$downloadsInMillions M+";
    }
    else 
    {
      double downloadsInBillions = downloads % pow(10,9);
      return "$downloadsInBillions B+";
    }
  }

  Widget _availableAppLocations(BuildContext context)
  {
    List<Widget> storeIcons = [];

    if (appItem.androidAppStoreURL != null)
    {
      storeIcons.add(
        _AppStoreIconWidget(
          icon: Icons.android,
          url: appItem.androidAppStoreURL!
        )
      );
    }

    if (appItem.appleAppStoreURL != null)
    {
      storeIcons.add(
        _AppStoreIconWidget(
          icon: Icons.apple,
          url: appItem.appleAppStoreURL!
        )
      );
    }

    if (appItem.windowsAppStoreURL != null)
    {
      storeIcons.add(
        _AppStoreIconWidget(
          icon: Icons.desktop_windows,
          url: appItem.windowsAppStoreURL!
        )
      );
    }

    if (storeIcons.isEmpty)
    {
      storeIcons.add(
        const Tooltip(
          message: "Could not find marketplaces this app is available at.",
          child: Icon(
            Icons.block,
            size: 20
          ),
        )
      );
    }

    return Row(
      children: storeIcons,
    );
  }

}

class _AppStoreIconWidget extends StatelessWidget {

  const _AppStoreIconWidget({
    required this.icon, 
    required this.url,
    this.size = 20.0});

  final IconData icon;
  final String url;
  final double size;

  @override 
  Widget build(BuildContext context)
  {
    return Tooltip(
      message: "Go to $url",
      child: IconButton(
        icon: Icon(icon),
        iconSize: size,
        onPressed: () async
        {
          final Uri uriURL = Uri.parse(url);
          if (await canLaunchUrl(uriURL))
          {
            await launchUrl(uriURL);
          }
          else
          {
            throw Exception('Could not launch $url');
          }
        },
      )
    );
  }
}