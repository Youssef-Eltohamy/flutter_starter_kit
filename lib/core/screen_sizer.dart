import 'package:flutter/material.dart';

mixin ScreenSizer {
  late double height;
  late double width;
  late Orientation orientation;

  void initScreenSizer(BuildContext context) {
    var mediaQueryData = MediaQuery.of(context);
    width = mediaQueryData.size.width;
    height = mediaQueryData.size.height;
    orientation = mediaQueryData.orientation;
  }

  double width10() => width * 10 / 100;

  bool isPortrait() => orientation == Orientation.portrait;

  bool isLandscape() => orientation == Orientation.landscape;

  bool isWebOrDesktopSize() => width >= 1000; // the default size is 950

  bool isTabletSize() => width >= 600;

  bool isPassedMinHeight() => height > 500;

  bool isPassedMinSizeForWeb() => isWebOrDesktopSize() && isPassedMinHeight();
}

/// references
/// https://flutter.dev/docs/development/ui/layout/responsive
/// https://stackoverflow.com/a/50744481/2172590
