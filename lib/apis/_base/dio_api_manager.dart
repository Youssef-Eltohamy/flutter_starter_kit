import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_starter_kit/apis/api_keys.dart';
import 'package:flutter_starter_kit/preferences/preferences_manager.dart';
import 'package:flutter_starter_kit/utils/build_type/build_type.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DioApiManager {
  final String defaultLanguage = "en";
  final PreferencesManager preferenceManager;

  //  dio instance to request token
  DioApiManager(this.preferenceManager);

  Dio get dioUnauthorized {
    return DioOptions.dioInstance(optionsUnauthorized)
      ..interceptors.clear()
      ..interceptors.addAll([
        _queuedInterceptorsWrapperUnauthorized,
        if (isDebugMode()) ...[
          LogInterceptor(
            responseBody: true,
            requestBody: true,
            error: true,
            logPrint: (object) => log(object.toString()),
          ),
        ],
      ]);
  }

  Dio get dio {
    return DioOptions.dioInstance(options)
      ..interceptors.clear()
      ..interceptors.addAll([
        _queuedInterceptorsWrapper,
        if (isDebugMode()) ...[
          LogInterceptor(
            responseBody: true,
            requestBody: true,
            error: true,
            logPrint: (object) => log(object.toString()),
          ),
        ],
      ]);
  }

  QueuedInterceptorsWrapper get _queuedInterceptorsWrapper {
    return QueuedInterceptorsWrapper(
      onError: (error, handler) async {
        // Assume 401 stands for token expired
        if (error.response?.statusCode == 401 ||
            error.response?.statusCode == 403) {
          logOutNow();
          return;
        }

        return handler.next(error);
      },
      onRequest: (request, handler) async {
        String language =
            await preferenceManager.getLocale() ?? defaultLanguage;
        if (request.headers[ApiKeys.locale] != language) {
          request.headers[ApiKeys.locale] = language;
        }
        String? token = await preferenceManager.getAccessToken();
        if (token != null && token != "") {
          if (request.headers[ApiKeys.authorization] == null) {
            request.headers[ApiKeys.authorization] =
                '${ApiKeys.keyBearer} $token';
          } else {
            request.headers.remove(ApiKeys.authorization);
          }
        }
        int? mode = await preferenceManager.getMode();
        if (request.headers[ApiKeys.mode] != mode) {
          request.headers[ApiKeys.mode] = mode ?? ApiKeys.clientMode;
        }
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String appVersion = packageInfo.version;
        if (request.headers[ApiKeys.appVersion] != appVersion) {
          request.headers[ApiKeys.appVersion] = appVersion;
        }
        String? lat = await preferenceManager.getAddressLat();
        String? lng = await preferenceManager.getAddressLng();
        if (lat != null && lng != null) {
          if (request.headers[ApiKeys.lat] != lat &&
              request.headers[ApiKeys.lng] != lng) {
            request.headers[ApiKeys.lat] = double.tryParse(lat) ?? 0;
            request.headers[ApiKeys.lng] = double.tryParse(lng) ?? 0;
          }
        }
        return handler.next(request);
      },
    );
  }

  QueuedInterceptorsWrapper get _queuedInterceptorsWrapperUnauthorized {
    return QueuedInterceptorsWrapper(
      onRequest: (request, handler) async {
        String? language = await preferenceManager.getLocale();
        if (request.headers[ApiKeys.locale] != language) {
          request.headers[ApiKeys.locale] = language ?? defaultLanguage;
        }
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String appVersion = packageInfo.version;
        if (request.headers[ApiKeys.appVersion] != appVersion) {
          request.headers[ApiKeys.appVersion] = appVersion;
        }

        return handler.next(request);
      },
    );
  }

  DioOptions options = DioOptions();

  DioOptions optionsUnauthorized = DioOptions();

  Future<void> logOutNow() async {
    // GetIt.I<UserMangers>().signOut();
  }
}

class DioOptions extends BaseOptions {
  @override
  Map<String, dynamic> get headers {
    Map<String, dynamic> header = {};

    header.putIfAbsent(ApiKeys.accept, () => ApiKeys.applicationJson);
    header.putIfAbsent(
      ApiKeys.platform,
      () => Platform.isIOS ? ApiKeys.platformIos : ApiKeys.platformAndroid,
    );

    return header;
  }

  @override
  String get baseUrl {
    return ApiKeys.baseUrlProduction;
  }

  static Dio? dio;

  static Dio dioInstance(BaseOptions options) {
    dio ??= Dio(options);

    return dio!;
  }
}
