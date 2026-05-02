# eMule BB REST API Parity Inventory

**Status:** pre-release implementation checklist
**Contract:** [REST-API-OPENAPI.yaml](REST-API-OPENAPI.yaml)
**Scope:** every runtime legacy WebServer action that should matter to a local
controller, plus explicit exclusions for presentation-only or host-level
actions.

## Classification Rules

| Status | Meaning |
|---|---|
| `implemented` | Current `main` already exposes equivalent REST behavior, though route shape or envelope may still need alignment with the OpenAPI contract. |
| `deferred` | Required before the complete broadband REST release, but not yet implemented or not yet verified against the OpenAPI contract. |
| `obsolete` | Intentionally excluded from REST because it is legacy web-page presentation state, session plumbing, binary streaming, or host OS control. |

`deferred` does not mean optional. It means the work is still required unless
the user explicitly approves removing that runtime capability from the release
contract.

## Contract-Wide Release Requirements

| Requirement | Status | Notes |
|---|---|---|
| REST base path is `/api/v1` | implemented | Existing REST already uses this root. |
| Auth uses `X-API-Key` only | implemented | No REST sessions, no cookie login, and no low-rights REST mode. |
| REST inherits WebServer bind, HTTPS, and allowed-IP exposure controls | implemented | REST remains in-process on the existing listener. |
| JSON success envelope is `{ data, meta }` | implemented | Landed on native `main`; aMuTorrent also unwraps this shape. |
| JSON collection envelope is `{ data: { items: [...] }, meta }` | implemented | List routes request the native item envelope and are wrapped by the v1 response envelope. |
| JSON error envelope is `{ error: { code, message, details? } }` | implemented | Native errors now use `{ error: { code, message } }`; `details` remains optional for future richer validation. |
| Field names are `camelCase` | deferred | Current implementation still has legacy snake_case in some request and response bodies. |
| Mutations return the updated resource when practical | deferred | Current routes often return `{ok:true}`. |
| Bulk endpoints use HTTP 200 with per-item results | deferred | Needed for multi-link download add and future batch controller operations. |
| Destructive file deletion requires explicit `deleteFiles: true` | implemented | Transfer deletes accept `deleteFiles`; legacy `delete_files` remains a compatibility alias. |
| aMuTorrent consumes this OpenAPI surface statically | implemented | The integration branch unwraps native envelopes and prefers the final operation routes. |

## Application And Preferences

| Legacy action | REST target | Status | Impact and notes |
|---|---|---|---|
| Show app/version/runtime information | `GET /app` | implemented | Current REST exposes app data; final route must include static capability map and elevation status. |
| Show global status/statistics summary | `GET /status`, `GET /stats`, `GET /snapshot` | implemented | Current status/snapshot coverage exists; final split needs stable envelopes and richer stat fields. |
| Update WebServer gzip preference | `PATCH /app/preferences` | implemented | Existing preferences route supports curated writes; final body uses `gzip`. |
| Update WebServer refresh interval | `PATCH /app/preferences` | implemented | Final body uses `refreshSeconds`. |
| Update max download speed | `PATCH /app/preferences` | implemented | Final body uses `downloadLimitKiBps`; UI text should present KiB/s and approximate MiB/s. |
| Update max upload speed | `PATCH /app/preferences` | implemented | Final body uses `uploadLimitKiBps`; same unit rule as download. |
| Update max sources per file | `PATCH /app/preferences` | implemented | Final body uses `maxSourcesPerFile`. |
| Update max connections | `PATCH /app/preferences` | implemented | Final body uses `maxConnections`. |
| Update max connections per five seconds | `PATCH /app/preferences` | implemented | Final body uses `maxConnectionsPerFiveSeconds`. |
| Start app shutdown | `POST /app/shutdown` | implemented | Keeps eMule-process shutdown only. Excluded from live destructive mutation loops. |
| Host shutdown or reboot from web UI | none | obsolete | User explicitly excluded OS shutdown/reboot from REST. |
| HTML login/logout/session state | none | obsolete | REST uses API-key auth only and must never fall back to HTML session behavior. |
| HTML template, sort, column, refresh presentation state | none | obsolete | Controller UIs own their own presentation state. |

