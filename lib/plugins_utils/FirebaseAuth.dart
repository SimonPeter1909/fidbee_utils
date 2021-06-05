import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../fidbee_utils.dart';

class FirebaseAuthClass {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<bool> signInWithEmailAndPassword({@required String username, @required String password}) async {
    final FirebaseUser user = (await _auth
            .signInWithEmailAndPassword(
              email: username,
              password: password,
            )
            .catchError((e) => FidbeeUtils.logD('sign in Error - $e')))
        .user;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> registerWithEmailAndPassword({@required String username, @required String password}) async {
    final FirebaseUser user = (await _auth
            .createUserWithEmailAndPassword(
              email: username,
              password: password,
            )
            .catchError((e) => FidbeeUtils.logD('register Error - $e')))
        .user;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  static Future logout() async {
    await _auth.signOut();
  }

  static Future<String> getUid() async {
    User user = _auth.currentUser;
    return user.uid;
  }

  static Future<bool> isLoggedIn() async {
    User user = _auth.currentUser;
    return user != null;
  }
}
