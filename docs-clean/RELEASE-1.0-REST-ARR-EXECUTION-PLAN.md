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
| `ARR-001` | Passed | `87b6f24`, `385273c`, `324c7f7` app; `8786847`, `4e02b3d`, `0fd6e77`, `4339716`, `3c5c963`, `8a85158`, `59f7e6d`, `e78c369` tests; `303f911` tooling | qBit form parsing shares native URL-encoded parser logic; strict percent-decoding parity is covered across native, Torznab, qBit form, and nested magnet parsing; qBit-compatible hash inputs normalize while native `/api/v1` hashes stay strict lowercase eD2K identifiers; native and Torznab search text normalization share the same rules; strict unsigned parsing rejects signs, whitespace, overflow, and adapter-bound violations; native and qBit category selectors share category-name trim, UTF-8/control, and length validation; magnet/eD2K conversion rejects unsafe hashes, names, sizes, and percent escapes in both directions. Direct REST live adapter smoke now covers Torznab caps/auth/malformed/search and qBit login/categories/info/properties/files/add/synthetic-magnet/missing-hash state mutations. Full Prowlarr live E2E passed in `repos\eMule-build-tests\reports\prowlarr-emulebb-live\20260506-191105-eMule-main-release`; full Radarr/Sonarr live E2E passed in `repos\eMule-build-tests\reports\radarr-sonarr-emulebb-live\20260506-191223-eMule-main-release`. |
| `CI-014` | Passed | `3bc65d6`, `3101391`, `b53627d`, `b8233b0`, `d907fc2`, `69eba5b` tests; `89810c5`, `8b548b3`, `cffd810`, `e3b5d24`, `9560435`, `fee7111`, `f2cc198` tooling | REST smoke consumes OpenAPI body metadata and OpenAPI documents explicit confirmation bodies. Native route specs now fail against OpenAPI method/path and request/query field drift; the unsupported `logs.level` query was removed from OpenAPI. Response envelopes and safe/unsafe classifications are derived from OpenAPI contract metadata and recorded in live contract summaries, and validation now fails if the human REST contract reintroduces active route tables instead of deferring to OpenAPI. Release x64 `build-tests` passed with 0 warnings, and Release x64 REST live E2E passed with 81 contract routes and 8026 stress requests with 0 failures. |
| `CI-015` | Passed | `f6cc0f9`, `75b4ce7`, `331f70d`, `fe6ee8c` tests | REST stress rows now enforce the native JSON-envelope path and report content-type counts, timeout count, native non-JSON response count, and cleanup shutdown duration. The stress mix includes native REST reads/mutations/malformed requests, qBit adapter reads and missing-hash mutations, Torznab caps/search validation, and legacy HTML GETs. Release x64 REST live smoke, soak, and `contract-stress` budgets passed with 0 failures, 0 timeouts, 0 non-JSON native REST responses, and clean app shutdown after stress. |
| `BUG-077` | Passed | `f6cc0f9`, `75b4ce7`, `331f70d`, `fe6ee8c` tests | Release x64 REST live soak passed with mixed native REST, qBit, Torznab, and legacy HTML traffic: 10997 completed requests, 0 failures, 0 timeouts, 0 non-JSON native REST responses, and clean app shutdown after stress. |
| `AMUT-001` | Passed | `affc4d6`, `11365ca` tests | aMuTorrent browser smoke now fails on browser console errors, page exceptions, failed page requests, and HTTP-200 error payloads. Release x64 `live-e2e -LiveSuite amutorrent-browser-smoke` passed in `repos\eMule-build-tests\reports\amutorrent-browser-smoke\20260506-193606-eMule-main-release`, with browser diagnostics showing 0 console errors, 0 page errors, and 0 request failures. The smoke covers configured eMule BB host/port/API key, dashboard/network status, category create/delete, ED2K add, search start/results, server action, and shared-directory reload. |
| `FEAT-050` | Passed | `b6ce2ef`, `1db8f7c` app; `ea9f163` tests | The completion hook is disabled by default, executable-only, launched through direct `CreateProcess`, skipped on failed/duplicate/shutdown paths, and covered by native tests for token expansion, literal shell metacharacters, missing executable validation, and retained-success launch request construction. Debug x64 `build-tests` and `test` passed with `483/483` native cases and `2686/2686` assertions. |
| `CI-011` | Passed | `7754d16`, `00a7da4`, `3b315a4`, `576f9a1` app; `13f1487`, `1058ac2`, `2bb7fd2`, `a68ac42`, `d929611`, `e5fca8e`, `961efac`, `1f973ae`, `e952b77` tests; `cb0fa27`, `eb079f8`, `bab2ac8`, `56bb1bb` tooling | Release x64 Debug/Release app builds, Debug/Release test builds, focused REST smoke, REST soak, preference UI, and full umbrella live E2E passed. Final umbrella evidence is `repos\eMule-build-tests\reports\live-e2e-suite\20260506-224844-eMule-main-release\result.json`; it records release-blocking REST, aMuTorrent, Prowlarr, Radarr/Sonarr, shared-directory, preference UI, startup/stability, and config/shared-file suites as passed, with `auto-browse-live` inconclusive only because no browse-capable live source was available. The clean-worktree audit passed with `pwsh -File repos\eMule-tooling\ci\check-clean-worktree.ps1 -EmuleWorkspaceRoot .`. Release identity, release-note product naming, and ZIP asset naming are reviewed in `docs\WORKSPACE_POLICY.md`, `docs-clean\RELEASE-1.0.md`, and `docs-clean\RELEASE-1.0-RUNBOOK.md`. |

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

