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
