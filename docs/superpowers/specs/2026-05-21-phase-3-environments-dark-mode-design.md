# Phase 3 — Environments, Networking Fixes & Dark Mode Design Spec

**Date:** 2026-05-21
**Project:** flutter_starter_kit
**Goal:** Make the base reliable across environments and themes: a simple
compile-time environment config that drives the API base URL, a fix for the
shared-Dio-instance bug, and runtime dark/light/system theming that persists.

**Builds on:** foundation (PR #2) and routing/base-widgets (PR #3). Follows the
principles in `CLAUDE.md` and conventions in `docs/ARCHITECTURE.md`.

**Out of scope (deliberately):** native flavors (`--flavor`, productFlavors),
`freezed`/`json_serializable` codegen, and a full design-system dark palette.

---

## 1. Environments (compile-time config)

`lib/core/config/app_config.dart`:

```dart
enum AppEnvironment { dev, staging, prod }

class AppConfig {
  const AppConfig({required this.environment, required this.baseUrl});

  final AppEnvironment environment;
  final String baseUrl;

  factory AppConfig.fromEnvironment() { ... } // reads String.fromEnvironment('ENV')
}
```

- `AppConfig.fromEnvironment()` reads `const String.fromEnvironment('ENV',
  defaultValue: 'dev')` and maps `dev`/`staging`/`prod` to placeholder base
  URLs (e.g. `https://api.dev.example.com`) that adopters replace.
- Created once in `main()` and registered in `lib/injection.dart` as a
  `getIt<AppConfig>()` singleton (no global mutable state).
- Selected at build/run time: `flutter run --dart-define=ENV=staging`.

## 2. Networking fixes (`DioApiManager` / `DioOptions`)

Two real bugs in `lib/apis/_base/dio_api_manager.dart`:

1. **Shared Dio instance:** `DioOptions.dioInstance` uses a `static Dio? dio`
   with `dio ??= Dio(options)`, so the authorized and unauthorized getters
   return the *same* Dio (first caller wins). Fix: each getter builds its own
   Dio; remove the shared static.
2. **Hardcoded base URL:** `DioOptions.baseUrl` returns
   `ApiKeys.baseUrlProduction`. Fix: the base URL comes from
   `getIt<AppConfig>().baseUrl`.

Constraints: keep the existing interceptor logic (auth headers, language,
app-version, 401/403 handling) unchanged — only fix instance creation and the
base URL source. The dead `oyn-gateway` URLs in `api_keys.dart` are removed
(base URLs now live in `AppConfig`).

## 3. Runtime dark mode

- `lib/core/theme/theme_cubit.dart`: `ThemeCubit extends Cubit<ThemeMode>`.
  On construction it loads the persisted mode (default `ThemeMode.system`);
  `setThemeMode(ThemeMode)` emits and persists.
- `PreferencesManager` gains `getThemeMode()` / `setThemeMode(ThemeMode)`
  (stored as a string key: `system` | `light` | `dark`).
- `lib/app.dart`: provide `ThemeCubit` alongside `LocaleCubit`; drive
  `MaterialApp.router`'s `themeMode` from its state (replacing the hardcoded
  `ThemeMode.light`).
- `AppTheme.themeDataDark` becomes a real dark theme mirroring the light one's
  `ColorScheme`/`appBarTheme`/`textTheme` with dark-appropriate colors (a
  sensible default, not a full design system).
- **Demonstration:** a theme-toggle `IconButton` in `PostsScreen`'s `AppBar`
  cycles system → light → dark via the `ThemeCubit`.

## 4. Testing

- `test/core/theme/theme_cubit_test.dart` — with a mocked `PreferencesManager`:
  loads the persisted mode on start; `setThemeMode` emits the new mode and
  persists it.
- `test/core/config/app_config_test.dart` — `AppConfig.fromEnvironment()`
  defaults to `AppEnvironment.dev` and exposes a non-empty `baseUrl`.
- Existing 17 tests keep passing.

## 5. Success criteria

- `flutter run --dart-define=ENV=prod|staging|dev` selects the matching base URL;
  default (no flag) is `dev`.
- Authorized and unauthorized Dio calls use independent instances.
- The app starts in `ThemeMode.system`; the toggle switches theme at runtime and
  the choice survives an app restart (persisted).
- `flutter analyze` clean, `dart format` clean, all tests pass, `flutter build
  web` succeeds.
- `docs/ARCHITECTURE.md` documents the environment config and theming.
