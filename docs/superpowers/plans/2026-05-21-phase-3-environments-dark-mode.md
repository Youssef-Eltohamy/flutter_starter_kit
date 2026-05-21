# Phase 3 — Environments, Networking Fixes & Dark Mode Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a compile-time environment config that drives the API base URL, fix the shared-Dio-instance bug, and add persisted runtime dark/light/system theming.

**Architecture:** `AppConfig.fromEnvironment()` (via `--dart-define=ENV=...`) is registered in `get_it` and supplies the base URL to `DioOptions`. A `ThemeCubit` (persisted through `PreferencesManager`) drives `MaterialApp.router`'s `themeMode`. No native flavors, no codegen.

**Tech Stack:** Flutter, flutter_bloc (Cubit), dio, get_it, shared_preferences. Tests use flutter_test + bloc_test + mocktail.

**Spec:** `docs/superpowers/specs/2026-05-21-phase-3-environments-dark-mode-design.md`
**Working branch:** `feat/phase-3-environments-dark-mode` (already created).

---

## File Structure

**Created:**
- `lib/core/config/app_config.dart` — environment enum + config + `fromEnvironment`.
- `lib/core/theme/theme_cubit.dart` — `ThemeCubit` (persisted `ThemeMode`).
- `test/core/config/app_config_test.dart`
- `test/core/theme/theme_cubit_test.dart`

**Modified:**
- `lib/injection.dart` — register `AppConfig`.
- `lib/apis/_base/dio_api_manager.dart` — fix shared instance; base URL from `AppConfig`.
- `lib/apis/api_keys.dart` — remove the three dead `baseUrl*` constants.
- `lib/preferences/preferences_keys.dart` — add `themeMode` key.
- `lib/preferences/preferences_manager.dart` — `getThemeMode` / `setThemeMode`.
- `lib/utils/theme/app_theme.dart` — real dark theme.
- `lib/app.dart` — provide `ThemeCubit`, drive `themeMode` from it.
- `lib/feature/example_posts/presentation/screen/posts_screen.dart` — theme-toggle button.
- `docs/ARCHITECTURE.md` — environments + theming docs.

---

## Task 1: AppConfig (TDD)

**Files:**
- Create: `lib/core/config/app_config.dart`
- Test: `test/core/config/app_config_test.dart`

- [ ] **Step 1: Write the failing test**

`test/core/config/app_config_test.dart`:
```dart
import 'package:flutter_starter_kit/core/config/app_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('defaults to the dev environment with a non-empty base URL', () {
    final config = AppConfig.fromEnvironment();

    expect(config.environment, AppEnvironment.dev);
    expect(config.baseUrl, isNotEmpty);
  });
}
```

- [ ] **Step 2: Run to verify it fails**

Run: `flutter test test/core/config/app_config_test.dart`
Expected: FAIL — `AppConfig` not defined.

- [ ] **Step 3: Implement `lib/core/config/app_config.dart`**

```dart
/// The deployment environments the app can target.
enum AppEnvironment { dev, staging, prod }

/// Compile-time application configuration. Select an environment with
/// `--dart-define=ENV=dev|staging|prod` (defaults to `dev`). Replace the
/// placeholder base URLs with your real API endpoints.
class AppConfig {
  const AppConfig({required this.environment, required this.baseUrl});

  final AppEnvironment environment;
  final String baseUrl;

  factory AppConfig.fromEnvironment() {
    const env = String.fromEnvironment('ENV', defaultValue: 'dev');
    return switch (env) {
      'prod' => const AppConfig(
        environment: AppEnvironment.prod,
        baseUrl: 'https://api.example.com',
      ),
      'staging' => const AppConfig(
        environment: AppEnvironment.staging,
        baseUrl: 'https://api.staging.example.com',
      ),
      _ => const AppConfig(
        environment: AppEnvironment.dev,
        baseUrl: 'https://api.dev.example.com',
      ),
    };
  }
}
```

- [ ] **Step 4: Run to verify it passes**

Run: `flutter test test/core/config/app_config_test.dart`
Expected: PASS.

