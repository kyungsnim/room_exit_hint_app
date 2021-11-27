import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:room_exit_hint_app/constants/constants.dart';
import 'package:room_exit_hint_app/db/database.dart';
import 'package:room_exit_hint_app/models/room_model.dart';
import 'package:room_exit_hint_app/notification/notification_service.dart';
import 'package:room_exit_hint_app/screens/my_room_screen.dart';
import 'package:room_exit_hint_app/screens/waiting_room_screen.dart';

import '../home_screen.dart';

showMoreTimeDialog(BuildContext context,
    RoomModel room, moreTimeController) async {
  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('시간 추가하기', // '게시글 수정/삭제하기'
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: Get.width * 0.05,
              )),
          content: Container(
            width: Get.width * 0.3,
            height: Get.height * 0.1,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '추가 시간',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Get.width * 0.03,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '시간을 분 단위로 입력하세요.',
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
                        controller: moreTimeController,
                        cursorColor: kPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('확인',
                    style: TextStyle(
                        fontFamily: 'Pretendard', fontSize: Get.width * 0.05)),
              ),
              style: ElevatedButton.styleFrom(primary: kPrimaryColor),
              onPressed: () {
                /// add time
                DatabaseService().addPlayTime(room, int.parse(moreTimeController.text));

                /// 상대방 토큰 가져오기
                List<dynamic> tokenList = [];
                String to = '';
                /// 토큰 ㄱㅏ져오기 : 길이가 2이면 ok, 길이가 1이면 관리자만 있는 상태
                roomReference.doc(room.id).get().then((DocumentSnapshot ds) {
                  Map<String, dynamic> dsMap = ds.data() as Map<String, dynamic>;

                  tokenList = dsMap['tokenList'];
                  for(int i = 0; i < dsMap['tokenList'].length; i++){
                    print(dsMap['tokenList'][i]);
                  }

                  for(int i = 0; i < tokenList.length; i++){
                    /// 내 토큰값이 아닌 경우 (상대에게 보내야할 토큰값이므로) to 에 할당해주기
                    if(currentUser.FCMToken != tokenList[i]) {
                      to = tokenList[i];
                    }
                  }

                  /// push
                  NotificationService().sendMessage('시간 추가', '${moreTimeController.text}분 추가! 새로고침을 눌러주세요.', [to]);
                });
                // moreTimeController.clear();
                Navigator.pop(context);
                Get.snackbar('시간 추가', '${moreTimeController.text}분이 추가되었습니다.');
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
