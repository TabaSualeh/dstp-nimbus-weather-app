import 'dart:io';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppModel extends GetxController {
  SharedPreferences? _prefs;

  Future<void> initPref() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> setStringInPref(String key, String value) async {
    return await _prefs!.setString(key, value);
  }

  String getStringInPref(String key) {
    return _prefs!.getString(key) ?? '';
  }

  // String getGreeting() {
  //   final hour = DateTime.now().hour;
  //
  //   if (hour >= 5 && hour < 12) return 'Good Morning';
  //   if (hour >= 12 && hour < 17) return 'Good Afternoon';
  //   if (hour >= 17 && hour < 21) return 'Good Evening';
  //   return 'Good Night';
  // }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Good Morning';
    if (hour >= 12 && hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Future<bool> isInternet() async {
    bool isInternet = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        isInternet = true;
      }
    } on SocketException catch (_) {
      print('not connected');
      isInternet = false;
    }

    return isInternet;
  }
}
