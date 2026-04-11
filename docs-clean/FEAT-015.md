---
id: FEAT-015
title: Broadband upload slot allocation — fixed cap + weak-slot reclamation
status: Open
priority: Major
category: feature
labels: [upload, broadband, performance, upload-queue, throttler, preferences]
milestone: ~
created: 2026-04-08
source: FEATURE-BROADBAND.md (FEAT_001 — stale branch, not yet on main)
---

## Summary

The stock upload controller scales slot count linearly with bandwidth using a hard-coded 25 KiB/s per-slot target (`UPLOAD_CLIENT_MAXDATARATE`). On a modern broadband link (50+ Mbit/s) this drives slot count toward 100, filling the pipe by accumulation rather than by keeping a small set of strong slots. This feature replaces that model with a budget-based controller: a configurable steady-state slot target, per-slot rate derived from one finite configured upload budget, and proactive slow-slot reclamation.

**Branch status:** Implemented on `feature/broadband-stabilization`. The active branch intentionally narrows the old broadband design into a strict fixed-slot controller: default cap `8`, no temporary overflow above the configured cap, underfill used only to justify weak-slot recycling, friend slots kept as the one intentional scheduling exception, and LowID reconnects returned to the normal waiting/admission path.

**Scope split:** Non-slot broadband extras still present on the branch, such as low-ratio queue scoring and ratio/cooldown UI columns, are no longer part of this story. Track them separately under `FEAT-023`.

## The Problem (stock v0.72a behavior)

`UploadQueue.cpp:401-406` — slot count formula:
```cpp
// 4 slots or more - linear growth by 1 KiB/s steps, cap off at UPLOAD_CLIENT_MAXDATARATE
nResult = min(UPLOAD_CLIENT_MAXDATARATE, nOpenSlots * 1024);
```

`Opcodes.h:109-111`:
```cpp
#define UPLOAD_CLIENT_MAXDATARATE  (25*1024)   // 25 KiB/s per slot target
#define MAX_UP_CLIENTS_ALLOWED     100
```

On a 50 Mbit/s (~6100 KiB/s) uplink:
- target per slot: 25 KiB/s
- implied slot count: 6100 / 25 = 244 → capped at 100
- result: 100 slots all transferring at ~60 KiB/s each, no weak-slot retirement

A modern link works better with 12 strong slots at ~500 KiB/s each.

## New Controller Design

### Preferences (active stabilization branch)

| Key | Type | Default | Meaning |
|-----|------|---------|---------|
| `BBMaxUpClientsAllowed` | int | 8 | Steady-state slot target |
| `BBSlowThresholdFactor` | float | 0.33 | Slow-slot threshold as a fraction of per-slot target |
| `BBSlowGraceSeconds` | int | 30 | Slow-rate recycle grace after warm-up |
| `BBSlowWarmupSeconds` | int | 60 | Startup protection before slow/zero recycle can apply |
| `BBZeroRateGraceSeconds` | int | 10 | Zero-rate recycle grace after warm-up |
| `BBSlowCooldownSeconds` | int | 120 | Score suppression after weak-slot recycle |
| `BBSessionTransferMode` | enum | Percent of file size | Transfer-rotation mode |
| `BBSessionTransferValue` | int | 55 | Value for the selected transfer-rotation mode |
| `BBSessionTimeLimitSeconds` | int | 3600 | Time-based session rotation backstop |

### Configured upload budget

```cpp
uint32 configuredBudget = GetMaxUpload();  // KiB/s
```

On `feature/broadband-stabilization`, upload is always finite:
- the configured upload limit is the only slot-control budget source
- unlimited upload is not supported
- missing, zero, or legacy-unlimited upload values normalize to `6100 KiB/s`

### Per-slot target

```cpp
uint32 targetPerSlot = max(3u, configuredBudget / BBMaxUpClientsAllowed);  // KiB/s floor 3
```

Existing 75% admission threshold applies to `targetPerSlot`.

### Slot admission (current stabilization branch)

- Fill until `BBMaxUpClientsAllowed` is reached
- Do not open temporary overflow slots above the configured cap
- `MAX_UP_CLIENTS_ALLOWED = 100` kept as absolute ceiling only
- Underfill is still evaluated, but only to justify reclaiming weak slots
- Slow-slot recycling only activates after underfill persists ≥ 2 seconds

