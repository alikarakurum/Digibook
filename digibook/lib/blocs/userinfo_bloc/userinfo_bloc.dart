import 'package:digibook/blocs/userinfo_bloc/userinfo_state.dart';
import 'package:digibook/blocs/userinfo_bloc/userinfo_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:digibook/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:digibook/utils/validators.dart';
import 'package:digibook/repositories/user_info_works.dart';

class UserInfoBloc extends Bloc<UserInfoEvent, UserInfoState> {
  final UserRepository _userRepository;
  UserInfoWorks _userInfoWorks;

  UserInfoBloc({UserRepository userRepository, FirebaseFirestore firestore})
      : assert(userRepository != null),
        _userRepository = userRepository,
        _userInfoWorks = UserInfoWorks(),
        super(UserInfoState.initial());

  @override
  Stream<UserInfoState> mapEventToState(UserInfoEvent event) async* {
    if (event is UserNameExist) {
      yield* _mapUsernameExistToState(event.currentUser);
    } else if (event is UserNameAlreadyTaken) {
      yield* _mapUsernameTakenToState(event.userName);
    } else if (event is UsernameChange) {
      yield* _mapUsernameChangeToState(event.username);
    } else if (event is DisplayNameChange) {
      yield* _mapDisplayNameChangeToState(event.displayname);
    } else if (event is UserInfoSubmitted) {
      yield* _mapUserInfoSubmitedToState(
          event.displayname, event.username, event.birthdate);
    } else if (event is BirthDateListener) {
      yield* _mapBirthDateChangeToState(event.birthDate);
    } else if (event is GetUserInfo) {
      yield* _mapUserInfoToState(event.uid);
    }
  }

  Stream<UserInfoState> _mapUsernameExistToState(User currentUser) async* {
    try {
      final isUsernameExist = await _userRepository.usernameQuery(currentUser);
      if (isUsernameExist) {
        yield UserNameResult(usernameExist: isUsernameExist);
      } else
        debugPrint("");
    } catch (e) {
      debugPrint(e.toString() + "/////////////////////////////////////");
    }
  }

  ///////////////////////////////////////////////////////////////////////////////////////
/////////////Below//////////////Does username already taken by another user?/////////////////////////////////////////
  Stream<UserInfoState> _mapUsernameTakenToState(String username) async* {
    yield UsernameAlreadyTaken();
  }

  Stream<UserInfoState> _mapUsernameChangeToState(String username) async* {
    yield state.update(isUsernameValid: Validators.isValidUserName(username));
  }

  Stream<UserInfoState> _mapDisplayNameChangeToState(
      String displayname) async* {
    yield state.update(
        isDisplayNameValid: Validators.isValidDisplayName(displayname));
  }

  Stream<UserInfoState> _mapUserInfoSubmitedToState(
      String displayname, String username, DateTime birthdate) async* {
    bool result;
    try {
      _userInfoWorks.submitUserInfoFirstTime(displayname, username, birthdate);
      result = true;
    } catch (e) {
      debugPrint(e.toString() + "!!!!!!!!!!!!!!!submit gerçekleşemedi.");
      yield state.update(isSubmissionFailed: true);
      result = false;
    }
    yield state.update(isFormSubmitted: result);
  }

  Stream<UserInfoState> _mapUserInfoToState(String uid) async* {}

  Stream<UserInfoState> _mapBirthDateChangeToState(DateTime birthDate) async* {
    yield BirthDateListen(birthDate: birthDate);
  }
}
