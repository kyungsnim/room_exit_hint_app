import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:room_exit_hint_app/constants/constants.dart';
import 'package:room_exit_hint_app/db/database.dart';
import 'package:room_exit_hint_app/models/room_model.dart';
import 'package:room_exit_hint_app/screens/hint_screen.dart';
import 'package:room_exit_hint_app/screens/messenger_screen.dart';
import 'package:room_exit_hint_app/screens/rewind_hint_screen.dart';
import 'package:room_exit_hint_app/screens/waiting_room_screen.dart';

class MyRoomScreen extends StatefulWidget {
  RoomModel room;

  MyRoomScreen({required this.room, Key? key}) : super(key: key);

  @override
  _MyRoomScreenState createState() => _MyRoomScreenState();
}

class _MyRoomScreenState extends State<MyRoomScreen> {
  Timer? _timer;
  RoomModel? room;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    room = widget.room;
  }

  getCurrentRoom() {
    print('<<<<<< ${room!.id}');
    DatabaseService().getCurrentRoom(room!.id).then((value) {
      Map<String, dynamic> roomData = value.data() as Map<String, dynamic>;
      setState(() {
        room = RoomModel.fromMap(roomData);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if(mounted) {
        setState(() {
          room!.endTime.add(const Duration(seconds: 10));
        });
      }
    });
    return DefaultTabController(
      length: 3,
      child: WillPopScope(
        onWillPop: () => emptyAction(),
        child: Scaffold(
          appBar: AppBar(
            leading: currentUser.id == 'admin' ? InkWell(onTap: () => Get.offAll(() => WaitingRoomScreen()), child: Icon(Icons.home)) : SizedBox(),
            // leading: InkWell(onTap: () => Get.offAll(() => WaitingRoomScreen()), child: Icon(Icons.home)),
            backgroundColor: Colors.black54,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    customAppBarView('🌈', '테마 ${room!.themaType}'),
                    customAppBarView('🕰', room!.endTime.isAfter(DateTime.now()) ? '${room!.endTime.difference(DateTime.now()).inMinutes}분 ${room!.endTime.difference(DateTime.now()).inSeconds % 60}초 남음' :
                    '${DateTime.now().difference(room!.endTime).inMinutes}분 ${DateTime.now().difference(room!.endTime).inSeconds % 60}초 지남'),
                    customAppBarView('⭐️', "사용한 힌트 수 ${room!.usedHintCount}개 / 전체 힌트 수 ${room!.hintCount.toString()}개"),
                  ],
                ),
                InkWell(
                  onTap: () => getCurrentRoom(),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.refresh,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            toolbarHeight: Get.height * 0.1,
            bottom: room!.isStarted
                ? TabBar(
              labelColor: Colors.white,
              indicatorColor: kPrimaryColor,
              // isScrollable: true,
              unselectedLabelColor: Colors.white,
              physics: NeverScrollableScrollPhysics(),
              onTap: (index) {
                if(index != 1) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              },
              tabs: const [
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
          backgroundColor: Colors.black,
          body: room!.isStarted
              ? TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              HintScreen(room: room!),
              MessengerScreen(roomId: room!.id,),
              RewindHintScreen(roomId: room!.id,),
            ],
          )
              : Center(
            child: Text(
              '게임 시작 전입니다.\n관리자에게 요청하세요.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
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

  emptyAction() {
    return null;
  }
}
