---
id: FEAT-016
title: Modern limits — update stale hard-coded defaults for broadband/modern hardware
status: Done
priority: Major
category: feature
labels: [preferences, defaults, performance, connections, upload, broadband]
milestone: ~
created: 2026-04-08
source: `main` commit `860d7a5` (`Modernize fixed runtime limits for broadband defaults`); historical rationale in `docs/FEATURE-MODERN-LIMITS.md`
---

> Historical reference only: `stale-v0.72a-experimental-clean` and
> `analysis\stale-v0.72a-experimental-clean` are retired reference sources, not
> active branch targets or current baselines. Use them only as provenance or
> idea-extraction sources; landed status is determined against `main`. See
> [Historical References](../docs/HISTORICAL-REFERENCES.md).

## Summary

This feature is merged to `main`.

Mainline commit:

- `860d7a5` — `Modernize fixed runtime limits for broadband defaults`

eMule's default connection, buffer, queue, and timeout limits were tuned for ~2005
hardware and dial-up/ADSL connections. `eMule-main` now carries the fixed-value
modernization pass documented below.

This remains a **fixed-value modernization pass only**:

- no adaptive logic
- no protocol changes
- existing `.ini` values still override the new defaults

Search-result ceilings are intentionally **not** part of FEAT-016. ed2k
`Search More` limits and Kad search result/lifetime expansion are tracked
separately under `FEAT-029`.

## Current State (main branch)

| Setting | Current default | Target default | Doc ref |
|---------|----------------|----------------|---------|
| `MaxHalfConnections` | 9 | 50 | FEAT_013 |
| `MaxConPerFive` | (stock) | 50 | FEAT_013 |
| Upload cap per client (`Client_MaxDataRate`) | (stock) | 8192 KiB/s (8 MB/s) persisted | FEAT_014 |
| UDP recv socket buffer | (stock) | 512 KiB | FEAT_015 |
| TCP big send buffer threshold/size | (stock) | enabled at 512 KiB | FEAT_015 |
| `FileBufferSize` | 0 → ~1 MiB | 64 MiB | FEAT_016 |
| `FileBufferTimeLimit` | 60 s | 120 s | FEAT_016 |
| `QueueSize` | 5 000 | 10 000 | FEAT_017 |
| `MaxSourcesPerFile` | 400 | 600 | FEAT_017 |
| Source soft cap / UDP soft cap | (stock) | 1 000 / 100 | FEAT_017 |
| `ConnectionTimeout` | (stock) | 30 s | FEAT_018 |
| `DownloadTimeout` | (stock) | 75 s | FEAT_018 |
| UDP queue expiry | (stock) | 20 s | FEAT_018 |
| `ConnectionLatency` | (stock) | 15 000 ms | FEAT_018 |

## Scope Boundary

**Safe to change** (this feature):
- Hard-coded default values
- Socket buffer sizes
- Queue and source-count caps
- File buffer size and flush timing defaults
- Connection and download timeout defaults
- Fixed per-client throughput ceilings
- Advanced tree UI exposure for key knobs

**Do NOT change** (out of scope):
- Protocol header values or opcode numbers
- `PARTSIZE`, `EMBLOCKSIZE`, Kad/eD2K packet format
- `UDP_KAD_MAXFRAGMENT`
- On-wire feature negotiation semantics

## Changes by Group

### FEAT_013 — Connection budget defaults

**`Preferences.cpp`:**
```cpp
maxhalfconnections = ini.GetInt(_T("MaxHalfConnections"), 50);  // was 9
```
Review `MaxConPerFive` and set default to 50 if still at stock value.

`MaxConnections` remains 500 (stock). On modern broadband with Win10+ half-open limits removed, 50 half-connections is appropriate.

### FEAT_014 — Per-client upload cap persists

Default cap raised to 8 MB/s (8192 KiB/s) and persisted to `preferences.ini` so it survives restarts. Previously the cap reset to stock on each launch.

### FEAT_015 — Socket buffer sizes

UDP recv buffer: `setsockopt(SO_RCVBUF, 512 * 1024)` in `ClientUDPSocket` and `KademliaUDPSocket`.

TCP big send buffer: enable at 512 KiB threshold, size 512 KiB. Replace stock `75 KiB/s` / `100 KiB/s` thresholds in `UploadDiskIOThread.cpp` (see also FEAT-015 broadband controller for the per-slot-rate-based approach).

### FEAT_016 — Disk buffering defaults

**`Preferences.cpp`:**
```cpp
m_uFileBufferSize = ini.GetInt(_T("FileBufferSize"), 64 * 1024 * 1024);  // 64 MiB, was ~1 MiB
m_uFileBufferTimeLimit = SEC2MS(ini.GetInt(_T("FileBufferTimeLimit"), 120));  // was 60 s
```

Slider maximum raised to 512 MiB. On modern hardware with 8+ GB RAM, 64 MiB write buffer reduces disk seeks dramatically on large downloads.

### FEAT_017 — Queue and source limits

**`Preferences.cpp`:**
```cpp
m_iQueueSize = ini.GetInt(_T("QueueSize"), 10000);        // was 5000
maxsourceperfile = ini.GetInt(_T("MaxSourcesPerFile"), 600);  // was 400
```

