import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fidbee_utils/plugins_utils/SharedPreferences.dart';
import './settings_screen.dart';

abstract class SettingsScreenViewModel extends State<SettingsScreen> {
  
  final appLockCntlr = StreamController<bool>.broadcast();
  final themeCntlr = StreamController<bool>.broadcast();

  checkAppLock() async {
    bool appLock = await Preferences.isAppLockEnabled();
    appLockCntlr.add(appLock);
  }

  switchAppLock(bool value) async {
    await Preferences.setAppLock(value);
    appLockCntlr.add(value);
  }

  switchTheme(bool value) async {
    themeCntlr.add(value);
  }

}
