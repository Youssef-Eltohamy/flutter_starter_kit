# Foundation Standards Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Establish the engineering principles, conventions, and lightweight guardrails (docs + tooling + one reference example feature) that keep this Flutter base strong, solid, and simple.

**Architecture:** Practical, balanced layering per feature — `data/` (repository returning `Either<Failure, T>`) + `presentation/` (Cubit + state + UI), with `domain/` optional. DI centralized in `injection.dart`. A real `posts` example feature demonstrates the full pattern and is covered by unit tests.

**Tech Stack:** Flutter, flutter_bloc (Cubit), dio, dartz (`Either`), get_it, equatable. Tests use `bloc_test` + `mocktail`. CI via GitHub Actions.

**Spec:** `docs/superpowers/specs/2026-05-20-foundation-standards-design.md`

**Working branch:** `chore/foundation-standards` (already created).

---

## File Structure

**Created:**
- `.editorconfig` — editor consistency
- `.github/workflows/ci.yml` — format + analyze + test on push/PR
- `.github/PULL_REQUEST_TEMPLATE.md`
- `.github/ISSUE_TEMPLATE/bug_report.md`, `.github/ISSUE_TEMPLATE/feature_request.md`
- `lib/injection.dart` — centralized get_it setup
- `lib/feature/example_posts/data/models/post.dart`
- `lib/feature/example_posts/data/posts_repository.dart`
- `lib/feature/example_posts/presentation/cubit/posts_state.dart`
- `lib/feature/example_posts/presentation/cubit/posts_cubit.dart`
- `lib/feature/example_posts/presentation/screen/posts_screen.dart`
- `test/feature/example_posts/posts_repository_test.dart`
- `test/feature/example_posts/posts_cubit_test.dart`
- `CONTRIBUTING.md`, `CLAUDE.md`, `docs/ARCHITECTURE.md`

**Modified:**
- `analysis_options.yaml` — curated stricter rules
- `lib/core/failures.dart` — message-bearing failure types
- `lib/core/usecase.dart` — single unified UseCase contract
- `lib/main.dart` — call `setupDependencies()`
- `lib/app.dart` — land on `PostsScreen`
- `pubspec.yaml` — add dev deps (via `flutter pub add`)

---

## Task 1: Curated lints + .editorconfig

**Files:**
- Modify: `analysis_options.yaml`
- Create: `.editorconfig`

- [ ] **Step 1: Replace `analysis_options.yaml` with a curated rule set**

```yaml
# Static analysis configuration.
# Base: Flutter recommended lints, plus a small, pragmatic set of stricter
# rules aligned with the project's "simple and consistent" principles.
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - always_declare_return_types
    - avoid_print
    - directives_ordering
    - prefer_const_constructors
    - prefer_const_declarations
    - prefer_final_locals
    - prefer_single_quotes
    - unawaited_futures
```

- [ ] **Step 2: Create `.editorconfig`**

```ini
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true
indent_style = space

[*.dart]
indent_size = 2
max_line_length = 80

[*.{yml,yaml,json}]
indent_size = 2

[*.md]
trim_trailing_whitespace = false
```

- [ ] **Step 3: Auto-fix and format**

Run: `dart fix --apply && dart format lib/ test/`
Expected: several fixes applied (single quotes, const, final locals, directive ordering); files reformatted.

- [ ] **Step 4: Resolve residual analyzer issues**

Run: `flutter analyze`
Likely residuals and their fixes:
- `avoid_print` → replace `print(x)` with `debugPrint(x)` (import `package:flutter/foundation.dart`); in pure-Dart files use `log(x)` (import `dart:developer`).
- `unawaited_futures` → wrap fire-and-forget calls with `unawaited(...)` (import `dart:async`) or add `await`.
Apply fixes until analyze reports no issues.

- [ ] **Step 5: Verify clean**

Run: `flutter analyze`
Expected: `No issues found!`

