# eMule BB REST API Contract

**Status:** Broadband release contract
**Primary implementation:** `EMULE_WORKSPACE_ROOT\workspaces\v0.72a\app\eMule-main\srchybrid\WebServerJson.cpp`
**Route seam:** `EMULE_WORKSPACE_ROOT\workspaces\v0.72a\app\eMule-main\srchybrid\WebServerJsonSeams.h`

## Overview

`main` exposes an authenticated in-process JSON API from the existing eMule
WebServer listener. The broadband release contract is a redesigned
resource-oriented `/api/v1` surface. The earlier command-style `/api/v1`
routes were retired before public release.

The API is:

- rooted at `/api/v1/...`
- authenticated with `X-API-Key`
- JSON-only
- served by the normal eMule WebServer HTTP or HTTPS listener
- intended for aMuTorrent and other local controllers

## Base URL And Auth

- `http://<host>:<port>/api/v1/...`
- `https://<host>:<port>/api/v1/...` when HTTPS is enabled

Authentication:

- header: `X-API-Key: <token>`

Requests without a configured API key return `503 EMULE_UNAVAILABLE`. Requests
without the correct key return `401 UNAUTHORIZED`.

## Error Shape

All failures return JSON:

```json
{
  "error": "ERROR_CODE",
  "message": "human-readable description"
}
```

Typical status mapping:

- `400` invalid route, query, method body, or JSON
- `401` missing or invalid API key
- `404` route or object not found
- `409` invalid current state
- `500` internal operation failure
- `503` runtime unavailable or REST not configured

## Routes

### Application

- `GET /api/v1/app`
- `GET /api/v1/app/preferences`
- `PATCH /api/v1/app/preferences`
- `POST /api/v1/app/shutdown`

`app` includes additive capability metadata for controller discovery:

- `apiVersion`
- `capabilities.transfers`
- `capabilities.searches`
- `capabilities.servers`
- `capabilities.sharedFiles`
- `capabilities.uploads`
- `capabilities.logs`
- `capabilities.categoriesRead`
- `capabilities.categoryAssignment`
- `capabilities.categoryCrud`
- `capabilities.renameFile`
- `capabilities.fileRatingComment`

`renameFile` means controllers may rename incomplete transfers. Completed
transfers and shared files are not renamed by this release slice.

`fileRatingComment` means controllers may update user-visible rating/comment
metadata on completed shared files.

### Status And Snapshot

- `GET /api/v1/status`
- `GET /api/v1/snapshot?limit=N`

`status` returns:

- `stats`
- `servers`
- `kad`

`snapshot` returns:

- `app`
- `status`
- `transfers`
- `sharedFiles`
- `uploads`
- `uploadQueue`
- `servers`
- `kad`
- `logs`

Per-transfer source details are intentionally excluded from `snapshot`; callers
should request sources lazily.

### Categories

- `GET /api/v1/categories`

Categories are read-only in the broadband release contract. The default
download category is exposed as id `0`, name `Default`.

Category rows include:

- `id`
- `name`
- `path`
- `comment`
- `color`
- `priority`

### Transfers

- `GET /api/v1/transfers?filter=&category=`
- `POST /api/v1/transfers`
- `GET /api/v1/transfers/{hash}`
- `PATCH /api/v1/transfers/{hash}`
- `DELETE /api/v1/transfers/{hash}`
- `GET /api/v1/transfers/{hash}/sources`
- `POST /api/v1/transfers/{hash}/sources/browse`

Add accepts either:

```json
{ "link": "ed2k://..." }
```

or:

```json
{ "links": ["ed2k://..."] }
```

Patch accepts one of:

```json
{ "action": "pause" }
{ "action": "resume" }
{ "action": "stop" }
{ "action": "recheck" }
{ "priority": "high" }
{ "category": 0 }
{ "categoryName": "Default" }
{ "name": "new-name.ext" }
```

`categoryName` assigns the transfer to an existing configured category by name.
Category creation, editing, deletion, and rename are intentionally not exposed
in this release slice.

`name` renames incomplete transfers only. Completed transfers and completing
transfers return `409 INVALID_STATE`; shared-file filesystem rename is not part
of this release slice.

Delete accepts:

```json
{ "delete_files": true }
```

### Shared Files

- `GET /api/v1/shared-files`
- `POST /api/v1/shared-files`
- `GET /api/v1/shared-files/{hash}`
- `PATCH /api/v1/shared-files/{hash}`
- `DELETE /api/v1/shared-files`
- `DELETE /api/v1/shared-files/{hash}`

Add accepts `{ "path": "C:\\share\\file.ext" }`. Delete by body accepts either
`path` or `hash`; delete by route hash supplies `hash` from the path.

Patch updates the completed shared-file comment and rating together:

```json
{ "comment": "verified release", "rating": 4 }
```

`rating` must be an integer from `0` through `5`. `comment` is required and is
truncated to eMule's file-comment length limit. Part files cannot be updated by
this endpoint. Shared-file rename remains unsupported in this release slice.

### Uploads

- `GET /api/v1/uploads`
- `GET /api/v1/upload-queue`
- `DELETE /api/v1/uploads/{client_id}`
- `POST /api/v1/uploads/{client_id}/release-slot`

The upload client selector may be supplied by route hash when available or by
JSON body using `userHash` or `ip` plus `port`.

### Servers

- `GET /api/v1/servers`
- `POST /api/v1/servers`
- `PATCH /api/v1/servers/{address}:{port}`
- `DELETE /api/v1/servers/{address}:{port}`

Patch actions:

```json
{ "action": "connect" }
{ "action": "disconnect" }
```

`disconnect` may use any syntactically valid placeholder id; the current
implementation disconnects the active server.

### Kad

- `GET /api/v1/kad`
- `PATCH /api/v1/kad`

Patch actions:

```json
{ "action": "connect" }
{ "action": "disconnect" }
{ "action": "recheck_firewall" }
```

### Searches

- `POST /api/v1/searches`
- `GET /api/v1/searches/{id}`
- `DELETE /api/v1/searches/{id}`

Search start returns:

```json
{ "search_id": "123" }
```

### Logs

- `GET /api/v1/logs?limit=N`

Callers should bound `limit` and not assume unbounded history.

## Response Notes

- Collection endpoints return `{ "items": [...] }`.
- `snapshot` embeds collection arrays directly.
- Transfer and shared-file hashes are lowercase 32-character MD4 hex strings.
- Field ordering is not part of the contract.
- Mutating endpoints return either the changed object, `{ "ok": true }`, or a
  `results` array for multi-item operations.

## Retired Before Public Release

The following command-style routes are not part of the broadband release
contract:

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
