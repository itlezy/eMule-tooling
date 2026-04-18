---
id: FEAT-028
title: Virtualize and harden shared files list
status: Done
priority: Minor
category: feature
labels: [shared-files, ui, performance, startup, owner-data]
milestone: ~
created: 2026-04-18
source: `main` commit `fc70cf9` (`FEAT-028 virtualize and harden shared files list`)
---

## Summary

This feature is merged to `main`.

The Shared Files list now uses a virtual/owner-data model with an explicit visible-file
vector and index map instead of rebuilding and rewalking a fully materialized control on
every churn point.

This is the main stock-friendly response to the same general performance class that eMuleAI
addresses with broader large-list / owner-data work, but it stays narrowly focused on the
Shared Files surface.

## Landed Mainline Shape

Mainline commit:

- `fc70cf9` — `FEAT-028 virtualize and harden shared files list`

Primary files:

- `srchybrid/SharedFilesCtrl.cpp/.h`
- `srchybrid/SharedFilesWnd.cpp/.h`
- `srchybrid/SharedDirsTreeCtrl.cpp/.h`
- `srchybrid/SharedFileList.cpp/.h`
- `srchybrid/MuleListCtrl.cpp/.h`

## Implemented Behavior

The landed slice adds:

- owner-data Shared Files rows
- explicit visible-row bookkeeping through `m_aVisibleFiles` and
  `m_mapVisibleFileIndex`
- `OnLvnGetDispInfo`-driven row materialization instead of permanent row payload storage
- coalesced reload behavior for startup-deferred hash intake
- guarded selection, focus, top-index, and horizontal-scroll restore across reloads
- safer shared-files list removal/update ordering against live UI callbacks

## Why This Is Separate From FEAT-026 / FEAT-027

These items all touched the same general startup/share surface, but they solve different
problems:

- **FEAT-026**: cache reuse of verified shared-directory inventory
- **FEAT-027**: startup sequencing and profiling visibility
- **FEAT-028**: the visible Shared Files list control itself

Keeping FEAT-028 separate preserves a clear performance story for later review.

## Relationship To Existing Items

- FEAT-028 carried the landed mainline implementations of **FEAT-022** and most of the
  shared-startup-cache surface tracked under **FEAT-026**
- FEAT-028 reduced the likelihood of the older shared-files UI churn issues later called
  out in sibling trees
- FEAT-028 complements **BUG-023**, which remains a smaller publish-state correctness bug
  on the same overall surface
