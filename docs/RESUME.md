# Session Resume

This file is the session-termination handoff for the canonical eMule
workspace. Update it only when ending a work session or when the user
explicitly asks for a current handoff. Do not use it for mid-task planning.
This file is not policy, not backlog authority, and not a substitute for
`EMULE_WORKSPACE_ROOT\repos\eMule-tooling\docs\WORKSPACE_POLICY.md`.

## Current State

- Date: 2026-05-02.
- Active app worktree: `%EMULE_WORKSPACE_ROOT%\workspaces\v0.72a\app\eMule-main`
  on `main`.
- Supporting repos checked this session:
  - `%EMULE_WORKSPACE_ROOT%\repos\eMule-tooling` on `main`
  - `%EMULE_WORKSPACE_ROOT%\repos\eMule-build-tests` on `main`
- All checked active repos are clean on `main...origin/main`.
- Latest tooling commit:
  `f1de5c8 FEAT-050 track completion command automation`.
- Latest app commits:
  - `1db8f7c FEAT-050 keep completion command seam standalone`
  - `6854c1d FEAT-050 launch completion command after retained file`
  - `b6ce2ef FEAT-050 add completion command preferences`
- Latest tests commit:
  `db45066 FEAT-050 cover completion command seams`.

## Completed This Session

- Added `FEAT-050` backlog tracking for a qBittorrent-style command/program
  launch after file completion.
- Implemented disabled-by-default Files preferences:
  - `RunCommandOnFileCompletion`
  - `FileCompletionProgram`
  - `FileCompletionArguments`
- Implemented program-plus-arguments command shape with direct `CreateProcess`
  launch, no shell.
- Restricted configured completion programs to `.exe` and `.com`.
- Hooked launch only after successful retained file completion, after the
  existing completion notification and collection handling.
- Skipped duplicate-discard, failed completion, disabled option, unsupported
  executable extension, and app-shutdown cases.
- Added supported argument tokens:
  - `%F` completed full file path, auto-quoted
  - `%D` completed directory, auto-quoted
  - `%N` completed file name
  - `%H` lowercase file hash
  - `%S` file size in bytes
  - `%C` category name
- Added seam coverage for launch request construction, token expansion, path
  quoting, skip conditions, and executable extension filtering.

## Validation References

Recent completed validation from this session:

- `repos\eMule-build\workspace.ps1 validate` passed after final commits.
- `repos\eMule-build\workspace.ps1 build-tests -Config Debug -Platform x64`
  passed.
- `repos\eMule-build\workspace.ps1 test -Config Debug -Platform x64
  -TestRunVariant main -BaselineVariant community` passed:
  - native parity: `475 passed`, `72 skipped`
  - live-diff completed with existing warning-style case-set mismatch messages
    and exit code `0`
- App Debug x64 builds passed during the FEAT-050 UI and runtime hook slices.
- Final post-commit app rebuild attempt hit `LNK1168` because the Debug
  `emule.exe` was still running from
  `%EMULE_WORKSPACE_ROOT%\workspaces\v0.72a\app\eMule-main\srchybrid\x64\Debug\emule.exe`
  as process `12888` at the time of handoff.

## Next Steps

- Read `repos\eMule-tooling\docs\WORKSPACE_POLICY.md` before the next
  workspace task.
- Use `repos\eMule-build\workspace.ps1` or `workspace.cmd` for build,
  validation, test, and live commands.
- Do not run direct MSBuild from app worktrees or test repos.
- Before rebuilding the app, close the running Debug `emule.exe` process that
  is locking the output binary, then rerun:
  `repos\eMule-build\workspace.ps1 build-app -Config Debug -Platform x64
  -AppVariant main`.
- Good next implementation focus: continue release stabilization around REST
  completeness, live E2E/UI coverage, and broadband release hardening.