## Categories

| Legacy action | REST target | Status | Impact and notes |
|---|---|---|---|
| List categories | `GET /categories` | implemented | Existing REST exposes categories; envelope and route contract need final alignment. |
| Create category | `POST /categories` | implemented | Required for aMuTorrent category management. |
| Edit category | `PATCH /categories/{categoryId}` | implemented | Default category id `0` remains protected. |
| Delete category | `DELETE /categories/{categoryId}` | implemented | Must preserve normal eMule constraints. |
| Category tab refresh | `GET /categories` plus UI polling | obsolete | Web UI tab refresh action is presentation-only. |
| Set category priority | `PATCH /categories/{categoryId}` | deferred | Legacy WebServer can alter category priority; final REST contract includes it. |

## Transfers

| Legacy action | REST target | Status | Impact and notes |
|---|---|---|---|
| List downloads | `GET /transfers` | implemented | Current REST already returns transfer rows. |
| Show one download | `GET /transfers/{hash}` | implemented | Current route exists. |
| Add ED2K URL | `POST /transfers` | implemented | Final contract accepts `link` or `links`. |
| Pause transfer | `POST /transfers/{hash}/operations/pause` | implemented | Existing command route must be aligned to resource operation route. |
| Resume transfer | `POST /transfers/{hash}/operations/resume` | implemented | Same route-shape alignment needed. |
| Stop transfer | `POST /transfers/{hash}/operations/stop` | implemented | Same route-shape alignment needed. |
| Cancel transfer | `DELETE /transfers/{hash}` | implemented | Final destructive-body behavior must use `deleteFiles`. |
| Delete transfer local files | `DELETE /transfers/{hash}` with `deleteFiles: true` | implemented | `deleteFiles` is the preferred spelling. |
| Clear completed transfers | `POST /transfers/operations/clear-completed` | implemented | Uses the existing main-window clear-completed path. |
| Rename incomplete transfer | `PATCH /transfers/{hash}` | implemented | Current main includes rename support for incomplete files only. |
| Set transfer priority low/normal/high/auto | `PATCH /transfers/{hash}` | implemented | Final enum is `low`, `normal`, `high`, `auto`; completed/shared priority is separate. |
| Set transfer category | `PATCH /transfers/{hash}` | implemented | Supports category id/name; final naming must be `categoryId`/`categoryName`. |
| File recheck | `POST /transfers/{hash}/operations/recheck` | implemented | Existing route exists; final route and envelope need alignment. |
| Preview transfer | `POST /transfers/{hash}/operations/preview` | implemented | Route validates preview readiness before launching the legacy preview action. |
| Get transfer sources | `GET /transfers/{hash}/sources` | implemented | Current route exists. |
| Get transfer part/gap/request detail | `GET /transfers/{hash}/details` | implemented | Native route returns transfer, part, and source detail; aMuTorrent hydrates part/gap/request fields from it. |
| Browse source | `POST /transfers/{hash}/sources/{clientId}/operations/browse` | implemented | Uses source user hash as the stable selector where available. |
| Add/remove friend from transfer peer user hash | `POST /friends`, `DELETE /friends/{userHash}` | deferred | Friend operations are needed for old context-menu parity. |
| Hide transfer columns or update transfer table sort | none | obsolete | Presentation state belongs to aMuTorrent or any other controller. |

## Shared Files And Shared Directories