Run: `flutter test`
Expected: All tests pass.

- [ ] **Step 6: Commit**

```bash
git add analysis_options.yaml .editorconfig lib test
git commit -m "chore: add curated lints and .editorconfig"
```

---

## Task 2: Add test dev-dependencies

**Files:**
- Modify: `pubspec.yaml` (via tool)

- [ ] **Step 1: Add dev dependencies**

Run: `flutter pub add --dev bloc_test mocktail`
Expected: `pubspec.yaml` gains `bloc_test` and `mocktail` under `dev_dependencies`; `pub get` resolves compatible versions.

- [ ] **Step 2: Verify resolution**

Run: `flutter pub get`
Expected: no version conflicts.

- [ ] **Step 3: Commit**

```bash
git add pubspec.yaml pubspec.lock
git commit -m "chore: add bloc_test and mocktail for testing"
```

---

## Task 3: Unify failures and the UseCase contract

**Files:**
- Modify: `lib/core/failures.dart`
- Modify: `lib/core/usecase.dart`

(`Failure`, `CacheFailure`, `BaseUseCase`, `UseCase`, `NoParams` are not referenced anywhere else — verified — so these rewrites are safe.)

- [ ] **Step 1: Rewrite `lib/core/failures.dart`**

```dart
import 'package:equatable/equatable.dart';

/// Base type for all recoverable failures. Carries a user-facing [message].
abstract class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// A remote/server-side error (non-2xx response, parsing error, etc.).
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Something went wrong. Please try again.']);
}

/// No internet connection / connection error.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

/// A local storage / cache error.
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'A storage error occurred.']);
}
```

- [ ] **Step 2: Rewrite `lib/core/usecase.dart` to a single contract**

```dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'failures.dart';

/// A single unit of business logic. Implement this only when a feature's
/// logic is non-trivial or shared — simple features call the repository
/// directly from their Cubit (see docs/ARCHITECTURE.md).
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Use as [Params] for use cases that take no arguments.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
```

- [ ] **Step 3: Verify**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 4: Commit**

```bash
git add lib/core/failures.dart lib/core/usecase.dart
git commit -m "refactor: unify Failure types and UseCase contract"
```

---

## Task 4: Centralize dependency injection in injection.dart

**Files:**
- Create: `lib/injection.dart`
- Modify: `lib/main.dart`

- [ ] **Step 1: Create `lib/injection.dart`**

```dart
import 'package:dio/dio.dart';
import 'package:flutter_starter_kit/apis/_base/dio_api_manager.dart';
import 'package:flutter_starter_kit/feature/example_posts/data/posts_repository.dart';
import 'package:flutter_starter_kit/preferences/preferences_manager.dart';
import 'package:flutter_starter_kit/utils/connectivity/connectivity_data.dart';
import 'package:get_it/get_it.dart';

/// The single service locator instance for the app.
final GetIt getIt = GetIt.instance;

/// Registers all app-wide dependencies. Call once from `main()` before
/// `runApp`. Group registrations by area and keep this the only place that
/// wires the object graph.
Future<void> setupDependencies() async {
  // Core
  getIt.registerLazySingleton<PreferencesManager>(PreferencesManager.new);
  getIt.registerLazySingleton<DioApiManager>(
    () => DioApiManager(getIt<PreferencesManager>()),
  );
  getIt.registerLazySingleton<ConnectivityData>(ConnectivityData.new);

  // Example feature (see lib/feature/example_posts)
  getIt.registerLazySingleton<Dio>(Dio.new);
  getIt.registerLazySingleton<PostsRepository>(
    () => PostsRepository(getIt<Dio>()),
  );
}
```

> Note: this imports `PostsRepository`, created in Task 5. If implementing strictly in order, temporarily comment the two example lines and the import, then re-enable them at the end of Task 5. (Subagent-driven execution can implement Task 5 first if preferred.)

