# eMule Reference Docs

This index covers the long-form reference material in `docs/`.

It does **not** own active backlog status. Use
[`../docs-clean/INDEX.md`](../docs-clean/INDEX.md) for the live revalidated
backlog and dated review trail. If a status claim in `docs/` conflicts with
`docs-clean`, treat `docs-clean` as authoritative for current backlog state.

## Start Here

| Need | Primary Doc |
|---|---|
| Workspace roles, active branches, and operating policy | [WORKSPACE_POLICY](WORKSPACE_POLICY.md) |
| Active backlog, landed status, and revalidation notes | [../docs-clean/INDEX.md](../docs-clean/INDEX.md) |
| Backlog history, graph, and source salvage references | [history/](history/) |
| Historical-reference rules for the stale experimental branch | [HISTORICAL-REFERENCES](HISTORICAL-REFERENCES.md) |
| Repo-level purpose and navigation | [../README.md](../README.md) |

Historical branch names such as `stale-v0.72a-experimental-clean` and old
branch labels such as `v0.72a-broadband-dev` appear in some reference docs.
Treat them as historical context only, not as active branch policy or proof
that behavior is landed on current `main`.

## Architecture

| Document | Description |
|---|---|
| [ARCH-NETWORKING](ARCH-NETWORKING.md) | Networking-stack reference: sockets, `WSAPoll`, UPnP, throttling, encryption |
| [ARCH-PREFERENCES](ARCH-PREFERENCES.md) | Preference architecture, compatibility policy, retired keys, and non-preference INI state |
| [ARCH-THREADING](ARCH-THREADING.md) | Threading-model reference and migration background |
| [PREFERENCE-SURFACE-MATRIX](PREFERENCE-SURFACE-MATRIX.md) | Canonical active preference key/default/range/UI/REST matrix |

## Audits

| Document | Description |
|---|---|
| [AUDIT-BUGS](AUDIT-BUGS.md) | Large static bug audit and triage archive |
| [AUDIT-CODEREVIEW](AUDIT-CODEREVIEW.md) | Focused code-review findings on selected upstream changes |
| [AUDIT-CODEQUALITY](AUDIT-CODEQUALITY.md) | Tooling and code-quality modernization notes |
| [AUDIT-DEADCODE](AUDIT-DEADCODE.md) | Dead-code and cleanup analysis |
| [AUDIT-DEFECTS](AUDIT-DEFECTS.md) | Preferences persistence audit |
| [AUDIT-KAD](AUDIT-KAD.md) | Kademlia security and routing analysis |
| [AUDIT-SECURITY](AUDIT-SECURITY.md) | Security audit and gap analysis |
| [AUDIT-WWMOD](AUDIT-WWMOD.md) | Win10+ compatibility and modernization audit |
| [CPP-AUDIT](CPP-AUDIT.md) | C++ language, lifetime, and safety audit |
| [MAIN-BUG-CONCURRENCY-SCAN](MAIN-BUG-CONCURRENCY-SCAN.md) | Current `main` bug, concurrency, persistence, and legacy-hardening scan |

## Dependencies

| Document | Description |
|---|---|
| [DEP-STATUS](DEP-STATUS.md) | Dependency health and status overview |
| [DEP-REMOVAL](DEP-REMOVAL.md) | Dependency-removal analysis and impact review |
| [DEP-REMOVAL-DLL](DEP-REMOVAL-DLL.md) | Static-to-DLL conversion feasibility notes |

## Feature And Product Reference

These docs are reference analyses and historical design notes. They do not own
active feature status.

| Document | Description |
|---|---|
| [FEATURE-BROADBAND](FEATURE-BROADBAND.md) | Broadband controller design/background |
| [FEATURE-KAD](FEATURE-KAD.md) | Kad improvement background and design notes |
| [FEATURE-MODERN-LIMITS](FEATURE-MODERN-LIMITS.md) | Modern-limits rationale and historical plan context |
| [FEATURE-PEERS-BANS](FEATURE-PEERS-BANS.md) | eMuleAI peer-banning analysis and context |
| [FEATURE-THUMBS](FEATURE-THUMBS.md) | Retired thumbnail-preview capability notes |
| [MODS-AND-EMULEAI-SCAN](MODS-AND-EMULEAI-SCAN.md) | Current eMuleAI/mod archive comparison notes for broadband feature selection |

