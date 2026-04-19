# eMule REST API Contract

**Status:** Shipped / Canonical Contract  
**Primary implementation:** `EMULE_WORKSPACE_ROOT\workspaces\v0.72a\app\eMule-main\srchybrid\WebServerJson.cpp`  
**Related backlog record:** `docs-clean/FEAT-013.md`

## Overview

`main` exposes an authenticated in-process JSON API from the existing eMule
WebServer listener.

The shipped API is:

- in-process inside `eMule-main`
- rooted at `/api/v1/...`
- authenticated with `X-API-Key`
- JSON-only
- limited to `GET` and `POST`

This document is the canonical contract for:

- `eMule-main`
- `eMule-remote`
- any future local tooling that consumes the shipped REST surface

## Explicit Non-Contract Surfaces

The following are **not** part of the shipped contract:

- the historical named-pipe transport
- `/api/v2/...`
- SSE event streaming
- bearer-login auth on the upstream eMule listener

The historical sidecar plan remains in `PLAN-API-SERVER.md` for reference only.

## Base URL And Auth

The API is served from the normal WebServer listener root:

- `http://<host>:<port>/api/v1/...`
- `https://<host>:<port>/api/v1/...` when HTTPS is enabled on the listener

Authentication:

- header: `X-API-Key: <token>`

Notes:

- the configured API key is a visible operator token stored in preferences
- requests without a configured key return `503 EMULE_UNAVAILABLE`
- requests without a valid `X-API-Key` return `401 UNAUTHORIZED`
- legacy HTML web UI session auth is separate and does not apply to `/api/v1`

## Error Shape

All REST failures return JSON:

```json
{
  "error": "ERROR_CODE",
  "message": "human-readable description"
}
```

Typical status mapping:

- `400` invalid arguments, path, query, or JSON body
- `401` missing or invalid `X-API-Key`
- `404` object or route not found
- `409` invalid current state where applicable
- `500` internal operation failure
- `503` runtime unavailable or REST not configured

## Route Surface

### Application

- `GET /api/v1/app/version`
- `GET /api/v1/app/preferences`
- `POST /api/v1/app/preferences`
- `POST /api/v1/app/shutdown`

### Stats

- `GET /api/v1/stats/global`

### Transfers

- `GET /api/v1/transfers`
- `GET /api/v1/transfers/{hash}`
- `GET /api/v1/transfers/{hash}/sources`
- `POST /api/v1/transfers/add`
- `POST /api/v1/transfers/pause`
- `POST /api/v1/transfers/resume`
- `POST /api/v1/transfers/stop`
- `POST /api/v1/transfers/delete`
- `POST /api/v1/transfers/{hash}/recheck`
- `POST /api/v1/transfers/{hash}/priority`
- `POST /api/v1/transfers/{hash}/category`

### Uploads

- `GET /api/v1/uploads/list`
- `GET /api/v1/uploads/queue`
- `POST /api/v1/uploads/remove`
- `POST /api/v1/uploads/release_slot`

### Servers

- `GET /api/v1/servers/list`
- `GET /api/v1/servers/status`
- `POST /api/v1/servers/connect`
- `POST /api/v1/servers/disconnect`
- `POST /api/v1/servers/add`
- `POST /api/v1/servers/remove`

### Kad

- `GET /api/v1/kad/status`
- `POST /api/v1/kad/connect`
- `POST /api/v1/kad/disconnect`
- `POST /api/v1/kad/recheck_firewall`

### Shared

- `GET /api/v1/shared/list`
- `GET /api/v1/shared/{hash}`
- `POST /api/v1/shared/add`
- `POST /api/v1/shared/remove`

### Search

- `POST /api/v1/search/start`
- `GET /api/v1/search/results`
- `POST /api/v1/search/stop`

### Log

- `GET /api/v1/log`

## Key Request And Response Notes

### General

- transfer and shared-file hashes are lowercase 32-character MD4 hex strings
- query strings are significant and should be preserved exactly by proxies
- upstream callers should treat payload field ordering as unspecified

### Preferences

- `POST /api/v1/app/preferences` expects:

```json
{
  "prefs": {
    "...": "..."
  }
}
```

- unsupported preference names are rejected, not silently ignored

### Transfers Add

- `POST /api/v1/transfers/add` expects a single link payload:

```json
{
  "link": "ed2k://..."
}
```

- upstream eMule does not batch `links[]` in the shipped `/api/v1` contract

### Search

- `POST /api/v1/search/start` returns:

```json
{
  "search_id": "..."
}
```

- `GET /api/v1/search/results` expects the `search_id` query parameter
- the response contains:
  - `status`
  - `results`
- individual result entries also carry their own `searchId`

### Log

- `GET /api/v1/log?limit=N` returns recent retained log entries
- callers should bound `limit` reasonably and not assume unbounded history

## Proxying Rules For `eMule-remote`

`eMule-remote` is expected to proxy the shipped eMule REST surface `1:1`.

That means:

- same `/api/v1/...` paths
- same query strings
- same JSON request bodies
- same HTTP status codes
- same JSON success and error payloads

For upstream configuration, the remote must be pointed at the eMule listener
root, for example:

- `http://127.0.0.1:4711`

not:

- `http://127.0.0.1:4711/api/v1`

because the proxy layer appends `/api/v1/...` itself.

## Historical Reference

The file `PLAN-API-SERVER.md` describes an older named-pipe plus sidecar design.
It is retained as historical analysis only and must not be treated as the
runtime contract for `main`.
