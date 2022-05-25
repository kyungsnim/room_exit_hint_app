import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:room_exit_hint_app/constants/constants.dart';
import 'package:room_exit_hint_app/db/database.dart';
import 'package:room_exit_hint_app/models/room_model.dart';
import 'package:room_exit_hint_app/screens/view_hint_screen.dart';
import 'package:room_exit_hint_app/screens/waiting_room_screen.dart';
import 'package:room_exit_hint_app/widgets/show_delete_dialog.dart';
import 'package:room_exit_hint_app/widgets/show_more_time_dialog.dart';

class HintScreen extends StatefulWidget {
  RoomModel room;

  HintScreen({required this.room, Key? key}) : super(key: key);

  @override
  _HintScreenState createState() => _HintScreenState();
}

class _HintScreenState extends State<HintScreen> {
  String hintCode = '';
  TextEditingController timeController = TextEditingController();
  RoomModel? room;
  TextEditingController pwdController = TextEditingController();

  @override
  void initState() {
    setState(() {
      room = widget.room;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: Get.width * 0.55,
                height: Get.height * 0.07,
                child: ElevatedButton(
                    onPressed: () {
                      if (currentUser.id == 'admin') {
                        Get.snackbar('힌트 보기 불가', '관리자는 힌트를 볼 수 없습니다.',
                            colorText: Colors.white,
                            backgroundColor: kPrimaryColor);
                      } else if (widget.room.usedHintCount ==
                          widget.room.hintCount) {
                        Get.snackbar('힌트 보기 불가', '더 이상 힌트 사용이 불가능합니다.');
                      } else {
                        showPasswordForHintDialog(context, pwdController,room!);
                      }
                    },
                    child: Text('힌트 보기',
                        style: TextStyle(
                          fontSize: Get.width * 0.05,
                        )),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
                    )),
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              Text(
                '현재 풀고 있는 문제의 힌트를 보여줍니다.\n힌트 사용시 사용한 힌트 1개가 추가됩니다.',
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              currentUser.id == 'admin'
                  ? SizedBox(
                      height: Get.height * 0.05,
                    )
                  : SizedBox(),
              currentUser.id == 'admin'
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: InkWell(
                              onTap: () {
                                showMoreTimeDialog(
                                    context, widget.room, timeController);
                              },
                              child: Icon(
                                Icons.more_time,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: Get.width * 0.03),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: InkWell(
                              onTap: () {
                                showDeleteDialog(context, widget.room);
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : SizedBox()
            ],
          ),
        ),
      ),
      // floatingActionButton: currentUser.id == 'admin'
      //     ? Column(
      //         mainAxisAlignment: MainAxisAlignment.end,
      //         children: [
      //           FloatingActionButton(
      //             onPressed: () {
      //               /// 시간 추가하는 부분 구현 중
      //               showMoreTimeDialog(context, widget.room, timeController)
      //                   .then((_) async {
      //                 // DocumentSnapshot ds = await DatabaseService().getRoomInfo(room!.id);
      //
      //                 // room 정보 업데이트
      //                 // setState(() {
      //                 //   room = RoomModel.fromDS(room!.id, ds);
      //                 // });
      //               });
      //             },
      //             child: const Icon(Icons.more_time),
      //             backgroundColor: Colors.red,
      //           ),
      //           SizedBox(height: Get.height * 0.015),
      //           FloatingActionButton(
      //             onPressed: () {
      //               showDeleteDialog(context, widget.room);
      //             },
      //             child: const Icon(Icons.delete),
      //             backgroundColor: kPrimaryColor,
      //           ),
      //         ],
      //       )
      //     : SizedBox(),
    );
  }

  showPasswordForHintDialog(
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
                  '힌트보기를 위해 비밀번호를 입력하세요.',
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
                        autofocus: true,
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
              ElevatedButton(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text('힌트보기',
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

                    /// 사용자만 힌트 보기 가능
                    final DatabaseReference db =
                    FirebaseDatabase().reference();
                    db
                        .child(widget.room.themaType)
                        .once()
                        .then((DataSnapshot result) async {
                      setState(() {
                        hintCode = result.value['hint'];
                      });
                      print('result = ${result.value['hint']}');

                      String lastHintCode = await DatabaseService()
                          .getLastHintCode(widget.room.id);

                      /// 힌트 보기 눌렀을 때 새로운 힌트를 보는 것이 아닌 경우
                      if (hintCode == lastHintCode) {
                        Get.snackbar('힌트 보기 불가', '새로운 힌트가 없습니다.',
                            colorText: Colors.white,
                            backgroundColor: kPrimaryColor);
                      } else {
                        Get.to(() => ViewHintScreen(
                            hintCode: hintCode, room: widget.room));
                      }
                    });
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
}
