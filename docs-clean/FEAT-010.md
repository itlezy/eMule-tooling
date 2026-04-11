---
id: FEAT-010
title: Long path support phase 2 — shell/UI icon, browse, and path-helper audit
status: Open
priority: Minor
category: feature
labels: [longpath, max-path, windows, filesystem, shell, ui]
milestone: ~
created: 2026-04-08
source: GUIDE-LONGPATHS.md + feature/windows-long-paths audit
---

## Summary

Core long-path support has landed on `main` for filesystem operations: manifests are long-path aware, `LongPathSeams` centralizes file opens/moves/deletes/enumeration, CRT-bypass helpers are in use, and real-FS tests cover overlong Unicode paths. The remaining work is Phase 2 shell/UI hardening so icon lookup, browse dialogs, and path-helper code no longer lag behind the core file-access model.

## Already Landed On Main

The following are no longer backlog items:

- `x64` and `ARM64` manifests carry `<ws2:longPathAware>true</ws2:longPathAware>`
- startup detects and logs whether `LongPathsEnabled` is enabled
- `LongPathSeams` centralizes Win32 file APIs, CRT-bypass file descriptors, `FILE*` streams, and MFC safe-file opens
- part files, config files, archive/import flows, ZIP/GZIP, web cert/key output, and similar high-value paths already use the shared long-path model
- real filesystem tests now cover long Unicode paths, Cyrillic/emoji path segments, generated payloads, copy/move/delete flows, and parity-style reference coverage

## Remaining Scope

The remaining long-path backlog is now shell/UI oriented:

Branch status on `fix/partfile-longpath-hardening`:

- `Ini2.cpp` path-helper cleanup is done; module/current-directory INI path construction no longer depends on fixed `_MAX_*` buffers or `MAX_PATH`-sized `GetModuleFileName` / `GetCurrentDirectory` calls.
- Shell icon / shell-attribute query call sites in `DirectoryTreeCtrl.cpp`, `SharedDirsTreeCtrl.cpp`, `Emule.cpp`, `PPgDirectories.cpp`, `SharedFileList.cpp`, and `SharedFilesCtrl.cpp` are intentionally deferred and marked in code as `TODO:MINOR(FEAT-010)`.
- Browse-dialog call sites in `OtherFunctions.cpp`, `PartFileConvert.cpp`, `TreeOptionsCtrl.cpp`, `KnownFile.cpp`, `PPgFiles.cpp`, `MuleToolBarCtrl.cpp`, and `StatisticsTree.cpp` are intentionally deferred and marked in code as `TODO:MINOR(FEAT-010)`.
- Path-helper / path-display call sites in `FileInfoDialog.cpp`, `MiniMule.cpp`, and `OtherFunctions.cpp` are intentionally deferred and marked in code as `TODO:MINOR(FEAT-010)`.
- `Emule.cpp` skin resource path assembly is intentionally deferred as `TODO:MINOR`.
- `MuleListCtrl.cpp` background skin image path assembly is intentionally deferred as `TODO:MINOR`.

1. **Shell icon lookup**
   Centralize direct `SHGetFileInfo` usage and define fallback behavior for overlong paths.

   Deferred status on `fix/partfile-longpath-hardening`:
   active call sites are tagged in code as `TODO:MINOR(FEAT-010)` and are not part of the current branch scope.

   Primary files:
   - `DirectoryTreeCtrl.cpp`
   - `SharedDirsTreeCtrl.cpp`
   - `SharedFileList.cpp`
   - `SharedFilesCtrl.cpp`
   - `PPgDirectories.cpp`
   - `Emule.cpp`

2. **Browse dialog flows**
   Audit `SHBrowseForFolder`, `SHGetPathFromIDList`, and `CFileDialog` call sites to document or improve long-path behavior where feasible.

   Deferred status on `fix/partfile-longpath-hardening`:
   active call sites are tagged in code as `TODO:MINOR(FEAT-010)` and are not part of the current branch scope.

   Primary files:
   - `OtherFunctions.cpp`
   - `PartFileConvert.cpp`
   - `TreeOptionsCtrl.cpp`
   - `KnownFile.cpp`
   - `PPgFiles.cpp`
   - `MuleToolBarCtrl.cpp`
   - `StatisticsTree.cpp`

3. **Path helper / path-display cleanup**
   Reduce legacy fixed-buffer `Path*` / `GetModuleFileName` patterns where they are still used in actual path construction or shell-facing code.

   Deferred status on `fix/partfile-longpath-hardening`:
   active call sites are tagged in code as `TODO:MINOR(FEAT-010)` and are not part of the current branch scope.

   Primary files:
   - `FileInfoDialog.cpp`
   - `OtherFunctions.cpp`
   - `MiniMule.cpp`

## Intended Phase 2 Approach

- Add a small shell-facing helper layer for icon/display queries rather than sprinkling more `SHGetFileInfo` patterns.
- Keep `LongPathSeams` as the core filesystem boundary; do not fork a second file-access model.
- Where shell APIs are inherently limited, prefer explicit fallback behavior and documentation over ad hoc failure.
- Keep pure string helpers like `PathFindExtension` only where they are not path-length sensitive.

## Acceptance Criteria

- [ ] Shell icon/display lookup is centralized and no longer scattered across tree/list controls
- [ ] Overlong paths still get sensible icons or graceful fallback behavior in directory/file UI
- [ ] Browse-dialog flows are audited and any unavoidable shell limitations are documented
- [ ] Fixed-buffer path composition used in real path construction is reduced or eliminated in the audited files
- [ ] Manual smoke checks cover icon lookup and browse flows for deep Unicode paths where the shell APIs permit it

## Reference

Core implementation spec: `docs/GUIDE-LONGPATHS.md`
