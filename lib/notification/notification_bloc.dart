import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './notification_service.dart';

class NotificationBloc extends ChangeNotifier {

  bool? _subscribed;
  bool? get subscribed => _subscribed;

  Future configureFcmSubscription(bool isSubscribed) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool('subscribed', isSubscribed);
    _subscribed = isSubscribed;
    NotificationService().handleFcmSubscribe();
    notifyListeners();
  }

  Future checkSubscription() async {
    await NotificationService().handleFcmSubscribe().then((bool subscription) {
      _subscribed = subscription;
      notifyListeners();

    });
  }

}
