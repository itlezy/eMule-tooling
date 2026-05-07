# eMule Broadband Edition 1.0 Release Control

This is the active control document for `emule-bb-v1.0.0`. It owns Release 1
gate status, candidate decisions, and final readiness rules.

Current status: `release/v0.72a-broadband` is a pre-release stabilization
branch, not ready for an official release. Do not tag or package
`emule-bb-v1.0.0` until the gates below are revalidated and the operator steps
in the checklist and runbook are complete.

Operator docs:

- [Release 1.0 checklist](RELEASE-1.0-CHECKLIST.md)
- [Release 1.0 runbook](RELEASE-1.0-RUNBOOK.md)
- [REST/Arr deep plan](RELEASE-1.0-REST-ARR-EXECUTION-PLAN.md)

## Release Identity

- Product name: `eMule broadband edition`
- Compact app/mod name: `eMule BB`
- Release tag: `emule-bb-v1.0.0`
- Release assets:
  - `eMule-broadband-1.0.0-x64.zip`
  - `eMule-broadband-1.0.0-arm64.zip`

## Release Gates

These gates must remain passed, or be explicitly revalidated if their evidence
ages out or related code changes.

| ID | Gate | Status | Evidence pointer |
|----|------|--------|------------------|
| [BUG-075](BUG-075.md) | REST typed error consistency | Passed | item completion evidence |
| [BUG-076](BUG-076.md) | Malformed WebServer/REST hardening | Passed | item completion evidence |
| [BUG-077](BUG-077.md) | Concurrent WebServer soak | Passed | item completion evidence |
| [CI-011](CI-011.md) | Release live E2E umbrella | Done | item completion evidence and latest full `live-e2e` report |
| [CI-014](CI-014.md) | REST manifest/live completeness gate | Passed | item completion evidence |
| [CI-015](CI-015.md) | REST malformed/concurrent matrix | Passed | item completion evidence |
| [AMUT-001](AMUT-001.md) | aMuTorrent live E2E validation | Passed | item completion evidence |
| [ARR-001](ARR-001.md) | Arr live E2E validation | Passed | item completion evidence |
| [FEAT-050](FEAT-050.md) | Download completion hook | Passed | item completion evidence |

## Candidate Decisions

These items are desirable but are not Release 1 blockers unless a later gate
failure proves that they are required.

| ID | Candidate | Release 1 decision |
|----|-----------|--------------------|
| [FEAT-032](FEAT-032.md) | NAT mapping live validation | Deferred; Release E2E did not require NAT proof |
| [FEAT-045](FEAT-045.md) | Transfer detail endpoint | Deferred; aMuTorrent and Arr passed without hydrated transfer detail |
| [FEAT-046](FEAT-046.md) | Server/Kad bootstrap/import APIs | Deferred; live-wire gates passed with current server/search/bootstrap coverage |
| [FEAT-047](FEAT-047.md) | Search API completeness | Passed; OpenAPI and REST contract document Release 1 behavior |
| [FEAT-048](FEAT-048.md) | Upload queue control completeness | Deferred; no Release 1 gate required extra queue mutations |
| [FEAT-049](FEAT-049.md) | Curated REST preference expansion | Deferred; current curated preference surface passed release gates |
| [AMUT-002](AMUT-002.md) | aMuTorrent transfer detail hydration | Deferred; depends on deferred `FEAT-045` |

## Deferred Scope

The following tracks stay outside the first public release unless a later
release-readiness review promotes a concrete blocker:

- Boost migration and broad CI/toolchain migration: `REF-008` through
  `REF-014`, `CI-001` through `CI-007`, `CI-010`
- dependency upgrades: `REF-028`, `REF-034`
- broad networking work: `REF-029`, `REF-030`, `FEAT-018`, `FEAT-035`,
  `FEAT-036`
- broad product/UI expansion: `FEAT-017`, `FEAT-019`, `FEAT-021`,
  `FEAT-031`, `FEAT-037`, `FEAT-039` through `FEAT-044`
- non-release hardening watchpoints: `BUG-031`, `BUG-034`, `BUG-035`,
  `FEAT-001` through `FEAT-006`, `FEAT-034`, `CI-008`, `CI-012`,
  `CI-013`, `CI-016`

## Validation

Before tagging `emule-bb-v1.0.0`, run the supported workspace commands:

- `pwsh -File repos\eMule-build\workspace.ps1 validate`
- `pwsh -File repos\eMule-build\workspace.ps1 build-app -Config Debug -Platform x64`
- `pwsh -File repos\eMule-build\workspace.ps1 build-app -Config Release -Platform x64`
- `pwsh -File repos\eMule-build\workspace.ps1 build-tests -Config Debug -Platform x64`
- `pwsh -File repos\eMule-build\workspace.ps1 build-tests -Config Release -Platform x64`
- native parity tests through the supported `test` command
- Release x64 `live-e2e`, including aMuTorrent, Prowlarr, Radarr, and Sonarr

Public-network unavailable results are acceptable only when the harness records
the run as inconclusive with enough diagnostics to distinguish environment
failure from product failure.
