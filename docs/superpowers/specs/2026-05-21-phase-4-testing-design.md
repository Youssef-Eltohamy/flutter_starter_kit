# Phase 4 — Quality & Testing Design Spec

**Date:** 2026-05-21
**Project:** flutter_starter_kit
**Goal:** Complete the base's testing story: a reusable widget-test helper, full
widget tests for the reference example screen, coverage reporting in CI, and
documented testing conventions — so contributors have a clear template.

**Builds on:** PRs #2–#4. Follows `CLAUDE.md` principles and `docs/ARCHITECTURE.md`.

**Out of scope (deliberately):** `integration_test` (extra dependency + heavier
runner), and any hard coverage-threshold gate (keep CI simple).

---

## 1. Test helper

`test/support/pump_app.dart` — a small helper that removes widget-test
boilerplate:

```dart
Future<void> pumpApp(WidgetTester tester, Widget widget, {ThemeCubit? themeCubit});
```

- Wraps `widget` in a `MaterialApp` (so `Scaffold`/`Navigator`/`Theme` exist).
- Provides a `ThemeCubit` (a passed-in one, or a default backed by a provided
  `PreferencesManager` mock) so screens that read `context.read<ThemeCubit>()`
  do not crash.
- Keeps things minimal — no localization delegates needed because `context.tr`
  falls back to the key when `AppLocalizations` is absent, and `PostsScreen`'s
  visible text comes from data + literals.

## 2. PostsScreen widget tests

`test/feature/example_posts/posts_screen_test.dart` — covers the reference
screen's three states by registering a mock `PostsRepository` in `getIt`:

- `setUp`: `getIt.registerFactory<PostsRepository>(() => mockRepo)` (or
  `registerSingleton`); `tearDown`: `getIt.reset()` (or unregister) to isolate
  tests.
- **loading:** before the future completes, a `CircularProgressIndicator` shows.
- **success:** with `getPosts` → `Right([...])`, the post titles render as
  `ListTile`s.
- **failure:** with `getPosts` → `Left(ServerFailure('...'))`, the error message
  and a `Retry` button show; tapping `Retry` calls `getPosts` again.

Uses `mocktail` (`registerFallbackValue` where needed). The navigation tap
(`context.push`) is out of this screen test's scope (router is already covered).

## 3. Coverage in CI

Update `.github/workflows/ci.yml`'s test step to `flutter test --coverage`, and
upload `coverage/lcov.info` as a build artifact (`actions/upload-artifact`). No
threshold gate — coverage is informational.

## 4. Documentation

Add a "Testing" section to `CONTRIBUTING.md`:
- Unit tests for pure logic (repositories with a mocked `Dio`, cubits with
  `bloc_test` + a mocked repository).
- Widget tests with the `pumpApp` helper; mock `get_it` dependencies by
  registering fakes in `setUp` and calling `getIt.reset()` in `tearDown`.
- Run `flutter test` (and `flutter test --coverage` for a coverage report).

## 5. Success criteria

- `PostsScreen` has passing widget tests for loading, success, and failure
  (incl. retry).
- `pumpApp` is used by the new widget test and documented as the pattern.
- CI runs `flutter test --coverage` and stores `lcov.info` as an artifact.
- `flutter analyze` clean, `dart format` clean, all tests pass, `flutter build
  web` succeeds.