- [x] Make stress budgets explicit and selectable:
  - [x] `smoke`
  - [x] `soak`
  - [x] `contract-stress`
- [x] Cover concurrent request classes:
  - [x] native REST reads
  - [x] safe native REST mutations
  - [x] malformed native REST requests
  - [x] qBit adapter reads/missing-hash mutations
  - [x] Torznab caps/search validation requests
  - [x] legacy HTML GET requests
- [x] Add stress metrics:
  - [x] requests started/completed
  - [x] status counts
  - [x] method counts
  - [x] route family counts
  - [x] scenario counts
  - [x] p50/p95/max latency
  - [x] timeout count
  - [x] sampled failures
  - [x] shutdown duration after stress
- [x] Enforce invariants:
  - [x] no native REST response unexpectedly HTML/text
  - [x] no request exceeds configured timeout
  - [x] no REST listener disappearance
  - [x] app shuts down cleanly after stress
  - [x] no session or bad-login corruption symptoms under mixed traffic
- [x] Validate release smoke with
      `live-e2e -Config Release -Platform x64 -LiveSuite rest-api
      -RestStressBudget smoke`.
- [x] Validate contract stress with
      `live-e2e -Config Release -Platform x64 -LiveSuite rest-api
      -RestCoverageBudget contract-stress`.
- [x] Validate operator soak with
      `live-e2e -Config Release -Platform x64 -LiveSuite rest-api
      -RestStressBudget soak`.
- [x] Record stress reports and aggregate result JSON in the release checklist.

### 5. Native `/api/v1` Clean Contract Pass

Goal: native REST is internally clean and stable; aMuTorrent and adapters follow
it.

- [x] Audit every OpenAPI route against implementation and aMuTorrent usage.
- [x] Break or rename pre-release routes where needed for a clean resource and
      operation model.
- [x] Keep strict field rules:
  - [x] lowercase 32-character eD2K hashes
  - [x] explicit booleans for destructive intent
  - [x] bounded unsigned integers
  - [x] UTF-8 text without controls
  - [x] mutually exclusive selectors rejected early
  - Evidence: `CI-014` live contract coverage exercised the OpenAPI-derived
    route table with 81 routes; `BUG-075`, `BUG-076`, `CI-015`, and the REST
    live smoke assert JSON-not-HTML errors, unknown field/query rejection,
    uppercase hash rejection, explicit destructive booleans, bounded unsigned
    query/body values, UTF-8/control validation, and mutually exclusive
    `categoryId`/`categoryName` selectors.
  - Evidence: `AMUT-001` passed with aMuTorrent adapting to native `/api/v1`
    field names, and the REST contract documents retired command-style routes
    that are not part of the Release 1.0 surface.
- [x] Close `FEAT-047` search documentation gap:
  - [x] document search paging/bounds behavior
  - [x] verify server/global/Kad/automatic live corpus coverage
  - [x] preserve stock eD2K/Kad search semantics
  - Evidence: `docs\REST-API-OPENAPI.yaml` and
    `docs\REST-API-CONTRACT.md` document that
    `GET /api/v1/searches/{searchId}` returns the current native visible
    result snapshot, intentionally does not expose `limit`/`offset` paging in
    Release 1.0, and preserves stock eD2K/Kad search behavior.
