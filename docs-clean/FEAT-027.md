---
id: FEAT-027
title: Startup sequencing fix, startup profiling, and shared-view startup churn cleanup
status: In Progress
priority: Minor
category: feature
labels: [startup, ui, profiling, sharing, performance]
milestone: ~
created: 2026-04-13
source: current workspace HEAD commit `e1ecdee`
---

## Summary

This feature exists on the current app workspace HEAD but is not merged to `main`.

It tightens the startup-stage handoff, adds optional startup profiling output, and
reduces path/UI churn around shared-files initialization so the FEAT-026 startup-cache
work can run on a cleaner startup surface.

## Current Branch Status

Validated on current workspace HEAD:

- `e1ecdee` — `FEAT-027 cut startup path churn and fix startup sequencing`

Backlog status remains **In Progress** until merged to `main`.

## Implemented Workspace-Head Changes

Primary files:

- `srchybrid/Emule.cpp/.h`
- `srchybrid/EmuleDlg.cpp/.h`
- `srchybrid/SharedFilesWnd.cpp/.h`
- `srchybrid/SharedFilesCtrl.cpp/.h`
- `srchybrid/UserMsgs.h`
- `srchybrid/LongPathSeams.h`

Visible implementation points:

- `UserMsgs.h` adds `UM_STARTUP_NEXT_STAGE`
- `CemuleDlg::OnStartupNextStage(...)` posts startup progression back through the UI message loop
- `Emule.cpp` writes `startup-profile.trace.json` in Chrome Trace Event format when startup profiling is enabled
- startup profiling is gated by the `EMULE_STARTUP_PROFILE` environment variable
- the trace now carries stable phase families for:
  - `ui.shared_files_ready` readiness milestones
  - `CStatisticsDlg::OnInitDialog ...` internal page-construction spans
  - `shared.hash.file.queue_wait` and `shared.hash.file.run` per-file hashing spans
  - `broadband.*` constructor and thread-readiness lifecycle events
- `SharedFilesWnd` now has `EnsureSharedTreeInitialized()`
- `SharedFilesWnd` also gains `OnVolumesChanged()` and `OnSingleFileShareStatusChanged()`

## Why This Exists

The old startup path chained more work through timer-driven sequencing and repeated
shared-view/path setup than necessary. The workspace-head slice makes that progression
more explicit and adds a lightweight profiling surface for measuring startup stages in
the active config directory.

## Mainline Status Boundary

At revalidation time:

- `main` does not contain this slice
- current workspace HEAD does contain it

That is why this stays **In Progress** in the clean backlog even though the code is
already present in the active worktree.

## Validation Focus Before Merge

- startup stage progression should not stall or double-run
- `startup-profile.trace.json` generation should remain optional and low-risk
- shared-files tree initialization should stay stable on fresh and warm starts
- shared-volume/share-status notifications should not regress existing UI refresh paths

## Latest Profiling Conclusions (2026-04-18)

Current evidence for future merge and follow-up work:

- startup matrix artifact:
  `EMULE_WORKSPACE_ROOT\repos\eMule-build-tests\reports\startup-profile-scenarios\20260418-121956-eMule-main-debug\startup-profiles-wrapper-summary.json`
- focused shutdown probe:
  `EMULE_WORKSPACE_ROOT\scratch\shutdown-probe-20260418-122546-profiling\summary.json`
- repeated shutdown variance probe:
  `EMULE_WORKSPACE_ROOT\scratch\shutdown-repeat-20260418-122927\summary.json`

Baseline `eMule-main` Debug startup with no shared files is still mostly UI/page
construction cost:

- `startup_complete_absolute_ms = 793.610`
- `shared_files_ready_absolute_ms = 793.678`
- `CemuleDlg::OnInitDialog complete = 623.326 ms`
- `child page creation total = 538.218 ms`
- `create statistics window = 138.444 ms`
- `CStatisticsDlg::OnInitDialog total = 133.474 ms`
- `create transfer window = 75.383 ms`

Current read: on the light profile, the main remaining startup cost is still eager
child-page construction, with `Statistics` the largest single page.

The heavy recursive long-path startup case is not page-creation bound:

- `shared_files_ready_absolute_ms = 29360.160`
- `shared_files_ready_after_startup_complete_ms = 27654.642`
- `shared.scan.complete = 963.106 ms`
- `CSharedFilesWnd::OnInitDialog total = 139.524 ms`
- top `shared.hash.file.queue_wait(...)` spans were about `28164.869 ms`,
  `27845.748 ms`, and `27634.356 ms`

Current read: the dominant remaining startup cost on heavy shared trees is
`shared.hash.file.queue_wait`, not shared-files page creation.

Shutdown measurements are split between visible UI handoff and final process exit:

- repeated baseline process-exit observation averaged `8566.246 ms`
- repeated heavy process-exit observation averaged `9042.636 ms`
- main-window disappearance averaged `254.555 ms` baseline and `252.291 ms` heavy
- focused heavy shutdown probe reached "no windows left" at `3530.240 ms`
  after close

Current read: visible shutdown UI clears in about `3.0-3.5 s`, but full teardown
still lands closer to `8.4-9.4 s`. Heavy shared trees add only modest extra shutdown
time versus baseline, so the dominant remaining shutdown cost appears to be common
post-UI teardown rather than shared-tree-specific window work.

## Relationship To Other Items

- depends on the same startup/share surface as **FEAT-026**
- likely makes a future fix for **BUG-023** easier by giving the shared-files UI a more explicit status-refresh path
