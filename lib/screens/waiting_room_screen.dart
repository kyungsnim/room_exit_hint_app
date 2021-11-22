import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:room_exit_hint_app/constants/constants.dart';

import '../home_screen.dart';

class WaitingRoomScreen extends StatefulWidget {
  const WaitingRoomScreen({Key? key}) : super(key: key);

  @override
  _WaitingRoomScreenState createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends State<WaitingRoomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('대기실'),
        backgroundColor: kPrimaryColor,
      ),
      body: Container(
        child: buildRoomList(),
      )
    );
  }

  buildRoomList() {
    return StreamBuilder(stream: roomReference.snapshots(),
        builder: (context, snapshot) {
      return GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          return Container(
            height: Get.height * 0.2,
            width: Get.height * 0.2,
            child: Text(index.toString())
          );
        },
      );
    });
  }
}