- [ ] **Step 5: Verify & commit**

Run: `flutter analyze` → `No issues found!`
Run: `dart format --output=none --set-exit-if-changed lib/core/config/app_config.dart test/core/config/app_config_test.dart` → exit 0.
```bash
git add lib/core/config/app_config.dart test/core/config/app_config_test.dart
git commit -m "feat: add compile-time AppConfig environment selection"
```
(Append: `Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>`)

---

## Task 2: Register AppConfig + fix DioApiManager

**Files:**
- Modify: `lib/injection.dart`
- Modify: `lib/apis/_base/dio_api_manager.dart`
- Modify: `lib/apis/api_keys.dart`

- [ ] **Step 1: Register `AppConfig` in `lib/injection.dart`**

Add the import (alphabetical order):
```dart
import 'package:flutter_starter_kit/core/config/app_config.dart';
```
Inside `setupDependencies()`, as the FIRST registration (before the others), add:
```dart
  getIt.registerSingleton<AppConfig>(AppConfig.fromEnvironment());
```

- [ ] **Step 2: Fix `lib/apis/_base/dio_api_manager.dart`**

Read the file first. Make these changes:

(a) Add imports (alphabetical order within the existing block):
```dart
import 'package:flutter_starter_kit/core/config/app_config.dart';
import 'package:get_it/get_it.dart';
```

(b) Replace the `dioUnauthorized` getter body so it builds its OWN Dio (no shared static, no `.clear()`):
```dart
  Dio get dioUnauthorized {
    return Dio(optionsUnauthorized)
      ..interceptors.addAll([
        _queuedInterceptorsWrapperUnauthorized,
        if (isDebugMode()) ...[
          LogInterceptor(
            responseBody: true,
            requestBody: true,
            error: true,
            logPrint: (object) => log(object.toString()),
          ),
        ],
      ]);
  }
```

(c) Replace the `dio` getter body the same way:
```dart
  Dio get dio {
    return Dio(options)
      ..interceptors.addAll([
        _queuedInterceptorsWrapper,
        if (isDebugMode()) ...[
          LogInterceptor(
            responseBody: true,
            requestBody: true,
            error: true,
            logPrint: (object) => log(object.toString()),
          ),
        ],
      ]);
  }
```

(d) In `class DioOptions extends BaseOptions`, change the `baseUrl` getter to read from `AppConfig`, and DELETE the `static Dio? dio;` field and the `static Dio dioInstance(BaseOptions options)` method entirely:
```dart
  @override
  String get baseUrl => GetIt.I<AppConfig>().baseUrl;
```
(Leave the `headers` getter unchanged. Leave both interceptor wrappers and `logOutNow` unchanged.)

- [ ] **Step 3: Remove the dead base URLs from `lib/apis/api_keys.dart`**

First confirm they are unused now:
```
grep -rn "baseUrlProduction\|baseUrlQc\|baseUrlDev" lib
```
Expected: no output (the only consumer was `DioOptions.baseUrl`, fixed in Step 2). If anything still references them, report BLOCKED.

Then delete these three constants from `api_keys.dart`:
```dart
  static const baseUrlProduction = "...";
  static const baseUrlQc = "...";
  static const baseUrlDev = "...";
```
(Keep every other constant in the file.)

- [ ] **Step 4: Verify & commit**

Run: `flutter analyze` → `No issues found!`
Run: `flutter test` → all pass (18: 17 prior + AppConfig 1).
Run: `dart format --output=none --set-exit-if-changed lib` → exit 0.
```bash
git add lib/injection.dart lib/apis/_base/dio_api_manager.dart lib/apis/api_keys.dart
git commit -m "fix: separate Dio instances and source base URL from AppConfig"
```
(Append the Co-Authored-By line.)

---

## Task 3: PreferencesManager theme persistence

**Files:**
- Modify: `lib/preferences/preferences_keys.dart`
- Modify: `lib/preferences/preferences_manager.dart`

- [ ] **Step 1: Add the `themeMode` key**

