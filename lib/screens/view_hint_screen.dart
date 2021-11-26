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
        .viewHint(widget.hintCode, widget.room.themaType)
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
    DatabaseService().updateLastHintCode(room.id, hintCode);
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
      body: hintMap == null ? loadingIndicator() : Padding(
        padding: EdgeInsets.all(16),
        child: Text(hintMap![widget.hintCode], style: TextStyle(
          fontSize: Get.width * 0.06,
        )),
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
