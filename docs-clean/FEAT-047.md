---
id: FEAT-047
title: REST search API completeness pass
status: Passed
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

## Release 1.0 Classification

**Release Candidate.** The search API is mostly complete for 1.0. The remaining
release work is to document paging/bounds behavior and keep live corpus
coverage meaningful; do not change stock search semantics for this item.

## Acceptance Criteria

- [x] aMuTorrent search views can render useful result rows without private
      adapter assumptions
- [x] server, global, Kad, and automatic search methods remain explicit
- [x] cancellation and missing-search behavior return stable typed errors
- [x] paging or bounding behavior is documented if result sets are limited
- [x] live coverage includes the release search corpus

## Progress

- 2026-05-06: Closed the Release 1.0 documentation gap. OpenAPI and the REST
  contract now state that `GET /api/v1/searches/{searchId}` returns the current
  native visible result snapshot, does not accept `limit` or `offset` in v1, and
  preserves stock eD2K/Kad search semantics. Live REST evidence already covers
  server/global/Kad/automatic search method handling through the release search
  corpus.
- 2026-05-02: Native `main` added `DELETE /api/v1/searches` and
  `POST /api/v1/searches/{searchId}/results/{hash}/operations/download`.
  aMuTorrent now uses the native result-download route when it has a native
  search id and keeps the ED2K-link fallback for older frames.

## Relationship To Other Items

- backs `CI-013` and `CI-014`
- should not change default eD2K/Kad search semantics
