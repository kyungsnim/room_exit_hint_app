import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/src/provider.dart';
import 'package:room_exit_hint_app/constants/constants.dart';
import 'package:room_exit_hint_app/db/database.dart';
import 'package:room_exit_hint_app/models/current_user.dart';
import 'package:room_exit_hint_app/models/room_model.dart';
import 'package:room_exit_hint_app/notification/notification_bloc.dart';
import 'package:room_exit_hint_app/notification/notification_service.dart';
import 'package:room_exit_hint_app/screens/my_room_screen.dart';
import 'package:room_exit_hint_app/screens/setting_screen.dart';
import 'package:room_exit_hint_app/widgets/loading_indicator.dart';
import 'package:room_exit_hint_app/widgets/show_password_dialog.dart';

import '../home_screen.dart';
import 'make_room_screen.dart';

final roomReference = FirebaseFirestore.instance.collection('Rooms');
final hintReference = FirebaseFirestore.instance.collection('Hints');
final userReference =
    FirebaseFirestore.instance.collection('Users'); // 사용자 정보 저장을 위한 ref

CurrentUser currentUser = CurrentUser(
    id: "",
    password: "",
    validateByAdmin: false,
    createdAt: DateTime.now(),
    name: '',
    phoneNumber: '',
    role: 'general',
    FCMToken: '');

class WaitingRoomScreen extends StatefulWidget {
  const WaitingRoomScreen({Key? key}) : super(key: key);