- [ ] **Step 2: Update `lib/main.dart` to use `setupDependencies()`**

Replace the inline `GetIt.I.registerLazySingleton<...>` block with a single call. The result should read:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter_kit/app.dart';
import 'package:flutter_starter_kit/injection.dart';
import 'package:flutter_starter_kit/utils/bloc_observer/app_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await setupDependencies();

  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}
```

- [ ] **Step 3: Verify**

Run: `flutter analyze`
Expected: `No issues found!` (assuming Task 5 files exist; otherwise see the note in Step 1).

- [ ] **Step 4: Commit**

```bash
git add lib/injection.dart lib/main.dart
git commit -m "refactor: centralize DI in injection.dart"
```

---

## Task 5: Example feature — model + repository (TDD)

**Files:**
- Create: `lib/feature/example_posts/data/models/post.dart`
- Create: `lib/feature/example_posts/data/posts_repository.dart`
- Test: `test/feature/example_posts/posts_repository_test.dart`

- [ ] **Step 1: Create the `Post` model**

`lib/feature/example_posts/data/models/post.dart`:

```dart
import 'package:equatable/equatable.dart';

/// A blog post returned by the example API.
class Post extends Equatable {
  const Post({required this.id, required this.title, required this.body});

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json['id'] as int,
        title: json['title'] as String,
        body: json['body'] as String,
      );

  final int id;
  final String title;
  final String body;

  @override
  List<Object?> get props => [id, title, body];
}
```

- [ ] **Step 2: Write the failing repository test**

`test/feature/example_posts/posts_repository_test.dart`:

```dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_starter_kit/core/failures.dart';
import 'package:flutter_starter_kit/feature/example_posts/data/models/post.dart';
import 'package:flutter_starter_kit/feature/example_posts/data/posts_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late PostsRepository repository;

  setUp(() {
    dio = MockDio();
    repository = PostsRepository(dio);
  });

  Response<dynamic> response(dynamic data, {int status = 200}) => Response(
        data: data,
        statusCode: status,
        requestOptions: RequestOptions(path: ''),
      );

  test('returns a list of posts on success', () async {
    when(() => dio.get<dynamic>(any())).thenAnswer(
      (_) async => response([
        {'id': 1, 'title': 'a', 'body': 'b'},
      ]),
    );

    final result = await repository.getPosts();

    expect(result, isA<Right<Failure, List<Post>>>());
    expect(result.getOrElse(() => []), [
      const Post(id: 1, title: 'a', body: 'b'),
    ]);
  });

  test('returns ServerFailure on DioException', () async {
    when(() => dio.get<dynamic>(any())).thenThrow(
      DioException(requestOptions: RequestOptions(path: '')),
    );

    final result = await repository.getPosts();

    expect(result, isA<Left<Failure, List<Post>>>());
    expect(result.swap().getOrElse(() => const CacheFailure()),
        isA<ServerFailure>());
  });

  test('returns NetworkFailure on connection error', () async {
    when(() => dio.get<dynamic>(any())).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionError,
      ),
    );

    final result = await repository.getPosts();

    expect(result.swap().getOrElse(() => const CacheFailure()),
        isA<NetworkFailure>());
  });
}
```

- [ ] **Step 3: Run test to verify it fails**

Run: `flutter test test/feature/example_posts/posts_repository_test.dart`
Expected: FAIL — `PostsRepository` / `getPosts` not defined.

- [ ] **Step 4: Implement the repository**

`lib/feature/example_posts/data/posts_repository.dart`:

```dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_starter_kit/core/failures.dart';
import 'package:flutter_starter_kit/feature/example_posts/data/models/post.dart';

/// Fetches example posts from a public API. Demonstrates the project's
/// data-layer pattern: take a [Dio], return `Either<Failure, T>`, and map
/// transport errors to typed [Failure]s.
class PostsRepository {
  const PostsRepository(this._dio);

