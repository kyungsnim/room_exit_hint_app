import 'package:cloud_firestore/cloud_firestore.dart';

class CurrentUser {
  String id; // 수험번호 (학번)
  String password;
  String name; // 이름
  String phoneNumber; // 휴대폰번호
  bool validateByAdmin; // 검증 전/후
  DateTime createdAt;
  String role;

  CurrentUser(
      {required this.id,
        required this.password,
        required this.name,
        required this.phoneNumber,
        required this.validateByAdmin,
        required this.createdAt,
      required this.role});

  factory CurrentUser.fromDocument(DocumentSnapshot doc) {
    var getDocs = doc.data() as Map<String, dynamic>;
    return CurrentUser(
        id: doc.id,
        password: getDocs["password"],
        name: getDocs["name"] ?? "-",
        phoneNumber:
            getDocs["phoneNumber"] ?? "-",
        validateByAdmin: getDocs["validateByAdmin"],
        createdAt: getDocs["createdAt"].toDate(),
    role: getDocs["role"] ?? "general");
  }
}
