---
id: FEAT-020
title: DB-IP city geolocation — location label and flag per peer
status: Done
priority: Trivial
category: feature
labels: [ui, geolocation, geoip, network, peer-info]
milestone: ~
created: 2026-04-10
source: `main` commit `aaf253f` (`FEAT-020 add DB-IP city geolocation UI and updater`)
---

## Summary

This feature is merged to `main`.

Current `eMule-main` does not use the original eMuleAI GeoLite2 / MaxMind import path.
Instead, it landed a lower-drift built-in DB-IP City Lite reader and updater that keeps
the user-visible goal while avoiding a larger dependency-policy jump.

Mainline commit:

- `aaf253f` — `FEAT-020 add DB-IP city geolocation UI and updater`

## Landed Mainline Shape

Primary files:

- `srchybrid/GeoLocation.cpp/.h`
- `srchybrid/Emule.cpp/.h`
- `srchybrid/EmuleDlg.cpp/.h`
- geo-aware list/dialog surfaces such as:
  - `DownloadListCtrl.cpp`
  - `QueueListCtrl.cpp`
  - `UploadListCtrl.cpp`
  - `ServerListCtrl.cpp`
  - `KadContactListCtrl.cpp`
  - `ClientDetailDialog.cpp`

## Implemented Behavior

Current `main` now provides:

- a built-in MMDB reader specialized for DB-IP City Lite data
- optional automatic or manual DB refresh through the existing app surface
- `Location` text display rather than a country-only column
- flag rendering plus country/city text on the supported list views
- graceful behavior when the DB is missing or geolocation is disabled

## Why The Backlog Item Is Closed

The original backlog entry came from eMuleAI's GeoLite2 feature work. That exact
implementation did not land, but the practical capability did land on `main` under the
same tracked feature id with a more conservative dependency choice.

What remains now is ordinary maintenance of the landed DB-IP implementation, not a pending
geolocation feature gap.

## Relationship To Other Items

- independent of protocol behavior and peer-routing logic
- complements the later `Location` column backfill work already landed under **FEAT-023**
- long-path hardening for the DB refresh/install path later landed under **BUG-029**
