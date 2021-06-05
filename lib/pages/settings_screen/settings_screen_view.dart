import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fidbee_utils/pages/settings_screen/settings_screen.dart';
import 'package:fidbee_utils/fidbee_utils.dart';
// import 'package:theme_provider/theme_provider.dart';

import './settings_screen_view_model.dart';

class SettingsScreenView extends SettingsScreenViewModel {
  @override
  void initState() {
    checkAppLock();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // if (widget.themeEnabled)
            //   ListTile(
            //     title: Text('Dark Theme'),
            //     subtitle: Text('Change Theme to Dark and Bright Mode'),
            //     dense: true,
            //     trailing: StreamBuilder<bool>(
            //         stream: themeCntlr.stream,
            //         initialData:
            //         ThemeProvider
            //             .themeOf(context)
            //             .data == ThemeData.dark(),
            //         builder: (context, snapshot) {
            //           return Switch(
            //               value: ThemeProvider
            //                   .themeOf(context)
            //                   .data ==
            //                   ThemeData.dark(),
            //               onChanged: (val) {
            //                 widget.switchTheme(val, context);
            //                 switchTheme(val);
            //               });
            //         }),
            //   ),
            if (widget.themeEnabled) Divider(),
            ListTile(
              dense: true,
              title: Text('App Lock'),
              subtitle:
              Text('If Enabled, Need to Pass Verification on App Launch'),
              trailing: StreamBuilder<bool>(
                  stream: appLockCntlr.stream,
                  builder: (context, snapshot) {
                    return Switch(
                        value: snapshot.data ?? false,
                        onChanged: switchAppLock);
                  }),
            ),
            Divider(),
            if (widget.multiLanguageEnabled)
              ListTile(
                dense: true,
                title: Text('Change Language'),
                subtitle: Text('Tap to Choose Language'),
                trailing: Icon(Icons.chevron_right),
                onTap: () => widget.chooseLanguage(context),
              ),
            if (widget.multiLanguageEnabled) Divider(),
            ListTile(
              dense: true,
              title: Text('Notification Permission'),
              subtitle: Text('Tap to open App Settings'),
              trailing: Icon(Icons.chevron_right),
              onTap: () => FidbeeUtils.checkNotificationPermission(context),
            ),
            Divider(),
            ListTile(
              dense: true,
              title: Text('Change Password'),
              subtitle: Text('Tap to Change Password'),
              trailing: Icon(Icons.chevron_right),
              onTap: () => widget.changePassword(context),
            ),
            Divider(),
            ListTile(
                dense: true,
                trailing: Icon(Icons.chevron_right),
                title: Text('Logout'),
                onTap: () {
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    // false = user must tap button, true = tap outside dialog
                    builder: (BuildContext dialogContext) {
                      return LogoutAlertWidget(
                          widget: widget, dialogContext: dialogContext);
                    },
                  );
                })
          ],
        ),
      ),
    );
  }
}

class LogoutAlertWidget extends StatelessWidget {
  LogoutAlertWidget({
    Key key,
    @required this.widget,
    this.dialogContext,
  }) : super(key: key);

  final SettingsScreen widget;
  final BuildContext dialogContext;

  final loadingCntlr = StreamController<bool>.broadcast();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Warning'),
      content: Text('Do you Really want to Logout?'),
      shape: FidbeeUtils.roundCorner(8),
      actions: <Widget>[
        FlatButton(
          child: Text('No'),
          onPressed: () {
            Navigator.of(dialogContext).pop(); // Dismiss alert dialog
          },
        ),
        StreamBuilder<bool>(
            stream: loadingCntlr.stream,
            initialData: false,
            builder: (context, snapshot) {
              return snapshot.data
                  ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                        ),
                      ),
                    ),
                  )
                  : FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  loadingCntlr.add(true);
                  return widget.onLogout(context);
                },
              );
            })
      ],
    );
  }
}
