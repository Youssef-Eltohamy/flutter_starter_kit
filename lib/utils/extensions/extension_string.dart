extension ConcatenateAsterisk on String {
  String get concatenateAsterisk {
    return "$this *";
  }
}

extension ConcatenateColon on String {
  String get concatenateColon {
    return "$this:";
  }
}

extension ConcatenateSpace on String {
  String get concatenateSpace {
    return "$this ";
  }
}

extension ConcatenatePercent on String {
  String get concatenatePercent {
    return "$this %";
  }
}

extension EncryptText on String {
  String get encryptText {
    String encryptedPhone = "";
    String text = this;
    for (int i = 0; i < text.length; i++) {
      if (i < text.length - 4) {
        encryptedPhone += "*";
      } else {
        encryptedPhone += text[i];
      }
    }
    return encryptedPhone;
  }
}

extension ConcatenateNewLine on String {
  String get concatenateNewline {
    return "$this\n";
  }
}

extension ConcatenateBrackets on String {
  String get concatenateBrackets {
    return "($this)";
  }
}

extension ConcatenateQuestionMarkEnglish on String {
  String get concatenateQuestionMarkEnglish {
    return "$this?";
  }
}

extension ConcatenateQuestionMarkArabic on String {
  String get concatenateQuestionMarkArabic {
    return "$this؟";
  }
}

extension Validation on String? {
  bool get isNullOrEmpty => (this != null && this!.isNotEmpty) ? false : true;
}

extension ConcatenateDash on String {
  String get concatenateDash {
    return "- $this";
  }
}

extension ArabicNumberConverter on String {
  static const Map<String, String> arabicDigits = <String, String>{
    '0': '\u0660',
    '1': '\u0661',
    '2': '\u0662',
    '3': '\u0663',
    '4': '\u0664',
    '5': '\u0665',
    '6': '\u0666',
    '7': '\u0667',
    '8': '\u0668',
    '9': '\u0669',
  };

  String toArabicDigitsConverter() {
    final String number = toString();
    StringBuffer sb = StringBuffer();
    for (int i = 0; i < number.length; i++) {
      sb.write(arabicDigits[number[i]] ?? number[i]);
    }
    return sb.toString();
  }
}

extension EnglishNumberConverter on String {
  static const Map<String, String> englishDigits = <String, String>{
    '\u0660': '0',
    '\u0661': '1',
    '\u0662': '2',
    '\u0663': '3',
    '\u0664': '4',
    '\u0665': '5',
    '\u0666': '6',
    '\u0667': '7',
    '\u0668': '8',
    '\u0669': '9',
  };

  String toEnglishDigitsConverter() {
    final String number = toString();
    StringBuffer sb = StringBuffer();
    for (int i = 0; i < number.length; i++) {
      sb.write(englishDigits[number[i]] ?? number[i]);
    }
    return sb.toString();
  }
}
