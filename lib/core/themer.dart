import 'package:flutter/material.dart';

mixin Themer {
  late ThemeData themeData;
  late TextTheme textTheme;

  void initThemer(BuildContext context) {
    themeData = Theme.of(context);
    textTheme = themeData.textTheme;
  }
}

/// references
/// https://flutter.dev/docs/development/ui/layout/responsive
/// https://stackoverflow.com/a/50744481/2172590
