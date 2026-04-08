# eMule Workspace Policy

This document is the single source of truth for the canonical eMule workspace.

All workspace-wide directives should point here instead of restating policy in
repo-local docs.

## Workspace Roots

- Canonical workspace paths are expressed through `EMULE_WORKSPACE_ROOT`.
- Repos live under `EMULE_WORKSPACE_ROOT\repos\...`.
- App worktrees live under `EMULE_WORKSPACE_ROOT\workspaces\v0.72a\app\...`.
- Do not hardcode machine-specific absolute paths in workspace docs or scripts.

## Repo Roles

- `repos\eMule-tooling` owns shared workspace policy, helper docs, and
  engineering notes.
- `eMulebb-setup` owns workspace materialization and repo/worktree
  orchestration.
- `repos\eMule-build` and `repos\eMule-build-tests` own build, validation, and
  test orchestration.
- `repos\eMule` is the canonical app repo checkout used as the branch store and
  worktree anchor.
- Normal app editing belongs in the active app worktrees, not in the canonical
  `repos\eMule` checkout.

## Active Branch Model

### App Repo

- `main` is the only integration branch.
- Short-lived working branches should be cut from `main`.
- Recommended names:
  - `feature/<topic>`
  - `fix/<topic>`
  - `chore/<topic>`
- Release branches are downstream stabilization lines:
  - `release/v0.72a-build`
  - `release/v0.72a-bugfix`
  - `release/v0.72a-broadband`
- Promotion flows from reviewed commits already present on `main`.
- Do not start normal feature work directly on release branches.

### Supporting Repos

- The active branch for supporting repos is `main` unless a repo has an
  explicitly maintained branch documented by setup pins.
- No long-lived release branches are part of the active model for:
  - `eMule-build`
  - `eMule-build-tests`
  - `eMule-tooling`
  - `eMule-remote`

### `stale/*`

- `stale/*` branches are retired historical references only.
- Never use them as active development targets.
- Never use them as setup materialization targets.
- Never treat them as current validation baselines unless a task explicitly
  calls for historical comparison.

## Worktree Mapping

The canonical workspace currently materializes these app worktrees:

- `eMule-main` -> `main`
- `eMule-v0.72a-build` -> `release/v0.72a-build`
- `eMule-v0.72a-bugfix` -> `release/v0.72a-bugfix`

`release/v0.72a-broadband` is part of the active branch strategy but is not a
managed canonical worktree unless setup/build orchestration is explicitly
extended for it.

## Canonical App Checkout

- `repos\eMule` exists to hold history, remotes, and worktrees.
- It should be treated as the branch store and maintenance checkout.
- It is not the normal editing location for app work.
- The setup helper may leave it on a detached app-anchor commit; that is the
  intended neutral state.

## Merge and History Hygiene

- The default merge strategy back to `main` is squash merge.
- `main` history should stay curated and readable.
- Do not push `WIP`, checkpoint, or debug commits to `main`.
- One `main` commit should represent one coherent outcome.
- Direct commits to `main` are acceptable only for very small administrative or
  policy corrections.

## Setup and Dependency Authority

- `eMulebb-setup` owns materialization, managed app worktrees, and repo pinning.
- `repos.psd1` in `eMulebb-setup` is the source of truth for active dependency
  branches used by the canonical workspace.
- Repo-local docs must not redefine dependency pin authority or workspace
  topology.

## Active Build Policy

- Active compiler baseline for workspace-owned C++ builds is `C++17`
  (`LanguageStandard=stdcpp17`).
- Active MSVC toolset baseline is `v143`.
- Debug builds in the active matrix must use:
  - `RuntimeLibrary=MultiThreadedDebug`
  - `Optimization=Disabled`
- Release builds in the active matrix must use:
  - `RuntimeLibrary=MultiThreaded`
  - explicit speed-oriented optimization
  - `FunctionLevelLinking=true`
  - `IntrinsicFunctions=true` where the project compiles code directly
- This policy applies to active workspace targets:
  - `eMule-main`
  - `eMule-build-tests`
  - maintained dependency projects used by the canonical workspace build
- Frozen app branches are not normalization targets for routine build-policy
  cleanup.
- Project-specific exceptions are allowed when they are structural, not
  accidental:
  - C-only projects are not forced to declare a C++ language standard
  - utility wrappers like `zlib` and `mbedtls` inherit their compiler policy
    through wrapper/CMake orchestration
  - `cryptopp` toolset enforcement remains in workspace build orchestration to
    avoid unnecessary fork delta

## Tags

- Official releases should be marked with annotated tags on the chosen
  release-branch commit.
- Recommended tag families:
  - `v0.72a-build.N`
  - `v0.72a-bugfix.N`
  - `v0.72a-broadband.N`
