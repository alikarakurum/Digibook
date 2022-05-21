import 'package:digibook/blocs/phone_bloc/phoneverify_event.dart';
import 'package:digibook/blocs/phone_bloc/phoneverify_state.dart';
import 'package:digibook/repositories/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneVerifyBloc extends Bloc<PhoneVerifyEvent, PhoneVerifyState> {
  final UserRepository _userRepository;

  PhoneVerifyBloc({UserRepository userRepository})
      : _userRepository = userRepository,
        super(PhoneVerifyState.initial());

  @override
  Stream<PhoneVerifyState> mapEventToState(PhoneVerifyEvent event) async* {
    if (event is PhoneNumberValidation) {
      yield* _mapPhoneNumberValidationToState(event.phoneNumberValidation);
    } else if (event is PhoneNumberChange) {
      yield* _mapPhoneNumberChangeToState(event.phoneNumber);
    } else if (event is LoginWithPhoneSignPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
          phoneNumber: event.phoneNumber);
    }
  }

  Stream<PhoneVerifyState> _mapPhoneNumberValidationToState(
      bool phoneNumberValidation) async* {
    debugPrint("$phoneNumberValidation");
    yield state.update(isPhoneNumberValid: phoneNumberValidation);
  }

  Stream<PhoneVerifyState> _mapPhoneNumberChangeToState(
      PhoneNumber phoneNumber) async* {
    //String _phoneNumber = phoneNumber.parseNumber();
    yield state.getNumber(phoneNumber: phoneNumber.parseNumber());
  }

  Stream<PhoneVerifyState> _mapLoginWithCredentialsPressedToState(
      {String phoneNumber}) async* {
    yield PhoneVerifyState.loading();
    try {
      await _userRepository.signInWithPhoneNumber(phoneNumber);
      yield PhoneVerifyState.success();
    } catch (_) {
      yield PhoneVerifyState.failure();
    }
  }
}