## Guides, History, And Plans

| Document | Description |
|---|---|
| [history/BACKLOG-HISTORY](history/BACKLOG-HISTORY.md) | Compact dated backlog revalidation trail |
| [history/BACKLOG-DEPENDENCY-GRAPH](history/BACKLOG-DEPENDENCY-GRAPH.md) | Backlog sequencing and dependency hints |
| [history/BACKLOG-SOURCE-SALVAGE](history/BACKLOG-SOURCE-SALVAGE.md) | Historical source-doc salvage map |
| [GUIDE-LONGPATHS](GUIDE-LONGPATHS.md) | Long-path implementation guide |
| [HISTORY-070-VS-072](HISTORY-070-VS-072.md) | 0.70b vs 0.72a comparison report |
| [HISTORY-CHANGELOG](HISTORY-CHANGELOG.md) | Community build change review across releases |
| [PLAN-API-SERVER](PLAN-API-SERVER.md) | API/server design reference |
| [PLAN-BOOST](PLAN-BOOST.md) | Boost-oriented modernization exploration |
| [PLAN-CMAKE](PLAN-CMAKE.md) | MSBuild-to-CMake migration plan |
| [PLAN-MODERNIZATION-2026](PLAN-MODERNIZATION-2026.md) | Broad modernization roadmap |
| [PLAN-RESTRUCTURE](PLAN-RESTRUCTURE.md) | Module restructuring guidance |
| [REFACTOR-TASKS](REFACTOR-TASKS.md) | Historical refactor-task ledger and background |

## REST API

| Document | Description |
|---|---|
| [REST-API-CONTRACT](REST-API-CONTRACT.md) | Human-readable broadband REST contract rules and scope |
| [REST-API-OPENAPI](REST-API-OPENAPI.yaml) | Canonical machine-readable `/api/v1` OpenAPI contract for eMule BB and aMuTorrent |
| [REST-API-PARITY-INVENTORY](REST-API-PARITY-INVENTORY.md) | Legacy WebServer runtime-action parity checklist for the REST release |

## Notes

- `docs/` owns deep background, analysis, and historical design context.
- `docs-clean/` owns active backlog status, dated revalidation notes, and
  landed/open item tracking.
- The latest eMuleAI/mod scan is [../docs-clean/REVIEW-2026-04-26-emuleai-mods-broadband-scan.md](../docs-clean/REVIEW-2026-04-26-emuleai-mods-broadband-scan.md), which updates the broadband feature-selection backlog and corrects landed shared-files watcher status.
- The latest direct current-main bug/concurrency scan is [../docs-clean/REVIEW-2026-04-26-main-bug-concurrency-scan.md](../docs-clean/REVIEW-2026-04-26-main-bug-concurrency-scan.md), which adds WebServer, persistence, helper-thread, and archive-preview hardening backlog items.
- The latest broad backlog refresh is [../docs-clean/REVIEW-2026-04-25-current-main-backlog-refresh.md](../docs-clean/REVIEW-2026-04-25-current-main-backlog-refresh.md), which rechecks current `main`, current tests coverage, and current `analysis\emuleai` v1.4 deltas against the active backlog.
- The latest feature-expansion pass is [../docs-clean/REVIEW-2026-04-20-feature-expansion-beyond-stock.md](../docs-clean/REVIEW-2026-04-20-feature-expansion-beyond-stock.md), which records the user-directed shift toward higher-drift product features and the new FEAT backlog candidates.
- Preserve commit ids and historical branch names in reference docs where they
  add provenance, but do not treat them as current-branch guidance unless
  `docs-clean` explicitly says the work is landed on `main`.
