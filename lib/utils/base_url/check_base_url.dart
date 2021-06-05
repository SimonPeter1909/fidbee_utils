import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../fidbee_utils.dart';

class CheckBaseURL {
  static String baseURL = 'base_url';

  static Future<bool> checkBaseURL(
      {String localURL,
      String onlineURL,
      @required BaseURLState baseURLState}) async {
    final pref = await SharedPreferences.getInstance();
    String _baseURL = pref.getString(baseURL);

    if (_baseURL == null || _baseURL.isEmpty) {
      FidbeeUtils.logD('url is empty');
      switch (baseURLState) {
        case BaseURLState.LOCAL:
          FidbeeUtils.logD('local url - $localURL');
          _baseURL = localURL;
          break;
        case BaseURLState.ONLINE:
          FidbeeUtils.logD('online url - $onlineURL');
          _baseURL = onlineURL;
          break;
        case BaseURLState.FIREBASE:
          _baseURL = await _getBaseURLFromFB() ?? '';
          break;
      }
      pref.setString(baseURL, _baseURL);
      return await _getBaseURL();
    } else {
      FidbeeUtils.logD('url is not empty, $_baseURL');
      return await _getBaseURL();
    }
  }

  static Future<String> _getBaseURLFromFB() async {
    try{
      await Firebase.initializeApp();
      DocumentSnapshot ds =
      await FirebaseFirestore.instance.collection(baseURL).doc(baseURL).get();
      FidbeeUtils.logD('firebase url - ${ds.get(baseURL)}');
      return ds.get(baseURL);
    } catch (e){
      return null;
    }
  }

  static Future<bool> _getBaseURL() async {
    if (await _checkHttpsConnection()) {
      return true;
    } else if (await _checkHttpConnection()) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> _checkHttpsConnection() async {
    FidbeeUtils.logD('checking https connection');
    final pref = await SharedPreferences.getInstance();

    String _baseURL = pref.getString(baseURL);
    try {
      var res = await http.get(_baseURL);
      if (res.statusCode == 200) {
        FidbeeUtils.logD('https connection Successful res - ${res.body}');
        pref.setString(baseURL, _baseURL);
        return true;
      } else {
        FidbeeUtils.logD(
            'https connection Successful but status code - ${res.statusCode}');
        return false;
      }
    } catch (e) {
      FidbeeUtils.logD('https connection error - $e');
      return false;
    }
  }

  static Future<bool> _checkHttpConnection() async {
    FidbeeUtils.logD('checking http connection');
    final pref = await SharedPreferences.getInstance();
    String _baseURL = pref.getString(baseURL);
    _baseURL = _baseURL.replaceAll('https://', 'http://');
    try {
      var res = await http.get(_baseURL);
      if (res.statusCode == 200) {
        FidbeeUtils.logD('http connection Successful res - ${res.body}');
        pref.setString(baseURL, _baseURL);
        return true;
      } else {
        FidbeeUtils.logD(
            'http connection Successful but res.statusCode = ${res.statusCode}');
        return false;
      }
    } catch (e) {
      FidbeeUtils.logD('http connection error - $e');
      return false;
    }
  }
}
