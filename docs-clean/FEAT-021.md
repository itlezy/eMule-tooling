---
id: FEAT-021
title: SourceSaver — persist download source lists between sessions
status: Open
priority: Minor
category: feature
labels: [download, sources, persistence, recovery]
milestone: ~
created: 2026-04-10
source: eMuleAI (SourceSaver.cpp/h, CSourceSaver class, 2026)
---

## Summary

When eMule restarts, all active sources for in-progress downloads are lost. The client must
re-discover sources from Kad, server queries, and passive source exchange — a process that
can take minutes to hours for rare files. eMuleAI's `CSourceSaver` persists the source list
for each in-progress download to disk and reloads it on startup, dramatically reducing the
time to resume transfers after a restart.

## eMuleAI Reference Implementation

**Source files:**
- `eMuleAI/SourceSaver.cpp` / `SourceSaver.h` — `CSourceSaver` class

**Per-source data persisted:**
```cpp
class CSourceData {
    CAddress  sourceIP;       // IPv4/IPv6 peer address
    uint32    sourceID;       // eDonkey user ID
    uint16    sourcePort;     // TCP port
    uint32    serverip;       // server IP (for ID-sourced peers)
    uint16    serverport;     // server port
    CString   expiration;     // absolute timestamp when source expires
    uint8     nSrcExchangeVer; // source exchange version
};
```

**File format:** Per-file XML or binary format keyed by file hash, stored in the temp/config
directory. `CalcExpiration(int nDays)` computes an ISO timestamp for source TTL.

**Lifecycle:**
- `Process(CPartFile* file)` — saves sources for a given download to disk
- `DeleteFile(CPartFile* file)` — removes the saved source file on download completion
- Called periodically from the main timer loop (e.g., every N minutes)
- On startup, loaded before Kad bootstrap completes

## Implementation Considerations

1. **CAddress dependency**: `CSourceSaver` uses `CAddress` (eMuleAI's IPv4/IPv6 abstraction).
   Adapting to `uint32` + optional IPv6 struct is straightforward.

2. **Source exchange version**: Persist `nSrcExchangeVer` to avoid re-negotiating on reload.

3. **TTL / expiration**: Sources older than N days should not be loaded. eMuleAI uses a
   configurable expiration window (`CalcExpiration(int nDays)`).

4. **Integration point**: `CDownloadQueue::Process()` or `CPartFile::InitializeFromFile()`
   for load; `CDownloadQueue::Process()` timer for save.

5. **Rare-file benefit**: For files with <10 sources globally, losing the source list on
   restart can mean hours of re-discovery. SourceSaver eliminates this.

6. **Source validity**: Saved sources are hints, not guarantees. The connection attempt must
   still succeed and the source must still have the file. Invalid saved sources are cleaned
   up naturally when the connection fails.

## Relationship to Existing Items

- **BUG-011** (Done: shareddir list race): no direct relationship, but same Preferences
  file infrastructure.
- **FEAT-002** (SafeKad CGNAT fix): SafeKad reduces source loss from firewall transitions;
  SourceSaver addresses session boundaries.

## Acceptance Criteria

- [ ] `CSourceSaver::Process(CPartFile*)` saves source list to a per-file binary/XML in
  the temp directory
- [ ] Sources loaded on startup before Kad is ready
- [ ] Sources with expired TTL not loaded
- [ ] `DeleteFile()` called on download completion (no stale files left)
- [ ] No regression if source file is missing, corrupted, or empty
- [ ] Preferences toggle: enable/disable source saving; configurable TTL (default: 7 days)
- [ ] Maximum sources per file capped (e.g., 200) to prevent unbounded file growth
