class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );
  static final RegExp _usernameRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }

  static isValidUserName(String username) {
    if (username.length <= 2 || username.length >= 15) {
      return false;
    } else
      return _usernameRegExp.hasMatch(username);
  }

  static isValidSmsCode(var smsCode) {
    if (smsCode.length == 4)
      return true;
    else
      return false;
  }

  static isValidDisplayName(var displayName) {
    if (displayName.length >= 3 && displayName.length <= 16)
      return true;
    else
      return false;
  }
}
