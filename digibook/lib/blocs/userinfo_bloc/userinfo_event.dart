import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserInfoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UsernameChange extends UserInfoEvent {
  final String username;

  UsernameChange({this.username});

  @override
  List<Object> get props => [username];
}

class DisplayNameChange extends UserInfoEvent {
  final String displayname;

  DisplayNameChange({this.displayname});

  @override
  List<Object> get props => [displayname];
}

class UserNameExist extends UserInfoEvent {
  final User currentUser;

  UserNameExist({this.currentUser});

  @override
  List<Object> get props => [currentUser];
}

class UserNameAlreadyTaken extends UserInfoEvent {
  final String userName;

  UserNameAlreadyTaken({this.userName});

  @override
  List<Object> get props => [userName];
}

class UserInfoSubmitted extends UserInfoEvent {
  final String displayname;
  final String username;
  final DateTime birthdate;

  UserInfoSubmitted({this.displayname, this.username, this.birthdate});

  @override
  List<Object> get props => [displayname, username, birthdate];
}

class BirthDateListener extends UserInfoEvent {
  final DateTime birthDate;
  BirthDateListener({this.birthDate});

  @override
  List<Object> get props => [birthDate];
}

class GetUserInfo extends UserInfoEvent {
  final String uid;
  GetUserInfo({this.uid});

  @override
  List<Object> get props => [uid];
}