  final Dio _dio;

  static const _endpoint = 'https://jsonplaceholder.typicode.com/posts?_limit=20';

  Future<Either<Failure, List<Post>>> getPosts() async {
    try {
      final response = await _dio.get<dynamic>(_endpoint);
      final data = (response.data as List<dynamic>?) ?? <dynamic>[];
      final posts = data
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(posts);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        return const Left(NetworkFailure());
      }
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (_) {
      return const Left(ServerFailure());
    }
  }
}
```

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/feature/example_posts/posts_repository_test.dart`
Expected: PASS (3 tests).

- [ ] **Step 6: Re-enable example lines in `injection.dart`** (if commented in Task 4) and run `flutter analyze` → `No issues found!`.

- [ ] **Step 7: Commit**

```bash
git add lib/feature/example_posts/data test/feature/example_posts/posts_repository_test.dart lib/injection.dart
git commit -m "feat: add example posts model and repository with tests"
```

---

## Task 6: Example feature — Cubit + state (TDD)

**Files:**
- Create: `lib/feature/example_posts/presentation/cubit/posts_state.dart`
- Create: `lib/feature/example_posts/presentation/cubit/posts_cubit.dart`
- Test: `test/feature/example_posts/posts_cubit_test.dart`

- [ ] **Step 1: Create the state**

`lib/feature/example_posts/presentation/cubit/posts_state.dart`:

```dart
import 'package:equatable/equatable.dart';
import 'package:flutter_starter_kit/feature/example_posts/data/models/post.dart';

enum PostsStatus { initial, loading, success, failure }

/// Single immutable state object for the posts screen. Prefer one state class
/// with a status enum over many subclasses — it is simpler to read and copy.
class PostsState extends Equatable {
  const PostsState({
    this.status = PostsStatus.initial,
    this.posts = const [],
    this.errorMessage,
  });

  final PostsStatus status;
  final List<Post> posts;
  final String? errorMessage;

  PostsState copyWith({
    PostsStatus? status,
    List<Post>? posts,
    String? errorMessage,
  }) {
    return PostsState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, posts, errorMessage];
}
```

- [ ] **Step 2: Write the failing cubit test**

`test/feature/example_posts/posts_cubit_test.dart`:

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_starter_kit/core/failures.dart';
import 'package:flutter_starter_kit/feature/example_posts/data/models/post.dart';
import 'package:flutter_starter_kit/feature/example_posts/data/posts_repository.dart';
import 'package:flutter_starter_kit/feature/example_posts/presentation/cubit/posts_cubit.dart';
import 'package:flutter_starter_kit/feature/example_posts/presentation/cubit/posts_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPostsRepository extends Mock implements PostsRepository {}

