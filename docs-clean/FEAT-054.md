---
id: FEAT-054
title: Normalize download message filename display
status: Done
priority: Minor
category: feature
labels: [ui, downloads, logging]
milestone: broadband-release
created: 2026-05-03
source: user-directed download message cleanup
---

## Summary

Normalize user-visible download lifecycle and part-file status messages so file
name arguments use the bracketed display form.

## Acceptance Criteria

- [x] New-download logs and notifications show `[ file name ]`.
- [x] Duplicate download warnings show `[ file name ]`.
- [x] Recovered part.met and user-visible part-file load/save errors show
  bracketed file names for the download name argument.
- [x] Download completion keeps the bracketed file name and no longer appends
  the legacy smiley to the English string.
- [x] Actual file names, persisted metadata, and list-column file names are not
  changed.

## Implementation Notes

- This uses the existing `FormatDisplayFileName()` helper and relies on its
  idempotence to avoid double wrapping.
- Localized resource files were left untouched; code-side filename formatting
  applies regardless of the active language.
