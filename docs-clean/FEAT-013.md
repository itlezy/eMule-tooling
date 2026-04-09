---
id: FEAT-013
title: REST API — CPipeApiServer (C++ named pipe IPC server)
status: Open
priority: Minor
category: feature
labels: [api, rest, named-pipe, ipc, json, cpp]
milestone: ~
created: 2026-04-08
source: PLAN-API-SERVER.md (PLAN_004 — C++ side)
---

## Summary

Implement `CPipeApiServer` — a named pipe IPC server inside `eMule.exe` that exposes eMule's internal state and operations to the `emule-sidecar` Node.js process (FEAT-014) via a JSON-lines protocol over `\\.\pipe\emule-api`.

This is the C++ half of the REST API architecture. The full contract is specified in `docs/PLAN-API-SERVER.md`.

## Architecture

```
eMule.exe
  CPipeApiServer
  ├── CreateNamedPipe  \\.\pipe\emule-api
  ├── Overlapped I/O read thread  →  JSON command dispatch
  ├── Write  →  JSON responses + async event pushes
  └── Event hook points:
      ├── EmuleDlg::OnFileCompleted
      ├── CServerConnect::OnConnected
      ├── periodic stats timer (~1 s)
      └── search result callbacks
```

## Pipe Transport

- **Pipe name:** `\\.\pipe\emule-api`
- **Mode:** `PIPE_ACCESS_DUPLEX | FILE_FLAG_OVERLAPPED`, byte stream
- **Max instances:** 1 (one sidecar at a time)
- **Framing:** newline-delimited JSON (JSON-lines / NDJSON) — each message ends with `\n`
- **Encoding:** UTF-8
- **Auth:** None — local pipe, auth lives in the sidecar's HTTP layer

## Message Types

### Command (sidecar → eMule)
```json
{"id": "uuid-v4", "cmd": "get_stats"}
```

### Response (eMule → sidecar)
```json
{"id": "uuid-v4", "ok": true, "data": {...}}
{"id": "uuid-v4", "ok": false, "error": "not_found"}
```

### Event (eMule → sidecar, unsolicited)
```json
{"event": "file_complete", "data": {"hash": "...", "name": "..."}}
{"event": "stats", "data": {"upSpeed": 42000, "downSpeed": 128000, ...}}
```

## Command Reference (partial)

| Command | Response |
|---------|----------|
| `get_stats` | Speed, connections, session bytes, kad status |
| `get_transfers` | Download list with progress, speed, ETA |
| `get_uploads` | Current upload slots |
| `get_servers` | Known servers + connected server |
| `get_kad` | Kad status, routing table size, bootstrap state |
| `get_shared` | Shared file list with metadata |
| `get_log` | Last N log lines |
| `search_start` | Starts a keyword search; results arrive as `search_result` events |
| `search_stop` | Cancels a running search |
| `download_add` | Adds an ed2k:// link or .met blob to the download queue |
| `download_cancel` | Removes a download |
| `download_pause` / `resume` | Pauses or resumes a download |

## Event Hook Points in eMule

| Event | Where to hook |
|-------|---------------|
| `file_complete` | `CemuleDlg::OnFileCompleted()` |
| `server_connect` | `CServerConnect::OnConnected()` |
| `stats` | `CemuleDlg::OnTimer()` — 1 s tick |
| `search_result` | `CSearchList::AddSearchResult()` |
| `download_added` | `CDownloadQueue::AddSearchResult()` |

## Class Design

```cpp
class CPipeApiServer {
public:
    void Start();      // CreateNamedPipe, launch I/O thread
    void Stop();       // disconnect, signal thread exit
    void PushEvent(const std::string& eventJson);  // thread-safe, queued

private:
    HANDLE          m_hPipe;
    std::thread     m_ioThread;
    std::mutex      m_writeMutex;
    std::queue<std::string> m_pendingEvents;

    void IoThreadProc();
    void DispatchCommand(const std::string& json);
    void WriteResponse(const std::string& json);
};
```

## Thread Safety

- **Read thread** (`m_ioThread`): reads commands, dispatches via `PostMessage` to UI thread or calls thread-safe API directly.
- **Write path**: all writes (responses + events) go through `m_writeMutex`.
- **Event queue**: `PushEvent()` acquires `m_writeMutex`, enqueues, signals write thread.

UI-thread-only state (download list, upload queue, etc.) must be accessed via `PostMessage` / `SendMessage` to the main window thread — never directly from `m_ioThread`.

## JSON Library

Use `nlohmann/json` (header-only, MIT license) — add as a single `json.hpp` header to `srchybrid/`. No additional build config needed.

## Implementation Order

1. Pipe create/accept/disconnect lifecycle
2. JSON-lines framing (read loop + write helper)
3. `get_stats` command (simplest, validates round-trip)
4. Event push path (`PushEvent` + stats timer hook)
5. Remaining commands in priority order

## Acceptance Criteria

- [ ] `CPipeApiServer` starts with eMule, creates `\\.\pipe\emule-api`
- [ ] JSON-lines framing correct (messages delimited by `\n`, no partial reads)
- [ ] `get_stats` returns correct speed/connection data
- [ ] `file_complete` event pushed when a download finishes
- [ ] Sidecar disconnect + reconnect handled without eMule restart
- [ ] No deadlock: UI-thread commands dispatched via PostMessage, not blocking pipe thread
- [ ] No sensitive data (plaintext passwords, private keys) in any pipe message

## Reference

Full API contract (commands, events, data types, error conventions): `docs/PLAN-API-SERVER.md`
Sidecar (Node.js) side: FEAT-014

## Experimental Reference Implementation

**Status in `stale-v0.72a-experimental-clean`:** Substantially implemented. `PipeApiServer.cpp/h` and `PipeApiServerPolicy.h` are present in `srchybrid/`. Key aspects:

**Lifecycle state machine:** `EPipeApiLifecycleState` enum (`Stopped`, `Listening`, `Connected`, `ShuttingDown`). Worker thread performs `CreateNamedPipe` → `ConnectNamedPipe` (overlapped) → read loop → `DisconnectNamedPipe` cycle.

**Backpressure:** `SPipeApiWriteEntry` tracks bytes in the write queue; `PipeApiPolicy::EWriteKind` distinguishes command responses (must-deliver) from event pushes (droppable under pressure). Write queue has a hard byte ceiling.

**Command dispatch:** Worker thread reads a line, creates `SPipeApiCommandRequest` with a Win32 `HANDLE hCompletedEvent`, posts to UI thread via `PostMessage`, waits on event. UI thread processes the model access, fills `strResponseLine`, sets the event. No blocking of the UI thread (uses `SendMessage` style but with timeout + cancellable flag).

**JSON:** `nlohmann/json` (`srchybrid/nlohmann/` directory) included as vendored header-only library.

**Startup toggle:** `m_bPipeServerEnabled` preference toggle + resource ID for menu/toolbar toggle.

**Commands implemented:** `get_stats`, `get_transfers`, `get_shared`, `get_servers`, `get_kad`, `get_log`, `search_start`, `download_add`, `download_cancel`, `download_pause`, `download_resume`, plus versioned v2 routes.

**Porting note:** `PipeApiServer.cpp/h`, `PipeApiServerPolicy.h`, and `srchybrid/nlohmann/` are all new. Add to `.vcxproj` and wire `CPipeApiServer` into `CemuleApp` and `EmuleDlg` (start/stop lifecycle + event hook points). The preference toggle and runtime enable/disable are important for safe rollout.
