---
id: FEAT-042
title: Automatic IP filter update scheduling
status: Done
priority: Minor
category: feature
labels: [ipfilter, security, automation, preferences, emuleai]
milestone: ~
created: 2026-04-25
source: `analysis\emuleai` v1.4 release notes
---

## Summary

Add an optional scheduler for updating `ipfilter.dat` from a configured URL
using the already-hardened safe download and promotion path.

## Mainline Shape

- reuses the manual IP-filter archive/plain-file install and atomic promotion path
- adds an explicit Security-page auto-update toggle and configurable day interval
- stores a first-class update URL, defaulting to `http://upd.emule-security.org/ipfilter.zip`
- queues one post-startup background refresh when enabled and due
- reloads the running `CIPFilter` instance and reapplies filtered-server pruning after successful promotion
- rejects empty or markup-like downloads before they can replace the live filter

## Acceptance Criteria

- [x] automatic updates are disabled by default
- [x] the interval is persisted and validated
- [x] the manual update path and automatic path share the same safe promotion
      logic
- [x] invalid downloads preserve the previous live `ipfilter.dat`
