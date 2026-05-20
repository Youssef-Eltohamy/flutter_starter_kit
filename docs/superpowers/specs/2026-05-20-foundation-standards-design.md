# Foundation Standards — Design Spec

**Date:** 2026-05-20
**Project:** flutter_starter_kit
**Goal:** Establish the engineering principles, conventions, and lightweight
guardrails that keep this base project **strong, solid, and simple — not
complex** — before broader architecture work (Phase 2) begins.

**Audience:** Public / community (GitHub). Documentation and examples must be
clear enough for any developer to adopt the base confidently.

---

## 1. Engineering Principles (the philosophy)

Every code decision must pass these nine rules:

1. **Simplicity first (KISS / YAGNI).** Add abstraction only when a real, present
   need exists — never speculative generality.
2. **Rule of two uses.** Do not generalize or extract until something has
   genuinely repeated twice.
3. **Clarity over cleverness.** Code reads top-to-bottom with obvious names; no
   obscure tricks.
4. **Small, focused units.** One file/class = one purpose. A growing file is a
   signal it does too much.
5. **Consistency.** One way to do common things; follow the established pattern
   everywhere.
6. **Safe errors.** Operations that can fail return `Either<Failure, T>` — fail
   loudly in debug, gracefully in production.
7. **Everything testable.** Business logic is separated from the framework so it
   can be unit-tested without a widget tree.
8. **Dependencies are liabilities.** Every package must be justified; keep the
   dependency list lean.
9. **Documented at the entry points.** Each feature and public API carries a
   short explanation of what it does and how to use it.

---

## 2. Architecture & Conventions (practical, balanced)

A light but clear layering per feature. **Not** full Clean Architecture for
every feature — the domain layer is optional.

```
lib/feature/<name>/
├── data/            # repository (+ models, data source when needed)
├── presentation/    # cubit|bloc + state + screens + widgets
└── domain/          # OPTIONAL: usecases/entities — only when logic is
                     #   non-trivial or shared across features
```

**Decision rules (these are what prevent over-engineering):**

- **Cubit by default** (simpler). Use **Bloc** only when discrete events or
  stream transformations genuinely justify it.
- **Domain layer is optional.** Add `domain/` (usecases/entities) only when the
  business logic is non-trivial or shared. Simple features go straight from
  repository → cubit.
- **All network access flows through repositories**, which return
  `Either<Failure, T>`.
- **Dependency injection** is centralized in a single `injection.dart`, removed
  from `main.dart`.
- **Unify the UseCase abstraction.** `core/usecase.dart` currently defines two
  conflicting contracts (`BaseUseCase` and `UseCase`); collapse to one used by
  the optional domain layer.

**Naming & files:**
- `snake_case` file and folder names; `UpperCamelCase` types; descriptive names.
- One public class per file where practical.
- Reusable cross-feature code lives in `core/` (framework building blocks) or
  `utils/` (helpers); feature-specific code stays in the feature.

**Reference example feature:** a small, real `example` feature shipping in the
repo that demonstrates the full pattern end-to-end (repository →
`Either<Failure, T>` → cubit + state → screen, with a unit test for the cubit
and the repository). This is the canonical thing contributors copy.

---

## 3. Artifacts & Guardrails

### Documentation
| File | Purpose |
|---|---|
| `CLAUDE.md` | Concise: principles + simplicity rules + common commands + links to the other docs. Guides both Claude and human contributors. |
| `docs/ARCHITECTURE.md` | The layering in detail, a walkthrough of the reference example feature, and the decision rules (when to add `domain/`, Cubit vs Bloc). |
| `CONTRIBUTING.md` | Workflow: PR-per-change, branch/commit naming, the "analyze clean + tests pass" gate, and step-by-step "how to add a feature". |

### Tooling (enforces the principles automatically)
- **`analysis_options.yaml`** — a curated, pragmatic stricter rule set (NOT a
  maximalist pack), aligned with simplicity. Candidate rules:
  `prefer_single_quotes`, `require_trailing_commas`, `always_declare_return_types`,
  `avoid_print`, `prefer_final_locals`, `directives_ordering`,
  `unawaited_futures`. Tuned so it does not fight the existing code style.
- **`.editorconfig`** — consistent indentation, charset, and final-newline rules
  across editors.
- **`.github/workflows/ci.yml`** — lightweight CI on push/PR:
  `dart format --set-exit-if-changed`, `flutter analyze`, `flutter test`.
- **`.github/PULL_REQUEST_TEMPLATE.md`** + issue templates — appropriate for a
  public repo.

---

## 4. Scope Boundary

This effort **defines, documents, and enforces** the foundation and ships **one
small reference example feature**. It deliberately does **not** include:

- Migrating all existing features into the new layering (Phase 2).
- Adopting `go_router` and the full DI reorganization beyond what the example
  needs (Phase 2).
- Flavors/environments, the Dio singleton fix, runtime dark mode (Phase 3).
- Expanding the test suite broadly (Phase 4) — only the example's tests here.

Decisions confirmed with the user:
- Architecture depth: **practical/balanced**, domain layer **optional**.
- Deliverable form: **docs + lightweight enforcing tooling**.
- Audience: **public**, so docs/examples are first-class.
- CI is included **now** as the enforcement mechanism (overlaps Phase 4 by
  design).

---

## 5. Success Criteria

- A new contributor can read `CLAUDE.md` + `docs/ARCHITECTURE.md` and add a
  feature by copying the reference example, without guessing conventions.
- `flutter analyze` stays clean and `flutter test` passes under the new, stricter
  `analysis_options.yaml`.
- CI runs format + analyze + test on every PR and blocks regressions.
- Nothing in the foundation introduces an abstraction without a present use
  (principle #1/#2 hold for the foundation itself).