void main() {
  late MockPostsRepository repository;

  const posts = [Post(id: 1, title: 'a', body: 'b')];

  setUp(() => repository = MockPostsRepository());

  blocTest<PostsCubit, PostsState>(
    'emits [loading, success] when posts load successfully',
    setUp: () => when(() => repository.getPosts())
        .thenAnswer((_) async => const Right(posts)),
    build: () => PostsCubit(repository),
    act: (cubit) => cubit.loadPosts(),
    expect: () => const [
      PostsState(status: PostsStatus.loading),
      PostsState(status: PostsStatus.success, posts: posts),
    ],
  );

  blocTest<PostsCubit, PostsState>(
    'emits [loading, failure] when the repository fails',
    setUp: () => when(() => repository.getPosts())
        .thenAnswer((_) async => const Left(ServerFailure('boom'))),
    build: () => PostsCubit(repository),
    act: (cubit) => cubit.loadPosts(),
    expect: () => const [
      PostsState(status: PostsStatus.loading),
      PostsState(status: PostsStatus.failure, errorMessage: 'boom'),
    ],
  );
}
```

- [ ] **Step 3: Run test to verify it fails**

Run: `flutter test test/feature/example_posts/posts_cubit_test.dart`
Expected: FAIL — `PostsCubit` not defined.

- [ ] **Step 4: Implement the cubit**

`lib/feature/example_posts/presentation/cubit/posts_cubit.dart`:

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter_kit/feature/example_posts/data/posts_repository.dart';
import 'package:flutter_starter_kit/feature/example_posts/presentation/cubit/posts_state.dart';

/// Drives the posts screen. Calls the repository and folds the
/// `Either<Failure, T>` result into a single [PostsState].
class PostsCubit extends Cubit<PostsState> {
  PostsCubit(this._repository) : super(const PostsState());

  final PostsRepository _repository;

  Future<void> loadPosts() async {
    emit(state.copyWith(status: PostsStatus.loading));
    final result = await _repository.getPosts();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PostsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (posts) => emit(
        state.copyWith(status: PostsStatus.success, posts: posts),
      ),
    );
  }
}
```

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/feature/example_posts/posts_cubit_test.dart`
Expected: PASS (2 tests).

- [ ] **Step 6: Commit**

```bash
git add lib/feature/example_posts/presentation/cubit test/feature/example_posts/posts_cubit_test.dart
git commit -m "feat: add example posts cubit and state with tests"
```

---

## Task 7: Example feature — screen + app wiring

**Files:**
- Create: `lib/feature/example_posts/presentation/screen/posts_screen.dart`
- Modify: `lib/app.dart`

- [ ] **Step 1: Create the screen**

`lib/feature/example_posts/presentation/screen/posts_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter_kit/feature/example_posts/data/posts_repository.dart';
import 'package:flutter_starter_kit/feature/example_posts/presentation/cubit/posts_cubit.dart';
import 'package:flutter_starter_kit/feature/example_posts/presentation/cubit/posts_state.dart';
import 'package:flutter_starter_kit/injection.dart';

/// Reference example screen. Shows the recommended wiring:
/// BlocProvider creates the Cubit from a get_it dependency, and BlocBuilder
/// renders one widget per [PostsStatus].
class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostsCubit(getIt<PostsRepository>())..loadPosts(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Posts (example)')),
        body: BlocBuilder<PostsCubit, PostsState>(
          builder: (context, state) {
            switch (state.status) {
              case PostsStatus.initial:
              case PostsStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case PostsStatus.failure:
                return _ErrorView(
                  message: state.errorMessage ?? 'Unknown error',
                  onRetry: () => context.read<PostsCubit>().loadPosts(),
                );
              case PostsStatus.success:
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.posts.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final post = state.posts[index];
                    return ListTile(
                      title: Text(post.title),
                      subtitle: Text(post.body),
                    );
                  },
                );
            }
          },
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Land the app on `PostsScreen`**

In `lib/app.dart`: replace the `home_screen.dart` import with the posts screen, and set `home: const PostsScreen()`.

Change the import line:
```dart
import 'package:flutter_starter_kit/feature/home/screen/home_screen.dart';
```
to:
```dart
import 'package:flutter_starter_kit/feature/example_posts/presentation/screen/posts_screen.dart';
```

Change:
```dart
                home: const HomeScreen(),
```
to:
```dart
                home: const PostsScreen(),
```

(The existing `HomeScreen` stays in the repo as an additional UI sample.)

- [ ] **Step 3: Verify analyze + tests**

Run: `flutter analyze`
Expected: `No issues found!`

Run: `flutter test`
Expected: All tests pass.

- [ ] **Step 4: Verify it builds**

Run: `flutter build apk --debug` (or `flutter run -d <device>` if available)
Expected: build succeeds.

- [ ] **Step 5: Commit**

```bash
git add lib/feature/example_posts/presentation/screen lib/app.dart
git commit -m "feat: add example posts screen and land app on it"
```

---

## Task 8: Documentation (CLAUDE.md, ARCHITECTURE.md, CONTRIBUTING.md)

