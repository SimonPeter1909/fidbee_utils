import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fidbee_utils/fidbee_utils.dart';

import 'loading_activity.dart';
import 'update_available_screen.dart';

class LoadingScreen extends StatefulWidget {
  final String appName;
  final Image logoImage;
  final Function userFound;
  final Function userNotFound;
  final Function lockNotFound;
  final Widget errorScreen;
  final bool showSigma;
  final bool firebaseAdmin;
  final String appURL;
  final BoxDecoration bgDecoration;
  final Future<bool> checkURL;
  final bool checkLock;
  final Color sigmaTextColor;
  final Widget customBody;

  LoadingScreen({@required this.appName,
    @required this.logoImage,
    @required this.errorScreen,
    @required this.userFound,
    @required this.userNotFound,
    @required this.lockNotFound,
    @required this.checkLock,
    @required this.checkURL,
    @required this.appURL,
    this.customBody,
    @required this.bgDecoration,
    @required this.firebaseAdmin,
    @required this.sigmaTextColor,
    @required this.showSigma});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends LoadingActivity with AfterLayoutMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<LoadingScreenState>(
          stream: loadingScreenCntlr.stream,
          initialData: LoadingScreenState.LOADING,
          builder: (context, snapshot) {
            switch (snapshot.data) {
              case LoadingScreenState.LOADING:
                return widget.customBody == null
                    ? loadingState()
                    : widget.customBody;
                break;
              case LoadingScreenState.ERROR:
                return errorState();
                break;
              case LoadingScreenState.OLD_APK:
                return UpdateAvailableScreen(
                    appImage: widget.logoImage,
                    appLink: widget.appURL,
                    appName: widget.appName);
                break;
              default:
                return errorState();
            }
          }),
    );
  }

  Widget loadingState() {
    return Stack(
      children: <Widget>[
        Container(
          decoration: widget.bgDecoration,
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: widget.showSigma
                ? Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FidbeeUtils.sigmaText(textColor: widget.sigmaTextColor),
              ],
            )
                : Container(),
          ),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              widget.logoImage,
              SizedBox(
                height: 10,
              ),
              Text(
                widget.appName,
                style: Theme
                    .of(context)
                    .textTheme
                    .headline6,
              ),
              SizedBox(
                height: 10,
              ),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ],
    );
  }

  Widget errorState() {
    return widget.errorScreen;
  }

  Widget oldApkState() {
    return oldVersionWidget(update: () {
      FidbeeUtils.launchURL(widget.appURL);
    });
  }

  /// a common widget for old apk version state
  /// /// needs a function to execute when user clicks [update]
  Widget oldVersionWidget({@required Function update}) {
    return Center(
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('New Update Available'),
        content: Text(
            'Please Download the new Version of the App from Google Play Store'),
        actions: <Widget>[
          FlatButton(
            child: Text('Exit App'),
            onPressed: () {
              SystemNavigator.pop();
            },
          ),
          FlatButton(onPressed: update, child: Text('Update'))
        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    getURL();
  }
}
