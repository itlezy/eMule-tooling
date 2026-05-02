---
id: FEAT-051
title: Pro-user context menus and always-on advanced controls
status: Done
priority: Minor
category: feature
labels: [ui, context-menu, pro-user, transfers]
milestone: broadband-release
created: 2026-05-02
source: user-directed pro-user menu expansion
---

## Summary

Remove the simplified-interface gate and make advanced controls part of the
normal eMule BB UI. Add pro-user context-menu copy actions and manual ban/unban
coverage across the main transfer, client, search, shared-file, and server
surfaces.

## Acceptance Criteria

- [x] `ShowExtControls` is no longer read, written, or exposed in Tweaks
- [x] formerly gated advanced controls are always available
- [x] download, shared-file, search, server, upload, queue, known-client,
      download-client, and download-source menus expose practical copy actions
- [x] raw copy actions emit one raw value per selected row without labels
- [x] summary copy actions emit compact labeled fields and omit unavailable data
- [x] live client menus expose manual ban/unban where a real eD2K client exists
- [x] focused native tests cover copy-summary and multi-line copy formatting

## Implementation Notes

- This intentionally removes the noob/pro split instead of preserving a hidden
  compatibility knob.
- Existing localized `IDS_SHOWEXTSETTINGS` strings may remain as inert resource
  history until the language files are next swept.
- Link copy behavior keeps existing eD2K command handlers and surfaces them
  inside the new Copy submenu where practical.
