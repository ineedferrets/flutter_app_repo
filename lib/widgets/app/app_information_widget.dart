import 'package:flutter/material.dart';

import 'package:test_application/widgets/app/app_item.dart';

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
            const Column(

            )
          ]
        ),
      ],
    );
  }
}