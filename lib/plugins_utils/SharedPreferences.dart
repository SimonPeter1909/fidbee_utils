import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../fidbee_utils.dart';

class Preferences {
  static final login_status_key = "login_status_key";
  static final admin_status_key = "admin_status_key";
  static final first_launch_key = "first_launch_key";
  static final offline = "offline";
  static final username_key = "username_key";
  static final user_id = "user_id_key";
  static final password_key = "password_key";
  static final first_name_key = "first_name_key";
  static final last_name_key = "last_name_key";
  static final phone_number_key = "phone_number_key";
  static final avatar_key = "avatar_key";
  static final alert_list = "alert_list";
  static final firebase_token = "firebase_token";
  static final base_url = "base_url";
  static final app_lock = "app_lock";
  static final jwt_token = "jwt_token";

  
  
  static Future<bool> saveFBToken(String userName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(firebase_token, userName);
  }

  static Future<String> getFBToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(firebase_token);
  }

  static Future<List<String>> getAlertList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList(alert_list)?.reversed?.toList();
    if(list != null){
      return list;
    } else {
      return [];
    }
  }

  static Future<bool> clearAlertList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(alert_list);
  }

  static Future addToAlertList(String alert) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = await getAlertList() ?? [];
    list.add(alert);
    return prefs.setStringList(alert_list, list);
  }

  static Future<bool> setHeader(String header) async {
    final pref = await SharedPreferences.getInstance();
    FidbeeUtils.logD('header set - $header');
    return pref.setString('header', header);
  }

  static Future<bool> setAdminStatus(bool status) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(admin_status_key, status);
  }

  static Future<bool> isAdmin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool(admin_status_key);
    if (status != null) {
      return status;
    } else {
      return false;
    }
  }

  static Future<bool> setLoginStatus(bool status) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(login_status_key, status);
  }

  static Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool(login_status_key);
    if (status != null) {
      return status;
    } else {
      return false;
    }
  }

  static Future<bool> setAppLock(bool status) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(app_lock, status);
  }

  static Future<bool> isAppLockEnabled() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool(app_lock);
    if (status != null) {
      return status;
    } else {
      return false;
    }
  }

  static Future logout() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  static Future<bool> setFirstLaunch(bool status) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(first_launch_key, status);
  }

  static Future<bool> isFirstLaunch() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool(first_launch_key);
    if (status != null) {
      return status;
    } else {
      return false;
    }
  }

  static Future<bool> setOffline(bool status) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(offline, status);
  }

  static Future<bool> isOffline() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool(offline);
    if (status != null) {
      return status;
    } else {
      return false;
    }
  }

  static Future<bool> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(jwt_token, token);
  }

  static Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(jwt_token);
  }

  static Future<bool> saveBaseURL(String userName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(base_url, userName);
  }

  static Future<String> getBaseURL() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(base_url);
  }

  static Future<bool> saveFirstName(String userName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(first_name_key, userName);
  }

  static Future<String> getFirstName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(first_name_key);
  }

  static Future<bool> saveLastName(String userName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(last_name_key, userName);
  }

  static Future<String> getLastName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(last_name_key);
  }

  static Future<bool> savePhoneNumber(String userName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(phone_number_key, userName);
  }

  static Future<String> getPhoneNumber() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(phone_number_key);
  }

  static Future<bool> saveAvatar(String userName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(avatar_key, userName);
  }

  static Future<String> getAvatar() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(avatar_key);
  }

  static Future<bool> savePassword(String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(password_key, password);
  }

  static Future<String> getPassword() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(password_key);
  }

  static Future<bool> saveUserId(String userName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(user_id, userName);
  }

  static Future<String> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(user_id);
  }

  static Future<bool> saveEmail(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(username_key, email);
  }

  static Future<String> getEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(username_key);
  }

  static Future<bool> saveString({String key, String value}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  static Future<String> getString({String key}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<bool> saveBool({String key, String value}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  static Future<String> getBool({String key}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<bool> clearPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    return true;
  }

  static Future<bool> clearBaseURL() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(base_url);
    return true;
  }
}
