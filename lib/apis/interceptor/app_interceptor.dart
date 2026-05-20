import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:nemo/apis/api_keys.dart';
import 'package:nemo/preferences/preferences_manager.dart';

class AppInterceptor extends InterceptorsWrapper {
  var preferencesManager = GetIt.I<PreferencesManager>();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    String? token = await preferencesManager.getAccessToken();
    String? locale = await preferencesManager.getLocale();
    options.headers[ApiKeys.accept] = ApiKeys.applicationJson;
    options.headers[ApiKeys.locale] = locale;
    options.headers[ApiKeys.contentType] = ApiKeys.applicationJson;
    if (token != null) {
      options.headers[ApiKeys.authorization] = "${ApiKeys.keyBearer} $token";
    }
    log("Request Path :: ${options.path}  -- Data :: ${options.data}");
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log("Response :: ${response.data}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log("error : ${err.error.toString()}");
    handler.resolve(err.response!);
  }
}