| Legacy action | REST target | Status | Impact and notes |
|---|---|---|---|
| List shared files | `GET /shared-files` | implemented | Current REST has shared-file listing. |
| Show one shared file | `GET /shared-files/{hash}` | implemented | Current route exists. |
| Add one shared file by path | `POST /shared-files` | implemented | Current route exists; final response should return resource envelope. |
| Unshare one file | `DELETE /shared-files/{hash}` | implemented | Existing behavior needs final `deleteFiles` naming and tests. |
| Delete shared local file | `DELETE /shared-files/{hash}` with `deleteFiles: true` | deferred | aMuTorrent now routes shared-file deletes to `/shared-files/{hash}`; native disk deletion is still intentionally not implemented. |
| Set shared-file upload priority | `PATCH /shared-files/{hash}` | implemented | Supports `very_low`, `low`, `normal`, `high`, `very_high`, `release`, and `auto`. |
| Update shared-file comment/rating | `PATCH /shared-files/{hash}` | implemented | Current main supports comment/rating for completed shared files. |
| Get ED2K link | `GET /shared-files/{hash}/ed2k-link` | implemented | Metadata only; binary file streaming remains excluded. |
| Show known file comments | `GET /shared-files/{hash}/comments` | implemented | Returns the local known-file comment/rating metadata as a comments collection. |
| Binary file download from WebServer `getfile` | none | obsolete | User explicitly excluded binary shared-file streaming. |
| Reload shared files | `POST /shared-files/operations/reload` and `/shared-directories/operations/reload` | implemented | Existing reload route exists; final contract names operation routes. |
| List shared directories | `GET /shared-directories` | implemented | Current REST supports configured roots. |
| Replace shared directory roots | `PATCH /shared-directories` | implemented | Current live E2E covers persistence. |
| Auto-share folder live monitor add/remove file events | `GET /shared-files` plus live E2E | implemented | Live REST test coverage exists in `eMule-build-tests`; final contract stays resource-based. |
| Shared-files sort/column state | none | obsolete | Presentation-only. |

## Uploads And Queue

| Legacy action | REST target | Status | Impact and notes |
|---|---|---|---|
| List active uploads | `GET /uploads` | implemented | Current REST exposes uploads; aMuTorrent currently drops this data in its data pipeline. |
| List upload queue | `GET /upload-queue` | implemented | Current REST exposes queue. |
| Remove upload client | `DELETE /uploads/{clientId}` | implemented | Existing command route must align to resource route and stable selector. |
| Give release slot | `POST /uploads/{clientId}/operations/release-slot` | implemented | Existing route exists; final selector and envelope need verification. |
| Upload context menu ban | future peer control route | deferred | Useful pro-user action, but exact peer selector and legacy equivalence need implementation design. |
| Upload queue context menu friend actions | `POST /friends`, `DELETE /friends/{userHash}` | deferred | Same friend route should serve transfer and upload contexts. |

## Servers

| Legacy action | REST target | Status | Impact and notes |
|---|---|---|---|
| List servers | `GET /servers` | implemented | Current REST exposes list/status through earlier route shapes. |
| Show server status | `GET /status`, `GET /servers` | implemented | Final contract folds status into resource rows and `/status`. |
| Connect to best server | `POST /servers/operations/connect` | implemented | Existing route exists; final route is resource-operation shaped. |
| Connect to specific server | `POST /servers/{serverId}/operations/connect` | implemented | `serverId` is URL-encoded `address:port`. |
| Disconnect or stop connecting | `POST /servers/operations/disconnect` | implemented | Covers both disconnect and stop-connecting legacy actions. |
| Add server | `POST /servers` | implemented | Final create supports `address`, `port`, `name`, `priority`, `static`, and `connect`. |
| Remove server | `DELETE /servers/{serverId}` | implemented | Existing route exists. |
| Add server to static list | `PATCH /servers/{serverId}` with `static: true` | implemented | Static membership is handled as a server property. |
| Remove server from static list | `PATCH /servers/{serverId}` with `static: false` | implemented | Static membership is handled as a server property. |
| Set server priority low/normal/high | `PATCH /servers/{serverId}` | implemented | Priority is handled as a server property. |
| Update server.met from URL | `POST /servers/met-url-imports` | implemented | Marshalled through the existing UI interaction path. |

## Kad

