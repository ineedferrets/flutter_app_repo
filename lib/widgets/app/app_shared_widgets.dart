import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class TitleDeveloperPublisherWidget extends StatelessWidget {

  const TitleDeveloperPublisherWidget({
    super.key,
    required this.title,
    required this.developer,
    this.publisher,
    this.titleStyle,
    this.devPubStyle,
    this.textAlign = TextAlign.left,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.start
  });

  final String title, developer;
  final String? publisher;
  final TextStyle? titleStyle;
  final TextStyle? devPubStyle;
  final TextAlign textAlign;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context)
  {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text( // Title of game
          title,
          style: titleStyle ?? Theme.of(context).textTheme.headlineMedium,
          textAlign: textAlign,
          overflow: TextOverflow.ellipsis,
        ),
        Text( // Developer and publisher
          developer + (publisher != null ? ", ${publisher!}" : "" ),
          style: devPubStyle ?? Theme.of(context).textTheme.bodyLarge,
          textAlign: textAlign,
          overflow: TextOverflow.ellipsis,
        )
      ],
    );
  }
}

class StarRatingWidget extends StatelessWidget {

  const StarRatingWidget({
    super.key,
    required this.rating,
    this.starSize = 20,
    this.spacing = 10,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center
    });

  final double rating;
  final double starSize;
  final double spacing;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  @override 
  Widget build(BuildContext context)
  {
    List<Widget> stars = [];

    int ratingProxy = (rating*2).round() - 1;
    for (int starIdx = 0 ; starIdx < 9 ; starIdx = ++starIdx)
    {
      if (starIdx % 2 == 0)
      {
        stars.add(Icon(
          starIdx > ratingProxy ? Icons.star_border_rounded : starIdx == ratingProxy ? Icons.star_half_rounded : Icons.star_rounded,
          size: starSize,
        ));
      }
      else
      {
        stars.add(SizedBox(width: spacing,));
      }
    }

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: stars,
    );
  }
}

class NumberOfDownloadsWidget extends StatelessWidget {

  const NumberOfDownloadsWidget({
    super.key,
    required this.numOfDownloads,
    this.textStyle,
    this.textAlign = TextAlign.left,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.start
  });

  final double numOfDownloads;
  final TextStyle? textStyle;
  final TextAlign textAlign;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  @override 
  Widget build(BuildContext context)
  {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          "Number of Downloads:",
          style: textStyle ?? Theme.of(context).textTheme.bodyLarge,
          textAlign: textAlign,
        ),
        Text(
          _downloadParser(numOfDownloads),
          style: textStyle ?? Theme.of(context).textTheme.bodyLarge,
          textAlign: textAlign,
        ),
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
      int downlodsInThousands = (downloads / 1000).floor();
      return "$downlodsInThousands k+";
    }
    else if (downloads < pow(10, 9))
    {
      int downloadsInMillions = (downloads / pow(10, 6)).floor();
      return "$downloadsInMillions M+";
    }
    else 
    {
      int downloadsInBillions = (downloads / pow(10,9)).floor();
      return "$downloadsInBillions B+";
    }
  }
}

class DownloadLocationsWidget extends StatelessWidget {

  const DownloadLocationsWidget({
    super.key,
    this.androidURL,
    this.appleURL,
    this.windowsURL ,
    this.iconSize = 20,
    this.iconSpacing = 10
  });

  final String? androidURL;
  final String? appleURL;
  final String? windowsURL;
  final double iconSize;
  final double iconSpacing;

  @override
  Widget build(BuildContext context)
  {
    List<Widget> storeIcons = [];

    if (androidURL != null)
    {
      storeIcons.add(
        _appStoreIconWidget(
          Icons.android,
          androidURL!
        )
      );
    }

    if (appleURL != null)
    {
      if (storeIcons.isNotEmpty)
      {
        storeIcons.add(
          SizedBox(
            width: iconSpacing,
          )
        );
      }
      storeIcons.add(
        _appStoreIconWidget(
          Icons.apple,
          appleURL!
        )
      );
    }

    if (windowsURL != null)
    {
      storeIcons.add(
        _appStoreIconWidget(
          Icons.desktop_windows,
          windowsURL!
        )
      );
    }

    if (storeIcons.isEmpty)
    {
      storeIcons.add(
        Tooltip(
          message: "Could not find marketplaces this app is available at.",
          child: Icon(
            Icons.block,
            size: iconSize
          ),
        )
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "Available Platforms:",
          style: Theme.of(context).textTheme.bodyLarge
        ),
        Row(
          children: storeIcons,
        )
      ]
    );
  }

  Widget _appStoreIconWidget(IconData icon, String url, {double size = 20})
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