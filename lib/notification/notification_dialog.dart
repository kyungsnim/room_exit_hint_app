import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:room_exit_hint_app/constants/constants.dart';
import './notification_model.dart';
import './notification_details.dart';
import './next_screen.dart';

void openNotificationDialog(context, NotificationModel notificationModel) {
  showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          scrollable: false,
          contentPadding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    notificationModel.title!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                  HtmlUnescape().convert(
                      parse(notificationModel.body).documentElement!.text),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  )),
            ],
          ),
          actions: [
            // ElevatedButton(
            //   child: Container(
            //     padding: const EdgeInsets.all(8),
            //     child: const Text('열기', style: TextStyle(fontSize: 20)),
            //   ),
            //   style: ElevatedButton.styleFrom(primary: kPrimarySecondColor),
            //   onPressed: () {
            //     Navigator.pop(context);
                // Get.to(() => HomeScreen(
                //       getPageIndex: 1,
                //     ));
                // nextScreen(context, NotificationDetails(notificationModel: notificationModel,));
              // },
            // ),
            ElevatedButton(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Text('닫기', style: TextStyle(fontSize: 20)),
              ),
              style: ElevatedButton.styleFrom(primary:kPrimaryColor),
              onPressed: () {
                // Navigator.pop(context);
              },
            )
          ],
        );
      });
}
