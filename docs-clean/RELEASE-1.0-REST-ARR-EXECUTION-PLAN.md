# Release 1.0 REST and Arr Execution Plan

This is the tracked working plan for completing the Release 1 REST, Arr,
aMuTorrent, robustness, long-path, and WebServer-boundary gates.

It complements, but does not replace, the release backlog, checklist, and
runbook:

- [RELEASE-1.0](RELEASE-1.0.md)
- [RELEASE-1.0-CHECKLIST](RELEASE-1.0-CHECKLIST.md)
- [RELEASE-1.0-RUNBOOK](RELEASE-1.0-RUNBOOK.md)

## Decisions

- Native `/api/v1` cleanliness wins over current client compatibility.
- Breaking pre-release REST contracts is allowed when it makes eMule BB cleaner.
- aMuTorrent adapts to the native REST API; it does not define that API.
- Arr compatibility is an adapter layer over shared native logic.
- Legacy WebServer cleanup is limited to REST/WebServer boundary safety and
  shared request/path/concurrency code. Do not rewrite or retire the legacy HTML
  UI for Release 1.
- Release 1 requires full live aMuTorrent and Arr gate success. Public-network
  or external-service failures must be fixed and rerun successfully before the
  tag.

## Tracking Rules

Use these status values in this document:

- `Open`
- `In Progress`
- `Ready For Validation`
- `Passed`
- `Blocked`
- `Deferred By Decision`

For each completed implementation slice, record:

- implementation commit
- validation command
- artifact path or report path
- blocker notes, if any

Only promote release checklist rows to `Passed` when the exact gate validation
has completed and the artifact is recorded in
[RELEASE-1.0-CHECKLIST](RELEASE-1.0-CHECKLIST.md).

## Recent Progress

| ID | Status | Evidence | Notes |
|----|--------|----------|-------|
| `BUG-075` | Passed | `fcedfe3`, `c8e6609`, `1e2ff57`, `69d9262`, `3c63552` app; `28f17db`, `83093a6`, `c10f2a8`, `8e67131`, `b7406d9`, `957c31a`, `51f8b6b`, `a3f3d56`, `4c2240e`, `bc0ca24` tests; `95fc6e9`, `a5d3d38` tooling | Explicit destructive REST confirmations, content-type seam coverage, centralized native error envelope, method/API-key failure classification, direct route-failure seam coverage, runtime-style error envelope coverage for missing objects, invalid state, service unavailable, and internal command failure classes, adapter-specific qBit text/Torznab XML response contracts, live-smoke JSON-not-HTML native failure assertions, OpenAPI stable error-code enum coverage, and legacy non-JSON smoke guards landed. Debug x64 validation artifacts are recorded in the release checklist. |
| `BUG-076` | Passed | `8d324d4`, `40bac28`, `90c6352`, `41964c8` app; `cee7499`, `214b327`, `2746ef1`, `7b002f2`, `f3d8923`, `e0f8ef6`, `aea6934` tests | Native REST target classification now keeps malformed `/api/v1%...` paths on the REST dispatcher, decoded slash/backslash path smuggling is rejected before route matching, lowercase/overlong unsupported REST method tokens preserve the target for native REST failure handling, direct malformed REST route coverage rejects invalid JSON, non-object JSON, content-type failures, malformed/duplicate queries, uppercase hashes, overlong identifiers, and unsupported native routes before command dispatch, HTTP header scanning rejects malformed, oversized, or duplicate `Content-Length` fields, incomplete header buffering is capped before body routing state exists, the socket dispatch path now shares an overflow-safe complete-request guard for declared bodies, and legacy HTML GET targets stay outside native REST and Arr/qBit compatibility dispatch. Debug x64 validation artifacts are recorded in the release checklist. |
| `ARR-001` | In Progress | `87b6f24`, `385273c`, `324c7f7` app; `8786847`, `4e02b3d`, `0fd6e77`, `4339716`, `3c5c963`, `8a85158` tests | qBit form parsing shares native URL-encoded parser logic; strict percent-decoding parity is covered across native, Torznab, qBit form, and nested magnet parsing; qBit-compatible hash inputs normalize while native `/api/v1` hashes stay strict lowercase eD2K identifiers; native and Torznab search text normalization share the same rules; strict unsigned parsing rejects signs, whitespace, overflow, and adapter-bound violations; native and qBit category selectors share category-name trim, UTF-8/control, and length validation; magnet/eD2K conversion rejects unsafe hashes, names, sizes, and percent escapes in both directions. Full live Arr gate remains open. |
| `CI-014` | Passed | `3bc65d6`, `3101391`, `b53627d`, `b8233b0`, `d907fc2`, `69eba5b` tests; `89810c5`, `8b548b3`, `cffd810`, `e3b5d24`, `9560435`, `fee7111`, `f2cc198` tooling | REST smoke consumes OpenAPI body metadata and OpenAPI documents explicit confirmation bodies. Native route specs now fail against OpenAPI method/path and request/query field drift; the unsupported `logs.level` query was removed from OpenAPI. Response envelopes and safe/unsafe classifications are derived from OpenAPI contract metadata and recorded in live contract summaries, and validation now fails if the human REST contract reintroduces active route tables instead of deferring to OpenAPI. Release x64 `build-tests` passed with 0 warnings, and Release x64 REST live E2E passed with 81 contract routes and 8026 stress requests with 0 failures. |
| `CI-015` | In Progress | `f6cc0f9`, `75b4ce7`, `331f70d`, `fe6ee8c` tests | REST stress rows now enforce the native JSON-envelope path and report content-type counts, timeout count, native non-JSON response count, and cleanup shutdown duration. The stress mix now includes native REST reads/mutations/malformed requests, qBit adapter reads and missing-hash mutations, Torznab caps/search validation, and legacy HTML GETs. Release x64 REST live smoke passed with 11111 mixed stress requests, and the soak budget passed with 10997 mixed stress requests; both runs had 0 failures, 0 timeouts, 0 non-JSON native REST responses, and clean app shutdown after stress. `contract-stress` remains open. |
| `BUG-077` | Passed | `f6cc0f9`, `75b4ce7`, `331f70d`, `fe6ee8c` tests | Release x64 REST live soak passed with mixed native REST, qBit, Torznab, and legacy HTML traffic: 10997 completed requests, 0 failures, 0 timeouts, 0 non-JSON native REST responses, and clean app shutdown after stress. |

