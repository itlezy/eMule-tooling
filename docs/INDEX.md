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
| [ARCH-PREFERENCES](ARCH-PREFERENCES.md) | Preferences reference: INI keys, defaults, UI exposure, hidden prefs |
| [ARCH-THREADING](ARCH-THREADING.md) | Threading-model reference and migration background |

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

## Guides, History, And Plans

| Document | Description |
|---|---|
| [GUIDE-LONGPATHS](GUIDE-LONGPATHS.md) | Long-path implementation guide |
| [HISTORY-070-VS-072](HISTORY-070-VS-072.md) | 0.70b vs 0.72a comparison report |
| [HISTORY-CHANGELOG](HISTORY-CHANGELOG.md) | Community build change review across releases |
| [PLAN-API-SERVER](PLAN-API-SERVER.md) | API/server design reference |
| [PLAN-BOOST](PLAN-BOOST.md) | Boost-oriented modernization exploration |
| [PLAN-CMAKE](PLAN-CMAKE.md) | MSBuild-to-CMake migration plan |
| [PLAN-MODERNIZATION-2026](PLAN-MODERNIZATION-2026.md) | Broad modernization roadmap |
| [PLAN-RESTRUCTURE](PLAN-RESTRUCTURE.md) | Module restructuring guidance |
| [REFACTOR-TASKS](REFACTOR-TASKS.md) | Historical refactor-task ledger and background |

## Notes

- `docs/` owns deep background, analysis, and historical design context.
- `docs-clean/` owns active backlog status, dated revalidation notes, and
  landed/open item tracking.
- Preserve commit ids and historical branch names in reference docs where they
  add provenance, but do not treat them as current-branch guidance unless
  `docs-clean` explicitly says the work is landed on `main`.
