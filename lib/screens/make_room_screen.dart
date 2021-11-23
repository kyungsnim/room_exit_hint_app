import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:room_exit_hint_app/constants/constants.dart';
import 'package:room_exit_hint_app/db/database.dart';
import 'package:room_exit_hint_app/home_screen.dart';
import 'package:room_exit_hint_app/screens/waiting_room_screen.dart';

class MakeRoomScreen extends StatefulWidget {
  const MakeRoomScreen({Key? key}) : super(key: key);

  @override
  _MakeRoomScreenState createState() => _MakeRoomScreenState();
}

class _MakeRoomScreenState extends State<MakeRoomScreen> {
  String roomType = 'room_A';
  List<String> roomTypeList = [
    'room_A',
    'room_B',
    'room_C',
    'room_D',
    'room_E',
    'room_F',
  ];
  String hintCount = '∞';
  List<String> hintCountList = [
    '∞','1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20'
  ];

  int playTime = 60;
  List<int> playTimeList = [30,40,50,60,70,80,90,100,110,120];

  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('방 만들기'),
        backgroundColor: kPrimaryColor,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  inputRoomType(),
                  inputHintCount(),
                  inputPlayTime(),
                  inputPassword(),
                  makeRoomButton(),
                  SizedBox(height: Get.height * 0.4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  inputRoomType() {
    return /// 룸타입 선택
      Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 8.0, vertical: 8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    '테마 (Room Type)',
                    style: TextStyle(
                        fontFamily: 'Nanum',
                        color: Colors.black87,
                        fontSize: Get.height * 0.025,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.black38, width: 2),
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: Row(
                children: [
                  Spacer(),
                  DropdownButton(
                      value: roomType,
                      style: TextStyle(
                        fontSize: Get.height * 0.02,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      borderRadius:
                      BorderRadius.circular(10),
                      underline: Container(
                        height: 0,
                      ),
                      items: roomTypeList.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value.toString(),
                              style: const TextStyle(
                                fontFamily: 'Binggrae',
                              )),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          roomType = value! as String;
                        });
                      }),
                  Spacer(), //SizedBox(width: 20),
                ],
              ),
            ),
          ],
        ),
      );
  }

  inputHintCount() {
    return /// 힌트 수 선택
      Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 8.0, vertical: 8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    '제공 힌트 수 (Hint Count)',
                    style: TextStyle(
                        fontFamily: 'Nanum',
                        color: Colors.black87,
                        fontSize: Get.height * 0.025,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.black38, width: 2),
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: Row(
                children: [
                  Spacer(),
                  DropdownButton(
                      value: hintCount,
                      style: TextStyle(
                        fontSize: Get.height * 0.02,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      borderRadius:
                      BorderRadius.circular(10),
                      underline: Container(
                        height: 0,
                      ),
                      items: hintCountList.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value.toString(),
                              style: const TextStyle(
                                fontFamily: 'Binggrae',
                              )),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          hintCount = value! as String;
                        });
                      }),
                  Spacer(), //SizedBox(width: 20),
                ],
              ),
            ),
          ],
        ),
      );
  }

  inputPlayTime() {
    return /// 플레이 시간 선택
      Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 8.0, vertical: 8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    '게임 시간 (Play Time)',
                    style: TextStyle(
                        fontFamily: 'Nanum',
                        color: Colors.black87,
                        fontSize: Get.height * 0.025,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.black38, width: 2),
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: Row(
                children: [
                  Spacer(),
                  DropdownButton(
                      value: playTime,
                      style: TextStyle(
                        fontSize: Get.height * 0.02,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      borderRadius:
                      BorderRadius.circular(10),
                      underline: Container(
                        height: 0,
                      ),
                      items: playTimeList.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value.toString(),
                              style: const TextStyle(
                                fontFamily: 'Binggrae',
                              )),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          playTime = value! as int;
                        });
                      }),
                  Spacer(), //SizedBox(width: 20),
                ],
              ),
            ),
          ],
        ),
      );
  }

  inputPassword() {
    return /// 비밀번호 입력
      Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 8.0, vertical: 8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    'Room 비밀번호',
                    style: TextStyle(
                        fontFamily: 'Nanum',
                        color: Colors.black87,
                        fontSize: Get.height * 0.025,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3),
            Container(
              width: Get.width,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.black38, width: 2),
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  cursorColor: kPrimaryColor,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide.none
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none
                    ),
                  ),
                  obscureText: true,
                ),
              )
            ),
          ],
        ),
      );
  }

  makeRoomButton() {
    return GestureDetector(
      onTap: () {
        String roomId = DateTime.now().microsecondsSinceEpoch.toString();

        Map<String, dynamic> roomMap = {
          'id': roomId,
          'roomType': roomType,
          'hintCount': hintCount,
          'playTime': playTime,
          'password': passwordController.text,
          'endTime': DateTime.now(),
        };

        DatabaseService().addRoom(roomMap).then((_) {
          FocusScope.of(context).unfocus();
          Get.offAll(() => WaitingRoomScreen());
          Get.snackbar('방만들기', '방 만들기 완료', colorText: Colors.white);
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: Get.height * 0.08,
          width: Get.width,
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              '방 만들기',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
