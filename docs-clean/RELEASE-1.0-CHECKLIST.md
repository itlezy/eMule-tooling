# eMule Broadband Edition 1.0 Release Checklist

This is the Markdown-only release control plane for `emule-bb-v1.0.0`.
It is written for maintainers and release operators. Do not tag Release 1 until
every release gate below has evidence.

## Completion Rule

Release 1 is complete only when:

- every gate is `Passed` or `Inconclusive Accepted`
- no gate has missing implementation, command, artifact, or ship-decision cells
- the aggregate live E2E result has no `failed` suites
- any `Inconclusive Accepted` live-network result proves the app and harness
  behaved correctly and records the external condition that blocked proof
- every release candidate is either promoted to a gate, explicitly shipped, or
  explicitly deferred

Allowed gate statuses:

- `Open`
- `In Progress`
- `Blocked`
- `Ready For Validation`
- `Passed`
- `Inconclusive Accepted`
- `Deferred By Decision`

## Gate Ledger

| ID | Gate | Status | Implementation evidence | Validation command | Required artifact | Ship decision |
|----|------|--------|-------------------------|--------------------|-------------------|---------------|
| [BUG-075](BUG-075.md) | REST typed error consistency | Open | TBD commit | `pwsh -File repos\eMule-build\workspace.ps1 build-tests -Config Debug -Platform x64`; `pwsh -File repos\eMule-build\workspace.ps1 test -Config Debug -Platform x64` | native test output plus REST error evidence | Blocks tag |
| [BUG-076](BUG-076.md) | Malformed WebServer/REST hardening | Open | TBD commit | `pwsh -File repos\eMule-build\workspace.ps1 build-tests -Config Debug -Platform x64`; `pwsh -File repos\eMule-build\workspace.ps1 test -Config Debug -Platform x64` | native test output plus malformed request evidence | Blocks tag |
| [CI-014](CI-014.md) | REST manifest/live completeness gate | Open | TBD commit | `pwsh -File repos\eMule-build\workspace.ps1 build-tests -Config Release -Platform x64`; `pwsh -File repos\eMule-build\workspace.ps1 live-e2e -Config Release -Platform x64 -LiveSuite rest-api` | REST child report and aggregate result JSON | Blocks tag |
| [CI-015](CI-015.md) | REST malformed/concurrent matrix | Open | TBD commit | `pwsh -File repos\eMule-build\workspace.ps1 live-e2e -Config Release -Platform x64 -LiveSuite rest-api` | REST stress report and aggregate result JSON | Blocks tag |
| [BUG-077](BUG-077.md) | Concurrent WebServer soak | Open | TBD commit | `pwsh -File repos\eMule-build\workspace.ps1 live-e2e -Config Release -Platform x64 -LiveSuite rest-api -RestStressBudget soak` | REST soak report with no failed requests beyond the configured budget | Blocks tag |
| [CI-011](CI-011.md) | Release live E2E umbrella | Open | TBD commit | `pwsh -File repos\eMule-build\workspace.ps1 live-e2e -Config Release -Platform x64` | `repos\eMule-build-tests\reports\live-e2e-suite-latest\result.json` | Blocks tag |
| [AMUT-001](AMUT-001.md) | aMuTorrent live E2E validation | Open | TBD commit | `pwsh -File repos\eMule-build\workspace.ps1 live-e2e -Config Release -Platform x64 -LiveSuite amutorrent-browser-smoke` | aMuTorrent browser console and REST request artifacts | Blocks tag |
| [ARR-001](ARR-001.md) | Arr live E2E validation | Open | TBD commit | `pwsh -File repos\eMule-build\workspace.ps1 live-e2e -Config Release -Platform x64 -LiveSuite prowlarr-emulebb -LiveSuite radarr-sonarr-emulebb` | Prowlarr, Radarr, Sonarr, and aggregate Arr artifacts | Blocks tag |
| [FEAT-050](FEAT-050.md) | Download completion hook | Open | TBD commit | `pwsh -File repos\eMule-build\workspace.ps1 build-tests -Config Debug -Platform x64`; `pwsh -File repos\eMule-build\workspace.ps1 test -Config Debug -Platform x64` | native completion-command test output | Blocks tag |

## Release Candidate Decisions

These items are not blockers unless a gate proves they are required.

| ID | Candidate | Current decision | Evidence required to promote |
|----|-----------|------------------|------------------------------|
| [FEAT-032](FEAT-032.md) | NAT mapping live validation | Candidate | Promote only if local network proof is available and release E2E needs it |
| [FEAT-045](FEAT-045.md) | Transfer detail endpoint | Candidate | Promote only if aMuTorrent or Arr release views are not useful without it |
| [FEAT-046](FEAT-046.md) | Server/Kad bootstrap/import APIs | Candidate | Promote only if live-wire bootstrap cannot be made reliable without it |
| [FEAT-047](FEAT-047.md) | Search API completeness | Candidate | Promote only for release-critical paging or bounds gaps |
| [FEAT-048](FEAT-048.md) | Upload queue control completeness | Candidate | Promote only for controller-required missing operations |
| [FEAT-049](FEAT-049.md) | Curated REST preference expansion | Candidate | Promote only for aMuTorrent or release E2E required settings |
| [AMUT-002](AMUT-002.md) | aMuTorrent transfer detail hydration | Candidate | Promote only if `FEAT-045` becomes required |

## Final Tag Readiness

Before creating `emule-bb-v1.0.0`, record evidence for:

- `pwsh -File repos\eMule-build\workspace.ps1 validate`
- Debug and Release x64 app builds
- Debug and Release x64 test builds
- supported native test command
- full Release x64 `live-e2e` run
- clean worktrees in active workspace repos
- release notes reviewed for public product name `eMule broadband edition`
- release assets named `eMule-broadband-1.0.0-x64.zip` and
  `eMule-broadband-1.0.0-arm64.zip`
