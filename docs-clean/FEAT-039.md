---
id: FEAT-039
title: Download checker — duplicate and near-duplicate intake guard
status: Open
priority: Minor
category: feature
labels: [downloads, duplicates, file-handling, safety, blacklist, intake]
milestone: ~
created: 2026-04-20
source: eMuleAI release notes
---

## Summary

Add an intake-time checker that evaluates a new download against existing downloads,
history, and shared files before the item is accepted.

The intent is to catch obvious duplicates, suspicious near-duplicates, and repeated junk
before they clutter the queue.

## Intended Mainline Shape

- compare new downloads against current downloads, known history, and shared inventory
- detect exact duplicates first and optionally warn or reject
- allow looser near-duplicate heuristics as an advanced mode
- optionally auto-blacklist or auto-hide clearly bad repeat items
- present the result as a user-facing decision rather than silently overriding everything

## Why Add It

This is a file-handling convenience feature with real operator value on long-running nodes:

- fewer accidental duplicate downloads
- less queue clutter
- less repeated junk from fake/spam-prone searches

## Scope Constraints

- exact-duplicate checks should be deterministic and cheap
- near-duplicate mode must stay optional because false positives are possible
- this feature should complement, not replace, the `KnownFileList` correctness fixes under
  `BUG-037`

## Acceptance Criteria

- [ ] exact duplicates can be detected before a new download is added
- [ ] operators can choose warn/reject/allow behavior
- [ ] optional near-duplicate mode can be enabled separately
- [ ] clearly blacklisted repeat items can be filtered automatically when configured
- [ ] no regression for normal add-download flows when the feature is disabled
