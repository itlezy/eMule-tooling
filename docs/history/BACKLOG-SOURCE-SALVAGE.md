# Backlog Source Salvage

This records where major historical source documents fed the active backlog.
It is intentionally compact; detailed provenance lives in item docs and dated
review records.

## Historical Docs

| Source | Salvaged into |
|--------|---------------|
| `AUDIT-BUGS.md` | early `BUG-*` triage and fixed/wont-fix decisions |
| `AUDIT-DEFECTS.md` | [BUG-001](../../docs-clean/BUG-001.md), [REF-004](../../docs-clean/REF-004.md) |
| `AUDIT-SECURITY.md` | [BUG-006](../../docs-clean/BUG-006.md), [REF-021](../../docs-clean/REF-021.md), [REF-028](../../docs-clean/REF-028.md) |
| `AUDIT-DEADCODE.md` | [REF-002](../../docs-clean/REF-002.md) through [REF-007](../../docs-clean/REF-007.md), [REF-017](../../docs-clean/REF-017.md) through [REF-019](../../docs-clean/REF-019.md) |
| `AUDIT-KAD.md` | [FEAT-001](../../docs-clean/FEAT-001.md) through [FEAT-006](../../docs-clean/FEAT-006.md), [CI-007](../../docs-clean/CI-007.md) |
| `AUDIT-CODEQUALITY.md` | [CI-001](../../docs-clean/CI-001.md) through [CI-006](../../docs-clean/CI-006.md) |
| `PLAN-BOOST.md` | [REF-008](../../docs-clean/REF-008.md) through [REF-014](../../docs-clean/REF-014.md) |
| `GUIDE-LONGPATHS.md` | [FEAT-010](../../docs-clean/FEAT-010.md) |
| `PLAN-API-SERVER.md` | [FEAT-013](../../docs-clean/FEAT-013.md), [FEAT-014](../../docs-clean/FEAT-014.md) |
| `FEATURE-BROADBAND.md` | [FEAT-015](../../docs-clean/FEAT-015.md), [FEAT-023](../../docs-clean/FEAT-023.md) |
| `FEATURE-MODERN-LIMITS.md` | [FEAT-016](../../docs-clean/FEAT-016.md) |
| `AUDIT-WWMOD.md` | Windows modernization refactors and UI/build policy items |
| `AUDIT-CODEREVIEW.md` | [BUG-007](../../docs-clean/BUG-007.md), [BUG-008](../../docs-clean/BUG-008.md), [REF-028](../../docs-clean/REF-028.md) |

## Analysis Inputs

- eMuleAI v1.3 seeded early persistence, shared-directory, destructor, and
  startup/config references.
- `stale-v0.72a-experimental-clean` remains a retired reference source for
  implementation ideas only.
- Current-main reviews from April and May 2026 own the live landed/open status.

## Confirmed Done Provenance

Do not use this file as a complete done ledger. For complete status, use
[docs-clean/INDEX](../../docs-clean/INDEX.md). Representative early confirmed
items include `BUG-009` through `BUG-012`, `BUG-015`, `BUG-016`, `FEAT-015`,
`FEAT-016`, `FEAT-023`, `FEAT-024`, `FEAT-025`, `FEAT-038`, and `FEAT-013`.
