import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../fidbee_utils.dart';

class Request {
  static Future<String> request(
      {BuildContext context,
      @required String url,
      Map<String, String> body = const {}}) async {
    final pref = await SharedPreferences.getInstance();
    String baseURL = pref.getString('base_url') ?? '';
    String header = pref.getString('header') ?? '';
    FidbeeUtils.logD('url - $url');
    FidbeeUtils.logD('body - $body');
    try {
      var res = await http.post(
        '$baseURL$url',
        body: body,
        headers: {
          "Authorization" : header
        },
      );
      FidbeeUtils.logD('res - ${res.body}');
      if (res.statusCode == 200) {
        return res.body;
      } else {
        return null;
      }
    } catch (e) {
      FidbeeUtils.logD('http request error - $e');
      return null;
    }
  }
}
