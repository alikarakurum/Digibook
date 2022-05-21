import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digibook/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:digibook/models/user_of_app.dart';

class UserInfoWorks {
  final UserOfApp _userOfApp;
  final FirebaseAuth _firebaseAuth;
  CollectionReference _usersReference;
  UserInfoWorks(
      {UserRepository userRepository,
      FirebaseFirestore firestore,
      FirebaseAuth firebaseAuth})
      : _userOfApp = UserOfApp(),
        _firebaseAuth = FirebaseAuth.instance,
        _usersReference = FirebaseFirestore.instance.collection("users");

  Future<void> submitUserInfoFirstTime(
      String displayName, String username, DateTime birthDate) async {
    final _currentUserID = _firebaseAuth.currentUser.uid;
    String id = _usersReference.doc(_currentUserID).id;
    try {
      await _usersReference.doc(_currentUserID).set(_userOfApp
          .returnUserOfAppInfoFirstTime(id, username, birthDate, DateTime.now(),
              displayName: displayName));
      return true;
    } catch (_) {
      return false;
    }
  }

  Future takeDocumentOfUser<DocumentSnapshot>(String uid) async {
    final docSnapOfUser = await _usersReference.doc(uid).get();
    return docSnapOfUser;
  }
}
