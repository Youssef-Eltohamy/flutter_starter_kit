import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nemo/utils/locale/app_localization.dart';
import 'package:nemo/utils/locale/locale_repository.dart';

class LocaleCubit extends Cubit<Locale> {
  final LocaleRepository localeRepository;

  LocaleCubit(this.localeRepository) : super(const Locale(codeEn)) {
    getDefaultLocale();
  }

  void changeLocale(LocaleApp selectedLanguage) async {
    final defaultLanguageCode = await localeRepository.getLanguageLocal();

    if (selectedLanguage == LocaleApp.ar && defaultLanguageCode != codeAr) {
      await localeRepository.updateLanguageInfo(LocaleApp.ar);
      emit(const Locale(codeAr));
    } else if (selectedLanguage == LocaleApp.en &&
        defaultLanguageCode != codeEn) {
      await localeRepository.updateLanguageInfo(LocaleApp.en);
      emit(const Locale(codeEn));
    }
  }

  void getDefaultLocale() async {
    final defaultLanguageCode = await localeRepository.getLanguageLocal();
    Locale locale;
    if (defaultLanguageCode == null) {
      locale = Locale(defaultSystemLocale);
    } else {
      locale = Locale(defaultLanguageCode);
    }
    emit(locale);
  }

  // String get defaultSystemLocale => Platform.localeName.substring(0, 2);
  String get defaultSystemLocale => "en";
}

enum LocaleApp {
  en,
  ar;

  int mapToApiKey() {
    switch (this) {
      case LocaleApp.en:
        return 1;
      case LocaleApp.ar:
        return 2;
    }
  }

  String mapToPreferenceKey() {
    switch (this) {
      case LocaleApp.en:
        return codeEn;
      // return "$codeEn-$conUs";
      case LocaleApp.ar:
        return codeAr;
      // return "$codeAr-$conSa";
    }
  }
}