## Gate Checklist

### 1. `BUG-075` REST Typed Error Consistency

Goal: every native `/api/v1` failure uses a stable JSON error envelope and
status map. Legacy HTML and qBit/Torznab compatibility responses remain
adapter-specific.

- [x] Inventory every native REST failure source:
  - [x] route miss
  - [x] method miss
  - [x] missing API key
  - [x] wrong API key
  - [x] malformed path/query
  - [x] malformed JSON
  - [x] non-object JSON
  - [x] unsupported content type
  - [x] unknown field
  - [x] validation failure
  - [x] missing object
  - [x] invalid state
  - [x] internal command failure
- [x] Define one native REST error envelope with `error.code`,
      `error.message`, and optional bounded `error.details`.
- [x] Centralize native REST status mapping and envelope construction in the
      REST seam layer.
- [x] Keep qBit text responses and Torznab XML responses adapter-specific.
- [x] Keep legacy HTML failures as legacy HTML/text where appropriate.
- [x] Require explicit confirmation bodies for destructive/broad native
      operations.
- [x] Reject non-empty native REST bodies without `application/json`.
- [x] Add seam coverage for stable native error status mapping and envelope
      shape.
- [x] Add seam tests for all error classes and status mappings.
- [x] Add live smoke assertions that native REST failures are JSON, never
      legacy HTML.
- [x] Update OpenAPI shared error schemas if the implementation exposes new
      precise status/error codes.
- [x] Validate with `workspace.ps1 validate`.
- [x] Validate with Debug x64 `build-tests` and `test`.
- [x] Record final implementation commits and artifacts in the release
      checklist.

### 2. `BUG-076` Malformed WebServer/REST Boundary Hardening

Goal: malformed REST requests fail as REST and never fall through into legacy
HTML login/session behavior.

