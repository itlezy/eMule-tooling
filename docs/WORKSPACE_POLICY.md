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
- `release/v0.72a-build` and `release/v0.72a-bugfix` are frozen historical
  stabilization lines.
- `oracle/v0.72a-build` is the sanctioned seam-enabled oracle branch derived
  from `release/v0.72a-build`.
- Small merge work on frozen release branches is allowed only to backport
  reviewed fixes or keep those branches buildable.
- Future release work should branch from reviewed commits already present on
  `main`.
- Release branches are downstream stabilization lines:
  - `release/v0.72a-build`
  - `release/v0.72a-bugfix`
  - `release/v0.72a-broadband`
- `release/v0.72a-broadband` is the intended next active release line when it
  is created.
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
- `eMule-v0.72a-oracle` -> `oracle/v0.72a-build`
- `eMule-v0.72a-build` -> `release/v0.72a-build`
- `eMule-v0.72a-bugfix` -> `release/v0.72a-bugfix`

`release/v0.72a-broadband` is part of the active branch strategy but is not a
managed canonical worktree unless setup/build orchestration is explicitly
extended for it.

## Canonical App Checkout

- `repos\eMule` exists to hold history, remotes, and worktrees.
- It should be treated as the branch store and maintenance checkout.
- It is not the normal editing location for app work.
- Its intended neutral state is detached `HEAD` at `origin/main`.
- The setup helper may leave it detached on that app-anchor commit; that is the
  correct state, not a problem to "fix" by checking out a local branch.

## Merge and History Hygiene

- The default merge strategy back to `main` is squash merge.
- `main` history should stay curated and readable.
- Do not push `WIP`, checkpoint, or debug commits to `main`.
- One `main` commit should represent one coherent outcome.
- Direct commits to `main` are acceptable only for very small administrative or
  policy corrections.

## Development Workflow

- Normal development starts from `main` on short-lived branches.
- Recommended branch families are:
  - `feature/<topic>` for new behavior
  - `fix/<topic>` for bug fixes
  - `chore/<topic>` for tooling, docs, or repo hygiene
- The normal path back to `main` is feature branch plus squash merge.
- One working branch should pursue one coherent outcome.
- Avoid mixing unrelated behavior changes, dependency churn, tooling churn, and
  large cleanup in one branch unless they are inseparable.
- Frozen release branches are not normal development targets.
- Frozen release branches may receive only selective backports from already
  reviewed work on `main`.

## Validation Expectations

- The default merge bar is scoped validation, not full-matrix validation for
  every change.
- Every development change should pass `validate`.
- After `validate`, run the smallest relevant build and test set for the area
  being changed.
- For feature and fix work on `main`, targeted regression checks are the
  default expectation.
- When a change affects observable behavior, compare `main` against
  `oracle/v0.72a-build` as the seam-enabled oracle baseline where the existing
  targeted test or live-diff flow makes that comparison meaningful.
- Full matrix validation is expected for:
  - build-system changes
  - dependency pin or dependency project changes
  - compiler or toolchain policy changes
  - broad integration changes that span multiple repos or architectures
- Docs-only or policy-only changes may use a lighter validation path when they
  do not alter the build contract.
- An exception to targeted regression work is acceptable only when the change
  has no meaningful runtime or observable behavior surface.
- Cleanliness checks like `check-clean-worktree.ps1` are appropriate for CI,
  release prep, or explicit hygiene passes, but are not the default requirement
  for every in-progress feature branch.

## Backport Rules

- `release/v0.72a-build` and `release/v0.72a-bugfix` are frozen maintenance
  lines.
- Acceptable backports are narrow and selective:
  - buildability fixes
  - important low-risk fixes
  - narrowly scoped release maintenance
- Unacceptable backports include:
  - normal feature work
  - broad refactors
  - speculative cleanup
  - changes that have not already been reviewed on `main`
- Prefer cherry-picks or tightly scoped merge work over branch drift.

## Oracle Branch Rules

- `oracle/v0.72a-build` is not a product release line and not a normal
  development target.
- The real product-history baseline remains `release/v0.72a-build`.
- `oracle/v0.72a-build` exists only to support targeted regression testing
  against a seam-enabled baseline derived from that release line.
- Allowed oracle changes are limited to:
  - test seams
  - deterministic probes or adapters
  - narrow logging or tracing needed by the test harness
- Oracle seams must be inert unless explicitly exercised by the test harness.
- Oracle changes must not alter normal runtime behavior, persistence semantics,
  network behavior, or default control flow relative to
  `release/v0.72a-build`.
- Oracle seams may lag `main`; backport only the minimal common seam surface
  required to compile and run the intended comparison tests.

## Setup and Dependency Authority

- `eMulebb-setup` owns materialization, managed app worktrees, and repo pinning.
- `repos.psd1` in `eMulebb-setup` is the source of truth for active dependency
  branches used by the canonical workspace.
- `repos\eMule-build` owns supported app-build orchestration and is required
  for canonical `emule.exe` builds.
