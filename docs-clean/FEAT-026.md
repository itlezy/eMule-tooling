---
id: FEAT-026
title: Shared startup cache with known.met lookup index and `sharedcache.dat`
status: In Progress
priority: Minor
category: feature
labels: [startup, sharing, performance, cache, filesystem]
milestone: ~
created: 2026-04-13
source: current workspace HEAD commits `1457365`, `acbb9b4`, `e59c8cb`
---

## Summary

This feature exists on the current app workspace HEAD but is not merged to `main`.

The implementation adds a disposable shared-file startup cache plus a known-file lookup
index so shared-directory startup can reuse previously verified inventory instead of
re-walking and linearly re-matching every file on every launch.

## Current Branch Status

Validated on current workspace HEAD:

- `1457365` — `FEAT-026 speed up shared startup with known.met index and shared cache`
- `acbb9b4` — `FEAT-026 harden shared startup cache validation and mounted volumes`
- `e59c8cb` — `FEAT-026 make shared startup cache actually fast`

Backlog status stays **In Progress** until this lands on `main`.

## Implemented Shape On Workspace HEAD

Primary files:

- `srchybrid/KnownFileLookupIndex.h`
- `srchybrid/SharedStartupCachePolicy.h`
- `srchybrid/SharedFileList.cpp/.h`
- `srchybrid/KnownFileList.cpp/.h`
- `srchybrid/LongPathSeams.h`

Key flow in `SharedFileList`:

- `TryLoadStartupCache()`
- `FindSharedFiles(bool bAllowStartupCache)`
- `TryRehydrateSharedDirectoryFromCache(...)`
- `SaveStartupCache()`

## Implemented Behavior

The workspace-head implementation adds:

- `sharedcache.dat` as a config-directory sidecar cache
- a collision-preserving `KnownFileLookupIndex` keyed by filename/date/size tuples
- cached per-directory file inventories for explicit shared directories
- generic verification fallback when cached state is doubtful
- an NTFS journal fast path when the cached volume guard still matches
- mounted-volume and filesystem-identity validation before trusting cached state
- cache persistence only when the directory snapshot is stable enough to reuse

The cache is intentionally disposable. Any structural mismatch, lookup miss, or
filesystem-validation doubt falls back to the normal rescan path.

## Why This Is Separate From Mainline

The current `docs-clean` contract treats **Done** as "verified in `main`." That is not
true yet for this slice.

At the time of revalidation:

- `main` points to `021cb5b`
- current workspace HEAD points to `e1ecdee`
- FEAT-026 is present only on the workspace feature line

## Merge Readiness Focus

Before this can close as **Done**, the merge review should focus on:

- correctness of cache invalidation and fallback
- mounted-volume / NTFS journal guard behavior
- startup perf benefit on large shared directories
- no false reuse when directory contents changed
- no interaction regressions with share-ignore and long-path behavior

## Latest Measured Status (2026-04-18)

Fresh `eMule-main` startup profiling still indicates that the dominant remaining heavy
shared-tree delay is in the hash pipeline rather than shared-files window creation.

From
`EMULE_WORKSPACE_ROOT\repos\eMule-build-tests\reports\startup-profile-scenarios\20260418-121956-eMule-main-debug\startup-profiles-wrapper-summary.json`:

- `shared_files_ready_absolute_ms = 29360.160`
- `shared.scan.complete = 963.106 ms`
- `CSharedFilesWnd::OnInitDialog total = 139.524 ms`
- top `shared.hash.file.queue_wait(...)` spans were about `28164.869 ms`,
  `27845.748 ms`, and `27634.356 ms`

Current read: when FEAT-026 is revalidated for merge, the most important remaining
heavy-startup question is hash queue wait in the shared-file pipeline, not shared-files
page construction. See **FEAT-027** for the broader startup/shutdown profiling summary.

## Relationship To Other Items

- pairs naturally with **FEAT-027**, which cleans up startup sequencing around the same path
- overlaps **FEAT-024** share-ignore behavior because cached inventories must preserve the same share/no-share decisions
