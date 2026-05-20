import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/utils/locale/app_localization.dart';
import 'package:flutter_starter_kit/utils/locale/app_localization_keys.dart';

Widget noData(AppLocalizations appLocale) {
  return Center(child: Text(appLocale.translate(LocalizationKeys.noData)!));
}
