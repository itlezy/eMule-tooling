---
id: FEAT-024
title: Share-ignore policy with additive `shareignore.dat`
status: Done
priority: Minor
category: feature
labels: [sharing, filesystem, config, filtering]
milestone: ~
created: 2026-04-13
source: feature/feat011-shareignore-config
---

## Summary

eMule now uses one centralized share-ignore policy for junk files and junk
directories across share scans, drag/drop intake, explicit single-share paths,
recursive shared-directory expansion, and persisted shared-directory load.

The policy is:

- built-in rules are always active
- user rules are additive only
- config filename is `shareignore.dat`
- config location is the active config directory
- load happens once at startup
- matching is case-insensitive on the leaf basename only

There is no UI editor and no runtime toggle.

## Implemented Behavior

The centralized policy now drives:

- shared-file scan and hash intake
- drag/drop prechecks for files and directories
- explicit single-file share attempts
- direct directory-share attempts
- recursive share-with-subdirectories expansion
- shared-tree and options-tree descendant enumeration
- incoming-directory “contains files” warning
- persisted shared-directory pruning on load

Practical effects:

- ignored files do not enter share state
- ignored directories cannot be directly shared
- recursive sharing skips ignored descendants under an allowed parent
- persisted ignored shared directories are pruned on load
- options-tree and Shared Files tree apply the same ignore decisions

## Built-In Rules

### Files

Exact names:

- `ehthumbs.db`
- `desktop.ini`
- `.ds_store`
- `.localized`
- `Icon\r`
- `.directory`

Prefixes:

- `._*`
- `~$*`
- `.nfs*`
- `.sb-*`
- `.syncthing.*`
- `~lock.*#`

Suffixes:

- `*.lnk`
- `*.part`
- `*.crdownload`
- `*.download`
- `*.tmp`
- `*.temp`
- `*~`

Special runtime rule:

- real structured-storage `thumbs.db` files are ignored only when they are
  actual thumbnail database storages

### Directories

Exact names:

- `.fseventsd`
- `.spotlight-v100`
- `.temporaryitems`
- `.trashes`
- `.git`
- `.svn`
- `.hg`
- `CVS`

Prefixes:

- `._*`
- `.nfs*`
- `.sb-*`
- `.syncthing.*`

No suffix-based built-in directory filtering is used.

## `shareignore.dat` Format

One rule per line, startup-loaded only.

Supported forms:

- `name` = exact basename match
- `prefix*` = prefix basename match
- `*suffix` = suffix basename match

Ignored silently:

- blank lines
- malformed lines
- lines with multiple `*`
- unsupported `*middle*` / full-glob patterns

User rules apply to both files and directories.

## Implementation Notes

Primary files:

- `srchybrid/SharedFileIntakePolicy.h`
- `srchybrid/Preferences.cpp`
- `srchybrid/SharedDirectoryOps.h`
- `srchybrid/OtherFunctions.cpp`
- `srchybrid/SharedFileList.cpp`

Key design choices:

- policy remains basename-only, not full-path-based
- built-ins cannot be disabled by user config
- startup caching avoids creating a second dynamic policy path
- directory-share blocking is enforced through `IsShareableDirectory(...)`
- recursive child skipping is enforced independently in
  `SharedDirectoryOps::EnumerateChildDirectories(...)`

## Explicit Boundaries

This is not a general hidden-file system for the whole app.

Out of scope:

- live reload of `shareignore.dat`
- UI editor or settings page
- path-based ignore rules
- full globbing or regex matching
- comments/escaping syntax in `shareignore.dat`
- non-share-related file views elsewhere in the app

## Validation

Implemented on app branch:

- `feature/feat011-shareignore-config`

Matching tests branch:

- `chore/ci009-feat011-shareignore-config`

Owned validation passed:

- `workspace.ps1 build-app`
- `workspace.ps1 build-tests`
- `workspace.ps1 test`
