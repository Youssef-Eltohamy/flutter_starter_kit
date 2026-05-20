import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter_kit/app.dart';
import 'package:flutter_starter_kit/injection.dart';
import 'package:flutter_starter_kit/utils/bloc_observer/app_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await setupDependencies();

  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}
