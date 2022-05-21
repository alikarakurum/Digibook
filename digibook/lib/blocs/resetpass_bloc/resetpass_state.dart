class RePassState {
  final bool isRePassEmailValid;
  final bool isRePassPageGo;
  final bool isRePassSent;

  bool get isFormValid => isRePassEmailValid && isRePassPageGo;

  RePassState(
      {this.isRePassEmailValid, this.isRePassPageGo, this.isRePassSent});

  factory RePassState.initial() {
    return RePassState(
      isRePassEmailValid: true,
      isRePassPageGo: false,
      isRePassSent: false,
    );
  }

  factory RePassState.rePasswordLoading() {
    return RePassState(
        isRePassEmailValid: true, isRePassPageGo: true, isRePassSent: false);
  }
  factory RePassState.rePasswordFail() {
    return RePassState(
        isRePassEmailValid: true, isRePassPageGo: false, isRePassSent: false);
  }
  factory RePassState.rePasswordSuccess() {
    return RePassState(
        isRePassEmailValid: true, isRePassPageGo: true, isRePassSent: true);
  }
  RePassState rePasswordUpdate({bool isRePassEmailValid}) {
    return copyWith(
        isRePassEmailValid: isRePassEmailValid,
        isRePassPageGo: false,
        isRePassSent: false);
  }

  RePassState copyWith({
    final bool isRePassEmailValid,
    final bool isRePassPageGo,
    final bool isRePassSent,
  }) {
    return RePassState(
        isRePassEmailValid: isRePassEmailValid ?? this.isRePassEmailValid,
        isRePassPageGo: isRePassPageGo ?? this.isRePassPageGo,
        isRePassSent: isRePassSent ?? this.isRePassSent);
  }
}