**Files:**
- Create: `CLAUDE.md`
- Create: `docs/ARCHITECTURE.md`
- Create: `CONTRIBUTING.md`

- [ ] **Step 1: Create `CLAUDE.md`**

```markdown
# CLAUDE.md

Guidance for Claude and contributors working in this repository.

## What this is
A production-ready Flutter **base/starter** project. Optimized to be **strong,
solid, and simple** — never complex. Read `docs/ARCHITECTURE.md` for the full
picture and `CONTRIBUTING.md` for the workflow.

## Core principles (do not violate)
1. Simplicity first (KISS / YAGNI) — no speculative abstraction.
2. Rule of two uses — don't generalize until something repeats twice.
3. Clarity over cleverness — obvious names, top-to-bottom readability.
4. Small, focused units — one file/class, one purpose.
5. Consistency — follow the existing pattern; one way to do common things.
6. Safe errors — fallible operations return `Either<Failure, T>`.
7. Everything testable — keep logic out of widgets.
8. Dependencies are liabilities — justify every package.
9. Document entry points — each feature/public API gets a short doc comment.

## Architecture in one breath
`feature/<name>/data` (repository → `Either<Failure, T>`) +
`presentation` (Cubit + state + UI). `domain/` (usecases) is **optional** —
add it only when logic is non-trivial or shared. DI lives in `lib/injection.dart`.
Copy `lib/feature/example_posts/` as the template for a new feature.

## Commands
- Install: `flutter pub get`
- Analyze: `flutter analyze` (must be clean)
- Format: `dart format lib test`
- Test: `flutter test`
- Run: `flutter run`

## Definition of done for any change
`flutter analyze` clean, `dart format` applied, `flutter test` green, and the
change follows the principles above.
```

- [ ] **Step 2: Create `docs/ARCHITECTURE.md`**

```markdown
# Architecture

This base uses a **practical, balanced** layering — clear boundaries without
the boilerplate of full Clean Architecture on every feature.

## Layers per feature

```
lib/feature/<name>/
├── data/            # repository (+ models, data source when needed)
├── presentation/    # cubit|bloc + state + screens + widgets
└── domain/          # OPTIONAL: usecases/entities
```

- **data/** — talks to the network/storage. Repositories return
  `Either<Failure, T>` (from `dartz`) and map transport errors to typed
  `Failure`s (see `lib/core/failures.dart`).
- **presentation/** — a `Cubit` (default) holds a single immutable state object
  with a status enum; screens render one widget per status.
- **domain/** — add only when business logic is non-trivial or shared across
  features. Implement `UseCase<T, Params>` from `lib/core/usecase.dart`.

## Decision rules
- **Cubit vs Bloc:** Cubit by default. Use Bloc only when discrete events or
  stream transformations clearly justify it.
- **Add a domain layer?** Only when logic is non-trivial or reused. Simple
  features go repository → cubit directly.
- **State shape:** one state class + status enum + `copyWith`. Avoid many state
  subclasses unless the feature truly needs them.

## Dependency injection
All wiring lives in `lib/injection.dart` via `get_it`. Call `setupDependencies()`
once in `main()`. Screens read dependencies with `getIt<T>()`.

## Reference example
`lib/feature/example_posts/` is the canonical template. It fetches posts from a
public API and demonstrates the full stack:
`PostsRepository` (`Either`) → `PostsCubit` + `PostsState` → `PostsScreen`,
with unit tests in `test/feature/example_posts/`.

## Adding a feature (copy the example)
1. Copy `lib/feature/example_posts/` to `lib/feature/<name>/` and rename.
2. Replace the model, endpoint, and UI.
3. Register the repository in `lib/injection.dart`.
4. Add tests under `test/feature/<name>/`.
5. Run `flutter analyze` and `flutter test`.
```

- [ ] **Step 3: Create `CONTRIBUTING.md`**

