# Session Resume

This file is the session-termination handoff for the canonical eMule
workspace. Update it only when ending a work session or when the user
explicitly asks for a current handoff. Do not use it for mid-task planning.

## Current State

- Date: 2026-04-26.
- Active app worktree: `workspaces\v0.72a\app\eMule-main` on `main`.
- Supporting repos checked this session: `repos\eMule-build-tests` and
  `repos\eMule-tooling` on `main`.
- All checked active repos are clean on `main...origin/main`.
- Latest app commit: `bb84294 FEAT-029 update reviewed preference defaults`.
- Latest tests commit: `f4c2ff2 CI-002 use LF for test source files`.
- Latest tooling commit:
  `f3f2f09 BUG-002 BUG-013 BUG-028 BUG-074 close retained legacy surfaces`.
- Release-closure backlog decisions recorded and pushed:
  - `BUG-002`, `BUG-013`, and `BUG-074` are Wont-Fix by product decision;
    archive preview/recovery is retained unchanged.
  - `BUG-028` is Wont-Fix by product decision; the retained `id3lib` fallback
    risk is accepted for Release 1.
- Current backlog non-done count is `62`.
- Proposed next slice is `BUG-023` Shared Files ED2K publish-state UI fix, with
  no new seams.

## Validation References

Recent completed validation from this session:

- `workspace.ps1 validate` passed.
- `workspace.ps1 build-tests -Config Release -Platform x64` passed.
- `workspace.ps1 test -Config Release -Platform x64` passed (`451 passed`,
  `70 skipped`).
- `workspace.ps1 build-app -Config Release -Platform x64` passed.
- `workspace.ps1 build-app -Config Debug -Platform x64` passed.
- Docs-only Wont-Fix closure validation passed:
  - source normalization check
  - Wont-Fix/index consistency check
  - `git diff --check`

## Next Steps

- Read `repos\eMule-tooling\docs\WORKSPACE_POLICY.md` before the next
  workspace task.
- Use `repos\eMule-build\workspace.ps1` or `workspace.cmd` for build,
  validation, test, and live commands.
- Do not run direct MSBuild from app worktrees or test repos.
- If continuing code work, implement `BUG-023` without new seams:
  - add a transient `CKnownFile` ED2K republish-pending flag
  - make `RepublishFile()` queue republish without flipping visible
    `PublishedED2K` to false
  - make `SendListToServer()` include pending files and clear pending state
    after successful packet inclusion
  - update docs after app validation
- Also clean stale triage in `docs-clean\INDEX.md`: `BUG-072` is already Done
  and should no longer appear in "Do First."
