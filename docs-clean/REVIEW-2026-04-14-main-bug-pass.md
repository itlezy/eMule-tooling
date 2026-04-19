# Review 2026-04-14 — Main Bug-Only Pass

> Historical reference only: `stale-v0.72a-experimental-clean` and
> `analysis\stale-v0.72a-experimental-clean` are retired reference sources, not
> active branch targets or current baselines. Use them only as provenance or
> idea-extraction sources; landed status is determined against `main`. See
> [Historical References](../docs/HISTORICAL-REFERENCES.md).

## Scope

Focused pass on fresh concrete bugs in current `eMule-main` only.

This pass intentionally excluded cleanup-only debt, MFC/toolchain modernization,
and broad speculative audits. The goal was to confirm live defects with direct
source evidence and write them into the clean backlog.

## New Confirmed Bugs

### BUG-024 — `statUTC(HANDLE)` returns corrupted `st_size`

- current `main` composes `st_size` from `nFileSizeHigh` and `nFileIndexLow`
  instead of `nFileSizeLow`
- bug is present in current `main` and the stale experimental tree
- `emuleai` already has the corrected low-dword logic

See: [BUG-024](BUG-024.md)

### BUG-025 — hashing open failures log stale/wrong error text

- current `main` logs `_tcserror(errno)` after a Win32 long-path open failure in
  `CKnownFile`
- this loses the real `CreateFile` failure reason on a live automatic-hashing path
- `stale-v0.72a-experimental-clean` and `emuleai` both contain better handling for
  at least part of this flow

See: [BUG-025](BUG-025.md)

## Revalidated But Not Promoted In This Pass

- `CreditsThread.cpp` still has the previously documented mask/compositing issue
  candidate, but this pass did not reopen it as a new backlog item without a
  stronger current-tree runtime confirmation
- no additional high-confidence crash or corruption bug was confirmed from the
  narrower `clienthistory` / UDP lifetime spot-checks during this pass

## Outcome

This pass added two new concrete bug items to `docs-clean/INDEX.md`:

- [BUG-024](BUG-024.md)
- [BUG-025](BUG-025.md)
