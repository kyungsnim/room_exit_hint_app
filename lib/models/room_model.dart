class RoomModel {
  String id;
  String roomType;
  String hintCount;
  int usedHintCount;
  int playTime;
  DateTime endTime;
  String password;
  bool isStarted;
  List<dynamic> hintHistory;

  RoomModel(
      { required this.id,
        required this.roomType,
        required this.hintCount,
        required this.usedHintCount,
        required this.playTime,
        required this.endTime,
      required this.password,
      required this.isStarted,
      required this.hintHistory});

  factory RoomModel.fromMap(Map data) {
    return RoomModel(
      id: data['id'],
      roomType: data['roomType'],
      hintCount: data['hintCount'],
      usedHintCount: data['usedHintCount'] ?? 0,
      playTime: data['playTime'],
      endTime: data['endTime'] != null ? data['endTime'].toDate() : DateTime.now(),
      password: data['password'],
      isStarted: data['isStarted'] ?? false,
      hintHistory: data['hintHistory'] ?? [],
    );
  }

  factory RoomModel.fromDS(String id, Map<String, dynamic> data) {
    return RoomModel(
      id: id,
      roomType: data['roomType'],
      hintCount: data['hintCount'],
      usedHintCount: data['usedHintCount'] ?? 0,
      playTime: data['playTime'],
      endTime: data['endTime'] != null ? data['endTime'].toDate() : DateTime.now(),
      password: data['password'],
      isStarted: data['isStarted'] ?? false,
      hintHistory: data['hintHistory'] ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "roomType": roomType,
      "hintCount": hintCount,
      "usedHintCount": usedHintCount,
      "playTime": playTime,
      "endTime": endTime,
      "isStarted": isStarted,
    };
  }
}