In `lib/preferences/preferences_keys.dart`, add `themeMode` to the enum (e.g. after `b2bCompleted`):
```dart
  b2bCompleted,
  cartItemList,
  themeMode,
```

- [ ] **Step 2: Add getters/setters to `lib/preferences/preferences_manager.dart`**

Add `import 'package:flutter/material.dart';` at the top (for `ThemeMode`), keeping imports ordered. Add these methods inside the class (e.g. before the closing brace):
```dart
  Future<bool> setThemeMode(ThemeMode mode) async {
    return PreferencesUtils.setString(
      PreferencesKeys.themeMode.name,
      mode.name,
    );
  }

  Future<ThemeMode> getThemeMode() async {
    final value = await PreferencesUtils.getString(
      PreferencesKeys.themeMode.name,
    );
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => ThemeMode.system,
    );
  }
```

- [ ] **Step 3: Verify & commit**

Run: `flutter analyze` → `No issues found!`
Run: `dart format --output=none --set-exit-if-changed lib` → exit 0.
```bash
git add lib/preferences/preferences_keys.dart lib/preferences/preferences_manager.dart
git commit -m "feat: persist theme mode in PreferencesManager"
```
(Append the Co-Authored-By line.)

---

## Task 4: ThemeCubit (TDD)

**Files:**
- Create: `lib/core/theme/theme_cubit.dart`
- Test: `test/core/theme/theme_cubit_test.dart`

- [ ] **Step 1: Write the failing test**

`test/core/theme/theme_cubit_test.dart`:
```dart
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
    setUp: () => when(prefs.getThemeMode).thenAnswer((_) async => ThemeMode.dark),
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
}
```

- [ ] **Step 2: Run to verify it fails**

Run: `flutter test test/core/theme/theme_cubit_test.dart`
Expected: FAIL — `ThemeCubit` not defined.

- [ ] **Step 3: Implement `lib/core/theme/theme_cubit.dart`**

```dart
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
    emit(await _preferences.getThemeMode());
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
```

- [ ] **Step 4: Run to verify it passes**

Run: `flutter test test/core/theme/theme_cubit_test.dart`
Expected: PASS (2 tests).

- [ ] **Step 5: Verify & commit**

Run: `flutter analyze` → `No issues found!`
Run: `dart format --output=none --set-exit-if-changed lib test` → exit 0.
```bash
git add lib/core/theme/theme_cubit.dart test/core/theme/theme_cubit_test.dart
git commit -m "feat: add persisted ThemeCubit"
```
(Append the Co-Authored-By line.)

---

## Task 5: Real dark theme

**Files:**
- Modify: `lib/utils/theme/app_theme.dart`

- [ ] **Step 1: Replace the `themeDataDark` getter**

Read `lib/utils/theme/app_theme.dart`. Replace the existing minimal `themeDataDark` getter:
```dart
  ThemeData get themeDataDark {
    return ThemeData(brightness: Brightness.dark);
  }
```
with a real dark theme:
```dart
  ThemeData get themeDataDark {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        secondary: AppColors.secondary,
        surface: Color(0xFF121212),
        onSurface: Color(0xFFE6E6E6),
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Color(0xFFE6E6E6),
        elevation: 0,
        centerTitle: false,
      ),
    );
  }
```
(`AppColors` is already imported in this file. Leave `themeDataLight` and the rest unchanged.)

- [ ] **Step 2: Verify & commit**

Run: `flutter analyze` → `No issues found!`
Run: `dart format --output=none --set-exit-if-changed lib` → exit 0.
```bash
git add lib/utils/theme/app_theme.dart
git commit -m "feat: add a real dark theme"
```
(Append the Co-Authored-By line.)

---

## Task 6: Wire ThemeCubit into the app + toggle

**Files:**
- Modify: `lib/app.dart`
- Modify: `lib/feature/example_posts/presentation/screen/posts_screen.dart`

- [ ] **Step 1: Provide `ThemeCubit` and drive `themeMode` in `lib/app.dart`**

