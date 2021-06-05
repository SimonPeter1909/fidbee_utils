import 'package:flutter/material.dart';

import './settings_screen_view.dart';

class SettingsScreen extends StatefulWidget {
  final bool themeEnabled;
  final bool multiLanguageEnabled;
  final Function(BuildContext context) changePassword;
  final Function(BuildContext context) onLogout;
  final Function(BuildContext context) chooseLanguage;
  final Function(bool value, BuildContext context) switchTheme;
  final BuildContext context;

  SettingsScreen(
      {@required this.changePassword,
      @required this.chooseLanguage,
      @required this.switchTheme,
      @required this.onLogout,
      this.themeEnabled,
      this.multiLanguageEnabled,
      this.context});

  @override
  SettingsScreenView createState() => new SettingsScreenView();
}
