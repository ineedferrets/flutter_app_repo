import 'package:flutter/material.dart';

import 'package:test_application/widgets/app/app_item.dart';
import 'package:test_application/widgets/app/app_shared_widgets.dart';

class AppInformationWidget extends StatelessWidget {

  const AppInformationWidget({super.key, required this.appItem});

  final AppItem appItem;

  @override
  Widget build(BuildContext context)
  {
    return Column(
      children: [
        Row( // Header
          children: [
            Icon(
              appItem.appIcon ?? Icons.image,
              size: 140,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleDeveloperPublisherWidget(
                  title: appItem.title,
                  developer: appItem.developer,
                  publisher: appItem.publisher,
                  ),
                StarRatingWidget(
                  rating: appItem.rating
                  ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                NumberOfDownloadsWidget(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  textAlign: TextAlign.right,
                  numOfDownloads: appItem.numOfDownloads
                  ),
                DownloadLocationsWidget(
                  androidURL: appItem.androidAppStoreURL,
                  appleURL: appItem.appleAppStoreURL,
                  windowsURL: appItem.windowsAppStoreURL,
                )
              ],
            )
          ]
        ),
      ],
    );
  }
}