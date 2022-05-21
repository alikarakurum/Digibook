import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digibook/repositories/base.dart';
import 'package:digibook/widgets/smscode_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository extends AuthBase {
  final FirebaseAuth _firebaseAuth;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore;

  UserRepository(
      {FirebaseAuth firebaseAuth,
      GoogleSignIn googleSignIn,
      FirebaseFirestore firestore})
      : _firebaseAuth = FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _firestore = FirebaseFirestore.instance;

  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {});
  }

  Future<void> signUp(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    return await _firebaseAuth.signInWithCredential(credential);
  }
/////////////////////////////// PHONE NUMBER SIGN IN ///////////////////////////////////////

  Future<void> signInWithPhoneNumber(String phoneNumber) async {
    String _smsCode;
    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _firebaseAuth.signInWithCredential(credential);
          debugPrint("Köprüden geçti gelin");
        },
        verificationFailed: (FirebaseAuthException e) {
          debugPrint("Verify HATA!!! /TEL NO");
          if (e.code == 'invalid-phone-number') {
            Fluttertoast.showToast(
                msg: "Invalid Phone Number!",
                gravity: ToastGravity.CENTER,
                backgroundColor: Colors.orange[600],
                textColor: Colors.black,
                fontSize: 14.0);
          }
          /*if (e.code == 'sms-quota-has-been-exceeded') {
            Fluttertoast.showToast(
                msg: "Invalid Phone Number!",
                gravity: ToastGravity.CENTER,
                backgroundColor: Colors.orange[600],
                textColor: Colors.black,
                fontSize: 14.0);
          }*/
        },
        codeSent: (String verificationId, int resendToken) async {
          debugPrint("KOD YOLLANDI /TEL NO");
          BuildContext context;
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return SmsCodeDialog(
                  onChanged: (value) {
                    _smsCode = value;
                  },
                  onPressed: () {
                    credential(verificationId, _smsCode);
                  },
                );
              });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          Fluttertoast.showToast(
              msg: "Process Time Out!",
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.orange[600],
              textColor: Colors.black,
              fontSize: 14.0);
        });
  }
/////////////////////////////////////////////////////////////////////////////////////////////////

  Future<void> signOut() async {
    return Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<User> getUser() async {
    return _firebaseAuth.currentUser;
  }

  Future<bool> usernameQuery(User currentUser) async {
    CollectionReference usersRef = _firestore.collection("users");
    debugPrint(usersRef.get().toString() + "////////////////////////////////");
    var result = false;

    DocumentSnapshot document = await usersRef.doc(currentUser.uid).get();
    try {
      if (document.data().containsKey("username")) {
        result = true;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return result;
  }

  Future<void> credential(String verificationId, String smsCode) async {
    PhoneAuthCredential phoneAuthcredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: "124983");
    await _firebaseAuth.signInWithCredential(phoneAuthcredential);
  }

  Future<void> passwordReset(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
