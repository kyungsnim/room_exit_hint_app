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
  List<String> tokenList = [];
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

      List<String> tokenList = [currentUser.FCMToken];

      /// push notification
      NotificationService()
          .sendMessage(
          '${currentUser.name}님의 메시지', '${_message.text}', tokenList)
          .then((value) {
        print(value);
      });

      _message.clear();
    } else {
      print('enter text');
    }
  }

  // Future<void> getRoundingInfo() async {
  //   await _firestore
  //       .collection('Groups')
  //       .doc(widget.roomId)
  //       .get()
  //       .then((value) {
  //     setState(() {
  //       roundingInfo = value.data();
  //       isLoading = false;
  //       reserveMembers = roundingInfo!['reserveMembers'];
  //       leaderInfo = roundingInfo!['leader'];
  //       isFinalReserved = roundingInfo!['isReserved'];
  //     });
  //
  //     for (int i = 0; i < reserveMembers.length; i++) {
  //       if (currentUser!.uid == reserveMembers[i]['uid']) {
  //         // if (_auth.currentUser!.uid == reserveMembers[i]['uid']) {
  //         setState(() {
  //           isMeReserveComplete = true;
  //         });
  //       }
  //     }
  //
  //     if (reserveMembers.length == roundingInfo!['player']) {
  //       setState(() {
  //         isFinalReserveReady = true;
  //       });
  //     }
  //   });
  // }

  @override
  void initState() {
    print(widget.roomId);
    super.initState();
    // getRoundingInfo().then((_) {
    //   switch (roundingInfo!['playDate'].toDate().weekday) {
    //     case 7:
    //       weekDay = '(일)';
    //       break;
    //     case 1:
    //       weekDay = '(월)';
    //       break;
    //     case 2:
    //       weekDay = '(화)';
    //       break;
    //     case 3:
    //       weekDay = '(수)';
    //       break;
    //     case 4:
    //       weekDay = '(목)';
    //       break;
    //     case 5:
    //       weekDay = '(금)';
    //       break;
    //     case 6:
    //       weekDay = '(토)';
    //       break;
    //   }

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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(
            FocusNode()),
        child: Column(
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
            /// 메시지 입력 창
            Container(
              height: Get.height * 0.06,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      offset: Offset(1, 1),
                      blurRadius: 3,
                      color: kPrimaryColor),
                ],
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: size.height * 0.05,
                        width: size.width / 1.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            20,
                          ),
                        ),
                        child: TextField(
                          cursorColor: kPrimarySecondColor,
                          controller: _message,
                          decoration: InputDecoration(
                            hintText: '메시지 입력',
                            hintStyle: TextStyle(
                              fontSize: Get.width * 0.03,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  width: 2, color: kPrimarySecondColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  color: kPrimarySecondColor, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  color: kPrimarySecondColor, width: 2.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.send,
                          color: kPrimarySecondColor,
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
                  style: TextStyle(fontSize: 10, color: Colors.black54),
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
                      style: TextStyle(color: Colors.black87),
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
                  style: TextStyle(fontSize: 10, color: Colors.black54),
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
              color: Colors.black54,
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

  // roundingInfoText(
  //     IconData iconData, String title, String content, bool reserveView) {
  //   return Row(
  //     children: [
  //       Container(
  //           decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(50),
  //               boxShadow: [
  //                 BoxShadow(blurRadius: 1, color: kPrimarySecondColor)
  //               ]),
  //           width: Get.width * 0.08,
  //           height: Get.width * 0.08,
  //           child: Padding(
  //             padding: const EdgeInsets.all(2.0),
  //             child: Icon(
  //               iconData,
  //               size: Get.width * 0.06,
  //               color: kPrimarySecondColor,
  //             ),
  //           )),
  //       SizedBox(width: 10),
  //       Expanded(
  //         child: Container(
  //           child: Text(
  //             content,
  //             style:
  //             TextStyle(fontSize: Get.width * 0.04, color: Colors.black54),
  //           ),
  //         ),
  //       ),
  //       reserveView ? renderReserveMember() : SizedBox(),
  //     ],
  //   );
  // }
  //
  // renderReserveMember() {
  //   return Row(
  //     children: [
  //       renderMember(0),
  //       reserveMembers.length == 2 ? renderMember(1) : SizedBox(),
  //       reserveMembers.length == 3
  //           ? Row(
  //         children: [renderMember(1), renderMember(2)],
  //       )
  //           : SizedBox(),
  //       reserveMembers.length == 4
  //           ? Row(children: [renderMember(1), renderMember(2), renderMember(3)])
  //           : SizedBox(),
  //     ],
  //   );
  // }
  //
  // renderMember(int index) {
  //   return Container(
  //     width: Get.width * 0.07,
  //     height: Get.width * 0.07,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(50),
  //       border: Border.all(
  //           width: 2,
  //           color: reserveMembers[index]['sex'] == '남'
  //               ? Colors.blueAccent
  //               : Colors.pinkAccent),
  //     ),
  //     child: ClipRRect(
  //       borderRadius: BorderRadius.circular(50),
  //       child: CachedNetworkImage(
  //         imageUrl: reserveMembers[index]['image'],
  //       ),
  //     ),
  //   );
  // }
  //
  // leaderInfoText(String content) {
  //   return Row(
  //     children: [
  //       Container(
  //         width: Get.width * 0.08,
  //         height: Get.width * 0.08,
  //         decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(50),
  //             boxShadow: [
  //               BoxShadow(blurRadius: 1, color: kPrimarySecondColor)
  //             ]),
  //         child: ClipRRect(
  //           borderRadius: BorderRadius.circular(50),
  //           child: CachedNetworkImage(imageUrl: leaderInfo!['image']),
  //         ),
  //       ),
  //       SizedBox(width: 10),
  //       Expanded(
  //         child: Container(
  //           child: Text(
  //             content,
  //             style:
  //             TextStyle(fontSize: Get.width * 0.04, color: Colors.black54),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
  //
  // Future getImage() async {
  //   ImagePicker _picker = ImagePicker();
  //
  //   await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
  //     if (xFile != null) {
  //       imageFile = File(xFile.path);
  //       uploadImage();
  //     }
  //   });
  // }
  //
  // Future uploadImage() async {
  //   String fileName = Uuid().v1();
  //   bool status = true;
  //
  //   setState(() {
  //     isUploading = true;
  //   });
  //   await _firestore
  //       .collection('Groups')
  //       .doc(roundingInfo!['id'])
  //       .collection('Chats')
  //       .doc(fileName)
  //       .set({
  //     'sendBy': currentUser!.uid, //_auth.currentUser!.displayName,
  //     'message': '',
  //     'type': 'img',
  //     'time': FieldValue.serverTimestamp(),
  //   });
  //
  //   var ref =
  //   FirebaseStorage.instance.ref().child('images').child('$fileName.jpg');
  //
  //   /// 에러가 있는 경우 firestore에 저장한 자료 삭제
  //   var uploadTask = ref.putFile(imageFile!).catchError((onError) async {
  //     await _firestore
  //         .collection('Groups')
  //         .doc(roundingInfo!['id'])
  //         .collection('Chats')
  //         .doc(fileName)
  //         .delete();
  //
  //     status = false;
  //   });
  //
  //   uploadTask.asStream().listen((TaskSnapshot snapshot) {
  //     print('Task state: ${snapshot.state}');
  //     print(
  //         'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
  //   }, onError: (e) {
  //     // The final snapshot is also available on the task via `.snapshot`,
  //     // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
  //     // print(uploadTask.);
  //
  //     if (e.code == 'permission-denied') {
  //       print('User does not have permission to upload to this reference.');
  //     }
  //   });
  //
  //   // We can still optionally use the Future alongside the stream.
  //   try {
  //     await uploadTask;
  //     print('Upload complete.');
  //   } on FirebaseException catch (e) {
  //     if (e.code == 'permission-denied') {
  //       print('User does not have permission to upload to this reference.');
  //     }
  //     // ...
  //   }
  //
  //   if (status) {
  //     String imageUrl = await ref.getDownloadURL();
  //
  //     await _firestore
  //         .collection('Groups')
  //         .doc(roundingInfo!['id'])
  //         .collection('Chats')
  //         .doc(fileName)
  //         .update({'message': imageUrl});
  //
  //     // print(imageUrl);
  //   }
  //
  //   setState(() {
  //     isUploading = false;
  //   });
  // }
}
