import 'package:flutter/material.dart';
import 'dart:async';

class AboutTime with ChangeNotifier {
  bool _isRunning = false;
  Timer? _timer;

  bool get isRunning => _isRunning;
  // int get seconds =>

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _isRunning = true;
    // _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
    //   // if (mounted) {
    //     setState(() {
    //       room.endTime.add(Duration(seconds: 1));
    //     });
    //   }
    // });
  }
}