Read `lib/app.dart`. Add imports (alphabetical order):
```dart
import 'package:flutter_starter_kit/core/theme/theme_cubit.dart';
```
(`flutter_bloc`, `get_it`, `PreferencesManager` are already imported.)

In the `MultiBlocProvider` `providers:` list, add a second provider after the `LocaleCubit` one:
```dart
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(GetIt.I<PreferencesManager>()),
        ),
```

Change the `MaterialApp.router` `themeMode:` argument from the hardcoded
`themeMode: ThemeMode.light,` to:
```dart
                themeMode: context.watch<ThemeCubit>().state,
```

- [ ] **Step 2: Add a theme-toggle button to `posts_screen.dart`**

Read `lib/feature/example_posts/presentation/screen/posts_screen.dart`. Add the import (alphabetical order):
```dart
import 'package:flutter_starter_kit/core/theme/theme_cubit.dart';
```
Change the `AppBar` from `appBar: AppBar(title: const Text('Posts (example)')),` to include an action that cycles the theme:
```dart
        appBar: AppBar(
          title: const Text('Posts (example)'),
          actions: [
            IconButton(
              icon: const Icon(Icons.brightness_6_outlined),
              tooltip: 'Toggle theme',
              onPressed: () => context.read<ThemeCubit>().cycleThemeMode(),
            ),
          ],
        ),
```
Note: `context` here is the `BlocBuilder` builder context, which is below the `BlocProvider<PostsCubit>` but the `ThemeCubit` is provided in `app.dart` above `MaterialApp.router`, so it is an ancestor and `context.read<ThemeCubit>()` resolves correctly.

- [ ] **Step 3: Verify**

Run: `dart format lib` then `dart format --output=none --set-exit-if-changed .` → exit 0.
Run: `flutter analyze` → `No issues found!`
Run: `flutter test` → all pass (≈20 total: 17 prior + AppConfig 1 + ThemeCubit 2; the Windows runner may report a higher number — the key is zero failures).
Run: `flutter build web` → succeeds.

- [ ] **Step 4: Commit**

```bash
git add lib/app.dart lib/feature/example_posts/presentation/screen/posts_screen.dart
git commit -m "feat: wire ThemeCubit into the app with a theme toggle"
```
(Append the Co-Authored-By line.)

---

## Task 7: Document & final verification

**Files:**
- Modify: `docs/ARCHITECTURE.md`

- [ ] **Step 1: Append an "Environments" and "Theming" section to `docs/ARCHITECTURE.md`**

Append at the end of the file:
```markdown
## Environments

`AppConfig` (`lib/core/config/app_config.dart`) selects the environment at
compile time from `--dart-define=ENV=dev|staging|prod` (default `dev`) and
exposes the API `baseUrl`. It is registered in `lib/injection.dart` and read by
the networking layer via `getIt<AppConfig>()`. Replace the placeholder base URLs
with your real endpoints. Run a flavor with, e.g.,
`flutter run --dart-define=ENV=staging`.

## Theming

`ThemeCubit` (`lib/core/theme/theme_cubit.dart`) holds the active `ThemeMode`,
defaults to `ThemeMode.system`, and persists changes through
`PreferencesManager`. `lib/app.dart` provides it and drives
`MaterialApp.router`'s `themeMode`. Light and dark `ThemeData` live in
`lib/utils/theme/app_theme.dart`. `PostsScreen`'s app-bar button
(`cycleThemeMode`) demonstrates switching at runtime.
```

- [ ] **Step 2: Final verification**

- `flutter analyze` → `No issues found!`
- `flutter test` → all pass (zero failures; ≈20 tests).
- `dart format --output=none --set-exit-if-changed .` → exit 0.
- `flutter build web` → succeeds.

- [ ] **Step 3: Commit**

```bash
git add docs/ARCHITECTURE.md
git commit -m "docs: document environments and theming"
```
(Append the Co-Authored-By line.)

---

## Integration

- [ ] Push branch and open a PR (per `CONTRIBUTING.md`).
- [ ] Confirm CI green, then merge to `main` (rebase for linear history).
