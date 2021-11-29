import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:room_exit_hint_app/constants/constants.dart';

class HintHistoryDetailScreen extends StatefulWidget {
  final Map hint;

  HintHistoryDetailScreen({required this.hint, Key? key}) : super(key: key);

  @override
  _HintHistoryDetailScreenState createState() =>
      _HintHistoryDetailScreenState();
}

class _HintHistoryDetailScreenState extends State<HintHistoryDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('힌트 다시보기'),
        backgroundColor: kPrimarySecondColor,
      ),
      body: ListView(children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            widget.hint['title'],
            style: TextStyle(
              fontSize: Get.width * 0.08,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Divider(),
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            widget.hint['content'],
            style: TextStyle(
              fontSize: Get.width * 0.05,
            ),
          ),
        ),
        Divider(),
        SizedBox(height: Get.height * 0.5),
        Text(
          '아래로 내려주세요.',
          textAlign: TextAlign.center,
        ),
        SizedBox(height: Get.height * 0.5),
        Divider(),
        Padding(
          padding: EdgeInsets.all(16),
          child: widget.hint['type'] == 'text' ? Text(
            widget.hint['correct'],
            style: TextStyle(fontSize: Get.width * 0.06, color: kPrimaryColor),
            textAlign: TextAlign.center,
          ) : CachedNetworkImage(imageUrl: widget.hint['correct']),
        ),
      ]),
    );
  }
}
