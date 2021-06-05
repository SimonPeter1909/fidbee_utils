import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:fidbee_utils/plugins_utils/SharedPreferences.dart';

import '../../fidbee_utils.dart';

class Notifications {
  void start(
      {@required
          flutterLocalNotificationsPlugin,
      @required
          firebaseMessaging,
      @required
          Future<dynamic> Function(Map<String, dynamic>)
              myBackgroundMessageHandler}) {
    FidbeeUtils.logD('Notification Configuration Started');
    configureNotification(flutterLocalNotificationsPlugin);
    configureMessaging(firebaseMessaging, myBackgroundMessageHandler,
        flutterLocalNotificationsPlugin);
    FidbeeUtils.logD('Notification Configuration Ended');
  }

  void configureNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      FidbeeUtils.logD('notification payload: ' + payload);
    }
  }

  void configureMessaging(
      FirebaseMessaging firebaseMessaging,
      Future<dynamic> Function(Map<String, dynamic>) myBackgroundMessageHandler,
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
    firebaseMessaging.subscribeToTopic('GeneralAlert');
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        message['data']['date'] =
            DateFormat('yyyy-MM-ddTkk:mm:ss').format(DateTime.now());
        FidbeeUtils.logD("onMessage: $message");
        await Preferences.addToAlertList(json.encode(message['data']));
        showNotification(
            flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
            title: message['data']['title'],
            body: message['data']['body']);
      },
      onBackgroundMessage: (val) => myBackgroundMessageHandler(val),
      onLaunch: (Map<String, dynamic> message) async {
        FidbeeUtils.logD("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        FidbeeUtils.logD("onResume: $message");
      },
    );
  }

  showNotification(
      {String channelID,
      String channelName,
      String channelDescription,
      @required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      @required String title,
      @required String body}) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channelID, channelName, channelDescription,
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: 'item x');
  }

//  Future<dynamic> myBackgroundMessageHandler(
//      Map<String, dynamic> message) async {
//    if (message.containsKey('data')) {
//      final dynamic data = message['data'];
//      FidbeeUtils.print('data - $data');
//      data['date'] = DateFormat('yyyy-MM-ddTkk:mm:ss').format(DateTime.now());
//      await Preferences.addToAlertList(json.encode(data));
//      showNotification(body: data['body'], title: data['title']);
//    }
//
//    if (message.containsKey('notification')) {
//      final dynamic notification = message['notification'];
//      FidbeeUtils.print('notification - $notification');
//    }
//  }
}
