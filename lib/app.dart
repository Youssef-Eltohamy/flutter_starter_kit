import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_starter_kit/apis/_base/dio_api_manager.dart';
import 'package:flutter_starter_kit/core/app_platform.dart';
import 'package:flutter_starter_kit/core/router/app_router.dart';
import 'package:flutter_starter_kit/preferences/preferences_manager.dart';
import 'package:flutter_starter_kit/res/app_colors.dart';
import 'package:flutter_starter_kit/utils/locale/app_localization.dart';
import 'package:flutter_starter_kit/utils/locale/app_localization_keys.dart';
import 'package:flutter_starter_kit/utils/locale/locale_cubit.dart';
import 'package:flutter_starter_kit/utils/locale/locale_repository.dart';
import 'package:flutter_starter_kit/utils/status_bar/statusbar_controller.dart';
import 'package:flutter_starter_kit/utils/theme/app_theme.dart';
import 'package:get_it/get_it.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    _changeStatusBarColor();
    final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<LocaleCubit>(
          create: (context) => LocaleCubit(
            LocaleRepository(
              dioApiManager,
              (GetIt.I<PreferencesManager>()),
            ),
          ),
        ),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, state) {
          return KeyboardDismisser(
            gestures: AppPlatform.isAndroid ? [] : [GestureType.onTap],
            child: ScreenUtilInit(
              designSize: const Size(390, 844),
              builder: (context, child) => MaterialApp.router(
                onGenerateTitle: (BuildContext context) =>
                    AppLocalizations.of(
                      context,
                    )?.translate(LocalizationKeys.appName) ??
                    'Flutter Starter Kit',
                debugShowCheckedModeBanner: false,
                theme: AppTheme(state).themeDataLight,
                darkTheme: AppTheme(state).themeDataDark,
                themeMode: ThemeMode.light,

                /// the list of our supported locals for our app
                /// currently we support only 2 English and Arabic ...
                supportedLocales: AppLocalizations.supportedLocales,

                /// these delegates make sure that the localization data
                /// for the proper
                /// language is loaded ...
                localizationsDelegates: const [
                  /// A class which loads the translations from JSON files
                  AppLocalizations.delegate,

                  /// Built-in localization of basic text
                  ///  for Material widgets in Material
                  GlobalMaterialLocalizations.delegate,

                  /// Built-in localization for text direction LTR/RTL
                  GlobalWidgetsLocalizations.delegate,

                  /// Built-in localization for text direction LTR/RTL in Cupertino
                  GlobalCupertinoLocalizations.delegate,

                  DefaultCupertinoLocalizations.delegate,
                ],
                locale: state,

                routerConfig: appRouter,
              ),
            ),
          );
        },
      ),
    );
  }

  void _changeStatusBarColor() {
    setStatusBarColor(AppColors.primary);
  }
}
