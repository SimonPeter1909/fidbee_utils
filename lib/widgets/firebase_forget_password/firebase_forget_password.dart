import 'package:flutter/material.dart';
import 'package:fidbee_utils/firebase/fb_auth/fb_auth.dart';
import 'package:fidbee_utils/plugins_utils/Fluttertoast.dart';
import 'package:fidbee_utils/widgets/firebase_forget_password/firebase_forget_password_activity.dart';

class FirebaseForgetPassword extends StatefulWidget {
  @override
  _FirebaseForgetPasswordState createState() => _FirebaseForgetPasswordState();
}

class _FirebaseForgetPasswordState extends FirebaseForgetPasswordActivity {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text('Forget Password?'),
      content: Form(
        key: forgetPassFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('A password reset link will be send to the E-Mail ID'),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Enter your E-Mail',
                labelText: 'E-Mail',
              ),
              validator: (val) {
                if (val.isEmpty)
                  return 'Enter E-Mail Address';
                else if (!val.contains('.') && !val.contains('@'))
                  return 'Enter Proper E-Mail Address';
                return null;
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        StreamBuilder<bool>(
            stream: sendBtnCntlr.stream,
            initialData: false,
            builder: (context, snapshot) {
              if (snapshot.data) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return FlatButton(
                child: Text('Send'),
                onPressed: () async {
                  if (forgetPassFormKey.currentState.validate()) {
                    sendBtnCntlr.add(true);
                    if (await FBAuth()
                        .sendPasswordResetLink(emailController.text)) {
                      Navigator.pop(context);
                      ToastUtils.successToast(
                          'Password Reset E-Mail has been sent successfully');
                    } else {
                      Navigator.pop(context);
                      ToastUtils.errorToast(
                          'This E-Mail ID is not Registered. Please Check the E-Mail ID or Create a New Account');
                    }
                  }
                },
              );
            }),
      ],
    );
  }
}
