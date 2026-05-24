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
