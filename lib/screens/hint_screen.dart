import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:room_exit_hint_app/constants/constants.dart';
import 'package:room_exit_hint_app/screens/view_hint_screen.dart';

class HintScreen extends StatefulWidget {
  const HintScreen({Key? key}) : super(key: key);

  @override
  _HintScreenState createState() => _HintScreenState();
}

class _HintScreenState extends State<HintScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: Get.width * 0.55,
          height: Get.height * 0.07,
          child: ElevatedButton(
              onPressed: () => Get.to(() => ViewHintScreen()),
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
        Text('현재 풀고 있는 문제의 힌트를 보여줍니다.\n힌트 사용시 사용한 힌트 1개가 추가됩니다.',
        style: TextStyle(
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,),
      ],
    )));
  }
}
