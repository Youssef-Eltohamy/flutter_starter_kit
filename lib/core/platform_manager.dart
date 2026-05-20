import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;

mixin PlatformManager {
  bool isOnAndroid() {
    try {
      if (Platform.isAndroid) {
        return true;
      }
      // ignore: empty_catches
    } catch (e) {}
    return false;
  }

  bool isOnIOS() {
    try {
      if (Platform.isIOS) {
        return true;
      }
      // ignore: empty_catches
    } catch (e) {}
    return false;
  }

  bool isOnLinux() {
    try {
      if (Platform.isLinux) {
        return true;
      }
      // ignore: empty_catches
    } catch (e) {}
    return false;
  }

  bool isOnWindows() {
    try {
      if (Platform.isWindows) {
        return true;
      }
      // ignore: empty_catches
    } catch (e) {}
    return false;
  }

  bool isOnMac() {
    try {
      if (Platform.isMacOS) {
        return true;
      }
      // ignore: empty_catches
    } catch (e) {}
    return false;
  }

  bool isOnWeb() => kIsWeb;

  bool isOnMobile() {
    try {
      if (isOnAndroid() || isOnIOS()) {
        return true;
      }
      // ignore: empty_catches
    } catch (e) {}
    return false;
  }

  bool isOnDeskTop() {
    try {
      if (isOnLinux() || isOnMac() || isOnWindows()) {
        return true;
      }
      // ignore: empty_catches
    } catch (e) {}
    return false;
  }
}

/// references
/// https://stackoverflow.com/a/50744481/2172590
