import 'package:flutter/material.dart';

import 'package:test_application/widgets/app/app_item.dart';
import 'package:test_application/widgets/app/app_shared_widgets.dart';

typedef AppItemToVoidFunc = void Function(AppItem);

class AppItemWidget extends StatelessWidget {

  const AppItemWidget({super.key, required this.appItem, required this.onPressed});

  final AppItem appItem;
  final AppItemToVoidFunc onPressed;

  @override
  Widget build(BuildContext context){
    return OutlinedButton(
      onPressed: () => onPressed(appItem),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleDeveloperPublisherWidget(
                title: appItem.title,
                developer: appItem.developer,
                publisher: appItem.publisher,
              ),
              StarRatingWidget(
                rating: appItem.rating,
              )
            ],
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              NumberOfDownloadsWidget(
                numOfDownloads: appItem.numOfDownloads,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                textAlign: TextAlign.right,
                ),
                DownloadLocationsWidget(
                  appleURL: appItem.appleAppStoreURL,
                  androidURL: appItem.androidAppStoreURL,
                  windowsURL: appItem.windowsAppStoreURL,
                )
            ],
          )
        ],
      ),
    );
  }
}