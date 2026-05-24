# Phase 4 — Quality & Testing Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Round out the base's testing story — a reusable widget-test helper, full widget tests for the reference `PostsScreen`, coverage reporting in CI, and documented testing conventions.

**Architecture:** A `pumpApp` `WidgetTester` extension removes boilerplate. `PostsScreen` is tested for its loading/success/failure states by registering a mock `PostsRepository` in `get_it`. CI runs `flutter test --coverage` and stores `lcov.info`.

**Tech Stack:** Flutter, flutter_test, mocktail, dartz, get_it.

**Spec:** `docs/superpowers/specs/2026-05-21-phase-4-testing-design.md`
**Working branch:** `feat/phase-4-testing` (already created).

---

## File Structure

**Created:**
- `test/support/pump_app.dart` — `pumpApp` WidgetTester extension.
- `test/feature/example_posts/posts_screen_test.dart` — PostsScreen widget tests.

**Modified:**
- `.github/workflows/ci.yml` — `flutter test --coverage` + artifact upload.
- `CONTRIBUTING.md` — a "Testing" section.

---

## Task 1: Test helper + PostsScreen widget tests

**Files:**
- Create: `test/support/pump_app.dart`
- Test: `test/feature/example_posts/posts_screen_test.dart`

Context: `PostsScreen` (`lib/feature/example_posts/presentation/screen/posts_screen.dart`) is a `StatelessWidget` that does `BlocProvider(create: (_) => PostsCubit(getIt<PostsRepository>())..loadPosts())`. `getIt` is exported from `lib/injection.dart`. On success it renders `ListTile`s with `post.title`/`post.body`; on failure an error message + a `Retry` `ElevatedButton`; while loading a `CircularProgressIndicator`. `PostsRepository.getPosts()` returns `Future<Either<Failure, List<Post>>>`. The theme-toggle button only reads `ThemeCubit` in its `onPressed`, so tests that do not tap it need no `ThemeCubit`.

- [ ] **Step 1: Create the helper `test/support/pump_app.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test helper: pumps [widget] inside a minimal [MaterialApp] so it has a
/// `Directionality`, `Navigator`, and `Theme`. Use in widget tests to avoid
/// repeating the `MaterialApp` wrapper.
extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget widget) {
    return pumpWidget(MaterialApp(home: widget));
  }
}
```

- [ ] **Step 2: Write the widget tests `test/feature/example_posts/posts_screen_test.dart`**

```dart
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/core/failures.dart';
import 'package:flutter_starter_kit/feature/example_posts/data/models/post.dart';
import 'package:flutter_starter_kit/feature/example_posts/data/posts_repository.dart';
import 'package:flutter_starter_kit/feature/example_posts/presentation/screen/posts_screen.dart';
import 'package:flutter_starter_kit/injection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../support/pump_app.dart';

class MockPostsRepository extends Mock implements PostsRepository {}

void main() {
  late MockPostsRepository repository;

  setUp(() {
    repository = MockPostsRepository();
    getIt.registerFactory<PostsRepository>(() => repository);
  });

  tearDown(() => getIt.reset());

  testWidgets('shows a loading indicator while posts load', (tester) async {
    when(() => repository.getPosts()).thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      return const Right<Failure, List<Post>>([]);
    });

    await tester.pumpApp(const PostsScreen());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
  });

  testWidgets('renders posts on success', (tester) async {
    when(() => repository.getPosts()).thenAnswer(
      (_) async => const Right<Failure, List<Post>>([
        Post(id: 1, title: 'Hello', body: 'World'),
      ]),
    );

    await tester.pumpApp(const PostsScreen());
    await tester.pumpAndSettle();

    expect(find.text('Hello'), findsOneWidget);
    expect(find.text('World'), findsOneWidget);
  });

  testWidgets('shows error + retry on failure, and retry refetches',
      (tester) async {
    when(() => repository.getPosts()).thenAnswer(
      (_) async => const Left<Failure, List<Post>>(ServerFailure('Boom')),
    );

    await tester.pumpApp(const PostsScreen());
    await tester.pumpAndSettle();

    expect(find.text('Boom'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    verify(() => repository.getPosts()).called(2);
  });
}
```