  @override
  _WaitingRoomScreenState createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends State<WaitingRoomScreen> {
  TextEditingController pwdController = TextEditingController();
  Timer? _timer;
  List roomList = [];

  @override
  void initState() {
    /// 푸시 알림 초기화 하기
    Future.delayed(const Duration(milliseconds: 0)).then((_) {
      NotificationService()
          .initFirebasePushNotification(context)
          .then((_) => context.read<NotificationBloc>().checkSubscription())
          .then((_) {});
    }).then((_) {});

    NotificationService().getToken().then((value) async {
      print('Token : $value');
      print('DB Token : ${currentUser.FCMToken}');

      /// token 이 갱신된 경우 업데이트
      if (currentUser.FCMToken != "" && currentUser.FCMToken != value!) {
        print('here');
        await userReference.doc(currentUser.id).update({'FCMToken': value});
      }
    });

    DatabaseService().getAvailableRooms().then((value) {
      setState(() {
        roomList = value.docs;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showExitDialog(),
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              if(_timer != null) {
                _timer?.cancel();
              }
              DatabaseService().getAvailableRooms().then((value) {
            setState(() {
              roomList = value.docs;
            });
          });
        },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(
                Icons.refresh,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
          title: Text('대기실'),
          backgroundColor: Colors.black,
          actions: [
            InkWell(
              onTap: () {
                _timer?.cancel();
                Get.to(() => SettingScreen());
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(
                  'assets/icon/setting.png',
                  width: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: _buildRoomList(),
        backgroundColor: Colors.black,
        floatingActionButton: currentUser.id == 'admin'
            ? FloatingActionButton(
                onPressed: () {
                  _timer?.cancel();
                  Get.to(() => MakeRoomScreen());
                },
                child: Icon(Icons.add),
                backgroundColor: Colors.grey,
              )
            : SizedBox(),
      ),
    );
  }

  _buildRoomList() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3/4,
      ),
      itemCount: roomList.length,
      itemBuilder: (context, index) {
        // Map<String, dynamic> item = snapshot.data.docs[index].data() as Map<String, dynamic>;
        RoomModel room = RoomModel.fromMap(
            roomList[index].data() as Map<String, dynamic>);
        return _buildItem(room);
      },
    );
  }

  _buildItem(RoomModel room) {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if(mounted) {
        setState(() {
          room.endTime.add(const Duration(seconds: 10));
        });
      }
    });
    return InkWell(
      onTap: () {
        _timer!.cancel();

        /// 게임중이고 관리자인 경우엔 바로 접속
        room.isStarted && currentUser.id == 'admin'
            ? goToRoom(room)
            : showPasswordDialog(context, pwdController, room).then((_) {
          DatabaseService().getAvailableRooms().then((value) {
            setState(() {
              roomList = value.docs;
            });
          });
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0, right: 4, top: 4, bottom: 2),
        child: Stack(children: [
          Container(
              height: Get.height * 0.5,
              width: Get.height * 0.3,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black,
                  border: Border.all(
                    color: Colors.grey,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 0),
                      blurRadius: 2,
                      color: Colors.grey,
                    )
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    titleText('🌈 Room type'),
                    contentText(room.themaType),
                    currentUser.id != 'admin' ? SizedBox() : SizedBox(
                      height: Get.height * 0.015,
                    ),
                    currentUser.id != 'admin' ? SizedBox() : titleText('🕰 Play time'),
                    currentUser.id != 'admin' ? SizedBox() : contentText('${room.playTime.toString()}분'),
                    currentUser.id != 'admin' ? SizedBox() : SizedBox(
                      height: Get.height * 0.015,
                    ),
                    currentUser.id != 'admin' ? SizedBox() : titleText('⭐ Hint count'),
                    currentUser.id != 'admin' ? SizedBox() : contentText(room.hintCount),
                    currentUser.id != 'admin' ? SizedBox() : SizedBox(
                      height: Get.height * 0.015,
                    ),
                    currentUser.id != 'admin' ? SizedBox() : titleText('🙎‍️ User'),
                    currentUser.id != 'admin' ? SizedBox() : contentText(room.user),
                  ],
                ),
              )),
          Positioned(
              top: Get.width * 0.02,
              right: Get.width * 0.02,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(room.isStarted ? '게임중' : '대기중',
                      style: TextStyle(
                        color: room.isStarted ? Colors.black : Colors.white,
                      )),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: room.isStarted ? Colors.yellow : Colors.black),
              )),
          room.isStarted
              ? Positioned(
                  bottom: Get.width * 0.02,
                  right: Get.width * 0.02,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                          room.endTime.isAfter(DateTime.now())
                              ? '${room.endTime.difference(DateTime.now()).inMinutes}분 ${room.endTime.difference(DateTime.now()).inSeconds % 60}초 남음'
                              : '${DateTime.now().difference(room.endTime).inMinutes}분 ${DateTime.now().difference(room.endTime).inSeconds % 60}초 지남',
                          style: TextStyle(
                            color: Colors.black,
                          )),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: room.isStarted
                            ? room.endTime.isAfter(DateTime.now())
                                ? Colors.yellow
                                : Colors.red
                            : Colors.white),
                  ))
              : SizedBox()
        ]),
      ),
    );
  }

  goToRoom(RoomModel room) {
    // DatabaseService().addFcmToken(room, [currentUser.FCMToken]);
    Get.to(() => MyRoomScreen(room: room));
  }
  titleText(String title) {
    return Text(
      title,
      style: TextStyle(color: Colors.white, fontSize: currentUser.id != 'admin' ? Get.width * 0.05 : Get.width * 0.04),
    );
  }

  contentText(String content) {
    return Text(
      content,
      style: TextStyle(
          color: Colors.white,
          fontSize: currentUser.id != 'admin' ? Get.width * 0.06 : Get.width * 0.045,
          fontWeight: FontWeight.bold),
    );
  }

  showExitDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('앱 종료',
                style: TextStyle(
                  fontFamily: 'Binggrae',
                )),
            content: Text(
              '종료하시겠습니까?',
              style: TextStyle(fontFamily: 'Binggrae'),
            ),
            actions: [
              ElevatedButton(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Text('확인',
                      style: TextStyle(
                          fontFamily: 'Binggrae', fontSize: Get.width * 0.05)),
                ),
                style: ElevatedButton.styleFrom(primary: kPrimaryColor),
                onPressed: () async {
                  SystemNavigator.pop();
                },
              ),
              ElevatedButton(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Text('취소',
                      style: TextStyle(
                          fontFamily: 'Binggrae', fontSize: Get.width * 0.05)),
                ),
                style: ElevatedButton.styleFrom(primary: kPrimarySecondColor),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
