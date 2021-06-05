import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fidbee_utils/firebase/fb_auth/fb_auth.dart';
import 'package:fidbee_utils/pages/loading_screen.dart';
import 'package:fidbee_utils/plugins_utils/Fluttertoast.dart';
import 'package:fidbee_utils/plugins_utils/SharedPreferences.dart';
import 'package:fidbee_utils/utils/device_unlock.dart';
import 'package:in_app_update/in_app_update.dart';

import '../fidbee_utils.dart';

enum LoadingScreenState { LOADING, ERROR, OLD_APK }

abstract class LoadingActivity extends State<LoadingScreen> {
  final loadingScreenCntlr = StreamController<LoadingScreenState>();

  void getURL() async {
    AppUpdateInfo info = await InAppUpdate.checkForUpdate();

    if (widget.firebaseAdmin) {
      try{
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          FidbeeUtils.logD('Update Not Available');
          if (await FBAuth().isLoggedIn()) {
            if(widget.checkLock || await Preferences.isAppLockEnabled()){
              await Preferences.setAppLock(true);
              switch(await UnlockDevice.unlockDevice()){
                case UnlockDeviceStatus.SUCCESS:
                  widget.userFound();
                  break;
                case UnlockDeviceStatus.FAILURE:
                  ToastUtils.errorToast('Authentication Failed');
                  break;
                case UnlockDeviceStatus.NO_LOCK:
                  widget.lockNotFound();
                  break;
              }
            } else {
              widget.userFound();
            }
          } else {
            widget.userNotFound();
          }
        } else {
          loadingScreenCntlr.add(LoadingScreenState.OLD_APK);
        }
      } catch (e){
       FidbeeUtils.logD('firebase error - $e');
       loadingScreenCntlr.add(LoadingScreenState.ERROR);
      }
    } else {
      if (await widget.checkURL) {
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          FidbeeUtils.logD('Update Not Available');
          if (await FidbeeUtils.isLoggedIn()) {
            FidbeeUtils.logD('user found');
            if(widget.checkLock || await Preferences.isAppLockEnabled()) {
              await Preferences.setAppLock(true);
              switch(await UnlockDevice.unlockDevice()) {
                case UnlockDeviceStatus.SUCCESS:
                  widget.userFound();
                  break;
                case UnlockDeviceStatus.FAILURE:
                  ToastUtils.errorToast('Authentication Failed');
                  break;
                case UnlockDeviceStatus.NO_LOCK:
                  widget.lockNotFound();
                  break;
              }
            } else {
              widget.userFound();
            }
          } else {
            FidbeeUtils.logD('user not found');
            widget.userNotFound();
          }
        } else {
          loadingScreenCntlr.add(LoadingScreenState.OLD_APK);
        }
      } else {
        loadingScreenCntlr.add(LoadingScreenState.ERROR);
      }
    }
  }
}
