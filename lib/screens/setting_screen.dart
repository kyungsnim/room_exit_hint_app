import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:room_exit_hint_app/models/room_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login/sign_in_with_user_id.dart';

class SettingScreen extends StatefulWidget {
  RoomModel? room;
  SettingScreen({this.room, Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('userId', '');
            prefs.setString('userPassword', '');
            prefs.setString('signOut', 'YES');
            Get.offAll(
              () => SignInPageWithUserId(),
            );
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.grey,
          ),
          child: Text('로그아웃'),
        )
      ],
    )));
  }
}
