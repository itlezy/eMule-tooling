---
id: FEAT-038
title: Shared-files watcher and live recursive share sync
status: Open
priority: Minor
category: feature
labels: [shared-files, watcher, filesystem, auto-share, live-sync, performance]
milestone: ~
created: 2026-04-20
source: eMuleAI release notes
---

## Summary

Move beyond manual reloads by adding filesystem-watcher-driven synchronization for shared
folders, including recursive subdirectory handling.

This is a higher-drift follow-up to `FEAT-034`. `FEAT-034` keeps the manual reload path from
freezing the UI; `FEAT-038` goes further by keeping the shared view current without needing
a full reload most of the time.

## Intended Mainline Shape

- watch configured shared roots using OS filesystem notifications
- detect adds, removals, and renames incrementally
- optionally auto-share subdirectories under selected roots
- coalesce bursts of watcher events into bounded background processing
- fall back to explicit reload when events are lost or a full rescan is safer

## Why Add It

This directly improves large-library usability:

- fewer slow full rescans
- fewer stale shared-file views after external file moves
- better fit for users who maintain large incoming/archive trees outside the app

## Scope Constraints

- keep the feature configurable because some network filesystems behave badly with watchers
- do not force automatic recursive sharing on everyone
- coordinate with `FEAT-028` and `FEAT-034` rather than reintroducing unstable shared-list
  behavior

## Acceptance Criteria

- [ ] shared-folder adds/removes/renames are detected without a full manual reload
- [ ] recursive subdirectory behavior is configurable
- [ ] event bursts are coalesced and processed off the UI thread
- [ ] fallback full reload remains available when watcher confidence is lost
- [ ] uploads and share-state accounting remain correct during live updates