### Slow/stuck slot reclamation (`UpdownClient.h` + `UploadClient.cpp`)

New state per `CUpDownClient` tracks accumulated slow/zero-rate time and
post-recycle cooldown.

Slow threshold: smoothed upload rate < `targetPerSlot / 3`

Eviction triggers (only while queue non-empty AND at/above soft cap AND underfilled):
- fresh slots are protected for `60` seconds before recycle can apply
- recycle after `30` seconds below slow threshold
- recycle after `10` seconds at exactly `0` upload rate

Evicted clients are requeued immediately (protocol compat) but queue score held
at `0` for `120` seconds (`Cooldown` column).

Good samples reduce accumulated slow time. Neutral periods freeze timers.

### Session rotation overrides

Replace `SESSIONMAXTRANS`/`SESSIONMAXTIME` checks in upload slot logic with:
- `BBSessionTransferMode` + `BBSessionTransferValue`
- `BBSessionTimeLimitSeconds`

Current default:
- percent-of-file transfer mode with value `55`
- `3600` second time limit

### Socket buffer / disk prefetch scaling

Replace fixed `75 KiB/s` / `100 KiB/s` thresholds in `UploadDiskIOThread.cpp`:
- Large socket send buffer: enable when slot rate ≥ `targetPerSlot / 2`
- Disk prefetch: 1 → 3 → 5 blocks based on rate relative to `targetPerSlot`

## Files to Modify

| File | Change |
|------|--------|
| `Preferences.h/cpp` | Slot-controller BB* preference keys with load/save/defaults |
| `Opcodes.h` | No change to existing constants |
| `UploadQueue.h/cpp` | Replace slot-count formula; add budget/target computation; add weak-slot recycle gates |
| `UploadBandwidthThrottler.h/cpp` | Replace `UPLOAD_CLIENT_MAXDATARATE` guard with `targetPerSlot` |
| `UpdownClient.h` | Add slow-tracking and cooldown members for weak-slot recycle |
| `UploadClient.cpp` | Slow/stuck detection + eviction logic; cooldown queue-score zero |
| `UploadDiskIOThread.cpp` | Replace fixed buffer/prefetch thresholds with `targetPerSlot`-based scaling |
| `PPgTweaks.cpp` | Broadband settings surfaced under `Preferences > Tweaks > Broadband` |

## Implementation Order

1. `Preferences.h/cpp` — slot-controller BB* keys
2. `UploadQueue.cpp` — fixed-cap admission and weak-slot recycle
3. `UploadBandwidthThrottler.cpp` — cap-aware slot pressure
4. `UpdownClient.h` / `UploadClient.cpp` — slow-slot tracking and cooldown
5. `UploadDiskIOThread.cpp` — per-slot-rate buffer/prefetch scaling
6. Session rotation overrides
7. `PPgTweaks` broadband settings

## Acceptance Criteria

- [ ] Default `BBMaxUpClientsAllowed=8` holds slot count near 8 on a 50 Mbit/s link (does not grow to 100)
- [ ] Manually setting `BBMaxUpClientsAllowed=12` holds slot count at or below 12 on a 50 Mbit/s link
- [ ] Fresh upload slots are protected from recycle for the first 60 s
- [ ] Slow uploaders (< `targetPerSlot / 3`) are evicted after 30 s and enter 120 s cooldown
- [ ] Zero-rate slots are evicted after 10 s once warm-up has completed
- [ ] Cooldown prevents immediate slot re-entry; column shows remaining time
- [ ] `BBSessionTransferMode` / `BBSessionTransferValue` / `BBSessionTimeLimitSeconds` override stock session rotation
- [ ] `Preferences > Tweaks > Broadband` page loads, saves, applies without restart
- [ ] Missing or legacy-unlimited upload config normalizes to `6100 KiB/s`
- [ ] Friend slots remain the only deliberate scheduling exception
- [ ] LowID reconnects do not bypass the normal waiting/admission path
- [ ] Collection handling is correctness-only and does not use a separate scheduler path

## Reference

Full design and rationale: `docs/FEATURE-BROADBAND.md`
Stale branch reference: `archive/v0.72a-experimental-clean-provisional-20260404`
eMuleAI Ratio columns: `analysis/emuleai/srchybrid/KnownFile.h:124-133`, `UploadListCtrl.cpp:355-362`
