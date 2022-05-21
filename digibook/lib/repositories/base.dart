import 'package:firebase_auth/firebase_auth.dart';


abstract class AuthBase {
  Future<void> signInWithCredentials(String email, String password);
  Future<void> signUp(String email, String password);
  Future<void> signInWithGoogle();
  Future<void> signInWithPhoneNumber(String phoneNumber);
  Future<void> signOut();
  Future<bool> isSignedIn();
  Future<User> getUser();
}