- [x] Promote release candidates only from live evidence:
  - [x] `FEAT-045` only if transfer details are required
  - [x] `FEAT-046` only if bootstrap/import is required
  - [x] `FEAT-048` only if upload controls are required
  - [x] `FEAT-049` only if preferences are required
  - Evidence: aMuTorrent, Prowlarr, Radarr/Sonarr, direct REST adapter smoke,
    and shared-directory REST E2E gates passed without proving a release
    blocker for `FEAT-045`, `FEAT-046`, `FEAT-048`, or `FEAT-049`; those remain
    backlog candidates unless a future live gate fails for a concrete missing
    operation.

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
- [x] Keep adapter-specific code only for:
  - [x] Torznab XML/feed shape
  - [x] qBit text responses and session-cookie compatibility
  - [x] Prowlarr/Radarr/Sonarr harness setup
- [x] Add seam tests proving identical behavior across:
  - [x] native query strings
  - [x] Torznab query strings
  - [x] qBit form bodies
  - [x] nested qBit magnet query strings
  - Evidence: `ARR-001` records shared parser, conversion, hash, search-text,
    unsigned-number, category, and magnet/eD2K validation behavior across
    native REST, Torznab, and qBittorrent compatibility. Remaining
    adapter-owned code is limited to compatibility response shapes and live
    harness setup.

### 7. `ARR-001` Full Arr Live E2E

Goal: Prowlarr, Radarr, Sonarr, and qBit-compatible flows pass against live
eMule BB.

- [x] Add low-risk direct Torznab/qBit smoke inside the REST live smoke lane.
- [x] Stabilize direct eMule BB adapter checks:
  - [x] Torznab caps
  - [x] Torznab auth by header and query API key
  - [x] Torznab malformed query errors
  - [x] Torznab direct search results
  - [x] qBit login/session
  - [x] qBit categories
  - [x] qBit info/properties/files
  - [x] qBit add invalid and synthetic magnet paths
  - [x] qBit pause/resume/stop/start/delete/setCategory flows
- [x] Validate Prowlarr:
  - [x] create/update Generic Torznab indexer
  - [x] test indexer
  - [x] run direct search stress
  - [x] redact API keys in artifacts
- [x] Validate Radarr/Sonarr:
  - [x] sync Prowlarr indexer into both apps
  - [x] configure temporary qBit-compatible download clients
  - [x] run release/RSS/search checks
  - [x] trigger qBit-compatible add/mutate/delete into live eMule BB
- [x] Extend reports with:
  - [x] indexer/client IDs
  - [x] redacted endpoint summaries
  - [x] route coverage summaries
  - [x] exact failure bodies with secrets redacted
  - [x] cleanup results
- [x] Validate with
      `live-e2e -Config Release -Platform x64 -LiveSuite prowlarr-emulebb`
      and `live-e2e -Config Release -Platform x64 -LiveSuite
      radarr-sonarr-emulebb`.
- [x] Record Prowlarr, Radarr, Sonarr, and aggregate Arr artifacts in the
      release checklist.

### 8. `AMUT-001` aMuTorrent Browser Smoke

Goal: aMuTorrent runs as a UI consumer of the clean native API.

- [x] Verify aMuTorrent can configure eMule BB host, port, and API key.
- [x] Verify dashboard connection state renders eD2K and Kad status.
- [x] Verify smoke-covered views and API-backed panels render without
      console/request errors:
  - [x] dashboard snapshot
  - [x] categories
  - [x] searches
  - [x] servers/status
  - [x] shared-directory reload path
- [x] Exercise smoke flows backed by clean native routes:
  - [x] category create/delete
  - [x] ED2K add test item
  - [x] search start/results
  - [x] server action
  - [x] shared-directory reload
- [x] Capture browser console, network artifacts, screenshot or DOM summary,
      and final REST status snapshot.
- [x] Validate with
      `live-e2e -Config Release -Platform x64 -LiveSuite
      amutorrent-browser-smoke`.
- [x] Record aMuTorrent artifacts in the release checklist.

### 9. Long Path and Unicode Release Proof

Goal: REST and adapters preserve eMule BB long-path guarantees.

- [x] Add REST/API-level tests for:
  - [x] shared-directory roots
  - [x] shared-file add/reload/list
  - [x] category incoming paths if exposed
  - [x] transfer file names from ED2K/magnet conversion
  - [x] logs/error messages with Unicode text
