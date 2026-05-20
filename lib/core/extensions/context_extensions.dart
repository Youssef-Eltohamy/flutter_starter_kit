import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/utils/locale/app_localization.dart';

/// Convenience getters on [BuildContext] for sizing, theming and localization.
/// Prefer these over base-class mixins so widgets stay truly stateless.
extension BuildContextX on BuildContext {
  // Sizing
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  Orientation get orientation => MediaQuery.orientationOf(this);
  bool get isPortrait => orientation == Orientation.portrait;
  bool get isLandscape => orientation == Orientation.landscape;
  bool get isTablet => screenWidth >= 600;
  bool get isDesktop => screenWidth >= 1000;

  // Theme
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // Localization
  String tr(String key) => AppLocalizations.of(this)?.translate(key) ?? key;
  bool get isRTL => AppLocalizations.of(this)?.isRTL() ?? false;
}
