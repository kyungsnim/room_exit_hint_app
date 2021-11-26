import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:room_exit_hint_app/constants/constants.dart';
import 'package:room_exit_hint_app/db/database.dart';
import 'package:room_exit_hint_app/models/room_model.dart';
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
                        obscureText: true,
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

                /// push


                Navigator.pop(context);
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