- [x] Use existing `LongPathSeams` and Windows APIs instead of direct raw file
      or path calls.
- [x] Cover edge cases:
  - [x] paths over `MAX_PATH`
  - [x] Unicode folder/file names
  - [x] trailing dot and trailing space preservation where Windows allows it
  - [x] reserved device names rejected or neutralized before filesystem use
  - [x] path traversal rejected
  - [x] missing parent handled predictably
  - [x] no API output truncation
- [x] Add live E2E coverage using existing long-path shared roots where
      possible.
      - Evidence: `repos\eMule-build-tests\reports\shared-directories-rest\20260506-204215-eMule-main-release\result.json`
        records `long_path_unicode.path_length` as `325`, `over_max_path` as
        `true`, the long Unicode root in REST directory responses and
        persisted path lists, `unicode-U+00DF-U+6F22.txt` in shared-file
        listings before and after relaunch, and the same root echoed as a
        category incoming path by `/api/v1/categories`.
      - Evidence: `repos\eMule-build-tests\reports\shared-directories-rest\20260506-211633-eMule-main-release\result.json`
        records exact-name shared directory `shared-rest-exact-names. \` and
        shared file `shared-file. ` in REST responses before and after relaunch,
        proving trailing dot/space names are preserved for existing filesystem
        objects where Windows allows them.
      - Evidence: `repos\eMule-build-tests\reports\rest-api-smoke\20260506-212037-eMule-main-release`
        records a live `/api/v1/transfers` add for eD2K display name
        `NUL .txt`, verifies REST exposes the created transfer as `NUL_.txt`,
        and deletes the transfer. This proves reserved Win32 device names are
        not accepted as raw download file leaves.
      - Evidence: `repos\eMule-build-tests\reports\rest-api-smoke\20260506-213004-eMule-main-release`
        records a live `/api/v1/logs` match for
        the Unicode ED2K transfer filename after the transfer add, proving
        Unicode text survives REST log serialization.
      - The same report records invalid PATCH checks for blank path and
        non-boolean `recursive` fields, proves those errors do not mutate the
        shared-directory model, and records missing-parent roots as accepted
        but `accessible=false`, listable with no files, and clearable.
- [x] Verify no REST/adapter path code uses raw `CFile`, CRT, or Win32 file
      calls where a `LongPathSeams` helper exists.
      - Evidence: source audit covered `WebServerJson`, `WebServerArrCompat`,
        `WebServerQBitCompat`, and static-file path seams. REST/adapter files
        have no direct `CFile`, CRT stream, raw open, raw find, or raw
        attribute probes; REST delete operations call `ShellDeleteFile`, which
        delegates direct deletes to `LongPathSeams::DeleteFile`.

### 10. Windows API and Custom-Code Audit

Goal: replace custom REST/Arr code with project helpers, standard library, or
Windows APIs where the behavior is already owned.

- [x] Continue `docs/REST_CUSTOM_CODE_AUDIT.md` for every REST/Arr helper.
- [x] Audit and mark each helper as:
  - [x] replaced
  - [x] kept with reason
  - [x] deferred
- [x] Prefer existing helpers/APIs for:
  - [x] path canonicalization
  - [x] file I/O
  - [x] UTF-8/UTF-16 conversion
  - [x] URL/form parsing
  - [x] JSON construction
  - [x] numeric parsing
  - [x] concurrency/lifetime synchronization
- [x] Keep local XML escaping only if no pinned XML writer is available and
      tests prove correctness.
- [x] Require tests and a short comment for every retained custom helper that
      has no existing owner.

### 11. Legacy Boundary Cleanup

Goal: preserve legacy HTML while preventing it from contaminating REST behavior.

- [x] Prevent REST requests from falling into legacy login/session paths.
- [x] Keep shared request parsing safe for REST and legacy HTML.
- [x] Add legacy HTML GETs to concurrent WebServer stress.
- [x] Fix session or bad-login synchronization only if `BUG-073` or stress
      evidence requires it.
- [x] Do not redesign templates.
- [x] Do not migrate HTML routes to REST.
- [x] Do not remove legacy commands for Release 1.
  - Evidence: `repos\eMule-build-tests\scripts\rest-api-smoke.py` keeps
    native REST errors on strict JSON envelopes with `require_error_response`,
    checks legacy `/` separately with `require_legacy_non_json_response`, and
    includes `REST_STRESS_LEGACY_OPERATIONS` only in the concurrent stress
    operation mix.
  - Evidence: `repos\eMule-build-tests\reports\rest-api-smoke\20260506-184530-eMule-main-release\result.json`
    completed 10,997 soak requests with `failure_count=0`,
    `native_rest_non_json_count=0`, and `family_counts.legacy-html=289`.
  - Evidence: `repos\eMule-build-tests\reports\rest-api-smoke\20260506-185112-eMule-main-release\result.json`
    completed 11,188 contract-stress requests with `failure_count=0`,
    `native_rest_non_json_count=0`, and `family_counts.legacy-html=294`.
  - No legacy templates, HTML routes, or legacy commands were redesigned,
    migrated, or removed for this Release 1 boundary proof.

### 12. Final Release Evidence

- [x] `workspace.ps1 validate`
  - Evidence: `pwsh -File repos\eMule-build\workspace.ps1 validate` passed
    after the final REST/Arr checklist documentation updates.
- [x] Debug x64 app build
  - Evidence: `pwsh -File repos\eMule-build\workspace.ps1 build-app
    -Config Debug -Platform x64` passed with log
    `workspaces\v0.72a\state\build-logs\20260506-215932`.
- [x] Release x64 app build
  - Evidence: `pwsh -File repos\eMule-build\workspace.ps1 build-app
    -Config Release -Platform x64` passed with log
    `workspaces\v0.72a\state\build-logs\20260506-215950`.
- [x] Debug x64 test build
  - Evidence: `pwsh -File repos\eMule-build\workspace.ps1 build-tests
    -Config Debug -Platform x64` passed with log
    `workspaces\v0.72a\state\build-logs\20260506-220000`.
- [x] Release x64 test build
  - Evidence: `pwsh -File repos\eMule-build\workspace.ps1 build-tests
    -Config Release -Platform x64` passed with log
    `workspaces\v0.72a\state\build-logs\20260506-220009`.
- [x] supported native test command
- [x] Release x64 `live-e2e -LiveSuite rest-api`
  - Evidence: `repos\eMule-build-tests\reports\rest-api-smoke\20260506-220016-eMule-main-release`
    passed after final Debug/Release app and test builds.
- [x] Release x64 `live-e2e -LiveSuite rest-api -RestStressBudget soak`
  - Evidence: `repos\eMule-build-tests\reports\rest-api-smoke\20260506-220422-eMule-main-release`
    passed after the final focused REST gate.
- [x] Release x64 `live-e2e -LiveSuite amutorrent-browser-smoke`
- [x] Release x64 `live-e2e -LiveSuite prowlarr-emulebb` and
      `live-e2e -LiveSuite radarr-sonarr-emulebb`
- [x] Release x64 `live-e2e -LiveSuite shared-directories-rest`
- [x] full Release x64 `live-e2e`
  - Evidence: `repos\eMule-build-tests\reports\live-e2e-suite\20260506-224844-eMule-main-release\result.json`
    passed after refreshing the preference UI harness to the current IP filter
    setting names. The umbrella recorded `auto-browse-live` as inconclusive
    because no browse-capable live source was available; all release-blocking
    REST, aMuTorrent, Prowlarr, Radarr/Sonarr, shared-directory, and stability
    suites passed.
- [x] clean worktrees in active workspace repos
  - Evidence: `pwsh -File repos\eMule-tooling\ci\check-clean-worktree.ps1
    -EmuleWorkspaceRoot .` passed.
- [x] release notes reviewed for `eMule broadband edition`
  - Evidence: `repos\eMule-tooling\docs\WORKSPACE_POLICY.md`,
    `repos\eMule-tooling\docs-clean\RELEASE-1.0.md`, and
    `repos\eMule-tooling\docs-clean\RELEASE-1.0-RUNBOOK.md` consistently use
    `eMule broadband edition` as the public product name and `eMule BB` as the
    compact app/mod name.
- [x] release assets named:
  - [x] `eMule-broadband-1.0.0-x64.zip`
  - [x] `eMule-broadband-1.0.0-arm64.zip`
  - Evidence: the release asset naming contract is recorded in
    `repos\eMule-tooling\docs\WORKSPACE_POLICY.md`,
    `repos\eMule-tooling\docs-clean\RELEASE-1.0.md`, and
    `repos\eMule-tooling\docs-clean\RELEASE-1.0-RUNBOOK.md`. Package creation
    and annotated tagging remain operator steps after the checklist is complete.
