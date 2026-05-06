# eMule Broadband Edition 1.0 Release Backlog

This page is the release-focused view over the active backlog. It does not
replace `INDEX.md`; it narrows the backlog into the work that matters for
`emule-bb-v1.0.0`.

Operator docs:

- [Release 1.0 checklist](RELEASE-1.0-CHECKLIST.md)
- [Release 1.0 runbook](RELEASE-1.0-RUNBOOK.md)
- [Release 1.0 REST/Arr execution plan](RELEASE-1.0-REST-ARR-EXECUTION-PLAN.md)

## Release Identity

- Product name: `eMule broadband edition`
- Compact app/mod name: `eMule BB`
- Release tag: `emule-bb-v1.0.0`
- Release assets:
  - `eMule-broadband-1.0.0-x64.zip`
  - `eMule-broadband-1.0.0-arm64.zip`

## Release Gates

These items block the first public release unless they are explicitly reclassed
by a later release-readiness review.

| ID | Gate | Next implementation slice |
|----|------|---------------------------|
| [BUG-075](BUG-075.md) | REST typed error consistency | Centralize route/auth/parse/validation/internal failure envelopes and lock HTTP status mapping in native tests. |
| [BUG-076](BUG-076.md) | Malformed WebServer/REST hardening | Add malformed JSON, method, path, content-type, and body-size cases without routing REST failures through legacy HTML login/session behavior. |
| [BUG-077](BUG-077.md) | Concurrent WebServer soak | Add short smoke and longer soak traffic that mixes REST reads, safe mutations, and legacy HTML requests. |
| [CI-011](CI-011.md) | Release live E2E umbrella | Make the aggregate runner publish stable suite result artifacts and document one supported release command. |
| [CI-014](CI-014.md) | REST manifest/live completeness gate | Make native route tests and live REST smoke consume or validate the checked-in OpenAPI contract. |
| [CI-015](CI-015.md) | REST malformed/concurrent matrix | Turn the malformed and concurrent request cases into selectable smoke/soak budgets. |
| [AMUT-001](AMUT-001.md) | aMuTorrent live E2E validation | Run aMuTorrent against a live eMule BB instance and capture browser console plus REST request artifacts. |
| [ARR-001](ARR-001.md) | Arr live E2E validation | Validate Prowlarr Torznab, Radarr/Sonarr indexer sync/search, and qBittorrent-compatible add/mutate/delete flows against live eMule BB. |
| [FEAT-050](FEAT-050.md) | Download completion hook | Add the disabled-by-default executable-only completion hook with native tests for token expansion, launch validation, and shutdown skip behavior. |

## Release Candidates

These are desirable for 1.0, but should stay out of the blocking gate unless
the gate work proves that a controller cannot ship without them.

| ID | Candidate | Ship decision |
|----|-----------|---------------|
| [FEAT-032](FEAT-032.md) | NAT mapping live validation | Finish MiniUPnP and PCP/NAT-PMP live validation if the local network can prove it cleanly; do not delay 1.0 solely for unavailable PCP/NAT-PMP conditions. |
| [FEAT-045](FEAT-045.md) | Transfer detail endpoint | Ship if aMuTorrent needs hydrated transfer detail for useful release views; otherwise document as 1.1 follow-up. |
| [FEAT-046](FEAT-046.md) | Server/Kad bootstrap/import APIs | Finish Kad import if live-wire bootstrap needs it; otherwise keep server import/bootstrap coverage and defer the rest. |
| [FEAT-047](FEAT-047.md) | Search API completeness | Passed; paging/bounds semantics are documented for Release 1.0. |
| [FEAT-048](FEAT-048.md) | Upload queue control completeness | Audit and test existing upload controls first; add only release-critical missing operations. |
| [FEAT-049](FEAT-049.md) | Curated REST preference expansion | Add only settings directly required by aMuTorrent or release E2E automation. |
| [AMUT-002](AMUT-002.md) | aMuTorrent transfer detail hydration | Depends on FEAT-045; degrade cleanly when the endpoint is absent. |

## Explicitly Deferred From 1.0

These items stay tracked in the backlog, but are not first-release blockers:

- Boost migration group: `REF-008` through `REF-014`
- dependency upgrades: `REF-028`, `REF-034`
- broad socket/network rewrites: `REF-029`, `REF-030`, `FEAT-018`, `FEAT-035`,
  `FEAT-036`
- broad product/UI features: `FEAT-017`, `FEAT-019`, `FEAT-021`, `FEAT-031`,
  `FEAT-037`, `FEAT-039`, `FEAT-040`, `FEAT-041`, `FEAT-043`, `FEAT-044`
- broad cleanup/modern-library work: `REF-021`, `REF-023`, `REF-025`,
  `REF-032`, `REF-033`, `REF-035`, `REF-036`, `CI-001` through `CI-007`,
  `CI-010`
- non-release hardening watchpoints: `BUG-031`, `BUG-034`, `BUG-035`,
  `FEAT-001`, `FEAT-002` through `FEAT-006`, `FEAT-034`, `CI-008`, `CI-012`,
  `CI-013`, `CI-016`

Deferred does not mean unimportant. It means 1.0 should ship only after the
release gates are meaningful, not after every useful future item is complete.

## Execution Order

1. REST error envelope and malformed request hardening:
   `BUG-075`, `BUG-076`.
2. Contract-driven REST completeness:
   `CI-014`; keep the closed `FEAT-047` search semantics in sync with OpenAPI
   if the search contract changes.
3. REST robustness matrix:
   `CI-015`, `BUG-077`.
4. Release E2E runner and operator command:
   `CI-011`.
5. Download completion hook:
   `FEAT-050`.
6. aMuTorrent and Arr integration validation:
   `AMUT-001`, `ARR-001`, with `FEAT-045` and `AMUT-002` pulled in only if the
   live controller gates prove transfer details are required for a useful
   release.

## What 1.0 Showcases

- broadband upload behavior, queue/scoring work, modern defaults, and large
  library handling
- long-path support, shared startup cache, monitored recursive shared roots,
  and safer file persistence
- REST automation, aMuTorrent, Prowlarr, Radarr, and Sonarr live E2E proof
- disabled-by-default completion automation for local workflows
- WebServer hardening and typed REST errors for reliable local controllers

## Release Candidate Validation

Before tagging `emule-bb-v1.0.0`, run:

- `pwsh -File repos\eMule-build\workspace.ps1 validate`
- `pwsh -File repos\eMule-build\workspace.ps1 build-app -Config Debug -Platform x64`
- `pwsh -File repos\eMule-build\workspace.ps1 build-app -Config Release -Platform x64`
- `pwsh -File repos\eMule-build\workspace.ps1 build-tests -Config Debug -Platform x64`
- `pwsh -File repos\eMule-build\workspace.ps1 build-tests -Config Release -Platform x64`
- native parity tests through the supported `test` command
- release live E2E through the supported `live-e2e` command, including:
  - aMuTorrent browser integration
  - Prowlarr Torznab integration
  - Radarr and Sonarr through Prowlarr plus qBittorrent-compatible download
    control

Public-network unavailable results are acceptable only when the harness records
the run as inconclusive with enough diagnostics to distinguish environment
failure from product failure.

Record the command, implementation commit, artifact path, and final ship
decision for every gate in
[RELEASE-1.0-CHECKLIST](RELEASE-1.0-CHECKLIST.md).
