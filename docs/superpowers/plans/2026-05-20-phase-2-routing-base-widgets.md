# Phase 2 — Routing & Base Widgets Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a clean go_router navigation foundation and refactor the shared widget bases (context extensions, remove the `must_be_immutable` anti-pattern, keep+improve the loading/connectivity screen base, fix a connectivity bug) — demonstrated by a tested post-details screen.

**Architecture:** Helpers (sizing/theme/translation) move from stateful mixins to `BuildContext` extensions. `BaseStatelessWidget` is removed; the valuable loading+connectivity screen base is kept, simplified, and demonstrated. Navigation uses a single central `GoRouter`.

**Tech Stack:** Flutter, go_router, flutter_bloc, dartz, get_it. Tests use flutter_test (+ existing mocktail/bloc_test).

**Spec:** `docs/superpowers/specs/2026-05-20-phase-2-architecture-design.md`
**Working branch:** `feat/phase-2-routing-base-widgets` (already created).

---

## File Structure

**Created:**
- `lib/core/extensions/context_extensions.dart` — `BuildContext` getters for sizing/theme/localization.
- `lib/core/app_platform.dart` — static platform checks.
- `lib/core/router/app_routes.dart` — route path/name constants.
- `lib/core/router/app_router.dart` — the central `GoRouter`.
- `lib/feature/example_posts/presentation/screen/post_details_view.dart` — pure content widget (testable).
- `lib/feature/example_posts/presentation/screen/post_details_screen.dart` — screen built on the base.
- `test/feature/example_posts/post_details_view_test.dart`
- `test/core/router/app_router_test.dart`

**Modified:**
- `lib/core/loading_manager.dart` — `on State<T>`, uses `setState` + `context.tr`.
- `lib/core/widgets/base_stateful_screen_widget.dart` — extends `StatefulWidget` directly, uses extensions.
- `lib/feature/on_boarding/widgets/onboarding_screen.dart` — plain `StatelessWidget` + extensions.
- `lib/utils/connectivity/connectivity_listener_widget.dart` — fix stream casts, use `context.tr`.
- `lib/feature/example_posts/presentation/screen/posts_screen.dart` — navigate to details.
- `lib/app.dart` — `MaterialApp.router`.
- `docs/ARCHITECTURE.md` — routing + extensions/screen-base conventions.
- `pubspec.yaml` — add `go_router`.

**Deleted:**
- `lib/core/widgets/base_stateless_widget.dart`
- `lib/core/widgets/base_stateful_widget.dart`
- `lib/core/screen_sizer.dart`, `lib/core/themer.dart`, `lib/core/translator.dart`, `lib/core/platform_manager.dart`

---

## Task 1: Context extensions + AppPlatform

**Files:**
- Create: `lib/core/extensions/context_extensions.dart`
- Create: `lib/core/app_platform.dart`

- [ ] **Step 1: Create `lib/core/extensions/context_extensions.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/utils/locale/app_localization.dart';

/// Convenience getters on [BuildContext] for sizing, theming and localization.
/// Prefer these over base-class mixins so widgets stay truly stateless.
extension BuildContextX on BuildContext {
  // Sizing
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  Orientation get orientation => MediaQuery.orientationOf(this);
  bool get isPortrait => orientation == Orientation.portrait;
  bool get isLandscape => orientation == Orientation.landscape;
  bool get isTablet => screenWidth >= 600;
  bool get isDesktop => screenWidth >= 1000;

  // Theme
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // Localization
  String tr(String key) => AppLocalizations.of(this)?.translate(key) ?? key;
  bool get isRTL => AppLocalizations.of(this)?.isRTL() ?? false;
}
```

- [ ] **Step 2: Create `lib/core/app_platform.dart`**

