---
id: FEAT-023
title: Broadband queue scoring and ratio/cooldown UI extras
status: Open
priority: Minor
category: feature
labels: [upload, broadband, scoring, ui, seeding]
milestone: ~
created: 2026-04-11
source: feature/broadband-stabilization branch state
---

## Summary

`feature/broadband-stabilization` still carries several broadband-related extras
that are no longer part of the core slot-allocation story in FEAT-015. These
extras are useful, but they change queue scoring and UI presentation rather than
the fixed-cap slot controller itself.

This follow-up item keeps those pieces explicit so FEAT-015 can close as the
slot-allocation story without pretending the remaining branch baggage has been
removed.

## Current Branch Extras

- `BBLowRatioBoostEnabled`, `BBLowRatioThreshold`, and `BBLowRatioBonus` add a
  low-ratio queue-score bonus for files with low all-time upload ratio
- `BBLowIDDivisor` reduces queue score for LowID clients
- `All-Time Ratio` / `Session Ratio` columns are shown in shared, upload, and
  queue views
- `Cooldown` column is shown in upload and queue views
- low-ratio preference also affects the published shared-file ordering logic

## Why This Is Separate From FEAT-015

FEAT-015 is now the slot-allocation story:

- fixed upload-slot cap
- finite upload budget
- underfill-driven weak-slot recycle
- warm-up / slow / zero / cooldown timing
- friend-slot exception
- collection correctness guard

The items here are different in kind:

- they tune queue score rather than slot count
- they expose extra state in UI lists
- they are not required for the fixed-cap broadband uploader to work correctly

## Acceptance Criteria

- [ ] low-ratio score knobs are documented as separate from FEAT-015 slot allocation
- [ ] ratio/cooldown UI columns are documented as separate from FEAT-015 slot allocation
- [ ] future cleanup can remove, keep, or retune these extras without reopening FEAT-015
