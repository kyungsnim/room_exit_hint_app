// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:room_exit_hint_app/constants/constants.dart';
// import 'package:room_exit_hint_app/screens/hint_screen.dart';
// import 'package:room_exit_hint_app/screens/messenger_screen.dart';
// import 'package:room_exit_hint_app/screens/rewind_hint_screen.dart';
// import 'package:room_exit_hint_app/screens/setting_screen.dart';
//
// import 'models/current_user.dart';
//
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.black54,
//           title: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   InkWell(
//                     onTap: () => Get.to(() => SettingScreen()),
//                     child: Icon(
//                       Icons.settings,
//                       color: Colors.white,
//                     ),
//                   )
//                 ],
//               ),
//               customAppBarView(Icons.access_time, '남은 시간 59:00'),
//               customAppBarView(Icons.favorite, '사용한 힌트 수 3개'),
//             ],
//           ),
//           toolbarHeight: Get.height * 0.15,
//           bottom: TabBar(
//             labelColor: Colors.white,
//             indicatorColor: kPrimaryColor,
//             // isScrollable: true,
//             unselectedLabelColor: Colors.white,
//             physics: NeverScrollableScrollPhysics(),
//             tabs: [
//               Tab(
//                 child: Text(
//                   '힌트',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//                 ),
//               ),
//               Tab(
//                 child: Text('메신저',
//                     textAlign: TextAlign.center,
//                     style:
//                         TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
//               ),
//               Tab(
//                 child: Text('힌트 다시보기',
//                     textAlign: TextAlign.center,
//                     style:
//                         TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
//               ),
//             ],
//           ),
//           // elevation: 0,
//           centerTitle: true,
//         ),
//         body: TabBarView(
//           physics: NeverScrollableScrollPhysics(),
//           children: [
//             HintScreen(),
//             MessengerScreen(),
//             RewindHintScreen(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   customAppBarView(IconData iconData, String title) {
//     return Row(
//       children: [
//         Icon(iconData, color: Colors.white,),
//         SizedBox(width: 10),
//         Text(
//           title,
//           style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//               fontSize: Get.width * 0.06,),
//         ),
//       ],
//     );
//   }
// }
