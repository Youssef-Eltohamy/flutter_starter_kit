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
    'cycleThemeMode goes system -> light',
    setUp: () {
      when(prefs.getThemeMode).thenAnswer((_) async => ThemeMode.system);
      when(() => prefs.setThemeMode(any())).thenAnswer((_) async => true);
    },
    build: () => ThemeCubit(prefs),
    act: (cubit) => cubit.cycleThemeMode(),
    expect: () => [ThemeMode.light],
  );

  blocTest<ThemeCubit, ThemeMode>(
    'cycleThemeMode goes light -> dark',
    setUp: () {
      when(prefs.getThemeMode).thenAnswer((_) async => ThemeMode.light);
      when(() => prefs.setThemeMode(any())).thenAnswer((_) async => true);
    },
    build: () => ThemeCubit(prefs),
    seed: () => ThemeMode.light,
    act: (cubit) => cubit.cycleThemeMode(),
    expect: () => [ThemeMode.dark],
  );

  blocTest<ThemeCubit, ThemeMode>(
    'cycleThemeMode goes dark -> system',
    setUp: () {
      when(prefs.getThemeMode).thenAnswer((_) async => ThemeMode.dark);
      when(() => prefs.setThemeMode(any())).thenAnswer((_) async => true);
    },
    build: () => ThemeCubit(prefs),
    seed: () => ThemeMode.dark,
    act: (cubit) => cubit.cycleThemeMode(),
    expect: () => [ThemeMode.system, ThemeMode.dark],
  );
}
