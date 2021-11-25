import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:room_exit_hint_app/screens/waiting_room_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './constants.dart';
import './notification_model.dart';
import './notifications.dart';
import './next_screen.dart';
import './notification_dialog.dart';

import 'package:http/http.dart' as http;

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final String subscriptionTopic = 'all';
  String? _token = '';

  Future<String?> getToken() async {
    return _token == '' ? await _fcm.getToken() : _token;
  }

  /// 채팅 메시지 알림
  Future<String?> sendMessage(
      String title, String bodyMessage, List<String> token) async {
    String url = 'https://fcm.googleapis.com/fcm/send';
    var body = {
      "registration_ids": token,
      "notification": {
        "title": "$title",
        "body": "$bodyMessage",
      },
      "data": {"messageType": "chat"}
    };

    // print('Send Push Message ========================================');
    print(jsonEncode(body));
    http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAA13D4arw:APA91bHxJx_VKCOX7UrPosaAKax5ciO8qsoA6LynMif-uKH8tgPbnZqHLzGV1vJzXWl9Qrb6ipsB7_PFGQ0svjEwY7WKOSRYtpH90pSiq9cD03-p0g_pmZMhOW95bYO4LY5dFeEbOXuT',
      },
      body: jsonEncode(body),
    );
    return response.body;
  }

  /// 채팅 메시지 알림
  Future<String?> sendReservedComplete(String title, String bodyMessage,
      String roundingId, List tokenList) async {
    String url = 'https://fcm.googleapis.com/fcm/send';
    var body = {
      "registration_ids": tokenList,
      "notification": {
        "title": "$title",
        "body": "$bodyMessage",
      },
      "data": {
        "messageType": "reservedComplete",
        "roundingId": "$roundingId",
      }
    };

    // print('Send Push Message ========================================');
    print(jsonEncode(body));
    http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAPRd8Uj8:APA91bFci0LR8c4PGOKEEOSAg5nsuwlF7FAMBczdjQsjili9aB8pk4-doboTMONj2JCah7fh5tRv4JL4M39ZozhvdE4zUZBNzm3ySaL_uBBjgntkvh2xJjusL4gLNpG2dVzEUBSPhyAs',
      },
      body: jsonEncode(body),
    );
    return response.body;
  }

  Future<String?> sendMessageToAll(String title, String bodyMessage) async {
    String url = 'https://fcm.googleapis.com/fcm/send';
    var body = {
      "to": "/topics/all",
      "notification": {
        "title": "$title",
        "body": "$bodyMessage",
      },
      "data": {"msgId": "msg_12342"}
    };

    // print('Send Push Message ========================================');
    print(jsonEncode(body));
    http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAPRd8Uj8:APA91bFci0LR8c4PGOKEEOSAg5nsuwlF7FAMBczdjQsjili9aB8pk4-doboTMONj2JCah7fh5tRv4JL4M39ZozhvdE4zUZBNzm3ySaL_uBBjgntkvh2xJjusL4gLNpG2dVzEUBSPhyAs',
      },
      body: jsonEncode(body),
    );
    return response.body;
  }

  Future _handleIosNotificationPermission() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    /// heads up notification (only iOS)
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  Future initFirebasePushNotification(context) async {
    /// iOS의 경우 권한 얻어야 함
    if (Platform.isIOS) {
      _handleIosNotificationPermission();
    }

    /// 최초 실행시 토큰 값 얻기
    _token = await _fcm.getToken();
    print('User FCM Token : $_token');

    RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    print('initial message : $initialMessage');
    if (initialMessage != null) {
      /// 알림메시지 저장
      await saveNotificationData(initialMessage).then((value) async {
        var roundingId;

        // if (initialMessage.data["messageType"] == "reservedComplete") {
        //   Get.offAll(() => HomeScreen(
        //             getPageIndex: 1,
        //           ))!
        //       .then((_) => Get.to(() => RoundingChatScreen(
        //           roundingId: initialMessage.data["roundingId"])));
        // } else {
        //   Get.offAll(() => HomeScreen(getPageIndex: 1));
        // }

      });
    }

    // Notification Channel (for android)
    const AndroidNotificationChannel androidNotificationChannel =
        AndroidNotificationChannel(
      'high_importance_channel', // channel id
      'High Importance Notifications', // channel name
      importance: Importance.max,
    );

    // Make Notification Channel (for android)
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);

    // FlutterLocalNotificationsPlugin 초기화. 이 부분은 notification icon 부분에서 다시 다룬다.
    await flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(

            /// android 알림 아이콘 launcher_icon으로 변경해줘야 함
            android: AndroidInitializationSettings('@mipmap/launcher_icon'),
            iOS: IOSInitializationSettings()),
        onSelectNotification: (String? payload) async {});

    /// 앱 실행 중 푸시 알림이 온 경우
    FirebaseMessaging.onMessage.listen((RemoteMessage rm) async {
      print('onMessage');
      await saveNotificationData(rm);

      Vibrate.vibrate();

      /// android foreground heads up notification (only android))
      RemoteNotification? notification = rm.notification;
      AndroidNotification? android = rm.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          0,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel', 'High Importance Notifications',
              icon: 'launcher_icon', // heads up notification icon setting
              largeIcon: DrawableResourceAndroidBitmap(
                'launcher_icon',
              ),
            ),
          ),
        );
      }

      // _handleOpenNotificationDialog(context, rm);
    });

    /// 앱이 백그라운드에 있을 때 푸시 알림이 온 경우
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      await saveNotificationData(message).then((value) {
        Get.offAll(() => WaitingRoomScreen());
        // nextScreen(context, Notifications())
      });
    });
  }

  /// 알림 다이얼로그 띄우기
  Future _handleOpenNotificationDialog(context, RemoteMessage message) async {
    DateTime now = DateTime.now();
    String _timestamp = DateFormat('yyyyMMddHHmmss').format(now);
    NotificationModel notificationModel = NotificationModel(
        timestamp: _timestamp,
        date: message.sentTime,
        title: message.notification!.title,
        body: message.notification!.body);
    // Vibrate.vibrate();

    openNotificationDialog(context, notificationModel);
  }

  Future saveNotificationData(RemoteMessage message) async {
    /// 알림메시지 기기 내에 정보 저장하기
    final list = Hive.box(Constants.notificationTag);
    DateTime now = DateTime.now();
    String _timestamp = DateFormat('yyyyMMddHHmmss').format(now);
    Map<String, dynamic> _notificationData = {
      'timestamp': _timestamp,
      'date': message.sentTime,
      'title': message.notification!.title ?? '',
      'body': message.notification!.body ?? ''
    };

    await list.put(_timestamp, _notificationData);
  }

  Future deleteNotificationData(key) async {
    final bookmarkedList = Hive.box(Constants.notificationTag);
    await bookmarkedList.delete(key);
  }

  Future deleteAllNotificationData() async {
    final bookmarkedList = Hive.box(Constants.notificationTag);
    await bookmarkedList.clear();
  }

  Future<bool> handleFcmSubscribe() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    bool _subscription = sp.getBool('subscribed') ?? true;
    if (_subscription == true) {
      _fcm.subscribeToTopic(subscriptionTopic);
      print('subscribed');
    } else {
      _fcm.unsubscribeFromTopic(subscriptionTopic);
      print('unsubscribed');
    }

    return _subscription;
  }

  void turnOnFcmSubscribtion() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('subscribed', true);
    _fcm.subscribeToTopic(subscriptionTopic);
    print('subscribed');
  }

  void turnOffFcmSubscribtion() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('subscribed', false);
    _fcm.unsubscribeFromTopic(subscriptionTopic);
    print('unsubscribed');
  }
}
