class RegisterState {
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isUsernameValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;


  bool get isFormValid => isEmailValid && isPasswordValid;

  RegisterState({
    this.isEmailValid,
    this.isPasswordValid,
    this.isUsernameValid,
    this.isSubmitting,
    this.isSuccess,
    this.isFailure,
  });

  factory RegisterState.initial() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isUsernameValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,

    );
  }

  factory RegisterState.loading() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isUsernameValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory RegisterState.failure() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isUsernameValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  factory RegisterState.success() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isUsernameValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }
 
 
  RegisterState update({
    bool isEmailValid,
    bool isPasswordValid,
    bool isUsernameValid,
  }) {
    return copyWith(
      isEmailValid: isEmailValid,
      isUsernameValid: isUsernameValid,
      isPasswordValid: isPasswordValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  RegisterState copyWith({
    bool isEmailValid,
    bool isPasswordValid,
    bool isUsernameValid,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return RegisterState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isUsernameValid: isUsernameValid ?? this.isUsernameValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }
}
