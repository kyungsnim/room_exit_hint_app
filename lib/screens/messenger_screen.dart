import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:room_exit_hint_app/constants/constants.dart';
import 'package:room_exit_hint_app/notification/notification_service.dart';
import 'package:room_exit_hint_app/screens/waiting_room_screen.dart';
import 'package:room_exit_hint_app/widgets/loading_indicator.dart';

class MessengerScreen extends StatefulWidget {
  final String roomId;

  MessengerScreen({required this.roomId, Key? key}) : super(key: key);

  @override
  State<MessengerScreen> createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<MessengerScreen> {
  final TextEditingController _message = TextEditingController();
  File? imageFile;
  // bool isLoading = true;
  bool isUploading = false;
  bool isMeReserveComplete = false; // 예약완료여부
  bool isFinalReserveReady = false;
  bool isFinalReserved = false;
  List<dynamic> tokenList = [];
  List adminList = [];

  String? weekDay;
  Map<String, dynamic>? roundingInfo;
  Map<String, dynamic>? leaderInfo;
  List reserveMembers = [];

  var _lastRow = 0;
  final FETCH_ROW = 15;
  var stream;
  ScrollController _scrollController = new ScrollController();

  Stream<QuerySnapshot> newStream() {
    return roomReference
        .doc(widget.roomId)
        .collection('Chats')
        .orderBy('time', descending: true)
        .limit(FETCH_ROW * (_lastRow + 1))
        .snapshots();
  }

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        'sendBy': currentUser.id, //_auth.currentUser!.displayName,
        'name': currentUser.name, //_auth.currentUser!.displayName,
        'message': _message.text,
        'type': 'text',
        'time': FieldValue.serverTimestamp(),
      };

      await roomReference
          .doc(widget.roomId)
          .collection('Chats')
          .add(messages);

      // /// 마지막 메시지
      // await roomReference.doc(widget.roomId).update({
      //   'lastMessage': _message.text,
      //   'lastMessageTime': FieldValue.serverTimestamp(),
      // });


      String to = '';
      if(tokenList.length < 2) {
        getTokenList();
      }

      for(int i = 0; i < tokenList.length; i++){
        /// 내 토큰값이 아닌 경우 (상대에게 보내야할 토큰값이므로) to 에 할당해주기
        if(currentUser.FCMToken != tokenList[i]) {
          to = tokenList[i];
        }
      }

      print('################ to : $to');
      /// push notification
      NotificationService()
          .sendMessage(
          '${currentUser.name}님의 메시지', '${_message.text}', [to])
          .then((value) {
        print(value);
      });

      _message.clear();
    } else {
      print('enter text');
    }
  }

  getTokenList() async {
    /// 토큰 ㄱㅏ져오기 : 길이가 2이면 ok, 길이가 1이면 관리자만 있는 상태
    roomReference.doc(widget.roomId).get().then((DocumentSnapshot ds) {
      Map<String, dynamic> dsMap = ds.data() as Map<String, dynamic>;
      print(dsMap['tokenList']);
      tokenList = dsMap['tokenList'];
      for(int i = 0; i < dsMap['tokenList'].length; i++){
        print(dsMap['tokenList'][i]);
      }
    });
  }

  @override
  void initState() {

    getTokenList();

    super.initState();
    /// 무한 스크롤
    stream = newStream();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() => stream = newStream());
      }
    });
    // });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(
            FocusNode()),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            /// 채팅 메시지 부분
            Flexible(
              child: GestureDetector(
                onTap: () => currentFocus.unfocus(),
                child: StreamBuilder<QuerySnapshot>(
                    stream: stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            controller: _scrollController,
                            reverse: true,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final currentRow =
                                  (index + 1) ~/ FETCH_ROW;
                              if (_lastRow != currentRow) {
                                _lastRow = currentRow;
                              }
                              Map<String, dynamic> chatMap =
                              snapshot.data!.docs[index].data()
                              as Map<String, dynamic>;
                              return messageTile(size, chatMap);
                            });
                      }
                      return Container();
                    }),
              ),
            ),
            SizedBox(height: 10),
            /// 메시지 입력 창
            Container(
              // height: Get.height * 0.06,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      offset: Offset(1, 1),
                      blurRadius: 3,
                      color: kPrimaryColor),
                ],
                color: Colors.black,
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        // height: size.height * 0.05,
                        width: size.width / 1.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            20,
                          ),
                        ),
                        child: TextField(
                          cursorColor: Colors.white,
                          controller: _message,
                          keyboardType: TextInputType.multiline,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: '메시지 입력',
                            hintStyle: TextStyle(
                              fontSize: Get.width * 0.03,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  width: 2, color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  color: Colors.white, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  color: Colors.white, width: 2.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          onSendMessage();
                        }),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget messageTile(Size size, Map<String, dynamic> chatMap) {
    return Builder(builder: (_) {
      if (chatMap['type'] == 'text') {
        return Container(
          width: size.width,
          alignment: chatMap['sendBy'] ==
              currentUser.id //_auth.currentUser!.displayName
              ? Alignment.centerRight
              : Alignment.centerLeft,
          padding: EdgeInsets.symmetric(
            horizontal: size.width / 100,
            vertical: size.height * 0.0025,
          ),
          child: Container(
            padding: chatMap['sendBy'] ==
                currentUser.id //_auth.currentUser!.displayName
                ? EdgeInsets.only(left: 80)
                : EdgeInsets.only(right: 80),
            child: Row(
              mainAxisAlignment: chatMap['sendBy'] ==
                  currentUser.id //_auth.currentUser!.displayName
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                chatMap['sendBy'] ==
                    currentUser.id //_auth.currentUser!.displayName
                    ? Text(
                  chatMap['time'] == null
                      ? ''
                      : chatMap['time']
                      .toDate()
                      .toString()
                      .substring(2, 10)
                      .replaceAll('-', '.') +
                      '\n' +
                      chatMap['time']
                          .toDate()
                          .toString()
                          .substring(11, 16),
                  style: TextStyle(fontSize: 10, color: Colors.white),
                  textAlign: TextAlign.end,
                )
                    : Text(''),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: chatMap['sendBy'] ==
                          currentUser.id //_auth.currentUser!.displayName
                          ? kPrimaryColor.withOpacity(0.4)
                          : Colors.grey.withOpacity(0.7),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 10,
                    ),
                    margin: chatMap['sendBy'] ==
                        currentUser.id //_auth.currentUser!.displayName
                        ? EdgeInsets.only(left: 8, right: 8)
                        : EdgeInsets.only(right: 8, left: 8),
                    child: Text(
                      chatMap['message'],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                chatMap['sendBy'] ==
                    currentUser.id //_auth.currentUser!.displayName
                    ? Text('')
                    : Text(
                  chatMap['time']
                      .toDate()
                      .toString()
                      .substring(2, 10)
                      .replaceAll('-', '.') +
                      '\n' +
                      chatMap['time']
                          .toDate()
                          .toString()
                          .substring(11, 16),
                  style: TextStyle(fontSize: 10, color: Colors.white),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        );
      } else if (chatMap['type'] == 'notify') {
        return Container(
          width: size.width,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey,
            ),
            padding: EdgeInsets.symmetric(
              vertical: size.height / 50,
              horizontal: size.width / 40,
            ),
            child: Text(chatMap['message'],
                style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        );
      } else {
        return SizedBox();
      }
    });
  }
}
