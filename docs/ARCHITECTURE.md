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
