---
id: FEAT-029
title: Search result ceilings — configurable ed2k expansion plus moderate Kad totals/lifetimes
status: Done
priority: Minor
category: feature
labels: [search, ed2k, kad, preferences, ui, networking]
milestone: ~
created: 2026-04-18
source: current `main` search-limit review and implementation follow-up
---

## Summary

Current `main` still carries separate hard-coded search result ceilings outside the
modern-defaults work tracked in `FEAT-016`:

- ed2k/UI caps through `MAX_RESULTS` and `MAX_MORE_SEARCH_REQ`
- Kad stop criteria through `SEARCHFILE_TOTAL`, `SEARCHKEYWORD_TOTAL`, and the
  corresponding search lifetimes

`FEAT-029` expands those limits in a stock-preserving way while keeping the safety
shape intact:

- ed2k becomes configurable and effectively unlimited by default (`0 = unlimited`)
- Kad gets only a moderate configurable total/lifetime increase
- `Search More` stays manual
- Kad per-node request sizing and oversized-reply rejection stay unchanged

## Intended Mainline Shape

- New persisted settings:
  - `Ed2kSearchMaxResults`
  - `Ed2kSearchMaxMoreRequests`
  - `KadFileSearchTotal`
  - `KadKeywordSearchTotal`
  - `KadFileSearchLifetime`
  - `KadKeywordSearchLifetime`
- New Tweaks-tree Search group for editing those values
- ed2k result cancellation and More-button enablement routed through preferences
- Kad file/keyword stop criteria and stop-preparation lifetime routed through preferences

## Chosen Defaults

- `Ed2kSearchMaxResults = 0`
- `Ed2kSearchMaxMoreRequests = 0`
- `KadFileSearchTotal = 500`
- `KadKeywordSearchTotal = 500`
- `KadFileSearchLifetime = 60`
- `KadKeywordSearchLifetime = 60`

Validation bounds:

- ed2k limits: non-negative (`0 = unlimited`)
- Kad totals: `100..5000`
- Kad lifetimes: `30..180` seconds

## Scope Boundaries

Safe in this item:

- local ed2k result caps
- manual More-button request budget
- Kad file/keyword totals and lifetimes
- advanced-settings exposure for those limits

Out of scope:

- automatic repeated `Search More`
- Kad fanout changes
- Kad request-size changes
- Kad protocol or packet-format changes
- spam-filter or duplicate-merge redesign

## Reference Notes

- `FEAT-016` remains done and should stay closed.
- `eMuleAI` is only a useful reference for the ed2k `0 = unlimited` cap shape.
- eMuleAI does not provide a strong low-drift reference for broader Kad search
  expansion, so the Kad side stays intentionally moderate here.

## Mainline Outcome

Landed on `main` in commit `1dd710c`:

- persisted ed2k and Kad search ceiling settings in `Preferences`
- Tweaks-tree Search controls for the new limits
- ed2k result and `Search More` limits routed through preferences
- Kad file/keyword totals and lifetimes routed through preferences