```dart
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;

/// Static platform checks that are safe on web (where `dart:io` `Platform`
/// throws). Use instead of touching `Platform` directly.
abstract final class AppPlatform {
  static bool get isWeb => kIsWeb;
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
  static bool get isIOS => !kIsWeb && Platform.isIOS;
  static bool get isLinux => !kIsWeb && Platform.isLinux;
  static bool get isWindows => !kIsWeb && Platform.isWindows;
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;
  static bool get isMobile => isAndroid || isIOS;
  static bool get isDesktop => isLinux || isWindows || isMacOS;
}
```

- [ ] **Step 3: Verify**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 4: Commit**

```bash
git add lib/core/extensions/context_extensions.dart lib/core/app_platform.dart
git commit -m "feat: add BuildContext extensions and AppPlatform helpers"
```

---

## Task 2: Refactor LoadingManager + screen base

**Files:**
- Modify: `lib/core/loading_manager.dart`
- Modify: `lib/core/widgets/base_stateful_screen_widget.dart`

- [ ] **Step 1: Rewrite `lib/core/loading_manager.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/core/extensions/context_extensions.dart';
import 'package:flutter_starter_kit/utils/loaders/full_screen_loader_widget.dart';
import 'package:flutter_starter_kit/utils/locale/app_localization_keys.dart';
import 'package:flutter_starter_kit/utils/widgets/empty_widgets.dart';

/// Adds a full-screen loading overlay to a [State]. Call [showLoading] /
/// [hideLoading] (or the message variants) from the screen, and render
/// [loadingManagerWidget] in the widget tree.
mixin LoadingManager<T extends StatefulWidget> on State<T> {
  String? _message;
  bool _isLoading = false;
  bool _isLoadingWithMessage = false;

  void showLoading() {
    if (!_isLoading) setState(() => _isLoading = true);
  }

  void hideLoading() {
    if (_isLoading) setState(() => _isLoading = false);
  }

  void showMessageLoading({String? message}) {
    setState(() {
      _message = message ?? context.tr(LocalizationKeys.plzWait);
      _isLoadingWithMessage = true;
    });
  }

  void hideMessageLoading() {
    if (_isLoadingWithMessage) setState(() => _isLoadingWithMessage = false);
  }

  void hideAnyLoading() {
    hideLoading();
    hideMessageLoading();
  }

  Widget loadingManagerWidget() {
    if (_isLoading) return FullScreenLoaderWidget.onlyAnimation();
    if (_isLoadingWithMessage) {
      return FullScreenLoaderWidget.message(_message!);
    }
    return getEmptyWidget();
  }
}
```