- [x] Harden request-line and method parsing before dispatch.
- [x] Ensure unsupported `/api/v1` methods return native REST failures.
- [x] Ensure malformed REST path escapes do not enter legacy HTML routing.
- [x] Ensure body-size and `Content-Length` limits fail cleanly:
  - [x] Reject malformed, oversized, and duplicate `Content-Length` headers.
  - [x] Cap buffered growth before a valid `Content-Length` can be parsed.
- [x] Ensure truncated or partial bodies do not dispatch unpredictably.
- [x] Add malformed cases:
  - [x] invalid JSON syntax
  - [x] JSON array/string/number body
  - [x] wrong `Content-Type`
  - [x] missing `Content-Type` with body
  - [x] lowercase method
  - [x] overlong method token
  - [x] malformed query escape
  - [x] duplicate query parameter
  - [x] malformed path escape
  - [x] uppercase hash where lowercase is required
  - [x] overlong identifiers
  - [x] unsupported `/api/v1` route
- [x] Add a legacy HTML smoke GET after REST hardening.
- [x] Validate with `workspace.ps1 validate`.
- [x] Validate with Debug x64 `build-tests` and `test`.
- [x] Record evidence in the release checklist.

### 3. `CI-014` Contract-Driven REST Completeness

Goal: OpenAPI is the canonical executable `/api/v1` contract for tests and live
coverage.

- [x] Keep `docs/REST-API-OPENAPI.yaml` as the machine-readable contract.
- [x] Parse OpenAPI route, method, operation, tag, and request-body metadata in
      the live REST smoke runner.
- [x] Fail static smoke parity when a required request body has no safe live
      payload.
- [x] Extend contract validation to response envelope class and safety
      classification.
- [x] Make native route seam tests fail on OpenAPI drift:
  - [x] missing route
  - [x] extra undocumented route
  - [x] method mismatch
  - [x] request body field mismatch
  - [x] query field mismatch
- [x] Add a docs drift check for `REST-API-CONTRACT.md`, or remove duplicated
      route tables from the human doc and point to OpenAPI.
- [x] Ensure `/app/shutdown` is always excluded from live mutation loops.
- [x] Record route coverage by family in live reports.
- [x] Validate with Release x64 `build-tests`.
- [x] Validate with `live-e2e -Config Release -Platform x64 -LiveSuite rest-api`.
- [x] Record REST child report and aggregate result JSON in the release
      checklist.

### 4. `CI-015` and `BUG-077` Stress, Malformed, and Concurrency Matrix

Goal: release-gate smoke and operator soak budgets prove REST, adapters, and
legacy WebServer boundary traffic stay stable under mixed concurrent load.

- [ ] Make stress budgets explicit and selectable:
  - [x] `smoke`
  - [x] `soak`
  - [ ] `contract-stress`
- [ ] Cover concurrent request classes:
  - [x] native REST reads
  - [x] safe native REST mutations
  - [x] malformed native REST requests
  - [x] qBit adapter reads/missing-hash mutations
  - [x] Torznab caps/search validation requests
  - [x] legacy HTML GET requests
- [ ] Add stress metrics:
  - [x] requests started/completed
  - [x] status counts
  - [x] method counts
  - [x] route family counts
  - [x] scenario counts
  - [x] p50/p95/max latency
  - [x] timeout count
  - [x] sampled failures
  - [x] shutdown duration after stress
- [ ] Enforce invariants:
  - [x] no native REST response unexpectedly HTML/text
  - [x] no request exceeds configured timeout
  - [x] no REST listener disappearance
  - [x] app shuts down cleanly after stress
  - [x] no session or bad-login corruption symptoms under mixed traffic
- [x] Validate release smoke with
      `live-e2e -Config Release -Platform x64 -LiveSuite rest-api
      -RestStressBudget smoke`.
- [x] Validate operator soak with
      `live-e2e -Config Release -Platform x64 -LiveSuite rest-api
      -RestStressBudget soak`.
- [x] Record stress reports and aggregate result JSON in the release checklist.

### 5. Native `/api/v1` Clean Contract Pass

