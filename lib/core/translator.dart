import 'package:flutter/material.dart';
import 'package:nemo/utils/locale/app_localization.dart';

/// Always keep in mind that mixin is not multiple inheritance instead
/// they are just a way to reuse our code from a class in multiple hierarchies
/// without needing to extend them.
/// Its like being able to use other people assets
/// without being their children. Its cool hah! 😝

mixin Translator {
  late AppLocalizations appLocale;

  void initTranslator(BuildContext context) {
    appLocale = AppLocalizations.of(context)!;
  }

  String? translate(String localizationKey) {
    String? value;

    value = appLocale.translate(localizationKey)!;
    return value;
  }

  bool isEnglish() {
    return appLocale.isLTR();
  }
}

/// mixin can not be extendable ...
///
/// reference
/// https://medium.com/flutter-community/https-medium-com-shubhamhackzz-dart-for-flutter-mixins-in-dart-f8bb10a3d341
