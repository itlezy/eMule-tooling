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
| JSON success envelope is `{ data, meta }` | deferred | Current implementation uses mixed raw objects and `{items}` shapes. |
| JSON collection envelope is `{ data: { items: [...] }, meta }` | deferred | Required for aMuTorrent adapter consistency. |
| JSON error envelope is `{ error: { code, message, details? } }` | deferred | Existing errors need typed consistency pass. |
| Field names are `camelCase` | deferred | Current implementation still has legacy snake_case in some request and response bodies. |
| Mutations return the updated resource when practical | deferred | Current routes often return `{ok:true}`. |
| Bulk endpoints use HTTP 200 with per-item results | deferred | Needed for multi-link download add and future batch controller operations. |
| Destructive file deletion requires explicit `deleteFiles: true` | deferred | Current delete bodies need final naming and route audit. |
| aMuTorrent consumes this OpenAPI surface statically | deferred | No dynamic capability negotiation is planned for release. |

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
| Delete transfer local files | `DELETE /transfers/{hash}` with `deleteFiles: true` | deferred | Must be explicit and tested. |
| Clear completed transfers | `POST /transfers/operations/clear-completed` | deferred | Legacy WebServer supports clear-completed; final REST needs a stable operation route. |
| Rename incomplete transfer | `PATCH /transfers/{hash}` | implemented | Current main includes rename support for incomplete files only. |
| Set transfer priority low/normal/high/auto | `PATCH /transfers/{hash}` | implemented | Final enum is `low`, `normal`, `high`, `auto`; completed/shared priority is separate. |
| Set transfer category | `PATCH /transfers/{hash}` | implemented | Supports category id/name; final naming must be `categoryId`/`categoryName`. |
| File recheck | `POST /transfers/{hash}/operations/recheck` | implemented | Existing route exists; final route and envelope need alignment. |
| Preview transfer | `POST /transfers/{hash}/operations/preview` | deferred | Legacy `preview`/`getflc` action needs controller-safe route and live test. |
| Get transfer sources | `GET /transfers/{hash}/sources` | implemented | Current route exists. |
| Get transfer part/gap/request detail | `GET /transfers/{hash}/details` | deferred | Required by aMuTorrent detail view; current adapter has placeholders. |
| Browse source | `POST /transfers/{hash}/sources/{clientId}/operations/browse` | deferred | Legacy source browse exists; final implementation must verify that `clientId` is stable enough for this operation. |
| Add/remove friend from transfer peer user hash | `POST /friends`, `DELETE /friends/{userHash}` | deferred | Friend operations are needed for old context-menu parity. |
| Hide transfer columns or update transfer table sort | none | obsolete | Presentation state belongs to aMuTorrent or any other controller. |

## Shared Files And Shared Directories

| Legacy action | REST target | Status | Impact and notes |
|---|---|---|---|
| List shared files | `GET /shared-files` | implemented | Current REST has shared-file listing. |
| Show one shared file | `GET /shared-files/{hash}` | implemented | Current route exists. |
| Add one shared file by path | `POST /shared-files` | implemented | Current route exists; final response should return resource envelope. |
| Unshare one file | `DELETE /shared-files/{hash}` | implemented | Existing behavior needs final `deleteFiles` naming and tests. |
| Delete shared local file | `DELETE /shared-files/{hash}` with `deleteFiles: true` | deferred | Destructive path must be explicit and separate from transfer deletion in aMuTorrent. |
| Set shared-file upload priority | `PATCH /shared-files/{hash}` | deferred | Legacy supports very-low/low/normal/high/release/auto. |
| Update shared-file comment/rating | `PATCH /shared-files/{hash}` | implemented | Current main supports comment/rating for completed shared files. |
| Get ED2K link | `GET /shared-files/{hash}/ed2k-link` | deferred | Metadata only; binary file streaming remains excluded. |
| Show known file comments | `GET /shared-files/{hash}/comments` | deferred | Legacy `commentlist` should become a metadata route. |
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
| Add server to static list | `PATCH /servers/{serverId}` with `static: true` | deferred | Legacy action exists; final REST treats static as a server property. |
| Remove server from static list | `PATCH /servers/{serverId}` with `static: false` | deferred | Same as above. |
| Set server priority low/normal/high | `PATCH /servers/{serverId}` | deferred | Legacy action exists; final REST treats priority as a server property. |
| Update server.met from URL | `POST /servers/met-url-imports` | deferred | Legacy action exists and should be available to aMuTorrent. |

## Kad

| Legacy action | REST target | Status | Impact and notes |
|---|---|---|---|
| Show Kad status | `GET /kad` | implemented | Current status route exists. |
| Start Kad | `POST /kad/operations/start` | implemented | Existing command route must align to final route. |
| Stop Kad | `POST /kad/operations/stop` | implemented | Existing command route must align to final route. |
| Recheck Kad firewall | `POST /kad/operations/recheck-firewall` | implemented | Existing route exists. |
| Bootstrap Kad | `POST /kad/operations/bootstrap` | deferred | Legacy `WEBGUIIA_KAD_BOOTSTRAP` exists; final API must support it. |

## Searches

| Legacy action | REST target | Status | Impact and notes |
|---|---|---|---|
| Start search | `POST /searches` | implemented | Existing route exists through earlier shape; final contract uses resource create. |
| Get search results | `GET /searches/{searchId}` | implemented | aMuTorrent should poll this until stable. |
| Stop/delete one search | `DELETE /searches/{searchId}` | implemented | Existing stop route exists; final route deletes the search session. |
| Delete all searches | `DELETE /searches` | deferred | Legacy action exists. |
| Start search with method/type/min/max/availability/extension filters | `POST /searches` | deferred | Basic search exists; full filter parity needs verification and tests. |
| Add selected search result to downloads | `POST /searches/{searchId}/results/{hash}/operations/download` | deferred | Required for full legacy WebServer and aMuTorrent search workflow parity. |
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
| Endpoint adapter route names | deferred | Update aMuTorrent to call the final resource routes, not older command-style aliases. |
| Response envelopes | deferred | Teach aMuTorrent to unwrap `{data, meta}` and collection `{data.items}` consistently. |
| Shared-file deletion | deferred | Ensure shared-file deletes call `/shared-files/{hash}` and never transfer delete helpers. |
| Uploads in data pipeline | deferred | Preserve `/uploads` and `/upload-queue` rows through aMuTorrent `DataFetchService`. |
| Transfer detail hydration | deferred | Replace placeholder part/gap/request fields with `/transfers/{hash}/details`. |
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
| aMuTorrent Node eMule BB tests | deferred |
| Live aMuTorrent browser smoke against eMule BB | deferred |
