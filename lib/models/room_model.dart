import 'package:cloud_firestore/cloud_firestore.dart';

class RoomModel {
  String id;
  String themaType;
  String hintCount;
  int usedHintCount;
  int playTime;
  DateTime endTime;
  String password;
  bool isStarted;
  List<dynamic> hintHistory;
  List<dynamic> tokenList;

  RoomModel(
      { required this.id,
        required this.themaType,
        required this.hintCount,
        required this.usedHintCount,
        required this.playTime,
        required this.endTime,
      required this.password,
      required this.isStarted,
      required this.hintHistory,
      required this.tokenList});

  factory RoomModel.fromMap(Map data) {
    return RoomModel(
      id: data['id'],
      themaType: data['themaType'] ?? '',
      hintCount: data['hintCount'],
      usedHintCount: data['usedHintCount'] ?? 0,
      playTime: data['playTime'],
      endTime: data['endTime'] != null ? data['endTime'].toDate() : DateTime.now(),
      password: data['password'],
      isStarted: data['isStarted'] ?? false,
      hintHistory: data['hintHistory'] ?? [],
      tokenList: data['tokenList'] ?? [],
    );
  }

  factory RoomModel.fromDS(String id, DocumentSnapshot data) {
    return RoomModel(
      id: id,
      themaType: data['themaType'],
      hintCount: data['hintCount'],
      usedHintCount: data['usedHintCount'] ?? 0,
      playTime: data['playTime'],
      endTime: data['endTime'] != null ? data['endTime'].toDate() : DateTime.now(),
      password: data['password'],
      isStarted: data['isStarted'] ?? false,
      hintHistory: data['hintHistory'] ?? [],
      tokenList: data['tokenList'] ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "themaType": themaType,
      "hintCount": hintCount,
      "usedHintCount": usedHintCount,
      "playTime": playTime,
      "endTime": endTime,
      "isStarted": isStarted,
      "hintHistory": hintHistory,
      "tokenList": tokenList,
    };
  }
}