Goal: native REST is internally clean and stable; aMuTorrent and adapters follow
it.

- [ ] Audit every OpenAPI route against implementation and aMuTorrent usage.
- [ ] Break or rename pre-release routes where needed for a clean resource and
      operation model.
- [ ] Keep strict field rules:
  - [ ] lowercase 32-character eD2K hashes
  - [ ] explicit booleans for destructive intent
  - [ ] bounded unsigned integers
  - [ ] UTF-8 text without controls
  - [ ] mutually exclusive selectors rejected early
- [ ] Close `FEAT-047` search documentation gap:
  - [ ] document search paging/bounds behavior
  - [ ] verify server/global/Kad/automatic live corpus coverage
  - [ ] preserve stock eD2K/Kad search semantics
- [ ] Promote release candidates only from live evidence:
  - [ ] `FEAT-045` only if transfer details are required
  - [ ] `FEAT-046` only if bootstrap/import is required
  - [ ] `FEAT-048` only if upload controls are required
  - [ ] `FEAT-049` only if preferences are required

### 6. Shared Native REST and Arr Adapter Logic

Goal: adapters do not duplicate native parser, validation, or normalization
logic.

- [x] Share URL-encoded key/value parsing between native query handling and
      qBit form parsing.
- [x] Share or prove shared behavior for:
  - [x] strict percent decoding
  - [x] hash normalization and validation
  - [x] search text normalization
  - [x] bounded unsigned parsing
  - [x] category selector validation
  - [x] magnet/eD2K conversion safety
- [ ] Keep adapter-specific code only for:
  - [ ] Torznab XML/feed shape
  - [ ] qBit text responses and session-cookie compatibility
  - [ ] Prowlarr/Radarr/Sonarr harness setup
- [ ] Add seam tests proving identical behavior across:
  - [x] native query strings
  - [x] Torznab query strings
  - [x] qBit form bodies
  - [x] nested qBit magnet query strings

### 7. `ARR-001` Full Arr Live E2E

Goal: Prowlarr, Radarr, Sonarr, and qBit-compatible flows pass against live
eMule BB.

- [x] Add low-risk direct Torznab/qBit smoke inside the REST live smoke lane.
- [ ] Stabilize direct eMule BB adapter checks:
  - [ ] Torznab caps
  - [ ] Torznab auth by header and query API key
  - [ ] Torznab malformed query errors
  - [ ] Torznab direct search results
  - [ ] qBit login/session
  - [ ] qBit categories
  - [ ] qBit info/properties/files
  - [ ] qBit add invalid and synthetic magnet paths
  - [ ] qBit pause/resume/stop/start/delete/setCategory flows
- [ ] Validate Prowlarr:
  - [ ] create/update Generic Torznab indexer
  - [ ] test indexer
  - [ ] run direct search stress
  - [ ] redact API keys in artifacts
- [ ] Validate Radarr/Sonarr:
  - [ ] sync Prowlarr indexer into both apps
  - [ ] configure temporary qBit-compatible download clients
  - [ ] run release/RSS/search checks
  - [ ] trigger qBit-compatible add/mutate/delete into live eMule BB
- [ ] Extend reports with:
  - [ ] indexer/client IDs
  - [ ] redacted endpoint summaries
  - [ ] route coverage summaries
  - [ ] exact failure bodies with secrets redacted
  - [ ] cleanup results
- [ ] Validate with
      `live-e2e -Config Release -Platform x64 -LiveSuite prowlarr-emulebb
      -LiveSuite radarr-sonarr-emulebb`.
- [ ] Record Prowlarr, Radarr, Sonarr, and aggregate Arr artifacts in the
      release checklist.

### 8. `AMUT-001` aMuTorrent Browser Smoke

Goal: aMuTorrent runs as a UI consumer of the clean native API.

- [ ] Verify aMuTorrent can configure eMule BB host, port, and API key.
- [ ] Verify dashboard connection state renders eD2K and Kad status.
- [ ] Verify these views render without console/request errors:
  - [ ] transfers
  - [ ] shared files
  - [ ] shared directories
  - [ ] categories
  - [ ] searches
  - [ ] uploads/upload queue
  - [ ] logs/status where present
