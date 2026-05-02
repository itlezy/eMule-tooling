---
id: FEAT-047
title: REST search API completeness pass
status: In Progress
priority: Minor
category: feature
labels: [rest, search, amutorrent, live-wire]
milestone: broadband-release
created: 2026-05-02
source: broadband release live E2E and REST completeness planning
---

## Summary

Audit and fill release-critical search API gaps for aMuTorrent and other local
controllers.

## Acceptance Criteria

- [x] aMuTorrent search views can render useful result rows without private
      adapter assumptions
- [x] server, global, Kad, and automatic search methods remain explicit
- [x] cancellation and missing-search behavior return stable typed errors
- [ ] paging or bounding behavior is documented if result sets are limited
- [x] live coverage includes the release search corpus

## Progress

- 2026-05-02: Native `main` added `DELETE /api/v1/searches` and
  `POST /api/v1/searches/{searchId}/results/{hash}/operations/download`.
  aMuTorrent now uses the native result-download route when it has a native
  search id and keeps the ED2K-link fallback for older frames.

## Relationship To Other Items

- backs `CI-013` and `CI-014`
- should not change default eD2K/Kad search semantics
