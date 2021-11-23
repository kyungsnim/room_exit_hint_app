import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:room_exit_hint_app/db/database.dart';
import 'package:room_exit_hint_app/models/current_user.dart';
import 'package:room_exit_hint_app/screens/login/sign_up_with_user_id.dart';
import 'package:room_exit_hint_app/screens/waiting_room_screen.dart';
import 'package:room_exit_hint_app/widgets/login_button.dart';
import 'package:room_exit_hint_app/widgets/room_exit_body.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../home_screen.dart';

class SignInPageWithUserId extends StatefulWidget {
  @override
  SignInPageWithUserIdState createState() => SignInPageWithUserIdState();
}

class SignInPageWithUserIdState extends State<SignInPageWithUserId> {
  DatabaseService ds = DatabaseService();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? userId, password, resetPwEmail;
  bool doRemember = false;
  var isLoading;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // 저장된 비밀번호 가져오기
    // _initialize();
    getRememberInfo();
    // 로그아웃으로 빠져나온게 아니면 자동로그인 시켜줌
    checkFirebaseAndSignIn();
    setState(() {
      isLoading = false;
    });
  }

  checkFirebaseAndSignIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Firebase.initializeApp().whenComplete(() {
      print("completed");

      if (prefs.getString('signOut') == 'NO') {
        signIn();
      }
    });
  }

  @override
  void dispose() {
    setRememberInfo();
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  getRememberInfo() async {
    // logger.d(doRemember);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      doRemember = (prefs.getBool('doRemember') ?? false);
    });
    if (doRemember) {
      setState(() {
        _userIdController.text = (prefs.getString('userId') ?? "");
        userId = _userIdController.text;
        _passwordController.text = (prefs.getString('userPassword') ?? "");
        password = _passwordController.text;
      });
    }
  }

  setRememberInfo() async {
    // logger.d(doRemember);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('doRemember', doRemember);
    if (doRemember) {
      prefs.setString('userId', _userIdController.text);
      prefs.setString('userPassword', _passwordController.text);
      prefs.setString('signOut', 'NO');
    }
  }

  signIn() async {
    String dbPassword;
    DocumentSnapshot dbUserData;
    // dbUserData = await ds.getUserLoginInfo(userId);
    print('userId : $userId');
    dbPassword = await ds.getUserLoginInfo(userId!);

    // 수험번호가 잘못 입력된 경우
    if (dbPassword == 'ID error') {
      checkIdPasswordPopup('아이디 확인', "존재하지 않는 아이디입니다.");
    } else if (password != dbPassword) {
      checkIdPasswordPopup('비밀번호 확인', "비밀번호가 잘못 입력되었습니다.");
    } else {
      // 해당 정보 다시 가져오기
      dbUserData = await ds.getUserInfo(userId!);
      // 현재 유저정보에 값 셋팅하기
      setState(() {
        currentUser = CurrentUser.fromDocument(dbUserData);
      });

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const WaitingRoomScreen()));
    }
  }

  checkIdPasswordPopup(title, content) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              FlatButton(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: const Text('확인',
                      style: TextStyle(
                          color: Colors.grey, fontSize: 20)),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  setState(() {
                    isLoading = false;
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var leftPaddingSize = MediaQuery.of(context).size.width * 0.1;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        ClipRRect(
            child: Container(color: Colors.blue.withOpacity(0.2),)
        ),
        Container(
          color: Colors.black.withOpacity(0.2),
          width: MediaQuery.of(context).size.width * 1,
          height: MediaQuery.of(context).size.height * 1,
        ),
        InkWell(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            alignment: Alignment.topCenter,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                roomExitBody(context),
                SizedBox(height: Get.height * 0.1),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border:
                            Border.all(color: Colors.blue.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 5,
                                  color: Colors.white24)
                            ]),
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            // keyboardType: TextInputType.number,
                            controller: _userIdController,
                            cursorColor: Colors.blue,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return '아이디를 입력하세요';
                              } else {
                                return null;
                              }
                            },
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                icon: Icon(Icons.perm_contact_cal,
                                    color: Colors.blue),
                                hintText: '아이디',
                                hintStyle:
                                TextStyle(fontSize: 18)),
                            onChanged: (val) {
                              userId = val;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border:
                            Border.all(color: Colors.blue.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 5,
                                  color: Colors.white24)
                            ]),
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            cursorColor: Colors.blue,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return '비밀번호를 입력하세요';
                              }
                            },
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                icon: Icon(Icons.vpn_key, color: Colors.blue),
                                hintText: '비밀번호',
                                hintStyle:
                                TextStyle(fontSize: 18)),
                            onChanged: (val) {
                              password = val;
                            },
                          ),
                        ),
                      ),
                      // Remember me
                      Container(
                          margin: const EdgeInsets.fromLTRB(0, 5, 25, 5),
                          child: Row(
                            children: <Widget>[
                              SizedBox(width: leftPaddingSize),
                              // checkbox 체크안했을 때 색상 설정하기 (매우 유용하군.....)
                              Theme(
                                data: ThemeData(
                                    unselectedWidgetColor: Colors.white),
                                child: Checkbox(
                                  activeColor: Colors.blue,
                                  value: doRemember,
                                  onChanged: (newValue) {
                                    setState(() {
                                      doRemember = newValue!;
                                    });
                                  },
                                ),
                              ),
                              const Text('아이디 기억하기',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18))
                            ],
                          )),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.07),
                      // Alert Box
                      isLoading == true
                          ? Column(
                        children: [
                          const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.blueAccent),
                            strokeWidth: 10,
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height *
                                  0.07),
                        ],
                      )
                          : Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                isLoading = true;
                              });
                              FocusScope.of(context).requestFocus(
                                  FocusNode()); // 키보드 감추기
                              signIn();
                            },
                            child: userIdLoginButton(
                                context,
                                '로그인',
                                Colors.white,
                                Colors.blue.withOpacity(0.7),
                                Colors.blue),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              FocusScope.of(context).requestFocus(
                                  FocusNode()); // 키보드 감추기
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const SignUpPageWithUserId()));
                              // signIn();
                            },
                            child: userIdLoginButton(
                                context,
                                '회원가입',
                                Colors.black,
                                Colors.white.withOpacity(0.7),
                                Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