- [ ] **Step 3: Run the tests**

Run: `flutter test test/feature/example_posts/posts_screen_test.dart`
Expected: PASS (3 tests). If the loading test reports a pending-timer error, ensure the final `await tester.pumpAndSettle();` is present so the delayed future completes.

- [ ] **Step 4: Verify whole project**

Run: `flutter analyze` → `No issues found!`
Run: `flutter test` → all pass (≈26: 23 prior + 3).
Run: `dart format --output=none --set-exit-if-changed lib test` → exit 0 (run `dart format test` if needed).

- [ ] **Step 5: Commit**

```bash
git add test/support/pump_app.dart test/feature/example_posts/posts_screen_test.dart
git commit -m "test: add pumpApp helper and PostsScreen widget tests"
```
(Append: `Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>`)

---

## Task 2: Coverage in CI

**Files:**
- Modify: `.github/workflows/ci.yml`

- [ ] **Step 1: Update the test step + add artifact upload**

Read `.github/workflows/ci.yml`. Replace the existing test step:
```yaml
      - name: Test
        run: flutter test
```
with:
```yaml
      - name: Test
        run: flutter test --coverage
      - name: Upload coverage
        uses: actions/upload-artifact@v4
        with:
          name: coverage
          path: coverage/lcov.info
```
(Leave the checkout, flutter-action, pub get, formatting, and analyze steps unchanged.)

- [ ] **Step 2: Sanity-check coverage runs locally**

Run: `flutter test --coverage`
Expected: tests pass and `coverage/lcov.info` is generated. (Note: `coverage/` is already git-ignored by the standard Flutter `.gitignore`; do not commit it.)

- [ ] **Step 3: Commit**

```bash
git add .github/workflows/ci.yml
git commit -m "ci: collect coverage and upload lcov.info artifact"
```
(Append the Co-Authored-By line.)

---

## Task 3: Document testing conventions

**Files:**
- Modify: `CONTRIBUTING.md`

- [ ] **Step 1: Append a "Testing" section to `CONTRIBUTING.md`**

Read the file (preserve existing content), then append after the last line:
```markdown
## Testing

- **Unit tests** for pure logic: repositories with a mocked `Dio`
  (`mocktail`), cubits with `bloc_test` + a mocked repository. See
  `test/feature/example_posts/`.
- **Widget tests** use the `pumpApp` helper (`test/support/pump_app.dart`),
  which wraps a widget in a minimal `MaterialApp`. Mock `get_it` dependencies by
  registering a fake in `setUp` and calling `getIt.reset()` in `tearDown` — see
  `test/feature/example_posts/posts_screen_test.dart`.
- Run `flutter test`; for a coverage report run `flutter test --coverage`
  (outputs `coverage/lcov.info`). CI runs coverage on every push/PR.
```

- [ ] **Step 2: Verify & commit**

Run: `flutter analyze` → `No issues found!`
```bash
git add CONTRIBUTING.md
git commit -m "docs: document testing conventions"
```
(Append the Co-Authored-By line.)

---

## Task 4: Final verification

- [ ] **Step 1: Run the full suite**

- `flutter analyze` → `No issues found!`
- `flutter test` → all pass (≈26; zero failures).
- `dart format --output=none --set-exit-if-changed .` → exit 0.
- `flutter test --coverage` → generates `coverage/lcov.info`.
- `flutter build web` → succeeds.

(No commit — verification only.)

---

## Integration

- [ ] Push branch and open a PR (per `CONTRIBUTING.md`).
- [ ] Confirm CI green (now including the coverage step), then merge to `main` (rebase for linear history).
