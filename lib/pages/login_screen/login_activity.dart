import 'dart:async';
import 'package:fidbee_utils/fidbee_utils.dart';
import 'package:flutter/material.dart';
import 'package:fidbee_utils/firebase/fb_auth/fb_auth.dart';
import 'package:fidbee_utils/plugins_utils/Fluttertoast.dart';
import 'login_screen.dart';

abstract class LoginActivity extends State<FirebaseLoginScreen> {
  var divWidth;
  bool autoValidate = false;
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final TextEditingController emailTextController = new TextEditingController();
  final TextEditingController passwordTextController =
      new TextEditingController();
  var kMarginPadding = 16.0;
  var kFontSize = 13.0;

  final loginButtonController = StreamController<bool>.broadcast();

  String validateEmail(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (regex.hasMatch(email))
      return null;
    else
      return "Please enter a valid email";
  }

  loginButtonTapped() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (formKey.currentState.validate()) {
      loginButtonController.add(true);
      if(await FBAuth().login(emailTextController.text, passwordTextController.text) ){
        FidbeeUtils.saveEmail(emailTextController.text);
         widget.onSuccess(context);
      } else {
        widget.onFail(context);
        // ToastUtils.errorToast('Invalid E-Mail ID or Password');
      }
      loginButtonController.add(false);
    }
  }
}
