---
id: FEAT-045
title: REST transfer detail endpoint for controller parity
status: In Progress
priority: Major
category: feature
labels: [rest, transfers, controller, amutorrent]
milestone: broadband-release
created: 2026-05-02
source: broadband release live E2E and REST completeness planning
---

## Summary

Add a transfer detail endpoint for controller views that need more than the
current transfer row plus source list.

## Release 1.0 Classification

**Release Candidate.** Pull this into the 1.0 gate only if the aMuTorrent smoke
proves the current transfer row plus source list cannot provide useful release
views. Otherwise keep it as a documented 1.1 controller-parity follow-up.

Target route:

- `GET /api/v1/transfers/{hash}/details`

## Execution Plan

Covered by the [Release 1.0 REST and Arr execution plan](../plans/RELEASE-1.0-REST-ARR-EXECUTION-PLAN.md).

## Current State

The backend now exposes `GET /api/v1/transfers/{hash}/details` as a dedicated
detail payload with the transfer row, per-part state, and source rows. The
remaining gap is controller consumption and compatibility fallback in
`AMUT-002`, not the native REST route itself.

## Acceptance Criteria

- [x] detail data is exposed through a dedicated endpoint, not by bloating
      `snapshot`
- [x] missing or malformed hashes return the stable REST error envelope
- [x] the endpoint is covered by native route tests, live REST smoke, and the
      contract manifest
- [ ] aMuTorrent consumes the endpoint when capability metadata indicates it is
      available

## Progress

- 2026-05-07: Revalidated the native detail route on current `main`. The
  OpenAPI contract includes `GET /api/v1/transfers/{hash}/details`, native route
  seams cover routing and hash validation, and the live REST smoke now verifies
  both the missing-transfer error path and the detail payload for an added
  paused transfer. `AMUT-002` remains open for controller-side hydration.

## Relationship To Other Items

- feeds `AMUT-002`
- updates `CI-014`
