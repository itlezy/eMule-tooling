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

## Relationship To Other Items

- depends on the same startup/share surface as **FEAT-026**
- likely makes a future fix for **BUG-023** easier by giving the shared-files UI a more explicit status-refresh path
