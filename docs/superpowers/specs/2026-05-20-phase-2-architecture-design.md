# Phase 2 — Routing & Base Widgets Design Spec

**Date:** 2026-05-20
**Project:** flutter_starter_kit
**Goal:** Give the base a clean navigation foundation (go_router) and fix/elevate
the shared widget bases so they are strong, in their best form, and actually
demonstrated — without over-engineering the demo screens.

**Builds on:** the foundation standards (PR #2). Follows the principles in
`CLAUDE.md` and the layering in `docs/ARCHITECTURE.md`.

---

## Context (why this scope)

- The app currently has almost no navigation (`routes: const {}`, a single
  `home:`, one `Navigator.pop`). go_router is introduced fresh, not migrated.
- `home/` and `on_boarding/` are demo UI screens with no data — forcing
  `data/presentation` layers on them would be over-engineering. They stay as-is.
- Shared widget bases are assessed as **base building blocks** (intentional
  foundation), not by current usage:
  - `BaseStatelessWidget` — anti-pattern (a `StatelessWidget` caching layout/
    theme/locale in mutable mixin fields → `must_be_immutable`). **Remove.**
  - `BaseStatefulScreenWidget` / `BaseScreenState` (+ `LoadingManager`) — a
    valuable base: every screen gets a full-screen loading overlay and an
    offline/connectivity banner for free. **Keep and improve.**
  - `ConnectivityListenerWidget` — valuable, but has a real bug (unsafe casts of
    the `connectivity_plus` stream). **Keep and fix.**

---

## 1. BuildContext extensions

New file `lib/core/extensions/context_extensions.dart` replaces the stateful
mixins (`ScreenSizer`, `Themer`, `Translator`) with extensions on `BuildContext`:

- **Sizing:** `screenWidth`, `screenHeight`, `orientation`, `isPortrait`,
  `isLandscape`, `isTablet` (`width >= 600`), `isDesktop` (`width >= 1000`).
- **Theme:** `theme`, `textTheme`, `colorScheme`.
- **Localization:** `tr(String key)` → `AppLocalizations.of(this)?.translate(key) ?? key`;
  `isRTL`.

Platform checks (`PlatformManager`) become a small static utility
`lib/core/app_platform.dart` (`AppPlatform.isAndroid`, `.isIOS`, `.isWeb`, …) —
they need no `BuildContext`.

The old mixin files (`screen_sizer.dart`, `themer.dart`, `translator.dart`,
`platform_manager.dart`) are removed once their consumers are migrated.

## 2. Base widget refactor

- **Remove** `BaseStatelessWidget`. Migrate `onboarding_screen.dart` to a plain
  `StatelessWidget` that uses the new context extensions; drop the
  `// ignore: must_be_immutable`.
- **Simplify** `BaseStatefulWidget` / `BaseState`: drop the mixin-init plumbing
  (no more `initTranslator/initScreenSizer/initThemer`); keep only the
  `baseBuild` convenience. Screens read helpers via context extensions.
- **Improve** `BaseStatefulScreenWidget` / `BaseScreenState` + `LoadingManager`:
  - Keep the value: a screen scaffold that stacks the screen content + a
    loading overlay + the connectivity banner.
  - Remove the awkward `provideTranslate()` / `runChangeState()` indirection;
    `LoadingManager` uses `setState` directly and `context.tr(...)` for the
    default "please wait" message.
  - Decouple from the removed mixins.
- **Fix** `ConnectivityListenerWidget`: the stream listener is currently cast
  unsafely (`... as void Function(List<ConnectivityResult>)?` /
  `as StreamSubscription<ConnectivityResult>`). `connectivity_plus` 6.x emits
  `List<ConnectivityResult>`. Type the subscription as
  `StreamSubscription<List<ConnectivityResult>>` and handle the list (treat
  "contains none / empty" as disconnected). Migrate its `Translator` mixin use
  to `context.tr(...)`.

## 3. go_router

- Add the `go_router` dependency.
- `lib/core/router/app_routes.dart` — path + name constants
  (`/onboarding`, `/` posts, `/posts/:id` post details).
- `lib/core/router/app_router.dart` — a single `GoRouter` (`appRouter`)
  exposing the routes; initial location is the posts list.
- `lib/app.dart` — switch `MaterialApp` → `MaterialApp.router(routerConfig: ...)`;
  remove `home:`/`routes:`.
- `PostDetailsScreen` (new, in `feature/example_posts/presentation/screen/`):
  receives a `Post` via the route and shows its title/body. `PostsScreen` list
  items navigate to it with `context.push('/posts/${post.id}', extra: post)`.

## 4. Demonstrate the base

To prove the base is real (not scaffolding) and to cover it with tests, the
`PostDetailsScreen` is built on `BaseStatefulScreenWidget`, so it exercises the
loading overlay + connectivity banner in a real screen.

## 5. Testing & verification

- Widget test: `PostDetailsScreen` renders a given `Post`'s title and body.
- Widget test: navigating from `PostsScreen` to details shows the post (using a
  test `GoRouter` / pumped router with a mocked repository so no network).
- Existing 13 tests keep passing.
- `flutter analyze` clean, `dart format` clean, `flutter test` green,
  `flutter build web` succeeds, CI green.

---

## Scope boundary

In scope: context extensions, base-widget refactor (remove `BaseStatelessWidget`,
simplify/keep the stateful bases, fix the connectivity cast bug), go_router with
a post-details route, and demonstrating the screen base.

Out of scope (later phases): flavors/environments and the `DioApiManager`
networking refactor (Phase 3), runtime dark mode (Phase 3), `freezed`/codegen,
forcing layers onto `home`/`on_boarding`, and `go_router_builder` (typed/codegen
routing).

## Success criteria

- No `must_be_immutable` suppressions remain; `flutter analyze` is clean.
- Screens access sizing/theme/translation via `context` extensions; no mutable
  state lives on a `StatelessWidget`.
- A real screen demonstrates the loading + connectivity base.
- Navigation works through `go_router`, including passing a `Post` to details.
- `docs/ARCHITECTURE.md` is updated with the routing pattern and the
  context-extensions / screen-base conventions.
