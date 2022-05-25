import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:room_exit_hint_app/home_screen.dart';
import 'package:room_exit_hint_app/screens/login/sign_in_with_user_id.dart';

import 'constants/constants.dart';
import 'notification/notification_bloc.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  Vibrate.vibrate();
  print('background message ${message.notification!.body}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.openBox('notifications');
  FirebaseMessaging.onBackgroundMessage(_messageHandler);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NotificationBloc>(create: (context) => NotificationBloc()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: AppBarTheme(
            color: kPrimarySecondColor,
          ),
        ),
        home: SignInPageWithUserId(),
      ),
    );
  }
}
