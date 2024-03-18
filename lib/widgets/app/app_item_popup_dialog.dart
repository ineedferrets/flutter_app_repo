import 'package:flutter/material.dart';

import 'package:test_application/widgets/app/app_item.dart';
import 'package:test_application/widgets/app/app_information_widget.dart';

class AppItemPopupDialog {
  static void showAppPopupDialog(BuildContext context, AppItem appItem)
  {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
      pageBuilder: ((context, animation, secondaryAnimation) {
        return _popupWidget(context, animation, secondaryAnimation, appItem);
      }));
  }

  static Widget _popupWidget(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, AppItem app)
  {
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Container(
        width: mediaWidth,
        height: mediaHeight,
        color: Colors.transparent,
        child: Center(
          child: Container(
            width: mediaWidth * 0.8,
            height: mediaHeight * 0.8,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Spacer(), 
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close))
                    ],
                  ),
                  AppInformationWidget(appItem: app),
                ],
              )
            )
          ),
        ),
      ) 
    );
  }
}