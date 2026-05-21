import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/core/theme/theme_cubit.dart';
import 'package:flutter_starter_kit/preferences/preferences_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPreferencesManager extends Mock implements PreferencesManager {}

void main() {
  late MockPreferencesManager prefs;

  setUpAll(() => registerFallbackValue(ThemeMode.system));
  setUp(() => prefs = MockPreferencesManager());

  blocTest<ThemeCubit, ThemeMode>(
    'loads the persisted mode on creation',
    setUp: () =>
        when(prefs.getThemeMode).thenAnswer((_) async => ThemeMode.dark),
    build: () => ThemeCubit(prefs),
    expect: () => [ThemeMode.dark],
  );

  blocTest<ThemeCubit, ThemeMode>(
    'setThemeMode emits the new mode and persists it',
    setUp: () {
      when(prefs.getThemeMode).thenAnswer((_) async => ThemeMode.system);
      when(() => prefs.setThemeMode(any())).thenAnswer((_) async => true);
    },
    build: () => ThemeCubit(prefs),
    act: (cubit) => cubit.setThemeMode(ThemeMode.light),
    expect: () => [ThemeMode.light],
    verify: (_) => verify(() => prefs.setThemeMode(ThemeMode.light)).called(1),
  );

  blocTest<ThemeCubit, ThemeMode>(
    'cycleThemeMode: system -> light',
    setUp: () {
      when(prefs.getThemeMode).thenAnswer((_) async => ThemeMode.system);
      when(() => prefs.setThemeMode(any())).thenAnswer((_) async => true);
    },
    build: () => ThemeCubit(prefs),
    act: (cubit) => cubit.cycleThemeMode(),
    expect: () => [ThemeMode.light],
  );

  blocTest<ThemeCubit, ThemeMode>(
    'cycleThemeMode: light -> dark',
    setUp: () {
      when(prefs.getThemeMode).thenAnswer((_) async => ThemeMode.system);
      when(() => prefs.setThemeMode(any())).thenAnswer((_) async => true);
    },
    build: () => ThemeCubit(prefs),
    act: (cubit) async {
      await cubit.setThemeMode(ThemeMode.light);
      await cubit.cycleThemeMode();
    },
    expect: () => [ThemeMode.light, ThemeMode.dark],
  );

  blocTest<ThemeCubit, ThemeMode>(
    'cycleThemeMode: dark -> system',
    setUp: () {
      when(prefs.getThemeMode).thenAnswer((_) async => ThemeMode.system);
      when(() => prefs.setThemeMode(any())).thenAnswer((_) async => true);
    },
    build: () => ThemeCubit(prefs),
    act: (cubit) async {
      await cubit.setThemeMode(ThemeMode.dark);
      await cubit.cycleThemeMode();
    },
    expect: () => [ThemeMode.dark, ThemeMode.system],
  );
}