| Legacy action | REST target | Status | Impact and notes |
|---|---|---|---|
| Show Kad status | `GET /kad` | implemented | Current status route exists. |
| Start Kad | `POST /kad/operations/start` | implemented | Existing command route must align to final route. |
| Stop Kad | `POST /kad/operations/stop` | implemented | Existing command route must align to final route. |
| Recheck Kad firewall | `POST /kad/operations/recheck-firewall` | implemented | Existing route exists. |
| Bootstrap Kad | `POST /kad/operations/bootstrap` | implemented | Supports optional `{address, port}` and otherwise starts Kad through the legacy UI action. |

## Searches

| Legacy action | REST target | Status | Impact and notes |
|---|---|---|---|
| Start search | `POST /searches` | implemented | Existing route exists through earlier shape; final contract uses resource create. |
| Get search results | `GET /searches/{searchId}` | implemented | aMuTorrent should poll this until stable. |
| Stop/delete one search | `DELETE /searches/{searchId}` | implemented | Existing stop route exists; final route deletes the search session. |
| Delete all searches | `DELETE /searches` | implemented | Uses the existing delete-all-searches UI action. |
| Start search with method/type/min/max/availability/extension filters | `POST /searches` | implemented | Method, type, size, and extension filters are parsed by the native command seam. |
| Add selected search result to downloads | `POST /searches/{searchId}/results/{hash}/operations/download` | implemented | aMuTorrent uses this route when a native search id is available. |
| Clear searches before new search | `POST /searches` with `clearExisting: true` or `DELETE /searches` | deferred | Contract supports both explicit clear and start-with-clear behavior. |
| Search page sort, table layout, and refresh | none | obsolete | Presentation-only. |

## Logs

| Legacy action | REST target | Status | Impact and notes |
|---|---|---|---|
| Show recent log lines | `GET /logs` | implemented | Current REST has bounded recent logs. |
| Warning when process runs elevated | `GET /logs` plus app startup warning | implemented | Startup warning was added earlier; REST exposes recent log buffer. |
| Detailed build warnings | none | obsolete | Build logs are workspace artifacts, not runtime REST data. |

## Explicit Non-Goals

| Legacy or possible action | Status | Rationale |
|---|---|---|
| Binary shared-file streaming through REST | obsolete | Metadata and ED2K links are enough for controller integration; local file serving changes risk profile. |
| Host OS shutdown/reboot | obsolete | Not needed by aMuTorrent and too destructive for the trusted local API. |
| HTML WebServer sessions and low-rights mode | obsolete | REST is all-in behind `X-API-Key`. |
| Dynamic capability negotiation | obsolete | eMule BB and aMuTorrent ship together; static contract compliance is simpler and stricter. |
| Granular REST permissions | obsolete | User explicitly chose all-in API-key behavior. |

## aMuTorrent Gap Checklist

| Area | Status | Work required |
|---|---|---|
| Endpoint adapter route names | implemented | aMuTorrent now prefers final operation/resource routes for transfers, servers, shared reload, and search-result download. |
| Response envelopes | implemented | aMuTorrent unwraps `{data, meta}` and native `{error:{code,message}}` while keeping old mock compatibility. |
| Shared-file deletion | implemented | Shared deletes call `/shared-files/{hash}` instead of transfer delete helpers. |
| Uploads in data pipeline | implemented | `/uploads` rows remain preserved through the eMule BB manager fetch result. |
| Transfer detail hydration | implemented | aMuTorrent hydrates peers plus part/gap/request detail from `/transfers/{hash}/details`. |
| Search polling | deferred | Poll `/searches/{searchId}` until stopped/complete instead of fetching once immediately. |
| Browser smoke | deferred | Add live aMuTorrent browser smoke against a live eMule BB instance. |

## Release Gate

The complete REST release is not done until all of these pass from supported
workspace entrypoints:

| Gate | Status |
|---|---|
| eMule app validation/build/tests | deferred |
| Native REST route and contract tests | deferred |
| Live eMule REST E2E completeness lane | deferred |
| aMuTorrent Node eMule BB tests | implemented |
| Live aMuTorrent browser smoke against eMule BB | deferred |
