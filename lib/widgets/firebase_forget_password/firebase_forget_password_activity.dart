import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fidbee_utils/widgets/firebase_forget_password/firebase_forget_password.dart';



abstract class FirebaseForgetPasswordActivity extends State<FirebaseForgetPassword>{

  final sendBtnCntlr = StreamController<bool>.broadcast();

  final forgetPassFormKey = GlobalKey<FormState>();

  ///Controller
  TextEditingController emailController = TextEditingController();



}