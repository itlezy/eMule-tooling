---
id: AMUT-001
title: aMuTorrent eMule BB browser smoke coverage
status: Open
priority: Major
category: integration
labels: [amutorrent, rest, ui-smoke, controller]
milestone: broadband-release
created: 2026-05-02
source: broadband release live E2E and REST completeness planning
---

## Summary

Add a browser smoke lane that runs aMuTorrent against a live eMule BB instance.

## Release 1.0 Classification

**Release Gate.** Full E2E-validated integration with aMuTorrent and the Arr
suite is part of Release 1. This item owns the aMuTorrent side of that gate:
at least one browser smoke against a live instance with request and console
artifacts.

## Acceptance Criteria

- [ ] aMuTorrent can connect to the eMule BB REST API with configured host,
      port, and API key
- [ ] dashboard connection state renders eD2K and Kad status
- [ ] transfers, shared files, shared directories, categories, searches, and
      uploads render without adapter exceptions
- [ ] create/edit/delete category and shared-directory save flows are exercised
      through the UI where supported
- [ ] failures produce browser console and REST request artifacts

## Relationship To Other Items

- backs `CI-011`
- complements `ARR-001`
- consumes the native REST contract owned by `FEAT-013` and follow-up items
