import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter_kit/apis/_base/dio_api_manager.dart';
import 'package:flutter_starter_kit/app.dart';
import 'package:flutter_starter_kit/preferences/preferences_manager.dart';
import 'package:flutter_starter_kit/utils/bloc_observer/app_bloc_observer.dart';
import 'package:flutter_starter_kit/utils/connectivity/connectivity_data.dart';
import 'package:get_it/get_it.dart';

void main() async {
  /// to fix Orientation problem

  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) async {
    /// setup GetIt Instances ...
    GetIt.I.registerLazySingleton<PreferencesManager>(
      () => PreferencesManager(),
    );
    GetIt.I.registerLazySingleton<DioApiManager>(
      () => DioApiManager(GetIt.I<PreferencesManager>()),
    );

    GetIt.I.registerLazySingleton<ConnectivityData>(() => ConnectivityData());
    Bloc.observer = AppBlocObserver();
    runApp(const MyApp());
  });
}
