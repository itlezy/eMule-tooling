---
id: FEAT-033
title: Disk-space floor hardening and legacy import-flow retirement
status: Done
priority: Minor
category: feature
labels: [disk-space, file-handling, preferences, partfile, import-parts, hardening]
milestone: ~
created: 2026-04-20
source: current `main` local commit `e15e9f4`
---

## Summary

This work is already landed on the current local `main`.

`FEAT-033` bundled two narrow storage/persistence cleanup lines that fit the low-drift
branch goal well:

- harden disk-space protection by separating config/temp/incoming floors
- retire the old Import Parts / `PartFileConvert` flow that no longer fits the current
  persistence path

## Landed Mainline Shape

The landed `e15e9f4` slice does all of the following:

- `DownloadQueue.cpp` now derives protected-volume thresholds from config, temp, and
  incoming roles separately
- `DownloadQueue.cpp` now has `ForceSaveAllPartMetFilesForDiskSpace()` and
  `StopAllDownloadsForDiskSpace()` so a protected-volume breach can save state first and
  then stop all active downloads cleanly
- `Preferences.cpp` now persists `MinFreeDiskSpaceConfig`, `MinFreeDiskSpaceTemp`, and
  `MinFreeDiskSpaceIncoming`
- `PPgTweaks.cpp` now exposes separate Tweaks controls and labels for those three floors
- `PartFileConvert.cpp/.h` and the remaining Import Parts hooks were removed from the
  app build and UI path

## Why It Was Worth Bringing In

The previous single-floor approach was too coarse once config, temp, and incoming data
could sit on different volumes. The landed behavior is closer to what operators actually
need:

- protect the configuration volume from silent exhaustion
- protect temp volumes independently
- protect incoming/category volumes without forcing one global threshold

Retiring the legacy import flow also reduces one more stale file-handling path that no
longer matches the current persistence hardening direction.

## Acceptance Criteria

- [x] separate config/temp/incoming free-space floors exist in preferences
- [x] protected-volume checks aggregate those roles correctly
- [x] a protected-volume breach saves part metadata before stopping downloads
- [x] Tweaks exposes the separate storage-floor controls
- [x] the legacy Import Parts / `PartFileConvert` flow is removed
