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
| [BUG-075](BUG-075.md) | REST typed error consistency | Passed | app: `fcedfe3`, `c8e6609`, `1e2ff57`, `69d9262`, `3c63552`; tests: `28f17db`, `83093a6`, `c10f2a8`, `8e67131`, `b7406d9`, `957c31a`, `51f8b6b`, `a3f3d56`, `4c2240e`, `bc0ca24`; tooling: `95fc6e9`, `a5d3d38` | `pwsh -File repos\eMule-build\workspace.ps1 validate`; `pwsh -File repos\eMule-build\workspace.ps1 build-tests -Config Debug -Platform x64`; `pwsh -File repos\eMule-build\workspace.ps1 test -Config Debug -Platform x64`; `python -m pytest tests\python\test_rest_api_smoke.py -q` | `workspaces\v0.72a\state\build-logs\20260506-175920`; `repos\eMule-build-tests\reports\native-coverage\20260506-175927-eMulebb-workspace-v0.72a-eMule-main-x64-Debug`; native test output passed `481/481` cases and `2679/2679` assertions; REST smoke unit output passed `25/25` tests | Blocks tag |
| [BUG-076](BUG-076.md) | Malformed WebServer/REST hardening | Passed | app: `8d324d4`, `40bac28`, `90c6352`, `41964c8`; tests: `cee7499`, `214b327`, `2746ef1`, `7b002f2`, `f3d8923`, `e0f8ef6`, `aea6934` | `pwsh -File repos\eMule-build\workspace.ps1 build-tests -Config Debug -Platform x64`; `pwsh -File repos\eMule-build\workspace.ps1 test -Config Debug -Platform x64` | `workspaces\v0.72a\state\build-logs\20260506-173324`; `repos\eMule-build-tests\reports\native-coverage\20260506-173327-eMulebb-workspace-v0.72a-eMule-main-x64-Debug`; native test output passed `481/481` cases and `2679/2679` assertions | Blocks tag |
| [CI-014](CI-014.md) | REST manifest/live completeness gate | Passed | tests: `3bc65d6`, `3101391`, `b53627d`, `b8233b0`, `d907fc2`, `69eba5b`; tooling: `89810c5`, `8b548b3`, `cffd810`, `e3b5d24`, `9560435`, `fee7111`, `f2cc198` | `pwsh -File repos\eMule-build\workspace.ps1 validate`; `python -m pytest tests\python\test_rest_api_smoke.py -q`; `pwsh -File repos\eMule-build\workspace.ps1 build-tests -Config Release -Platform x64`; `pwsh -File repos\eMule-build\workspace.ps1 live-e2e -Config Release -Platform x64 -LiveSuite rest-api` | `workspaces\v0.72a\state\build-logs\20260506-181540`; `repos\eMule-build-tests\reports\rest-api-smoke\20260506-181933-eMule-main-release`; `repos\eMule-build-tests\reports\live-e2e-suite\20260506-181933-eMule-main-release\result.json`; REST contract covered 81 routes with `/app/shutdown` skipped as unsafe; REST stress completed 8026 requests with 0 failures | Blocks tag |
| [CI-015](CI-015.md) | REST malformed/concurrent matrix | Passed | tests: `f6cc0f9`, `75b4ce7`, `331f70d`, `fe6ee8c` | `pwsh -File repos\eMule-build\workspace.ps1 validate`; `python -m pytest tests\python\test_rest_api_smoke.py -q`; `pwsh -File repos\eMule-build\workspace.ps1 live-e2e -Config Release -Platform x64 -LiveSuite rest-api`; `pwsh -File repos\eMule-build\workspace.ps1 live-e2e -Config Release -Platform x64 -LiveSuite rest-api -RestCoverageBudget contract-stress` | `repos\eMule-build-tests\reports\rest-api-smoke\20260506-185112-eMule-main-release`; `repos\eMule-build-tests\reports\live-e2e-suite\20260506-185112-eMule-main-release\result.json`; contract-stress covered 81 routes and completed 11188 mixed stress requests with 0 failures, 0 timeouts, and 0 non-JSON native REST responses; app closed cleanly after stress in 5387.841 ms | Blocks tag |
| [BUG-077](BUG-077.md) | Concurrent WebServer soak | Passed | tests: `f6cc0f9`, `75b4ce7`, `331f70d`, `fe6ee8c` | `pwsh -File repos\eMule-build\workspace.ps1 live-e2e -Config Release -Platform x64 -LiveSuite rest-api -RestStressBudget soak` | `repos\eMule-build-tests\reports\rest-api-smoke\20260506-184530-eMule-main-release`; `repos\eMule-build-tests\reports\live-e2e-suite\20260506-184530-eMule-main-release\result.json`; mixed soak completed 10997 requests with 0 failures, 0 timeouts, and 0 non-JSON native REST responses; app closed cleanly after stress in 5418.439 ms | Blocks tag |
| [CI-011](CI-011.md) | Release live E2E umbrella | In Progress | app: `7754d16`; tests: `13f1487`, `1058ac2`, `2bb7fd2`, `a68ac42` focused REST proofs | `pwsh -File repos\eMule-build\workspace.ps1 live-e2e -Config Release -Platform x64`; focused proof: `pwsh -File repos\eMule-build\workspace.ps1 live-e2e -Config Release -Platform x64 -LiveSuite shared-directories-rest`; cleanup validation: `pwsh -File repos\eMule-build\workspace.ps1 build-tests -Config Debug -Platform x64`; `pwsh -File repos\eMule-build\workspace.ps1 test -Config Debug -Platform x64`; `pwsh -File repos\eMule-build\workspace.ps1 build-app -Config Debug -Platform x64`; `pwsh -File repos\eMule-build\workspace.ps1 build-app -Config Release -Platform x64`; `pwsh -File repos\eMule-build\workspace.ps1 live-e2e -Config Release -Platform x64 -LiveSuite rest-api` | Full umbrella still requires `repos\eMule-build-tests\reports\live-e2e-suite-latest\result.json`; focused shared-directory proof passed in `repos\eMule-build-tests\reports\shared-directories-rest\20260506-204215-eMule-main-release\result.json` with a 325-character Unicode shared root, category incoming-path echo/delete, shared-file listing, persistence, relaunch reload, malformed PATCH errors, and missing-parent root handling; adapter conversion cleanup validated in `workspaces\v0.72a\state\build-logs\20260506-203159`, `repos\eMule-build-tests\reports\native-coverage\20260506-203211-eMulebb-workspace-v0.72a-eMule-main-x64-Debug`, `workspaces\v0.72a\state\build-logs\20260506-203241`, `workspaces\v0.72a\state\build-logs\20260506-203443`, `repos\eMule-build-tests\reports\rest-api-smoke\20260506-203524-eMule-main-release`, and aggregate `repos\eMule-build-tests\reports\live-e2e-suite\20260506-203523-eMule-main-release\result.json`; Unicode ED2K transfer-name proof passed in `repos\eMule-build-tests\reports\rest-api-smoke\20260506-204523-eMule-main-release` and aggregate `repos\eMule-build-tests\reports\live-e2e-suite\20260506-204522-eMule-main-release\result.json` | Blocks tag |
| [AMUT-001](AMUT-001.md) | aMuTorrent live E2E validation | Passed | tests: `affc4d6`, `11365ca` | `python -m pytest tests\python\test_amutorrent_browser_smoke.py tests\python\test_live_e2e_suite.py -q`; `pwsh -File repos\eMule-build\workspace.ps1 live-e2e -Config Release -Platform x64 -LiveSuite amutorrent-browser-smoke` | `repos\eMule-build-tests\reports\amutorrent-browser-smoke\20260506-193606-eMule-main-release\result.json`; `repos\eMule-build-tests\reports\live-e2e-suite\20260506-193606-eMule-main-release\result.json`; browser diagnostics recorded 0 console errors, 0 page errors, and 0 request failures; category create/delete, ED2K add, search, server action, and shared-directory reload flows passed | Blocks tag |
| [ARR-001](ARR-001.md) | Arr live E2E validation | Passed | app: `87b6f24`, `385273c`, `324c7f7`; tests: `8786847`, `4e02b3d`, `0fd6e77`, `4339716`, `3c5c963`, `8a85158`, `59f7e6d`, `e78c369`; tooling: `303f911` | `pwsh -File repos\eMule-build\workspace.ps1 validate`; `python -m pytest tests\python\test_rest_api_smoke.py -q`; `pwsh -File repos\eMule-build\workspace.ps1 live-e2e -Config Release -Platform x64 -LiveSuite rest-api`; `pwsh -File repos\eMule-build\workspace.ps1 live-e2e -Config Release -Platform x64 -LiveSuite prowlarr-emulebb`; `pwsh -File repos\eMule-build\workspace.ps1 live-e2e -Config Release -Platform x64 -LiveSuite radarr-sonarr-emulebb` | Direct adapter smoke passed in `repos\eMule-build-tests\reports\rest-api-smoke\20260506-190401-eMule-main-release`; Prowlarr passed in `repos\eMule-build-tests\reports\prowlarr-emulebb-live\20260506-191105-eMule-main-release` with aggregate `repos\eMule-build-tests\reports\live-e2e-suite\20260506-191105-eMule-main-release\result.json`; Radarr/Sonarr passed in `repos\eMule-build-tests\reports\radarr-sonarr-emulebb-live\20260506-191223-eMule-main-release` with aggregate `repos\eMule-build-tests\reports\live-e2e-suite\20260506-191223-eMule-main-release\result.json` | Blocks tag |
| [FEAT-050](FEAT-050.md) | Download completion hook | Passed | app: `b6ce2ef`, `1db8f7c`; tests: `ea9f163` | `pwsh -File repos\eMule-build\workspace.ps1 build-tests -Config Debug -Platform x64`; `pwsh -File repos\eMule-build\workspace.ps1 test -Config Debug -Platform x64` | `workspaces\v0.72a\state\build-logs\20260506-201517`; `repos\eMule-build-tests\reports\native-coverage\20260506-201526-eMulebb-workspace-v0.72a-eMule-main-x64-Debug`; completion-command native tests covered retained success, duplicate/failed/shutdown skips, executable-only validation, literal shell metacharacters, token expansion, and direct `CreateProcess` request building; native test output passed `483/483` cases and `2686/2686` assertions | Blocks tag |

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
