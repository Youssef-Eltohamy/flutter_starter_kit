import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter_kit/preferences/preferences_manager.dart';

/// Holds the active [ThemeMode] (system/light/dark), loads the persisted choice
/// on startup, and persists changes.
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._preferences) : super(ThemeMode.system) {
    _load();
  }

  final PreferencesManager _preferences;

  Future<void> _load() async {
    // Only apply the persisted value if the state has not been changed by a
    // manual call (i.e. it still equals the constructor-time default).
    if (state != ThemeMode.system) return;
    final mode = await _preferences.getThemeMode();
    if (!isClosed && state == ThemeMode.system) emit(mode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
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
