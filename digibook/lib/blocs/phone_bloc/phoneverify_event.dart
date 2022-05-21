import 'package:equatable/equatable.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

abstract class PhoneVerifyEvent extends Equatable {
  @override
  List<Object> get props => [];
}

/*class PhoneNumberChange extends PhoneVerifyEvent {
  final String phoneNumber;

  PhoneNumberChange({this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}*/

class PhoneNumberValidation extends PhoneVerifyEvent {
  final bool phoneNumberValidation;

  PhoneNumberValidation({this.phoneNumberValidation});

  @override
  List<Object> get props => [phoneNumberValidation];
}

class PhoneNumberChange extends PhoneVerifyEvent {
  final PhoneNumber phoneNumber;

  PhoneNumberChange({this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}

class SmsCodeChange extends PhoneVerifyEvent {
  final String smsCode;

  SmsCodeChange({this.smsCode});

  @override
  List<Object> get props => [smsCode];
}

class LoginWithPhoneSignPressed extends PhoneVerifyEvent {
  final String phoneNumber;


  LoginWithPhoneSignPressed({this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}
