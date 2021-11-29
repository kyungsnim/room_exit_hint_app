import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:room_exit_hint_app/constants/constants.dart';
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

      saveHint(widget.room, widget.hintCode, hintMap!);
    });
  }

  saveHint(RoomModel room, String hintCode, Map<String, dynamic> hintMap) {
    // List<String> history = [];
    // for (int i = 0; i < room.hintHistory.length; i++) {
    //   history.add(room.hintHistory[i]);
    // }
    // history.add(hintResult);
    List<dynamic> history = [];
    for (int i = 0; i < room.hintHistory.length; i++) {
      history.add(room.hintHistory[i]);
    }
    Map<String, dynamic> hint = {
      'title': hintMap['${hintCode}_title'],
      'content': hintMap['${hintCode}_content'],
      'correct': hintMap['${hintCode}_correct'],
      'createAt': DateTime.now()
    };
    history.add(hint);

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
      body: hintMap == null
          ? loadingIndicator()
          : ListView(children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  hintMap!['${widget.hintCode}_title'],
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
                  hintMap!['${widget.hintCode}_content'],
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
                child: hintMap!['${widget.hintCode}_type'] == 'text'
                    ? Text(
                        hintMap!['${widget.hintCode}_correct'],
                        style: TextStyle(
                            fontSize: Get.width * 0.06, color: kPrimaryColor),
                        textAlign: TextAlign.center,
                      )
                    : CachedNetworkImage(
                        imageUrl: hintMap!['${widget.hintCode}_correct'],
                      ),
              ),
            ]),
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
