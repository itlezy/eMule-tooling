---
id: FEAT-050
title: Launch external program on completed download
status: Open
priority: Minor
category: feature
labels: [downloads, completion, automation, preferences]
milestone: broadband-release
created: 2026-05-02
source: qBittorrent-style completion command planning
---

## Summary

Add an opt-in qBittorrent-style completion hook that launches one configured
external executable after a download is fully completed and retained as the
live known/shared file.

## Release 1.0 Classification

**Release Gate.** This is the one optional workflow feature promoted into 1.0
in addition to the REST/controller gate. It must stay disabled by default,
executable-only, asynchronous, and covered by targeted native tests so it adds
automation value without creating a shell-execution surface.

## Product Contract

- disabled by default
- global setting only
- configured from Files preferences
- executable file only; scripts can be run by explicitly choosing
  `powershell.exe` or `cmd.exe`
- no shell expansion, pipes, or environment-variable expansion
- asynchronous launch; eMule does not wait for exit
- minimized normal window
- skipped while the app is closing
- launch failures are logged, not shown as modal dialogs

## Argument Tokens

The first release supports these tokens in the argument string:

- `%F` completed full file path
- `%D` completed directory
- `%N` completed file name
- `%H` lowercase file hash
- `%S` file size in bytes
- `%C` category name

Path tokens are quoted automatically so paths with spaces work without fragile
user quoting.

## Acceptance Criteria

- [ ] command does not run for failed completion or duplicate-discard paths
- [ ] command runs after final UI-thread completion success and notifier/log
      work
- [ ] missing executable is rejected when enabling the feature
- [ ] disabled preference allows empty command fields
- [ ] token expansion is covered by native tests
- [ ] launch helper closes process and thread handles immediately
- [ ] app validation and targeted tests pass
