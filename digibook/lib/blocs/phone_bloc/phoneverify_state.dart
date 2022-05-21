class PhoneVerifyState {
  final String parsedNumberText;
  final bool isPhoneNumberValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  bool get isFormValid => isPhoneNumberValid;

  PhoneVerifyState(
      {this.isPhoneNumberValid,
      this.parsedNumberText,
      this.isSubmitting,
      this.isSuccess,
      this.isFailure});

  factory PhoneVerifyState.initial() {
    return PhoneVerifyState(
      isPhoneNumberValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      parsedNumberText: "",
    );
  }

  factory PhoneVerifyState.loading() {
    return PhoneVerifyState(
      isPhoneNumberValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory PhoneVerifyState.failure() {
    return PhoneVerifyState(
      isPhoneNumberValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  factory PhoneVerifyState.success() {
    return PhoneVerifyState(
      isPhoneNumberValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  PhoneVerifyState update({
    bool isPhoneNumberValid,
  }) {
    return copyWith(
      isPhoneNumberValid: isPhoneNumberValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  PhoneVerifyState getNumber({String phoneNumber}) {
    return PhoneVerifyState(parsedNumberText: phoneNumber);
  }

  PhoneVerifyState copyWith({
    bool isPhoneNumberValid,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return PhoneVerifyState(
      isPhoneNumberValid: isPhoneNumberValid ?? this.isPhoneNumberValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }
}
