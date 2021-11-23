import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:room_exit_hint_app/db/database.dart';
import 'package:room_exit_hint_app/models/room_model.dart';
import 'package:room_exit_hint_app/widgets/loading_indicator.dart';

class ViewHintScreen extends StatefulWidget {
  String hintCode;
  RoomModel room;

  ViewHintScreen({required this.hintCode, required this.room, Key? key})
      : super(key: key);

  @override
  _ViewHintScreenState createState() => _ViewHintScreenState();
}

class _ViewHintScreenState extends State<ViewHintScreen> {
  Map<String, dynamic>? hintMap;

  @override
  void initState() {
    super.initState();
    getHint();
  }

  getHint() async {
    DatabaseService()
        .viewHint(widget.hintCode, widget.room.roomType)
        .then((ds) {
      setState(() {
        hintMap = ds.data() as Map<String, dynamic>;
      });

      saveHint(widget.room, widget.hintCode, hintMap![widget.hintCode]);
    });
  }

  saveHint(RoomModel room, String hintCode, String hintResult) {
    List<String> history = [];
    for(int i = 0; i < room.hintHistory.length; i++) {
      history.add(room.hintHistory[i]);
    }
    history.add(hintResult);
    DatabaseService().saveHintHistory(room.id, history);
    DatabaseService().useHintCountUp(room.id, ++room.usedHintCount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Text('힌트 보기'),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  hintMap != null
                  ? Text(hintMap![widget.hintCode], textAlign: TextAlign.center,)
                  : loadingIndicator(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  titleText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: Text(
        text,
        style: TextStyle(fontSize: Get.width * 0.06),
      ),
    );
  }

  bodyText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
        text,
        style: TextStyle(fontSize: Get.width * 0.04),
      ),
    );
  }
}
