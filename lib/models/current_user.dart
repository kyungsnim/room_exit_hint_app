import 'package:cloud_firestore/cloud_firestore.dart';

class CurrentUser {
  String id;
  String password;
  String name;
  String phoneNumber;
  bool validateByAdmin;
  DateTime createdAt;
  String role;
  String FCMToken;

  CurrentUser(
      {required this.id,
        required this.password,
        required this.name,
        required this.phoneNumber,
        required this.validateByAdmin,
        required this.createdAt,
      required this.role,
      required this.FCMToken});

  factory CurrentUser.fromDocument(DocumentSnapshot doc) {
    var getDocs = doc.data() as Map<String, dynamic>;
    return CurrentUser(
        id: doc.id,
        password: getDocs["password"],
        name: getDocs["name"] ?? doc.id,
        phoneNumber:
            getDocs["phoneNumber"] ?? "-",
        validateByAdmin: getDocs["validateByAdmin"],
        createdAt: getDocs["createdAt"].toDate(),
    role: getDocs["role"] ?? "general",
    FCMToken: getDocs["FCMToken"] ?? "");
  }
}
