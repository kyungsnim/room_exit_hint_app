import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:room_exit_hint_app/db/database.dart';
import 'package:room_exit_hint_app/widgets/loading_indicator.dart';

import 'hint_history_detail_screen.dart';

class RewindHintScreen extends StatefulWidget {
  final String roomId;

  const RewindHintScreen({required this.roomId, Key? key}) : super(key: key);

  @override
  _RewindHintScreenState createState() => _RewindHintScreenState();
}

class _RewindHintScreenState extends State<RewindHintScreen> {
  Map<String, dynamic>? currentRoomDataMap;

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection("Rooms")
        .doc(widget.roomId)
        .get()
        .then((value) {
      setState(() {
        currentRoomDataMap = value.data();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (currentRoomDataMap == null) {
      return loadingIndicator();
    }
    List hintHistoryList = currentRoomDataMap!['hintHistory'];
    return ListView.builder(
      itemCount: hintHistoryList.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () => Get.to(
            () => HintHistoryDetailScreen(
              hint: hintHistoryList[index],
            ),
          ),
          child: ListTile(
            title: Text(
                hintHistoryList[index].toString().length >= 40 ? hintHistoryList[index].toString().substring(0, 40) : hintHistoryList[index].toString(),
            ),
          ),
        );
      },
    );
  }
}
