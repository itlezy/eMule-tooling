---
id: FEAT-035
title: IPv6 dual-stack networking for peers, friends, Kad, and server surfaces
status: Open
priority: Major
category: feature
labels: [ipv6, networking, dual-stack, kad, sockets, friends]
milestone: ~
created: 2026-04-20
source: eMuleAI release notes; eMule Qt announcement 2026-03-05
---

## Summary

Add real IPv6 support across the networking stack instead of remaining IPv4-only.

This is an explicit expansion feature, not a stock-preserving hardening task. The goal is
dual-stack operation:

- IPv4 continues to work unchanged
- IPv6-capable peers can connect directly over IPv6
- addresses display, persist, copy, and log correctly across the app

## Why Add It

Both local and current web signals point in the same direction:

- eMuleAI already ships an early IPv6 line
- eMule Qt publicly calls IPv6 one of the features the community has been asking for
- more users now sit behind CGNAT or IPv6-heavy consumer/mobile networks where IPv4-only
  behavior is increasingly limiting

## Intended Mainline Shape

- introduce a first-class peer/server address abstraction instead of assuming `uint32`
  IPv4 everywhere
- dual-stack listen/connect behavior for peer and server sockets
- IPv6-capable friend handling and clipboard/UI display
- Kad and source paths updated to carry IPv6 addresses safely
- logging, tooltips, lists, and copy actions show bracketed IPv6 endpoints correctly
- settings and bind policy extended to cover IPv6 interfaces cleanly

## Scope Constraints

- keep IPv4 behavior fully intact
- prefer dual-stack over IPv6-only design
- defer any larger transport rewrite unless it is strictly required
- coordinate with `FEAT-032` and future traversal work rather than duplicating
  connectivity policy

## Acceptance Criteria

- [ ] peer and server sockets can listen and connect on IPv6
- [ ] friends, logs, lists, and tooltips display IPv6 endpoints correctly
- [ ] Kad/source/address persistence handles IPv6 safely
- [ ] bind policy can target IPv6-capable interfaces without regressing IPv4
- [ ] mixed IPv4/IPv6 sessions run without breaking current network behavior
