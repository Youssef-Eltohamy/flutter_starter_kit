import 'package:dio/dio.dart';
import 'package:flutter_starter_kit/apis/_base/dio_api_manager.dart';
import 'package:flutter_starter_kit/core/config/app_config.dart';
import 'package:flutter_starter_kit/feature/example_posts/data/posts_repository.dart';
import 'package:flutter_starter_kit/preferences/preferences_manager.dart';
import 'package:flutter_starter_kit/utils/connectivity/connectivity_data.dart';
import 'package:get_it/get_it.dart';

/// The single service locator instance for the app.
final GetIt getIt = GetIt.instance;

/// Registers all app-wide dependencies. Call once from `main()` before
/// `runApp`. Group registrations by area and keep this the only place that
/// wires the object graph.
Future<void> setupDependencies() async {
  getIt.registerSingleton<AppConfig>(AppConfig.fromEnvironment());

  // Core
  getIt.registerLazySingleton<PreferencesManager>(PreferencesManager.new);
  getIt.registerLazySingleton<DioApiManager>(
    () => DioApiManager(getIt<PreferencesManager>()),
  );
  getIt.registerLazySingleton<ConnectivityData>(ConnectivityData.new);

  // Example feature (see lib/feature/example_posts)
  getIt.registerLazySingleton<Dio>(Dio.new);
  getIt.registerLazySingleton<PostsRepository>(
    () => PostsRepository(getIt<Dio>()),
  );
}
