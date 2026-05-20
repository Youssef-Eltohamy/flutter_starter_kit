import 'package:flutter_starter_kit/utils/extensions/extension_string.dart';

class Validator {
  static bool isEmail(String email) {
    const String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    var regExp = RegExp(pattern);

    return regExp.hasMatch(email.trim());
  }

  static bool isNumber(String number) {
    const String pattern = r'^[0-9]+$';

    var regExp = RegExp(pattern);

    return regExp.hasMatch(number.trim());
  }

  static bool isName(String name) {
    const String pattern = r'^[a-zA-Z]+$';
    var regExp = RegExp(pattern);
    return regExp.hasMatch(name.trim());
  }

  static bool isPassportNumber(String name) {
    const String pattern = r'^(?!^0+$)[a-zA-Z0-9]{3,20}$';
    var regExp = RegExp(pattern);
    return regExp.hasMatch(name.trim());
  }

  static ValidationState validateEmail(String? email) {
    if (email.isNullOrEmpty) {
      return ValidationState.empty;
    } else if (!isEmail(email!)) {
      return ValidationState.formatting;
    } else {
      return ValidationState.valid;
    }
  }

  static ValidationState validatePassword(String? password) {
    if (password.isNullOrEmpty) {
      return ValidationState.empty;
    } else if (password!.length < 8) {
      return ValidationState.formatting;
    } else {
      return ValidationState.valid;
    }
  }

  static ValidationState validateOtpCode(String code) {
    if (code.isNullOrEmpty) {
      return ValidationState.empty;
    } else if (code.length != 4) {
      return ValidationState.formatting;
    } else {
      return ValidationState.valid;
    }
  }

  static ValidationState validateNumber(String? number, {int length = 11}) {
    if (number.isNullOrEmpty) {
      return ValidationState.empty;
    } else if (!isNumber(number!) || number.length != length) {
      return ValidationState.formatting;
    } else {
      return ValidationState.valid;
    }
  }

  static ValidationState validateKSANumber(String? number) {
    if (number.isNullOrEmpty) {
      return ValidationState.empty;
    } else if (!isNumber(number!) ||
        !number.startsWith("5") ||
        number.length != 9) {
      return ValidationState.formatting;
    } else {
      return ValidationState.valid;
    }
  }

  static ValidationState validatePassportNumber(String? number) {
    if (number.isNullOrEmpty) {
      return ValidationState.empty;
    } else if (!isPassportNumber(number!)) {
      return ValidationState.formatting;
    } else {
      return ValidationState.valid;
    }
  }

  static ValidationState validateText(String? text) {
    if (text.isNullOrEmpty) {
      return ValidationState.empty;
    } else {
      return ValidationState.valid;
    }
  }

  static ValidationState validateTextWithText(
    String? textNeedToValid,
    String correctText,
  ) {
    if (textNeedToValid.isNullOrEmpty) {
      return ValidationState.empty;
    } else if (textNeedToValid! != correctText) {
      return ValidationState.formatting;
    } else {
      return ValidationState.valid;
    }
  }
}

enum ValidationState { empty, formatting, valid }
