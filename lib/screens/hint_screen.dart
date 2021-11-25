import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:room_exit_hint_app/constants/constants.dart';
import 'package:room_exit_hint_app/db/database.dart';
import 'package:room_exit_hint_app/models/room_model.dart';
import 'package:room_exit_hint_app/screens/view_hint_screen.dart';
import 'package:room_exit_hint_app/screens/waiting_room_screen.dart';
import 'package:room_exit_hint_app/widgets/show_delete_dialog.dart';

class HintScreen extends StatefulWidget {
  RoomModel room;

  HintScreen({required this.room, Key? key}) : super(key: key);

  @override
  _HintScreenState createState() => _HintScreenState();
}

class _HintScreenState extends State<HintScreen> {
  String hintCode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: Get.width * 0.55,
                height: Get.height * 0.07,
                child: ElevatedButton(
                    onPressed: () {
                      if (currentUser.id == 'admin') {
                        Get.snackbar('힌트 보기 불가', '관리자는 힌트를 볼 수 없습니다.',
                            colorText: Colors.white,
                            backgroundColor: kPrimaryColor);
                      } else if (widget.room.usedHintCount ==
                          widget.room.hintCount) {
                        Get.snackbar('힌트 보기 불가', '더 이상 힌트 사용이 불가능합니다.');
                      } else {
                        /// 사용자만 힌트 보기 가능
                        final DatabaseReference db =
                            FirebaseDatabase().reference();
                        db
                            .child(widget.room.themaType)
                            .once()
                            .then((DataSnapshot result) async {
                          setState(() {
                            hintCode = result.value['hint'];
                          });
                          print('result = ${result.value['hint']}');

                          String lastHintCode = await DatabaseService()
                              .getLastHintCode(widget.room.id);

                          /// 힌트 보기 눌렀을 때 새로운 힌트를 보는 것이 아닌 경우
                          if (hintCode == lastHintCode) {
                            Get.snackbar('힌트 보기 불가', '새로운 힌트가 없습니다.',
                                colorText: Colors.white,
                                backgroundColor: kPrimaryColor);
                          } else {
                            Get.to(() => ViewHintScreen(
                                hintCode: hintCode, room: widget.room));
                          }
                        });
                      }
                    },
                    child: Text('힌트 보기',
                        style: TextStyle(
                          fontSize: Get.width * 0.05,
                        )),
                    style: ElevatedButton.styleFrom(
                      primary: kPrimaryColor,
                    )),
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              Text(
                '현재 풀고 있는 문제의 힌트를 보여줍니다.\n힌트 사용시 사용한 힌트 1개가 추가됩니다.',
                style: TextStyle(
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: currentUser.id == 'admin'
          ? FloatingActionButton(
              onPressed: () {
                showDeleteDialog(context, widget.room);
              },
              child: const Icon(Icons.delete),
              backgroundColor: kPrimaryColor,
            )
          : SizedBox(),
    );
  }
}
