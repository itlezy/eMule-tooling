---
id: FEAT-034
title: Shared-files reload should stop blocking the UI on large trees
status: In Progress
priority: Minor
category: feature
labels: [performance, shared-files, reload, threading, ui]
milestone: ~
created: 2026-04-20
source: current `main` revalidation; `analysis\emuleai` and Xtreme comparison; filtered web-demand scan
---

## Summary

Current `main` still handles `CSharedFileList::Reload()` synchronously. The current path
clears transient state and then immediately calls `FindSharedFiles(false)` on the caller
thread.

On large share trees, that remains a plausible UI-freeze path even after the startup and
Shared Files list improvements already landed under `FEAT-026`, `FEAT-027`, and
`FEAT-028`.

## Current Mainline Evidence

Before the first FEAT-034 slice, `srchybrid/SharedFileList.cpp` had this narrow shape:

- clear keywords, queues, and transient lookup state
- call `FindSharedFiles(false)` directly from `Reload()`
- reload the output control only after the synchronous scan returns

So the expensive directory walk still happens on the immediate reload path.

## Landed Scope

The first implementation slice landed on `main` on 2026-04-21:

- `f5da4c5` — app-lifetime shared-file hash worker replaces per-file shared hash threads
- `7f5b207` — full shared reloads are deferred/coalesced while shared hashing is active, Shared Files UI refresh is throttled during active hashing, and startup profiling now separates `ui.shared_files_ready` from `ui.shared_files_hashing_done`
- `0aaadbe` — shared reload deferral policy is exposed through seams for native tests
- `f138856` in `repos\eMule-build-tests` — native seam coverage and live-profile summary parsing were updated for the new readiness/hash-drain split

The follow-up hardening slice landed after review:

- `7cbad68` — startup-deferred Shared Files list reloads now stay pending while shared hashing is active and flush only after hash drain
- `85fcaf6` — the shared hash worker waits for the UI thread to consume each posted completion before starting the next job
- `ff254ab` — shared hash completion posting retries while the UI is still alive before discarding a result during shutdown/error paths
- `67d85de` and `306bb63` in `repos\eMule-build-tests` — native seam coverage for the deferred-list reload gate and worker backpressure
- `f711688` in `repos\eMule-build-tests` — live startup-profile coverage now fails if the Shared Files list rebuilds repeatedly during hash drain

The targeted long-path recursive live scenario now shows one final coalesced list rebuild during shared hash drain instead of repeated periodic reloads. This reduces the startup and reload churn caused by hash-thread creation and repeated list rebuilds. It does **not** yet move the directory enumeration pass itself fully off the UI thread, so this item remains `In Progress` rather than `Done`.

## Comparison Notes

- `analysis\emuleai` keeps a dedicated search worker thread alive and resets/coalesces
  work on reload
- the focused Xtreme archive also shows a long-standing off-thread/shared-scan direction

That does not mean the branch should import their broader watcher/thread model. It does
mean there is a proven low-level path to avoid blocking the UI during manual reloads.

## Scope Constraints

This item stays intentionally narrow:

- target manual reloads and similar explicit shared-tree rescans
- allow a bounded worker or coalesced background scan
- do not add always-on filesystem watching
- do not change share policy, duplicate policy, or startup cache ownership
- keep behavior close to stock outside responsiveness improvements

## Web-Demand Fit

Recent web signals still point much more strongly toward remote control/API work and
networking friendliness than toward large new product features. Performance pain around
big queues and big trees remains a recurring complaint, but not one that justifies a big
subsystem rewrite on this branch.

That is why `FEAT-034` is kept as a small, low-priority responsiveness item rather than a
broader `eMuleAI` shared-files feature import.

## Acceptance Criteria

- [ ] manual shared-files reload returns control quickly on large trees
- [x] repeated reload requests coalesce instead of starting overlapping scans while hashing is active
- [x] targeted long-path live profile converges to the expected final visible Shared Files rows after hash drain
- [ ] general final shared-file results converge to the same set as the synchronous path across broader reload scenarios
- [x] uploads, share state, and GUI counters remain stable while shared hashes drain in the background
- [x] no always-on watcher or wider product drift is introduced
