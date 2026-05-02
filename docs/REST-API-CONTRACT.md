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
- return collections as `{ "data": { "items": [...] }, "meta": ... }`
- return errors as `{ "error": { "code": "...", "message": "...", "details": {} } }`
- return the updated resource from mutations when practical
- require explicit booleans such as `deleteFiles: true` for destructive local
  file deletion
- use HTTP 200 for valid bulk requests with per-item results

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

## Implementation Status

The OpenAPI contract is the target contract. The current application already
implements a substantial resource-style REST surface, but some routes,
envelopes, field names, and legacy-action parity items still need alignment.

Use [REST-API-PARITY-INVENTORY.md](REST-API-PARITY-INVENTORY.md) as the
implementation checklist. Any remaining `deferred` runtime action must either
be implemented before the complete REST release or explicitly removed by a user
decision.

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
