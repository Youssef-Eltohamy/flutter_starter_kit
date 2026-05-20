import 'package:flutter/services.dart';

void showStatusBar() async {
  /// to show status and navigation bar again
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: SystemUiOverlay.values);
}

void setStatusBarColor(Color color) {
  showStatusBar();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: color,
  ));
}

void hideStatusBar() async {
  /// to make screen -> full
  /// hidden status bar in splash screen

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
}
