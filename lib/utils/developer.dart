import 'dart:developer';

import 'package:flutter_starter_kit/utils/feedback/feedback_toast.dart';

class Developer {
  static const String sampleDeveloperError =
      "Sample Developer Error to be guided with";

  static void developerError(String message) {
    developerShow(message);
    developerLog(message);
  }

  static void developerLog(String message) {
    log(message);
  }

  static void developerShow(String message) {
    showToast(message);
  }
}
