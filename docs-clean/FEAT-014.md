---
id: FEAT-014
title: REST API follow-up — OpenAPI docs and optional external gateway
status: Open
priority: Minor
category: feature
labels: [api, rest, openapi, tooling, sidecar]
milestone: ~
created: 2026-04-08
source: 2026-04-12 backlog review pivot from pipe/sidecar-first plan
---

## Summary

After `FEAT-013` lands an in-process REST surface in `WebServer.cpp`, a second phase can
add external-facing tooling around it:

- OpenAPI-style schema/docs generation
- optional lightweight external gateway or proxy
- optional event fan-out layer if polling proves insufficient

This is no longer the primary architecture. It is an additive follow-up only.

## Why This Is Deferred

For the current milestone, adding a sidecar or separate transport first would create
unnecessary drift and enlarge the stabilization surface:

- two auth/transport layers instead of one
- two failure modes instead of one
- more moving parts before the core JSON API is proven useful

The app should first expose a stable JSON API directly from the existing web server.

## Follow-up Scope

Possible later work:

- generate machine-readable route/schema docs from the in-process REST surface
- add a thin external gateway for:
  - API-key/JWT wrappers
  - SSE/event fan-out
  - integration tooling
- ship a small CLI/client SDK for automation

## Acceptance Criteria

- [ ] FEAT-013 exists first and defines the stable JSON route surface
- [ ] OpenAPI or equivalent machine-readable schema can be generated from that surface
- [ ] Any external gateway remains optional and does not become a runtime prerequisite

## Progress

- 2026-05-02: Added `docs/REST-API-OPENAPI.yaml` as the canonical target
  contract for the pre-release resource-oriented `/api/v1` redesign. The item
  remains open until implementation and tests are aligned to that schema.

## Prerequisite

- **FEAT-013** — the primary WebServer REST surface must land first
