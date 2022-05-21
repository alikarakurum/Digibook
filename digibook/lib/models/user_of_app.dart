import 'package:digibook/repositories/user_info_works.dart';

class UserOfApp {
  final String userID;
  final String username;
  final String displayName;
  final DateTime birthDate;
  final String biography;
  final String userProfilePhotoUrl;
  final DateTime timeStampOfRegistration;
  final int userPoint;
  final String parentUserID;
  UserInfoWorks userInfoWorks;

  UserOfApp({
    this.userID,
    this.username,
    this.birthDate,
    this.displayName,
    this.biography,
    this.userProfilePhotoUrl,
    this.timeStampOfRegistration,
    this.userInfoWorks,
    this.userPoint,
    this.parentUserID,
  });

  factory UserOfApp.fromDocument(Map<String, dynamic> docdata) {
    return UserOfApp(
      userID: docdata["id"],
      username: docdata["username"],
      displayName: docdata["displayName"],
      biography: docdata["biography"],
      userProfilePhotoUrl: docdata["userProfilePhotoUrl"],
      userPoint: docdata["userPoint"],
      parentUserID: docdata["parentUserID"] ?? "",
    );
  }
/////// Used to taking username right after the registration step//////////////
  returnUserOfAppInfoFirstTime(
    String userId,
    String username,
    DateTime birthDate,
    DateTime timeStampOfRegistration, {
    String displayName,
  }) {
    return {
      "id": userId,
      "username": username,
      "displayName": displayName ?? "",
      "birthDate": birthDate,
      "timeStampOfRegistration": timeStampOfRegistration,
      "userProfilePhotoUrl": "",
      "biography": "",
      "userPoint": 100,
    };
  }
}
