import 'package:digibook/models/user_of_app.dart';
import 'package:equatable/equatable.dart';

class UserInfoState extends Equatable {
  final bool isUsernameValid;
  final bool isDisplayNameValid;
  final bool isFormSubmitted;
  final bool isSubmissionFailed;
  final UserOfApp userOfApp;

  UserInfoState({
    this.isUsernameValid,
    this.isDisplayNameValid,
    this.isFormSubmitted,
    this.isSubmissionFailed,
    this.userOfApp,
  });

  factory UserInfoState.initial() {
    return UserInfoState(
      isUsernameValid: false,
      isDisplayNameValid: true,
      isFormSubmitted: false,
      isSubmissionFailed: false,
    );
  }

  UserInfoState update(
      {bool isUsernameValid,
      bool isDisplayNameValid,
      bool isFormSubmitted,
      bool isSubmissionFailed}) {
    return copyWith(
      isUsernameValid: isUsernameValid,
      isDisplayNameValid: isDisplayNameValid,
      isFormSubmitted: isFormSubmitted,
      isSubmissionFailed: isSubmissionFailed,
    );
  }

  UserInfoState copyWith(
      {bool isUsernameValid,
      bool isDisplayNameValid,
      bool isFormSubmitted,
      bool isSubmissionFailed}) {
    return UserInfoState(
      isUsernameValid: isUsernameValid ?? this.isUsernameValid,
      isDisplayNameValid: isDisplayNameValid ?? this.isDisplayNameValid,
      isFormSubmitted: isFormSubmitted ?? isFormSubmitted,
      isSubmissionFailed: isSubmissionFailed ?? isSubmissionFailed,
    );
  }

  @override
  List<Object> get props =>
      [isUsernameValid, isDisplayNameValid, isFormSubmitted, userOfApp];
}

class UserNameResult extends UserInfoState {
  final bool usernameExist;

  UserNameResult({this.usernameExist});

  bool get isUsernameExists => usernameExist;

  @override
  List<Object> get props => [usernameExist];
}

class UsernameAlreadyTaken extends UserInfoState {
  final bool usernameAlreadyTaken;
  UsernameAlreadyTaken({this.usernameAlreadyTaken});

  @override
  List<Object> get props => [usernameAlreadyTaken];
}

class BirthDateListen extends UserInfoState {
  final DateTime birthDate;
  BirthDateListen({this.birthDate});

  DateTime get finalDateTime => birthDate;

  @override
  List<Object> get props => [birthDate];
}