- [ ] Exercise UI flows only where backed by clean native routes:
  - [ ] create/edit/delete category
  - [ ] shared-directory save/reload
  - [ ] search start/stop/result download
  - [ ] transfer pause/resume/delete test item
- [ ] Capture browser console, network artifacts, screenshot or DOM summary,
      and final REST status snapshot.
- [ ] Validate with
      `live-e2e -Config Release -Platform x64 -LiveSuite
      amutorrent-browser-smoke`.
- [ ] Record aMuTorrent artifacts in the release checklist.

### 9. Long Path and Unicode Release Proof

Goal: REST and adapters preserve eMule BB long-path guarantees.

- [ ] Add REST/API-level tests for:
  - [ ] shared-directory roots
  - [ ] shared-file add/reload/list
  - [ ] category incoming paths if exposed
  - [ ] transfer file names from ED2K/magnet conversion
  - [ ] logs/error messages with Unicode text
- [ ] Use existing `LongPathSeams` and Windows APIs instead of direct raw file
      or path calls.
- [ ] Cover edge cases:
  - [ ] paths over `MAX_PATH`
  - [ ] Unicode folder/file names
  - [ ] trailing dot and trailing space preservation where Windows allows it
  - [ ] reserved device names rejected
  - [ ] path traversal rejected
  - [ ] missing parent handled predictably
  - [ ] no API output truncation
- [ ] Add live E2E coverage using existing long-path shared roots where
      possible.
- [ ] Verify no REST/adapter path code uses raw `CFile`, CRT, or Win32 file
      calls where a `LongPathSeams` helper exists.

### 10. Windows API and Custom-Code Audit

Goal: replace custom REST/Arr code with project helpers, standard library, or
Windows APIs where the behavior is already owned.

- [ ] Continue `docs/REST_CUSTOM_CODE_AUDIT.md` for every REST/Arr helper.
- [ ] Audit and mark each helper as:
  - [ ] replaced
  - [ ] kept with reason
  - [ ] deferred
- [ ] Prefer existing helpers/APIs for:
  - [ ] path canonicalization
  - [ ] file I/O
  - [ ] UTF-8/UTF-16 conversion
  - [ ] URL/form parsing
  - [ ] JSON construction
  - [ ] numeric parsing
  - [ ] concurrency/lifetime synchronization
- [ ] Keep local XML escaping only if no pinned XML writer is available and
      tests prove correctness.
- [ ] Require tests and a short comment for every retained custom helper that
      has no existing owner.

### 11. Legacy Boundary Cleanup

Goal: preserve legacy HTML while preventing it from contaminating REST behavior.

- [ ] Prevent REST requests from falling into legacy login/session paths.
- [ ] Keep shared request parsing safe for REST and legacy HTML.
- [ ] Add legacy HTML GETs to concurrent WebServer stress.
- [ ] Fix session or bad-login synchronization only if `BUG-073` or stress
      evidence requires it.
- [ ] Do not redesign templates.
- [ ] Do not migrate HTML routes to REST.
- [ ] Do not remove legacy commands for Release 1.

### 12. Final Release Evidence

- [ ] `workspace.ps1 validate`
- [ ] Debug x64 app build
- [ ] Release x64 app build
- [ ] Debug x64 test build
- [ ] Release x64 test build
- [ ] supported native test command
- [ ] Release x64 `live-e2e -LiveSuite rest-api`
- [ ] Release x64 `live-e2e -LiveSuite rest-api -RestStressBudget soak`
- [ ] Release x64 `live-e2e -LiveSuite amutorrent-browser-smoke`
- [ ] Release x64 `live-e2e -LiveSuite prowlarr-emulebb -LiveSuite
      radarr-sonarr-emulebb`
- [ ] full Release x64 `live-e2e`
- [ ] clean worktrees in active workspace repos
- [ ] release notes reviewed for `eMule broadband edition`
- [ ] release assets named:
  - [ ] `eMule-broadband-1.0.0-x64.zip`
  - [ ] `eMule-broadband-1.0.0-arm64.zip`