```markdown
# Contributing

Thanks for improving this base! The aim is a foundation that stays **simple and
consistent**. Please follow these conventions.

## Workflow
- Branch from `main`: `feat/<topic>`, `fix/<topic>`, or `chore/<topic>`.
- One focused change per pull request.
- Open a PR; CI must pass (format + analyze + test).

## Commit messages
Conventional style: `feat:`, `fix:`, `refactor:`, `chore:`, `docs:`, `test:`.

## Definition of done
- `dart format lib test` applied.
- `flutter analyze` → no issues.
- `flutter test` → all green.
- Change follows the principles in `CLAUDE.md` and the layering in
  `docs/ARCHITECTURE.md`.

## Adding a feature
Copy `lib/feature/example_posts/` and follow the steps in
`docs/ARCHITECTURE.md` ("Adding a feature"). Keep the domain layer out unless
the logic genuinely needs it.

## Code style
- `snake_case` files, `UpperCamelCase` types, single quotes, trailing commas.
- Keep files small and focused; extract a widget/class when one grows unwieldy.
```

- [ ] **Step 4: Verify formatting of docs (no code impact)**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 5: Commit**

```bash
git add CLAUDE.md docs/ARCHITECTURE.md CONTRIBUTING.md
git commit -m "docs: add CLAUDE.md, ARCHITECTURE.md and CONTRIBUTING.md"
```

---

## Task 9: CI workflow + GitHub templates

**Files:**
- Create: `.github/workflows/ci.yml`
- Create: `.github/PULL_REQUEST_TEMPLATE.md`
- Create: `.github/ISSUE_TEMPLATE/bug_report.md`
- Create: `.github/ISSUE_TEMPLATE/feature_request.md`

- [ ] **Step 1: Create `.github/workflows/ci.yml`**

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:

jobs:
  analyze-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          channel: stable
      - run: flutter pub get
      - name: Verify formatting
        run: dart format --output=none --set-exit-if-changed .
      - name: Analyze
        run: flutter analyze
      - name: Test
        run: flutter test
```

- [ ] **Step 2: Create `.github/PULL_REQUEST_TEMPLATE.md`**

```markdown
## What & why
<!-- Briefly describe the change and the motivation. -->

## Checklist
- [ ] `dart format lib test` applied
- [ ] `flutter analyze` is clean
- [ ] `flutter test` passes
- [ ] Follows the principles in `CLAUDE.md` and layering in `docs/ARCHITECTURE.md`
```

- [ ] **Step 3: Create `.github/ISSUE_TEMPLATE/bug_report.md`**

```markdown
---
name: Bug report
about: Report a problem
title: "[Bug] "
labels: bug
---

**Describe the bug**
A clear description of what the bug is.

**To reproduce**
Steps to reproduce the behavior.

**Expected behavior**
What you expected to happen.

**Environment**
- Flutter version:
- Platform/device:
```

- [ ] **Step 4: Create `.github/ISSUE_TEMPLATE/feature_request.md`**

```markdown
---
name: Feature request
about: Suggest an improvement
title: "[Feature] "
labels: enhancement
---

**Problem**
What problem does this solve?

**Proposed solution**
Describe the change you'd like.

**Alternatives considered**
Any alternative approaches.
```

- [ ] **Step 5: Commit**

```bash
git add .github
git commit -m "ci: add GitHub Actions workflow and issue/PR templates"
```

---

## Final verification

- [ ] Run `flutter analyze` → `No issues found!`
- [ ] Run `flutter test` → all tests pass (repository + cubit + existing utils tests).
- [ ] Run `dart format --output=none --set-exit-if-changed .` → exits 0 (no diff).
- [ ] Confirm the app launches on `PostsScreen` and lists posts (network permitting).

## Integration
- [ ] Push branch and open a PR (per `CONTRIBUTING.md`).
- [ ] Merge to `main` after review (rebase for linear history).
