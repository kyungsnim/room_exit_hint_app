import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:room_exit_hint_app/models/room_model.dart';
import 'package:room_exit_hint_app/screens/waiting_room_screen.dart';

import '../home_screen.dart';
import '../screens/login/sign_in_with_user_id.dart';

class DatabaseService {
  // 로그인을 위한 회원 로그인정보록 가져오기
  getUserLoginInfo(String userId) async {
    // DocumentSnapshot currentUser;
    String password = "";
    print('userId : $userId');
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userId)
          .get()
          .then((value) {
        // currentUser = value;
        password = value.data()!["password"];
        print("password : $password");
      });
    } catch (e) {
      return "ID error";
    }

    return password;
  }

  updateLastHintCode(String roomId, String hintCode) async {
    try {
      await roomReference.doc(roomId).update({
        'lastHintCode': hintCode
      });
    } catch(e) {
      return "roomID error";
    }
  }
  // 마지막 확인한 힌트코드 가져오기
  getLastHintCode(String roomId) async {
    // DocumentSnapshot currentUser;
    String lastHintCode = "";

    try {
      await roomReference
          .doc(roomId)
          .get()
          .then((value) {
        // currentUser = value;
        lastHintCode = value.data()!["lastHintCode"];
      });
    } catch (e) {
      return "roomID error";
    }

    return lastHintCode;
  }

  /// 힌트 다시보기를 위한 목록 가져오기
  getHintHistoryList(String roomId) async {
    try {
      return await FirebaseFirestore.instance
          .collection("Rooms")
          .doc(roomId)
          .get();
    } catch (e) {
      return "ID error";
    }
  }

  getRoomInfo(String roomId) async {
    return roomReference.doc(roomId).get();
  }

  getUserInfo(String userId) async {
    return userReference.doc(userId).get();
  }

  Future<void> addRoom(Map<String, dynamic> roomMap) async {
    await roomReference
        .doc(roomMap['id'])
        .set(roomMap)
        .catchError((e) => print(e.toString()));

    await roomReference
        .doc(roomMap['id'])
        .collection('Chats')
        .add({
      'message': '방탈출 게임 관련 문의가 있는 경우 언제든 메시지 주세요!',
      'type': 'notify',
      'time': DateTime.now(),
    });
  }

  gameStart(RoomModel room) async {
    await roomReference.doc(room.id).update({
      'isStarted': true,
      'endTime': DateTime.now().add(Duration(minutes: room.playTime.toInt()))
    });
  }

  addUserId(String roomId, String userId) async {
    await roomReference.doc(roomId).update({
      'user': userId
    });
  }

  addFcmToken(String roomId, List<dynamic> tokenList) async {
    List<dynamic> beforeTokenList = [];
    roomReference.doc(roomId).get().then((DocumentSnapshot value) {
      Map<String, dynamic> map = value.data() as Map<String, dynamic>;
      beforeTokenList = map['tokenList'];

      for(int i = 0; i < beforeTokenList.length; i++) {
        if (tokenList[0] == beforeTokenList[i]) {
          beforeTokenList.removeAt(i);
        }
      }

      beforeTokenList.add(tokenList[0]);

      /// admin이 게임시작 먼저 한 경우
      /// admin token 쌓임
      /// 이후에 user 들어오면 token 2개 ok
      ///
      /// user가 먼저 방에 들어간 경우
      /// user token 쌓임
      /// 이후에 게임시작버튼 admin이 누른 경우 admin token 쌓임 ok
      ///
      /// issue : user가 먼저 들어간 후에 메신저 남기면 관리자에게 안감
      /// 방 만들때 admin token 쌓아줘야 할지 고민 필요
      /// admin이 방에 들어갈 때 user 토큰 안지워지도록 해야 함
      ///
      /// 1. admin 방 생성 후 바로 입장 > user1 입장
      /// 2. admin 방 생성 > user1 입장 > admin 입장
      /// 3. admin 방 생성 > user1 입장 > admin 입장 없이 메시지
      ///
      print(beforeTokenList);
      try {
        roomReference.doc(roomId).update({
          'tokenList': beforeTokenList
        });
      } catch(e) {
        print(e);
      }
    });
  }

  setFcmToken(RoomModel room, List<dynamic> tokenList) async {
    await roomReference.doc(room.id).set({
      'tokenList': tokenList
    });
  }

  viewHint(String hintCode, String roomType) async {
    return hintReference.doc(roomType).get();
  }

  saveHintHistory(String roomId, List<dynamic> hintHistory) async {
    return roomReference.doc(roomId).update({'hintHistory': hintHistory});
  }

  useHintCountUp(String roomId, int usedHintCount) async {
    return roomReference.doc(roomId).update({'usedHintCount': usedHintCount});
  }

  deleteRoom(RoomModel room) async {
    roomReference.doc(room.id).collection('Chats').get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    }).then((_) => roomReference.doc(room.id).delete());
  }

  getAvailableRooms() async {
    return await roomReference.get();
  }

  addPlayTime(RoomModel room, int moreTime) async {
    await roomReference.doc(room.id).update({
      'endTime': room.endTime.add(Duration(minutes: moreTime))
    });
  }

  Future<void> addUser(Map pUserMap, String userId) async {
    // random id 부여,
    Map<String, dynamic> userMap = {
      "id": userId,
      "password": pUserMap['password'],
      "name": pUserMap['name'],
      "phoneNumber": pUserMap['phoneNumber'],
      "validateByAdmin": pUserMap['validateByAdmin'], // 최초 회원가입시 관리자 검증 false
      "createdAt": DateTime.now()
    };

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .set(userMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserInfoList(String userId) async {
    return await userReference.doc(userId).get();
  }

  getCurrentRoom(String roomId) async {
    return await roomReference.doc(roomId).get();
  }
}