- App worktrees do not by themselves define a complete supported app-build
  environment; dependency materialization and third-party build inputs are part
  of the `eMulebb-setup` plus `eMule-build` contract.
- Direct `msbuild` of `srchybrid\emule.vcxproj` from an app worktree is not the
  default supported validation path unless the `eMule-build` materialized build
  environment is already known to be active.
- If a direct app-project build fails because third-party headers or libraries
  are unresolved, report that the supported `eMule-build` path was bypassed
  rather than describing the workspace as generically missing materialization.
- Repo-local docs must not redefine dependency pin authority or workspace
  topology.

## Shared CI Policy

- Shared workspace policy audits live under `repos\eMule-tooling\ci\`.
- Routine `validate` in `repos\eMule-build` must run the active static audits:
  - build policy
  - branch policy
  - dependency pin policy
  - active documentation path policy
  - project entrypoint policy
  - warning policy
- `check-clean-worktree.ps1` is an explicit cleanliness guard for CI or
  pre-release verification; it is not part of routine `validate` because local
  feature work may legitimately leave tracked changes in progress.

## Documentation Discipline

- Workspace-wide development rules belong only in this document.
- Repo-local `AGENTS.md` files should stay thin and repo-specific.
- Repo-local docs must point to this policy rather than restating workspace
  branch, worktree, setup, or dependency authority.
- Use `EMULE_WORKSPACE_ROOT` style references instead of machine-specific
  absolute paths in active docs.
- Backlog and planning docs are not authoritative by themselves.
- Before implementing a backlog item, revalidate it against current `main`,
  current dependency pins, and the current workspace policy.

## File Normalization Policy

- Tracked text-file edits must honor the repo-local `.editorconfig` and
  `.gitattributes` rules of the repo being edited.
- Line endings, charset or BOM, trailing whitespace, and final-newline policy
  are part of the workspace contract, not optional editor preferences.
- Do not leave edited tracked files in mixed-EOL state.
- `repos\eMule-tooling\helpers\source-normalizer.py` is the canonical
  normalization helper for workspace-owned repos and app worktrees.
- `repos\eMule-tooling\helpers\install-editorconfig-hook.ps1` is the supported
  local hook installer for catching normalization drift before commit.
- Routine `validate` must fail when modified tracked files in workspace-owned
  repos or canonical app worktrees drift from their declared normalization
  policy.

## Active Build Policy

- Active compiler baseline for workspace-owned C++ builds is `C++17`
  (`LanguageStandard=stdcpp17`).
- Active MSVC toolset baseline is `v143`.
- The active workspace build matrix has no `Win32` target.
- Supported build architectures are:
  - `x64`
  - `ARM64`
- Debug builds in the active matrix must use:
  - `RuntimeLibrary=MultiThreadedDebug`
  - `Optimization=Disabled`
  - `IncrementalLink=true` for executable targets
  - `DebugInformationFormat=ProgramDatabase`
- Release builds in the active matrix must use:
  - `RuntimeLibrary=MultiThreaded`
  - explicit speed-oriented optimization
  - `FunctionLevelLinking=true`
  - `IntrinsicFunctions=true` where the project compiles code directly
  - `IncrementalLink=false` for executable targets
  - `LinkTimeCodeGeneration=UseLinkTimeCodeGeneration` for release app links
- Active compile targets should also declare:
  - `BufferSecurityCheck=true`
  - `MultiProcessorCompilation=true`
- This policy applies to active workspace targets:
  - `eMule-main`
  - `eMule-build-tests`
  - maintained dependency projects used by the canonical workspace build
- Shared test builds support `x64` and `ARM64`; test execution remains `x64`
  only.
- Frozen app branches are not normalization targets for routine build-policy
  cleanup.
- Project-specific exceptions are allowed when they are structural, not
  accidental:
  - C-only projects are not forced to declare a C++ language standard
  - utility wrappers like `zlib` and `mbedtls` inherit their compiler policy
    through wrapper/CMake orchestration
  - `cryptopp` toolset enforcement remains in workspace build orchestration to
    avoid unnecessary fork delta

## Implementation Discipline

- Put changes at the earliest layer where they are true, then let later layers
  inherit them.
- Prefer narrow, build-level fixes over source edits in third-party dependency
  forks when the issue is build policy, warning policy, or orchestration.
- Do not revive `stale/*` branches or historical workflows as active solutions.
- Do not reintroduce workspace orchestration, dependency pin policy, or branch
  policy into app-repo docs or ad hoc notes.
- Keep commits and reviewed outcomes behavior-focused and easy to explain.
- If an exception to these defaults is necessary, record it clearly in the
  change itself rather than relying on local habit.

## Tags

- Official releases should be marked with annotated tags on the chosen
  release-branch commit.
- Recommended tag families:
  - `v0.72a-build.N`
  - `v0.72a-bugfix.N`
  - `v0.72a-broadband.N`
