import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:room_exit_hint_app/constants/constants.dart';
import 'package:room_exit_hint_app/models/room_model.dart';
import 'package:room_exit_hint_app/screens/hint_screen.dart';
import 'package:room_exit_hint_app/screens/messenger_screen.dart';
import 'package:room_exit_hint_app/screens/rewind_hint_screen.dart';
import 'package:room_exit_hint_app/screens/setting_screen.dart';
import 'package:room_exit_hint_app/screens/waiting_room_screen.dart';
import 'package:room_exit_hint_app/widgets/show_delete_dialog.dart';

class MyRoomScreen extends StatefulWidget {
  RoomModel room;

  MyRoomScreen({required this.room, Key? key}) : super(key: key);

  @override
  _MyRoomScreenState createState() => _MyRoomScreenState();
}

class _MyRoomScreenState extends State<MyRoomScreen> {
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if(mounted) {
        setState(() {
          widget.room.endTime.add(const Duration(seconds: 1));
        });
      }
    });
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black54,
          title: Column(
            children: [
              customAppBarView('🌈', '테마 ${widget.room.themaType}'),
              customAppBarView('🕰', '${widget.room.endTime.difference(DateTime.now()).inMinutes}분 ${widget.room.endTime.difference(DateTime.now()).inSeconds % 60}초 남음'),
              customAppBarView('⭐️', "사용한 힌트 수 ${widget.room.usedHintCount}개 / 전체 힌트 수 ${widget.room.hintCount.toString()}개"),
            ],
          ),
          toolbarHeight: Get.height * 0.1,
          bottom: widget.room.isStarted
              ? TabBar(
            labelColor: Colors.white,
            indicatorColor: kPrimaryColor,
            // isScrollable: true,
            unselectedLabelColor: Colors.white,
            physics: NeverScrollableScrollPhysics(),
            tabs: [
              Tab(
                child: Text(
                  '힌트',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              Tab(
                child: Text('메신저',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
              ),
              Tab(
                child: Text('힌트 다시보기',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ],
          )
              : null,
          // elevation: 0,
          centerTitle: true,
        ),
        body: widget.room.isStarted
            ? TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            HintScreen(room: widget.room),
            MessengerScreen(roomId: widget.room.id,),
            RewindHintScreen(roomId: widget.room.id,),
          ],
        )
            : Center(
          child: Text(
            '게임 시작 전입니다.\n관리자에게 요청하세요.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  customAppBarView(String icon, String title) {
    return Row(
      children: [
        Text(
          icon,
          style: TextStyle(fontSize: Get.width * 0.035,),
        ),
        SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: Get.width * 0.035,
          ),
        ),
      ],
    );
  }
}
