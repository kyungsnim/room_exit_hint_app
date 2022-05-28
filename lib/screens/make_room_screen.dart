import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:room_exit_hint_app/constants/constants.dart';
import 'package:room_exit_hint_app/db/database.dart';
import 'package:room_exit_hint_app/home_screen.dart';
import 'package:room_exit_hint_app/screens/waiting_room_screen.dart';

import '../models/room_model.dart';

class MakeRoomScreen extends StatefulWidget {
  const MakeRoomScreen({Key? key}) : super(key: key);

  @override
  _MakeRoomScreenState createState() => _MakeRoomScreenState();
}

class _MakeRoomScreenState extends State<MakeRoomScreen> {
  String themaType = 'thema1';
  List<String> roomTypeList = [
    'thema1',
    'thema2',
    'thema3',
    'thema4',
    'thema5',
    'thema6',
  ];

  // String hintCount = '∞';
  // List<String> hintCountList = [
  //   '∞','1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20'
  // ];
  //
  // int playTime = 60;
  // List<int> playTimeList = [30,40,50,60,70,80,90,100,110,120];

  TextEditingController passwordController = TextEditingController();
  TextEditingController playTimeController = TextEditingController();
  TextEditingController hintCountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('방 만들기'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  inputRoomType(),
                  // inputHintCount(),
                  // inputPlayTime(),
                  inputArea('게임 시간 입력', playTimeController, false),
                  inputArea('제공 힌트 수 입력', hintCountController, false),
                  inputArea('비밀번호 입력', passwordController, true),
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
    return

        /// 룸타입 선택
        Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  '테마 (Theme Type)',
                  style: TextStyle(
                      fontFamily: 'Nanum',
                      color: Colors.white,
                      fontSize: Get.height * 0.025,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 3),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.withOpacity(0.1),
            ),
            child: Row(
              children: [
                Spacer(),
                DropdownButton(
                  dropdownColor: Colors.grey,
                    value: themaType,
                    style: TextStyle(
                      fontSize: Get.height * 0.02,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    underline: Container(
                      height: 0,
                    ),
                    items: roomTypeList.map((value) {
                      return DropdownMenuItem(

                        value: value,
                        child: Text(value.toString(),
                            style: const TextStyle(
                              fontFamily: 'Binggrae',
                              color: Colors.white
                            )),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        themaType = value! as String;
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

  inputArea(String title, TextEditingController controller, bool secure) {
    return

        /// 비밀번호 입력
        Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  title,
                  style: TextStyle(
                      fontFamily: 'Nanum',
                      color: Colors.white,
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
                border: Border.all(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.white,
                  controller: controller,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder:
                        UnderlineInputBorder(borderSide: BorderSide.none),
                    enabledBorder:
                        UnderlineInputBorder(borderSide: BorderSide.none),
                  ),
                  obscureText: secure,
                ),
              )),
        ],
      ),
    );
  }

  bool isInt(String str) {
    if (str == null) {
      return false;
    }
    return int.tryParse(str) != null;
  }

  makeRoomButton() {
    return GestureDetector(
      onTap: () {
        /// 힌트수와 게임시간 숫자일 때만 방 만들어지도록 변경해야 함
        if (hintCountController.text.isNum && playTimeController.text.isNum) {
          String roomId = DateTime.now().microsecondsSinceEpoch.toString();

          Map<String, dynamic> roomMap = {
            'id': roomId,
            'themaType': themaType,
            'hintCount': hintCountController.text,
            'playTime': int.parse(playTimeController.text),
            'password': passwordController.text,
            'lastHintCode': '',
            'hintHistory': [],
            'tokenList': [],
            'endTime': DateTime.now(),
          };

          DatabaseService().addRoom(roomMap).then((_) async {
            FocusScope.of(context).unfocus();
            await DatabaseService().addFcmToken(roomId, [currentUser.FCMToken]);
            Get.offAll(() => WaitingRoomScreen());
            Get.snackbar('방만들기', '방 만들기 완료', colorText: Colors.white);
          });
        } else {
          Get.snackbar('입력값 오류', '제공 힌트 수 또는 게임 시간이 숫자가 아닌 입력값입니다.');
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: Get.height * 0.08,
          width: Get.width,
          decoration: BoxDecoration(
            color: Colors.grey,
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
