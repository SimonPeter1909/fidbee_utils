import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fidbee_utils/fidbee_utils.dart';

class FBAuth {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> login(String email, String password) async {
    return await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((result) {
      if (result.user != null) {
        return true;
      } else {
        return false;
      }
    }).catchError((e) {
      return false;
    });
  }

  Future<bool> loginWithCredentials(AuthCredential credential) async {
    return await _firebaseAuth
        .signInWithCredential(credential)
        .then((result) {
      if (result.user != null) {
        return true;
      } else {
        return false;
      }
    }).catchError((e) {
      return false;
    });
  }

  Future<bool> register(String email, String password) async {
    return await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((result) {
      if (result.user != null) {
        return true;
      } else {
        return false;
      }
    }).catchError((e) {
      return false;
    });
  }

  Future<bool> isLoggedIn() async {
    User user = _firebaseAuth.currentUser;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  ///send password reset link
  Future<bool> sendPasswordResetLink(String email) async {
    bool result;
    await _firebaseAuth.sendPasswordResetEmail(email: email).then((val) {
      result = true;
    }).catchError((e) {
      FidbeeUtils.logD('error - $e');
      result = false;
    });
    return result;
  }

  Future<String> currentUid() async {
    User user = _firebaseAuth.currentUser;
    return user.uid;
  }

  Future<String> currentEMail() async {
    User user = _firebaseAuth.currentUser;
    return user.email;
  }

  logout() async {
    await _firebaseAuth.signOut();
    await FidbeeUtils.logout();
  }

  Future sendOtpCode({
    String phoneNumber,
    PhoneVerificationCompleted verificationCompleted,
    PhoneVerificationFailed verificationFailed,
    PhoneCodeSent codeSent,
    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
    Duration timeOut,
  }) async {
   await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: timeOut,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  Future<bool> signInWithOTP({String otp, String verificationId}) async {
    FidbeeUtils.logD('vid - $verificationId | otp - $otp');
    try {
      AuthCredential credential = PhoneAuthProvider.getCredential(
          verificationId: verificationId, smsCode: otp);
      return await _firebaseAuth.signInWithCredential(credential).then((value) {
        return true;
      }).catchError((e) {
        FidbeeUtils.logD('credential error - $e');
        return false;
      });
    } catch (e) {
      return false;
    }
  }
}
