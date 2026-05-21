import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter_kit/preferences/preferences_manager.dart';

/// Holds the active [ThemeMode] (system/light/dark), loads the persisted choice
/// on startup, and persists changes. A user's explicit choice always wins over
/// the asynchronous startup load.
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._preferences) : super(ThemeMode.system) {
    _load();
  }

  final PreferencesManager _preferences;
  bool _userChanged = false;

  Future<void> _load() async {
    final mode = await _preferences.getThemeMode();
    if (_userChanged || isClosed) return;
    emit(mode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _userChanged = true;
    emit(mode);
    await _preferences.setThemeMode(mode);
  }

  /// Convenience for a toggle button: system -> light -> dark -> system.
  Future<void> cycleThemeMode() {
    final next = switch (state) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
    return setThemeMode(next);
  }
}
