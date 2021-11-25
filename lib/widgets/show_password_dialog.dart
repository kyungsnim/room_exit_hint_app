import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:room_exit_hint_app/constants/constants.dart';
import 'package:room_exit_hint_app/db/database.dart';
import 'package:room_exit_hint_app/models/room_model.dart';
import 'package:room_exit_hint_app/screens/my_room_screen.dart';
import 'package:room_exit_hint_app/screens/waiting_room_screen.dart';

import '../home_screen.dart';

showPasswordDialog(
  BuildContext context,
  TextEditingController pwdController,
    RoomModel room,
) async {
  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('비밀번호 입력', // '게시글 수정/삭제하기'
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: Get.width * 0.05,
              )),
          content: Container(
            width: Get.width * 0.3,
            height: Get.height * 0.1,
            child: Column(children: [
              Text(
                '방 입장을 위해 비밀번호를 입력하세요.',
                // '해당 게시글을 수정/삭제하시려면 비밀번호 입력 후 버튼을 눌러주세요.'
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: Get.width * 0.03,
                ),
              ),
              Spacer(),
              Row(
                children: [
                  Text(
                    '비밀번호',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: Get.width * 0.03,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '비밀번호를 입력하세요.',
                        hintStyle: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Get.width * 0.03,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: kPrimaryColor,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: kPrimaryColor,
                          ),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                      controller: pwdController,
                      cursorColor: kPrimaryColor,
                    ),
                  ),
                ],
              ),
              Spacer(),
            ]),
          ),
          actions: [
            currentUser.id == 'admin' ? ElevatedButton(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('게임시작',
                    style: TextStyle(
                        fontFamily: 'Pretendard', fontSize: Get.width * 0.05)),
              ),
              style: ElevatedButton.styleFrom(primary: Colors.indigoAccent),
              onPressed: () {
                DatabaseService().addFcmToken(room, [currentUser.FCMToken]);
                Future.delayed(const Duration(seconds: 2));
                DatabaseService().gameStart(room);
                Get.back();
              },
            ) : SizedBox(),
            ElevatedButton(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('입장',
                    style: TextStyle(
                        fontFamily: 'Pretendard', fontSize: Get.width * 0.05)),
              ),
              style: ElevatedButton.styleFrom(primary: kPrimaryColor),
              onPressed: () {
                if (pwdController.text != room.password) {
                  Get.snackbar(
                    '비밀번호 오류',
                    '비밀번호가 맞지 않습니다.',
                    colorText: Colors.white,
                    backgroundColor: kPrimaryColor,
                  );
                } else {
                  pwdController.text = '';
                  Navigator.pop(context);

                  /// 사용자 입장시 사용자의 토큰값 저장
                  List<dynamic>? tokenList;
                  bool alreadySavedToken = false;
                  for(int i = 0; i < room.tokenList.length; i++) {
                    if(currentUser.FCMToken == room.tokenList[i]) {
                      alreadySavedToken = true;
                    }
                  }

                  /// 토큰 추가 안된 경우에만 추가해주기
                  if(!alreadySavedToken) {
                    tokenList = room.tokenList;
                    tokenList.add(currentUser.FCMToken);
                  } else {
                    tokenList = room.tokenList;
                  }

                  DatabaseService().addFcmToken(room, tokenList);
                  Get.to(() => MyRoomScreen(room: room,));
                }
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
