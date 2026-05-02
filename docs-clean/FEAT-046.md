---
id: FEAT-046
title: REST server and Kad bootstrap/import APIs
status: In Progress
priority: Major
category: feature
labels: [rest, servers, kad, bootstrap, live-wire]
milestone: broadband-release
created: 2026-05-02
source: broadband release live E2E and REST completeness planning
---

## Summary

Expose native REST operations for controlled server and Kad bootstrap/import
flows.

Default live sources are the already-persisted eMule Security URLs:

- `https://emule-security.org/`
- `https://upd.emule-security.org/server.met`
- `https://upd.emule-security.org/nodes.dat`

## Acceptance Criteria

- [x] server import can refresh `server.met` through the same safe validation
      and promotion path used by the app
- [ ] Kad import can refresh `nodes.dat` without weakening the existing
      bootstrap-empty guard
- [ ] endpoints support configured URLs and do not silently depend on bundled
      external lists
- [ ] live E2E records source URL, size, hash, and import outcome
- [ ] malformed downloads preserve the previous live files

## Progress

- 2026-05-02: Native `main` added `POST /api/v1/servers/met-url-imports`,
  `PATCH /api/v1/servers/{serverId}` property updates, and
  `POST /api/v1/kad/operations/bootstrap`. Route seam and live-smoke contract
  coverage were updated in `eMule-build-tests`.

## Relationship To Other Items

- updates `CI-014` and `CI-015`
- complements `BUG-071` and `BUG-072`
