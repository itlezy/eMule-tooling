---
id: FEAT-030
title: Bind policy completion — global `BindAddr` everywhere else, separate `WebBindAddr` for WebServer
status: In Progress
priority: Minor
category: feature
labels: [networking, bind, webserver, preferences, sockets, hardening]
milestone: ~
created: 2026-04-18
source: current `main` bind-address audit and follow-up implementation
---

## Summary

Current `main` already applies the global `BindAddr` to the core peer/server UDP
and TCP sockets, but the embedded webserver still reuses that same bind directly
and ancillary socket users were not fully re-audited.

`FEAT-030` finishes the policy in a low-drift way:

- keep the global `BindAddr` as the single bind setting for all non-web socket paths
- add a separate `WebBindAddr` override for the embedded WebServer
- audit and close any remaining socket-open paths which were still using wildcard bind

## Intended Mainline Shape

- New persisted web setting:
  - `WebBindAddr`
- Web listener semantics:
  - empty `WebBindAddr` = bind all interfaces
  - non-empty `WebBindAddr` = bind only that IPv4 address
- Non-web sockets continue to follow the existing global `BindAddr`

## Audited Coverage

Already under the global `BindAddr`:

- incoming peer TCP listener
- outgoing peer TCP sockets
- outgoing server TCP sockets
- client/Kad UDP socket
- server UDP socket
- proxy-backed outgoing TCP init
- UPnP discovery source bind

Explicit follow-up in this item:

- split WebServer listener onto `WebBindAddr`
- bring ancillary socket users such as `Pinger` under the global bind policy

Not a separate bind target:

- accepted child sockets that inherit from an already-bound listener
- Kad traffic that rides the already-bound client UDP socket

## Scope Boundaries

In scope:

- bind-address policy only
- preference persistence and WebServer settings UI
- narrow ancillary socket fixes discovered by audit

Out of scope:

- interface-id-based bind UI redesign
- IPv6 bind support
- new per-subsystem bind settings beyond WebServer
- broader WebServer/REST changes

## Acceptance Criteria

- [ ] `WebBindAddr` persists in the `WebServer` section
- [ ] WebServer binds wildcard when `WebBindAddr` is empty
- [ ] WebServer binds only the override IP when `WebBindAddr` is set
- [ ] non-web socket paths continue to use the global `BindAddr`
- [ ] ancillary audited socket paths no longer bypass the global bind policy