- [ ] **Step 2: Rewrite `lib/core/widgets/base_stateful_screen_widget.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/core/loading_manager.dart';
import 'package:flutter_starter_kit/utils/connectivity/connectivity_listener_widget.dart';

/// Base for full screens. Stacks the screen content with a loading overlay
/// (via [LoadingManager]) and an offline/connectivity banner — so every screen
/// gets these for free. Implement [baseScreenBuild] in the state subclass.
abstract class BaseStatefulScreenWidget extends StatefulWidget {
  const BaseStatefulScreenWidget({super.key});
}

abstract class BaseScreenState<W extends BaseStatefulScreenWidget>
    extends State<W> with LoadingManager<W> {
  Widget baseScreenBuild(BuildContext context);

  double? get connectivityStart => 20;
  double? get connectivityEnd => 20;
  double? get connectivityTop => null;
  double? get connectivityBottom => 100;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        fit: StackFit.expand,
        children: [
          baseScreenBuild(context),
          loadingManagerWidget(),
          PositionedDirectional(
            start: connectivityStart,
            end: connectivityEnd,
            top: connectivityTop,
            bottom: connectivityBottom,
            child: const ConnectivityListenerWidget(),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 3: Verify**

Run: `flutter analyze`
Expected: `No issues found!` (the old mixin files still exist and are now unused; they are deleted in Task 5.)

- [ ] **Step 4: Commit**

```bash
git add lib/core/loading_manager.dart lib/core/widgets/base_stateful_screen_widget.dart
git commit -m "refactor: simplify LoadingManager and screen base to use context extensions"
```

---

## Task 3: Migrate onboarding off BaseStatelessWidget

**Files:**
- Modify: `lib/feature/on_boarding/widgets/onboarding_screen.dart`

- [ ] **Step 1: Rewrite `onboarding_screen.dart` as a plain StatelessWidget**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_starter_kit/core/extensions/context_extensions.dart';
import 'package:flutter_starter_kit/utils/locale/app_localization_keys.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr(LocalizationKeys.languageValue)),
        backgroundColor: context
            .theme.textButtonTheme.style?.backgroundColor
            ?.resolve({}),
      ),
      body: Center(
        child: SizedBox(
          width: 90.h,
          height: 90.w,
          child: Text(context.tr(LocalizationKeys.account)),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Verify**

Run: `flutter analyze`
Expected: `No issues found!` (`BaseStatelessWidget` is now unused; deleted in Task 5.)

- [ ] **Step 3: Commit**

```bash
git add lib/feature/on_boarding/widgets/onboarding_screen.dart
git commit -m "refactor: convert OnboardingScreen to a stateless widget using extensions"
```

---

## Task 4: Fix ConnectivityListenerWidget

**Files:**
- Modify: `lib/utils/connectivity/connectivity_listener_widget.dart`

- [ ] **Step 1: Replace the `Translator` mixin usage**

Change the state class declaration from:
```dart
class _ConnectivityListenerWidgetState extends State<ConnectivityListenerWidget>
    with Translator, SingleTickerProviderStateMixin {
```
to:
```dart
class _ConnectivityListenerWidgetState extends State<ConnectivityListenerWidget>
    with SingleTickerProviderStateMixin {
```

Remove the import line `import 'package:flutter_starter_kit/core/translator.dart';`
and add `import 'package:flutter_starter_kit/core/extensions/context_extensions.dart';`

In `build`, remove the line `initTranslator(context);`.

Update the two message helpers to use `context.tr`:
```dart
  String _notConnectedMsg() =>
      widget.notConnectedMessage ??
      context.tr(LocalizationKeys.noInternetConnection);

  String _connectedMsg() =>
      widget.connectedMessage ?? context.tr(LocalizationKeys.connectionRestored);
```

- [ ] **Step 2: Fix the connectivity stream typing/cast bug**

Change the field declaration from:
```dart
  late StreamSubscription<ConnectivityResult> _connectivityStream;
```
to:
```dart
  late StreamSubscription<List<ConnectivityResult>> _connectivityStream;
```

Replace the whole `_startConnectivityListener` method body with a correctly-typed
listener (`connectivity_plus` 6.x emits `List<ConnectivityResult>`):

```dart
  void _startConnectivityListener() {
    final connectivity = Connectivity();
    _connectivityStream = connectivity.onConnectivityChanged.listen((results) {
      final result = results.isEmpty ? ConnectivityResult.none : results.first;
      switch (result) {
        case ConnectivityResult.wifi:
          Developer.developerLog('connected through wifi');
          connectivityData.connectivityType =
              ConnectivityType.connectedThrowWifi;
        case ConnectivityResult.mobile:
          Developer.developerLog('connected through mobile');
          connectivityData.connectivityType =
              ConnectivityType.connectedThrowMobile;
        default:
          Developer.developerLog('not connected');
          connectivityData.connectivityType = ConnectivityType.notConnected;
      }
    });
  }
```

- [ ] **Step 3: Verify**

Run: `flutter analyze`
Expected: `No issues found!`

Run: `flutter test`
Expected: existing 13 tests still pass.

- [ ] **Step 4: Commit**

```bash
git add lib/utils/connectivity/connectivity_listener_widget.dart
git commit -m "fix: correct connectivity stream typing and use context.tr"
```

---

## Task 5: Remove dead base widgets and mixins

**Files:**
- Delete: `lib/core/widgets/base_stateless_widget.dart`
- Delete: `lib/core/widgets/base_stateful_widget.dart`
- Delete: `lib/core/screen_sizer.dart`
- Delete: `lib/core/themer.dart`
- Delete: `lib/core/translator.dart`
- Delete: `lib/core/platform_manager.dart`

- [ ] **Step 1: Confirm nothing imports the files to delete**

Run:
```bash
grep -rn "base_stateless_widget\|base_stateful_widget\b\|core/screen_sizer\|core/themer\|core/translator\|core/platform_manager\|with Translator\|with ScreenSizer\|with Themer\|with PlatformManager\|BaseStatelessWidget" lib | grep -v "base_stateful_screen_widget"
```
Expected: no output (all consumers migrated in Tasks 2–4).

- [ ] **Step 2: Delete the files**

```bash
git rm lib/core/widgets/base_stateless_widget.dart \
       lib/core/widgets/base_stateful_widget.dart \
       lib/core/screen_sizer.dart \
       lib/core/themer.dart \
       lib/core/translator.dart \
       lib/core/platform_manager.dart
```

- [ ] **Step 3: Verify**

Run: `flutter analyze`
Expected: `No issues found!`

Run: `flutter test`
Expected: 13 tests pass.

- [ ] **Step 4: Commit**

```bash
git commit -m "refactor: remove BaseStatelessWidget and the helper mixins (now context extensions)"
```

---

## Task 6: PostDetailsView (pure content) + test (TDD)

**Files:**
- Create: `lib/feature/example_posts/presentation/screen/post_details_view.dart`
- Test: `test/feature/example_posts/post_details_view_test.dart`

- [ ] **Step 1: Write the failing test**

`test/feature/example_posts/post_details_view_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/feature/example_posts/data/models/post.dart';
import 'package:flutter_starter_kit/feature/example_posts/presentation/screen/post_details_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the post title and body', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PostDetailsView(
            post: Post(id: 1, title: 'My title', body: 'My body'),
          ),
        ),
      ),
    );

    expect(find.text('My title'), findsOneWidget);
    expect(find.text('My body'), findsOneWidget);
  });

  testWidgets('shows a fallback when the post is null', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: PostDetailsView(post: null)),
      ),
    );

    expect(find.text('Post not found'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/feature/example_posts/post_details_view_test.dart`
Expected: FAIL — `PostDetailsView` not defined.

- [ ] **Step 3: Implement `post_details_view.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/core/extensions/context_extensions.dart';
import 'package:flutter_starter_kit/feature/example_posts/data/models/post.dart';

/// Pure, framework-light content for the post details screen — kept separate
/// from the screen scaffold so it is trivial to test.
class PostDetailsView extends StatelessWidget {
  const PostDetailsView({super.key, required this.post});

  final Post? post;

  @override
  Widget build(BuildContext context) {
    final post = this.post;
    if (post == null) {
      return const Center(child: Text('Post not found'));
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(post.title, style: context.textTheme.titleLarge),
          const SizedBox(height: 12),
          Text(post.body),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/feature/example_posts/post_details_view_test.dart`
Expected: PASS (2 tests).

- [ ] **Step 5: Commit**

```bash
git add lib/feature/example_posts/presentation/screen/post_details_view.dart test/feature/example_posts/post_details_view_test.dart
git commit -m "feat: add testable PostDetailsView"
```

---

## Task 7: PostDetailsScreen (demonstrates the screen base)

**Files:**
- Create: `lib/feature/example_posts/presentation/screen/post_details_screen.dart`

- [ ] **Step 1: Create `post_details_screen.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/core/widgets/base_stateful_screen_widget.dart';
import 'package:flutter_starter_kit/feature/example_posts/data/models/post.dart';
import 'package:flutter_starter_kit/feature/example_posts/presentation/screen/post_details_view.dart';

/// Details screen for a single [Post]. Built on [BaseStatefulScreenWidget] to
/// demonstrate the shared screen base (loading overlay + connectivity banner).
class PostDetailsScreen extends BaseStatefulScreenWidget {
  const PostDetailsScreen({super.key, required this.post});

  final Post? post;

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends BaseScreenState<PostDetailsScreen> {
  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post')),
      body: PostDetailsView(post: widget.post),
    );
  }
}
```

- [ ] **Step 2: Verify**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add lib/feature/example_posts/presentation/screen/post_details_screen.dart
git commit -m "feat: add PostDetailsScreen built on the screen base"
```

---

## Task 8: go_router + navigation wiring

**Files:**
- Modify: `pubspec.yaml` (via tool)
- Create: `lib/core/router/app_routes.dart`
- Create: `lib/core/router/app_router.dart`
- Test: `test/core/router/app_router_test.dart`
- Modify: `lib/feature/example_posts/presentation/screen/posts_screen.dart`
- Modify: `lib/app.dart`

- [ ] **Step 1: Add go_router**

Run: `flutter pub add go_router`
Expected: `pubspec.yaml` gains `go_router`; `pub get` resolves.

- [ ] **Step 2: Create `lib/core/router/app_routes.dart`**

```dart
/// Centralized route paths and names. Reference these instead of string
/// literals when navigating.
abstract final class AppRoutes {
  static const posts = '/';
  static const postsName = 'posts';

  static const postDetails = '/posts/:id';
  static const postDetailsName = 'postDetails';

  static const onboarding = '/onboarding';
  static const onboardingName = 'onboarding';

  static String postDetailsPath(int id) => '/posts/$id';
}
```

- [ ] **Step 3: Create `lib/core/router/app_router.dart`**

```dart
import 'package:flutter_starter_kit/core/router/app_routes.dart';
import 'package:flutter_starter_kit/feature/example_posts/data/models/post.dart';
import 'package:flutter_starter_kit/feature/example_posts/presentation/screen/post_details_screen.dart';
import 'package:flutter_starter_kit/feature/example_posts/presentation/screen/posts_screen.dart';
import 'package:flutter_starter_kit/feature/on_boarding/widgets/onboarding_screen.dart';
import 'package:go_router/go_router.dart';

/// The single source of truth for app navigation.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.posts,
  routes: [
    GoRoute(
      path: AppRoutes.posts,
      name: AppRoutes.postsName,
      builder: (context, state) => const PostsScreen(),
    ),
    GoRoute(
      path: AppRoutes.postDetails,
      name: AppRoutes.postDetailsName,
      builder: (context, state) =>
          PostDetailsScreen(post: state.extra as Post?),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      name: AppRoutes.onboardingName,
      builder: (context, state) => const OnboardingScreen(),
    ),
  ],
);
```

- [ ] **Step 4: Write the router test**

`test/core/router/app_router_test.dart`:

```dart
import 'package:flutter_starter_kit/core/router/app_router.dart';
import 'package:flutter_starter_kit/core/router/app_routes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  test('router exposes the expected routes', () {
    final paths = appRouter.configuration.routes
        .whereType<GoRoute>()
        .map((r) => r.path)
        .toList();

    expect(paths, contains(AppRoutes.posts));
    expect(paths, contains(AppRoutes.postDetails));
    expect(paths, contains(AppRoutes.onboarding));
  });

  test('postDetailsPath builds the expected location', () {
    expect(AppRoutes.postDetailsPath(7), '/posts/7');
  });
}
```

- [ ] **Step 5: Run the router test**

Run: `flutter test test/core/router/app_router_test.dart`
Expected: PASS (2 tests).

- [ ] **Step 6: Wire navigation in `posts_screen.dart`**

Add the imports:
```dart
import 'package:go_router/go_router.dart';
import 'package:flutter_starter_kit/core/router/app_routes.dart';
```
(Place them in alphabetical order within the existing import block.)

Change the success-state `ListTile` to be tappable:
```dart
                  itemBuilder: (context, index) {
                    final post = state.posts[index];
                    return ListTile(
                      title: Text(post.title),
                      subtitle: Text(post.body),
                      onTap: () => context.push(
                        AppRoutes.postDetailsPath(post.id),
                        extra: post,
                      ),
                    );
                  },
```

- [ ] **Step 7: Switch `app.dart` to `MaterialApp.router`**

In `lib/app.dart`:
- Remove `import 'dart:io';` and the `PostsScreen` import.
- Add `import 'package:flutter_starter_kit/core/app_platform.dart';` and
  `import 'package:flutter_starter_kit/core/router/app_router.dart';`
- Replace `Platform.isAndroid` with `AppPlatform.isAndroid`.
- Replace the `MaterialApp(...)` widget with `MaterialApp.router(...)`: keep
  `onGenerateTitle`, `debugShowCheckedModeBanner`, `theme`, `darkTheme`,
  `themeMode`, `supportedLocales`, `localizationsDelegates`, `locale`; remove
  `routes` and `home`; add `routerConfig: appRouter`.

The resulting builder reads:
```dart
              builder: (context, child) => MaterialApp.router(
                onGenerateTitle: (BuildContext context) =>
                    AppLocalizations.of(
                      context,
                    )?.translate(LocalizationKeys.appName) ??
                    'Flutter Starter Kit',
                debugShowCheckedModeBanner: false,
                theme: AppTheme(state).themeDataLight,
                darkTheme: AppTheme(state).themeDataDark,
                themeMode: ThemeMode.light,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  DefaultCupertinoLocalizations.delegate,
                ],
                locale: state,
                routerConfig: appRouter,
              ),
```

- [ ] **Step 8: Verify**

Run: `dart format lib test`
Run: `flutter analyze`
Expected: `No issues found!`

Run: `flutter test`
Expected: all tests pass (17 total).

Run: `flutter build web`
Expected: build succeeds.

- [ ] **Step 9: Commit**

```bash
git add pubspec.yaml pubspec.lock lib/core/router test/core/router lib/feature/example_posts/presentation/screen/posts_screen.dart lib/app.dart
git commit -m "feat: add go_router navigation with post details route"
```

---

## Task 9: Update ARCHITECTURE.md

**Files:**
- Modify: `docs/ARCHITECTURE.md`

- [ ] **Step 1: Append a "Navigation" and "UI conventions" section to `docs/ARCHITECTURE.md`**

Add at the end of the file:

```markdown
## Navigation

Routing uses a single `GoRouter` in `lib/core/router/app_router.dart`. Route
paths/names live in `lib/core/router/app_routes.dart` — reference those, never
string literals. Navigate with `context.push(AppRoutes.postDetailsPath(id),
extra: post)` and read arguments via `state.extra`. `lib/app.dart` wires it with
`MaterialApp.router(routerConfig: appRouter)`.

## UI conventions

- Access sizing/theme/localization through `BuildContext` extensions
  (`context.screenWidth`, `context.theme`, `context.tr('key')`) — see
  `lib/core/extensions/context_extensions.dart`. Widgets stay stateless; no
  layout/theme state is cached on a widget.
- Platform checks use `AppPlatform` (`lib/core/app_platform.dart`).
- Full screens that need a loading overlay and an offline banner extend
  `BaseStatefulScreenWidget` and implement `baseScreenBuild` (call
  `showLoading()` / `hideLoading()` as needed). `PostDetailsScreen` is the
  reference example. Simple screens can be plain `StatelessWidget`s.
```

- [ ] **Step 2: Verify & commit**

Run: `flutter analyze`
Expected: `No issues found!`

```bash
git add docs/ARCHITECTURE.md
git commit -m "docs: document routing and UI conventions"
```

---

## Final verification

- [ ] `flutter analyze` → `No issues found!`
- [ ] `flutter test` → all pass (17: 13 existing + PostDetailsView 2 + router 2)
- [ ] `dart format --output=none --set-exit-if-changed .` → exits 0
- [ ] `flutter build web` → succeeds
- [ ] No `must_be_immutable` suppressions remain (`grep -rn "must_be_immutable" lib` → empty)
- [ ] App launches on the posts list; tapping a post opens its details (loading + connectivity base active)

## Integration

- [ ] Push branch and open a PR (per `CONTRIBUTING.md`).
- [ ] Confirm CI green, then merge to `main` (rebase for linear history).
