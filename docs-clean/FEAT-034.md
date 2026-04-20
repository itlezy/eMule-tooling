---
id: FEAT-034
title: Shared-files reload should stop blocking the UI on large trees
status: Open
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

`srchybrid/SharedFileList.cpp` still has this narrow shape today:

- clear keywords, queues, and transient lookup state
- call `FindSharedFiles(false)` directly from `Reload()`
- reload the output control only after the synchronous scan returns

So the expensive directory walk still happens on the immediate reload path.

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
- [ ] repeated reload requests coalesce instead of starting overlapping scans
- [ ] final shared-file results converge to the same set as the synchronous path
- [ ] uploads, share state, and GUI counters remain stable while scans finish in the background
- [ ] no always-on watcher or wider product drift is introduced
