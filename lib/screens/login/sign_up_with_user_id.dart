import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:room_exit_hint_app/db/database.dart';
import 'package:room_exit_hint_app/widgets/login_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPageWithUserId extends StatefulWidget {
  const SignUpPageWithUserId({Key? key}) : super(key: key);

  @override
  SignUpPageWithUserIdState createState() => SignUpPageWithUserIdState();
}

class SignUpPageWithUserIdState extends State<SignUpPageWithUserId> {
  DatabaseService ds = DatabaseService();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? userId, name, phoneNumber, password; // 수험번호, 비밀번호;
  var grade; // 학년
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var isLoading;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _nameController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  signUpWithUserIdPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Map<dynamic, dynamic> userMap = {
        "id": userId,
        "password": password,
        "validateByAdmin": true, // 최초 회원가입시 관리자 검증 false
        "name": name,
        "role": "student",
        'FCMToken': prefs.get('FCMToken') ?? 'NOToken',
        "createdAt": DateTime.now()
      };
      await ds.addUser(userMap, userId!);
    } catch (e) {
      print(e.toString());
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: Stack(children: [
          ClipRRect(
            child: Container(color: Colors.green.withOpacity(0.2),)
          ),
          Container(
            color: Colors.black.withOpacity(0.6),
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 1,
          ),
          InkWell(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
                alignment: Alignment.center,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: Get.height * 0.1),
                      Center(
                        child: Text(
                          '회원 가입',
                          style: TextStyle(
                              fontSize: Get.width * 0.1,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: const [
                                Shadow(
                                    offset: Offset(1, 2),
                                    blurRadius: 3,
                                    color: Colors.black)
                              ]),
                        ),
                      ),
                      // SizedBox(height: 40),
                      SizedBox(height: Get.height * 0.1),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.green.withOpacity(0.5)),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: TextFormField(
                                  controller: _userIdController,
                                  cursorColor: Colors.green,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      return '아이디를 입력하세요';
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(Icons.perm_contact_cal,
                                          color: Colors.green),
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
                                  border: Border.all(
                                      color: Colors.green.withOpacity(0.5)),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    const Icon(Icons.person, color: Colors.green),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      flex: 1,
                                      child: TextFormField(
                                        controller: _nameController,
                                        cursorColor: Colors.green,
                                        validator: (val) {
                                          if (!Platform.isIOS && val!.isEmpty) {
                                            return '이름을 입력하세요';
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: Platform.isIOS ? '이름(선택사항)' : '이름',
                                            hintStyle: const TextStyle(
                                                fontSize: 18)),
                                        onChanged: (val) {
                                          name = val;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.green.withOpacity(0.5)),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  cursorColor: Colors.green,
                                  validator: (val) {
                                    if (val!.length < 4) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      return '4자 이상의 비밀번호를 사용하세요.';
                                    } else {
                                      return val.isEmpty ? '비밀번호를 입력하세요' : null;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(Icons.vpn_key,
                                          color: Colors.green),
                                      hintText: '비밀번호',
                                      hintStyle:
                                          TextStyle(fontSize: 18)),
                                  onChanged: (val) {
                                    password = val;
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.green.withOpacity(0.5)),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: true,
                                  cursorColor: Colors.green,
                                  validator: (val) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    if (val!.length < 4) {
                                      return '4자 이상의 비밀번호를 사용하세요.';
                                    } else if (_passwordController.text !=
                                        _confirmPasswordController.text) {
                                      return '비밀번호 입력이 잘못되었습니다.';
                                    } else {
                                      return val.isEmpty ? '비밀번호를 입력하세요' : null;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(Icons.vpn_key_outlined,
                                          color: Colors.green),
                                      hintText: '비밀번호 확인',
                                      hintStyle:
                                          TextStyle(fontSize: 18)),
                                  onChanged: (val) {
                                    password = val;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
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
                                      ds.getUserInfoList(userId).then((val) {
                                        if (!val.exists) {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            signUpWithUserIdPassword();
                                          }
                                        } else {
                                          checkIdPasswordPopup('중복 수험번호',
                                              '해당 아이디는 이미 가입되어 있습니다.');
                                        }
                                      });
                                    },
                                    child: userIdLoginButton(
                                        context,
                                        '회원 가입',
                                        Colors.white,
                                        Colors.green.withOpacity(0.7),
                                        Colors.green)),
                                const SizedBox(height: 10),
                                InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: userIdLoginButton(
                                        context,
                                        '돌아가기',
                                        Colors.black,
                                        Colors.white.withOpacity(0.7),
                                        Colors.white)),
                              ],
                            ),
                      const SizedBox(height: 100),
                    ])),
          ),
        ]));
  }

  checkIdPasswordPopup(title, content) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
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
}
