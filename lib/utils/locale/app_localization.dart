import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_starter_kit/utils/build_type/build_type.dart';

const codeEn = 'en';
const codeAr = 'ar';

const conUs = 'US';
const conSa = 'SA';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  late Map<String, String> _localizedStrings;

  Future<bool> load() async {
    /// 1- Load the language JSON file from the "lang" folder
    String jsonString = await rootBundle.loadString(
      'locale/${locale.languageCode}.json',
    );

    /// 2- mapping the json string that we loaded from the file to json map
    /// with dynamic value.
    Map<String, dynamic> jsonMap =
        json.decode(jsonString) as Map<String, dynamic>;

    /// 3- because we assure that every value in the map is String we will map
    /// the json map to Map<String, String> instead of Map<String, dynamic>
    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  /// This method will be called from every widget which needs a localized text
  /// that means we can not have two
  /// items with the same key .. because we access
  /// the map using that key...
  String? translate(String key) {
    if (isDebugMode()) {
      if (_localizedStrings[key] == null) {
        load();
      }
    }
    return _localizedStrings[key];
  }

  bool isRTL() {
    return locale.languageCode == codeAr;
  }

  bool isLTR() {
    return locale.languageCode == codeEn;
  }

  static List<Locale> supportedLocales = [
    const Locale(codeEn, conUs),
    const Locale(codeAr, conSa),
  ];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
}

/// LocalizationsDelegate is a factory for a set of localized resources
/// In this case, the localized strings will
/// be gotten in an AppLocalizations object
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  /// This delegate instance will never change (it doesn't even have fields!)
  /// It can provide a constant constructor.
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    /// Include all of your supported language codes here
    return AppLocalizations.supportedLocales.contains(locale);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    /// AppLocalizations class is where the JSON loading actually runs
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  /// we do not know why this method should return false
  /// but we follow the guide as Material Localization ...
  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
