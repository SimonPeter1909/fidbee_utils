import 'package:flutter/material.dart';
import 'package:fidbee_utils/fidbee_utils.dart';
import 'login_activity.dart';

class FirebaseLoginScreen extends StatefulWidget {

  final String appLogo;
  final Function(BuildContext context) onSuccess;
  final Function(BuildContext context) onFail;

  FirebaseLoginScreen({@required this.appLogo, @required this.onSuccess,@required this.onFail});

  @override
  _FirebaseLoginScreenState createState() => _FirebaseLoginScreenState();
}

class _FirebaseLoginScreenState extends LoginActivity {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    divWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
              key: formKey,
              autovalidate: autoValidate,
              child: Column(
                children: <Widget>[_buildEmailSignUpForm()],
              )),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
    );
  }

  Widget _buildEmailSignUpForm() {
    //Form 1
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Container(
          height: 100.0,
          child: Image.asset(widget.appLogo),
        ),
        new Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          margin: EdgeInsets.only(left: kMarginPadding, right: kMarginPadding),
          child: new TextFormField(
              controller: emailTextController,
              validator: validateEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  labelText: "Email*",
                  hintText: "Enter your email",
                  labelStyle: new TextStyle(fontSize: 13))),
        ),
        SizedBox(
          height: 10.0,
        ),
        new Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          margin: EdgeInsets.only(left: kMarginPadding, right: kMarginPadding),
          child: new TextFormField(
              style: new TextStyle(
                  fontSize: kMarginPadding, color: Colors.black38),
              obscureText: true,
              validator: (String value) {
                if (value.isEmpty) {
                  return "Please enter your password";
                } else {
                  return null;
                }
              },
              controller: passwordTextController,
              decoration: InputDecoration(
                  labelText: "Password*",
                  hintText: "Enter a password",
                  labelStyle: new TextStyle(fontSize: kFontSize))),
        ),
        SizedBox(
          height: 10.0,
        ),
        StreamBuilder<bool>(
            initialData: false,
            stream: loginButtonController.stream,
            builder: (context, snapshot) {
              if (snapshot.data) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return RaisedButton(
                  child: Text('Login'),
                  onPressed: loginButtonTapped);
            }),
        new FlatButton(
            onPressed: () {
              FidbeeUtils.firebaseForgetPasswordDialog(context);
            },
            child: new Text(
              'Forgot password',
            )),
      ],
    );
  }

}
