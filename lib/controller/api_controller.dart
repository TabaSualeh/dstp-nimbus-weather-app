import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nimbus/utils/app_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/string_constants.dart';

class ApiController {
  AppModel _appModel = Get.find<AppModel>();

  Future<String> _retrieveToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(Constants.tokenKey) ?? "";
  }

  Future<void> setToken({required String value}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constants.tokenKey, value);
  }

  Future<(int statusCode, String body)> get({required String url, bool isToken = false}) async {
    bool connected = await Get.find<AppModel>().isInternet();

    if (!connected) {
      return (503, "No Internet Connection");
    }

    Map<String, String> headers = {'Content-Type': 'application/json'};

    if (isToken) {
      String token = await _retrieveToken();
      headers.addAll({'Authorization': 'Bearer $token'});
    }

    try {
      Uri uri = Uri.parse(url);
      var response = await http.get(uri, headers: headers);
      return (response.statusCode, response.body);
    } catch (e) {
      print(e);
      return (600, "Something went wrong");
    }
  }

  Future<(int statusCode, String body)> post({
    required String url,
    dynamic body,
    bool isToken = false,
  }) async {
    Map<String, String> headers = {'Content-Type': 'application/json'};

    if (isToken) {
      String token = await _retrieveToken();
      headers.addAll({'Authorization': 'Bearer $token'});
    }

    try {
      Uri uri = Uri.parse(url);

      var response = await http.post(
        uri,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );
      return (response.statusCode, response.body);
    } catch (e) {
      print(e);
      return (600, "Something went wrong");
    }
  }
}
