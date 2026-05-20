import 'package:flutter_starter_kit/utils/locale/app_localization_keys.dart';

class LocaleDioExceptions {
  static String getLocaleMessage(int code) {
    switch (code) {
      case 1001:
        return LocalizationKeys.requestToApiServerWasCancelled;
      case 1002:
        return LocalizationKeys.connectionTimeoutWithApiServer;
      case 1003:
        return LocalizationKeys.receiveTimeoutInConnectionWithApiServer;
      case 1004:
        return LocalizationKeys.badRequest;
      case 1005:
        return LocalizationKeys.unauthorized;
      case 1006:
        return LocalizationKeys.forbidden;
      case 1008:
        return LocalizationKeys.internalServerError;
      case 1009:
        return LocalizationKeys.badGateway;
      case 1010:
        return LocalizationKeys.oopsSomethingWentWrong;
      case 1011:
        return LocalizationKeys.sendTimeoutInConnectionWithApiServer;
      case 1012:
        return LocalizationKeys.noInternet;
      case 1013:
        return LocalizationKeys.unexpectedErrorOccurred;
      case 1014:
        return LocalizationKeys.somethingWentWrong;
      case 1015:
        return LocalizationKeys.unknownError;
      default:
        return LocalizationKeys.unknownError;
    }
  }
}
