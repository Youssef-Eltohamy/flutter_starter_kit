import 'package:nemo/utils/extensions/extension_string.dart';

class ErrorApiHelper {
  static int handleResponseErrorCode(int? statusCoder) {
    switch (statusCoder) {
      case 400:
        return 1004;
      case 401:
        return 1005;
      case 403:
        return 1006;
      case 404:
        return 1007;
      case 500:
        return 1008;
      case 502:
        return 1009;
      default:
        return 1010;
    }
  }

  static String formErrorMessage(String message, String? stackTrace) {
    if (stackTrace.isNullOrEmpty) {
      return message;
    } else {
      return message.concatenateColon.concatenateNewline + stackTrace!;
    }
  }
}