Review soft cap and UDP source cap — set to 1000 / 100 if still at stock.

### FEAT_018 — Timeout adjustments

| Parameter | Stock | New |
|-----------|-------|-----|
| `ConnectionTimeout` | (stock) | 30 000 ms |
| `DownloadTimeout` | (stock) | 75 000 ms |
| UDP queue expiry | (stock) | 20 000 ms |
| `ConnectionLatency` | (stock) | 15 000 ms |

### FEAT_019 — Advanced tree UI exposure

Expose in `Preferences > Tweaks` (advanced tree) without adding a new subtree:
- Upload cap per client (knob, already in prefs, needs UI)
- Active timeouts (ConnectionTimeout, DownloadTimeout)
- FileBufferSize slider with new 512 MiB max

## Files to Modify

| File | Change |
|------|--------|
| `Preferences.cpp` | Update 8+ `ini.GetInt` default values |
| `ClientUDPSocket.cpp` | Set UDP recv buffer to 512 KiB |
| `KademliaUDPListener.cpp` | Set UDP recv buffer to 512 KiB |
| `UploadDiskIOThread.cpp` | Raise TCP big-buffer threshold |
| `PPgTweaks.cpp` (or equivalent) | Expose timeout + upload-cap knobs |

## Acceptance Criteria

- [ ] `MaxHalfConnections` default = 50 in a fresh install
- [ ] `FileBufferSize` default = 64 MiB; slider max = 512 MiB
- [ ] `FileBufferTimeLimit` default = 120 s
- [ ] `QueueSize` default = 10 000
- [ ] `MaxSourcesPerFile` default = 600
- [ ] UDP recv buffer = 512 KiB (both ED2K and Kad sockets)
- [ ] Per-client upload cap defaults to 8 MB/s and persists across restarts
- [ ] Timeout defaults updated in `Preferences.cpp`
- [ ] Advanced tree exposes upload cap and timeout knobs
- [ ] Existing `preferences.ini` with old values continues to work (ini values override defaults)
- [ ] No protocol behavior changes — only defaults

## Reference

Full rationale and per-setting analysis: `docs/FEATURE-MODERN-LIMITS.md`

## Experimental Reference Implementation

**Status in `stale-v0.72a-experimental-clean`:** Done in commit `a0bebbc` (FEAT: finish modern limits defaults follow-through) and related cleanup commits. Key deliverables:

**`ModernLimits.h` (new file):** Centralizes all modern defaults as `constexpr` values in the `ModernLimits` namespace:
- `kDefaultMaxConnectionsPerFiveSeconds = 50`
- `kDefaultConnectionTimeoutSeconds = 30`, `kDefaultDownloadTimeoutSeconds = 75`
- `kDefaultUdpMaxQueueTimeSeconds = 20`, `kDefaultConnectionLatencyMs = 15000`
- `kDefaultUdpReceiveBufferSize = 512 KiB`, `kDefaultTcpSendBufferSize = 512 KiB`
- `kDefaultFileBufferSize = 64 MiB`, `kMaxFileBufferSize = 512 MiB`, `kDefaultFileBufferTimeLimitSeconds = 120`
- `kDefaultQueueSize = 10000`, `kDefaultMaxSourcesPerFile = 600`, `kDefaultMaxSourcesPerFileSoft = 1000`, `kDefaultMaxSourcesPerFileUdp = 100`
- `kDefaultUploadClientDataRate = 8 MiB/s`
- `SecondsToMs`, `NormalizeTimeoutSeconds`, `TimeoutMsToSeconds`, `ApplyUploadClientDataRateCap` helpers

**`Opcodes.h` changes:**
- `SESSIONMAXTRANS` raised from `(PARTSIZE+20*1024)` to `(1024ui64*1024*1024*64)` (64 GiB target — upload full file to fast user)
- `SESSIONMAXTIME` raised from `HR2MS(1)` to `HR2MS(3)` (3 hours)
- `MAXCONPER5SEC` raised from 20 to 50
- `MAX_UP_CLIENTS_ALLOWED` changed to 50 (softened, dynamic expansion via broadband controller)
- `PROXYTYPE_*` constants removed
- `CONNECTION_TIMEOUT`, `UDPMAXQUEUETIME`, `MAX_SOURCES_FILE_SOFT`, `MAX_SOURCES_FILE_UDP`, `CONNECTION_LATENCY` moved/removed (now in `ModernLimits.h`)

**`Preferences.cpp` changes:**
- `m_dwConnectionTimeout` and `m_dwDownloadTimeout` now use `ModernLimits::NormalizeTimeoutSeconds` on load/save
- `m_uMaxUpClientsAllowed` new field with `kDefaultMaxConnectionsPerFiveSeconds` default
- `BBBoostLowRatioFiles`, `BBBoostLowRatioFilesBy`, `BBDeboostLowIDs` added for broadband slot controller

**`PPgTweaks.cpp`:** UI sliders for `FileBufferSize` (max raised to 512 MiB), `FileBufferTimeLimit`, `ConnectionTimeout`, `DownloadTimeout` exposed.

**Porting note:** Port `ModernLimits.h` first (new header, no dependencies), then update `Opcodes.h` constants, then `Preferences.cpp` load/save paths. Keep changes gated on existing `.ini` values overriding defaults — no forced migration.
