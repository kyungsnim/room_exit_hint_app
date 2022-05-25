import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:room_exit_hint_app/constants/constants.dart';
import 'package:room_exit_hint_app/db/database.dart';
import 'package:room_exit_hint_app/models/room_model.dart';
import 'package:room_exit_hint_app/screens/my_room_screen.dart';
import 'package:room_exit_hint_app/screens/waiting_room_screen.dart';

import '../home_screen.dart';

showDeleteDialog(
  BuildContext context,
  RoomModel room,
) async {
  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('방 삭제하기', // '게시글 수정/삭제하기'
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: Get.width * 0.05,
              )),
          content: Container(
            width: Get.width * 0.3,
            height: Get.height * 0.1,
            child: Text(
              '삭제하시겠습니까?',
              // '해당 게시글을 수정/삭제하시려면 비밀번호 입력 후 버튼을 눌러주세요.'
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: Get.width * 0.05,
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('삭제',
                    style: TextStyle(
                        fontFamily: 'Pretendard', fontSize: Get.width * 0.05)),
              ),
              style: ElevatedButton.styleFrom(primary: kPrimaryColor),
              onPressed: () {
                DatabaseService().deleteRoom(room);

                /// 방 삭제 후 Realtime Database thema의 hint A00으로 초기화
                final DatabaseReference db = FirebaseDatabase().reference();
                db.child(room.themaType).update({'hint': 'A00'});
                Get.snackbar('삭제 중', '잠시만 기다려주세요.', colorText: Colors.white);
                Future.delayed(Duration(milliseconds: 1500)).then((_) {
                  Navigator.pop(context);
                  Get.offAll(() => WaitingRoomScreen());
                });
              },
            ),
            ElevatedButton(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('취소',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: Get.width * 0.05,
                    )),
              ),
              style: ElevatedButton.styleFrom(primary: Colors.grey),
              onPressed: () async {
                Get.back();
              },
            ),
          ],
        );
      });
}
