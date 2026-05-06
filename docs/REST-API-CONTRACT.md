# eMule BB REST API Contract

**Status:** pre-release broadband contract
**Source of truth:** [REST-API-OPENAPI.yaml](REST-API-OPENAPI.yaml)
**Legacy parity inventory:** [REST-API-PARITY-INVENTORY.md](REST-API-PARITY-INVENTORY.md)
**Primary implementation:** `EMULE_WORKSPACE_ROOT\workspaces\v0.72a\app\eMule-main\srchybrid\WebServerJson.cpp`
**Route seam:** `EMULE_WORKSPACE_ROOT\workspaces\v0.72a\app\eMule-main\srchybrid\WebServerJsonSeams.h`

## Overview

`main` exposes an authenticated in-process JSON API from the existing eMule
WebServer listener. The broadband release contract is the resource-oriented
`/api/v1` surface described by the OpenAPI document above.

The API is designed for aMuTorrent and other trusted local controllers. eMule
BB and aMuTorrent are both pre-release, so the final contract intentionally
prioritizes consistency and aMuTorrent completeness over preserving old
command-style route names.

## Contract Rules

- root every endpoint at `/api/v1/...`
- authenticate only with `X-API-Key`
- serve JSON only
- inherit the normal WebServer bind, HTTPS, and allowed-IP behavior
- use `camelCase` field names
- return success envelopes as `{ "data": ..., "meta": ... }`
- return collections as `{ "data": { "items": [...], "total": n, "offset": n, "limit": n }, "meta": ... }`
- return errors as `{ "error": { "code": "...", "message": "...", "details": {} } }`
- return the updated resource from mutations when practical
- validate method/path/body/query through the native route schema table before
  dispatching commands
- reject unknown JSON body fields and unknown or malformed query parameters with
  `400 INVALID_ARGUMENT`
- require explicit booleans such as `deleteFiles: true` for destructive local
  file deletion
- use HTTP 200 for valid bulk requests with per-item results
- marshal native commands through the main UI thread before touching eMule
  state owned by dialogs, sockets, queues, and list controls
- reject pre-release alias spellings; public request fields are the final
  OpenAPI names such as `categoryId`, `searchId`, `deleteFiles`,
  `uploadLimitKiBps`, and `downloadLimitKiBps`

## Scope

The release API must cover every useful runtime action from the legacy
WebServer: transfers, shared files, shared directories, uploads, upload queue,
servers, Kad, searches, friends, logs, categories, statistics, preferences, and
application shutdown.

The release API intentionally excludes:

- HTML sessions, login/logout, templates, sort state, column hiding, and other
  legacy WebServer presentation state
- host operating-system shutdown and reboot
- binary shared-file streaming
- granular REST permissions or low-rights REST mode
- dynamic capability negotiation between eMule BB and aMuTorrent

## Search Semantics

`POST /api/v1/searches` starts a native eMule search using the requested method:
`automatic`, `server`, `global`, or `kad`. The route maps directly to the
existing eD2K/Kad search modes and must not change stock search semantics for
Release 1.0.

`GET /api/v1/searches/{searchId}` returns the current native visible result
snapshot for that search. Release 1.0 intentionally does not expose search
result paging; the route does not accept `limit` or `offset`, and the strict
route table rejects unknown query parameters. Controllers should poll the search
resource and treat `results` as a bounded native snapshot governed by eMule's
existing search-result retention and visibility behavior.

`POST /api/v1/searches/{searchId}/results/{hash}/operations/download` starts a
download from one visible search result by lowercase 32-character eD2K hash.

## Implementation Status

The OpenAPI contract is the implemented target contract for the current
pre-release pass. Native route-seam tests cover the route schema table and
strict validation behavior; the Python smoke harness includes an OpenAPI route
consistency check and validates success/error envelopes. aMuTorrent's eMule BB
adapter consumes the same final field names while keeping aMuTorrent's own
public routes stable.

Use [REST-API-PARITY-INVENTORY.md](REST-API-PARITY-INVENTORY.md) for residual
release-gate and live-smoke tracking. Runtime route completeness is expected to
match [REST-API-OPENAPI.yaml](REST-API-OPENAPI.yaml).

## Retired Before Public Release

The following earlier command-style routes are not part of the final broadband
release contract and should not be used by aMuTorrent:

- `/api/v1/app/version`
- `/api/v1/stats/global`
- `/api/v1/transfers/add`
- `/api/v1/transfers/pause`
- `/api/v1/transfers/resume`
- `/api/v1/transfers/stop`
- `/api/v1/transfers/delete`
- `/api/v1/uploads/list`
- `/api/v1/uploads/queue`
- `/api/v1/servers/list`
- `/api/v1/servers/status`
- `/api/v1/search/start`
- `/api/v1/search/results`
- `/api/v1/search/stop`
- `/api/v1/log`
