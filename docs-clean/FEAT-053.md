---
id: FEAT-053
title: Classic tray balloon notification mode
status: Done
priority: Minor
category: feature
labels: [ui, notifications, tray]
milestone: broadband-release
created: 2026-05-03
source: user-directed notification display mode cleanup
---

## Summary

Add a deliberate native Windows notification-area balloon mode alongside modern
Windows toasts and the existing custom eMule popup.

## Acceptance Criteria

- [x] Notification display mode is selected from explicit Windows toast,
  classic tray balloon, and custom popup choices.
- [x] Fresh profiles default to Windows toast while existing saved enum values
  stay stable.
- [x] Classic tray balloon mode uses `Shell_NotifyIcon` `NIF_INFO` balloons.
- [x] Elevated or otherwise failed Windows toast attempts fall back to classic
  tray balloons before the custom popup.
- [x] A separate Tweaks option can keep the tray icon visible.
- [x] Classic tray balloon mode, toast fallback, and minimize-to-tray keep the
  tray icon visible when needed.
- [x] Tray balloon clicks restore eMule without opening notification links.

## Implementation Notes

- `NotifierDisplayMode` values are stable: `0` custom popup, `1` Windows
  toast, `2` classic tray balloon.
- `AlwaysShowTrayIcon` is independent of minimize-to-tray. Notification
  delivery can still force tray visibility while the setting is disabled.
- Tray icon callbacks now use `NOTIFYICON_VERSION_4` decoding.
