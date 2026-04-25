---
id: FEAT-032
title: NAT mapping modernization — keep MiniUPnP, drop WinServ, add PCP/NAT-PMP
status: In Progress
priority: Minor
category: feature
labels: [networking, upnp, nat-pmp, pcp, miniupnp, preferences]
milestone: ~
created: 2026-04-20
source: 2026-04-20 UPnP robustness review plus PCP/NAT-PMP dependency follow-through
---

## Summary

Current `main` historically carried two UPnP codepaths:

- `miniupnpc` for `UPnP IGD`
- legacy Windows-service/COM discovery and mapping in `UPnPImplWinServ`

That mixed stack is noisy and hard to reason about in practice. Typical logs
show MiniUPnP finding a valid IGD, then an unrelated Windows-service fallback
failure that does not help the operator understand what actually happened.

`FEAT-032` modernizes the NAT-mapping stack by:

- keeping `miniupnpc` as the `UPnP IGD` backend
- removing the legacy Windows-service/COM backend
- adding `libpcpnatpmp` as a second protocol-family backend for `PCP` /
  `NAT-PMP`
- exposing a new Tweaks backend-mode selector

## Intended Mainline Shape

- Backends:
  - `Automatic`
    - try `UPnP IGD (MiniUPnP)` first
    - fall back to `PCP/NAT-PMP`
  - `UPnP IGD only`
  - `PCP/NAT-PMP only`
- Existing top-level settings remain:
  - `EnableUPnP`
  - `WebUseUPnP`
  - `CloseUPnPOnExit`
- Mapping scope remains:
  - main TCP port
  - main UDP port
  - WebServer TCP port when `WebUseUPnP` is enabled

## Current Local Runtime Slice

The current local workspace implementation has completed the code/build phase:

- removed `UPnPImplWinServ.cpp/.h` from the app
- added `UPnPImplPcpNatPmp.cpp/.h`
- simplified the wrapper to MiniUPnP plus PCP/NAT-PMP ordering only
- removed WinServ-only active prefs:
  - `SkipWANIPSetup`
  - `SkipWANPPPSetup`
  - remembered `LastWorkingImplementation`
  - backend disable toggles
- added a new Tweaks radio-group backend selector:
  - `Automatic`
  - `UPnP IGD only`
  - `PCP/NAT-PMP only`
- updated `eMule-build` so `build-app` now requires and passes the
  `libpcpnatpmp` static library through the supported workspace build path
- locked the `Automatic` backend order through a seam-level policy so
  `UPnP IGD (MiniUPnP)` is attempted before `PCP/NAT-PMP`

## Remaining Completion Work

Still needed before this should be marked `Done`:

- live-network validation of:
  - MiniUPnP success path
  - PCP/NAT-PMP fallback path where available
  - explicit `PCP/NAT-PMP only` mode
- final commit/landing bookkeeping once the local runtime slice is accepted

## Acceptance Criteria

- [x] `UPnPImplWinServ` removed from the app build
- [x] `miniupnpc` remains the `UPnP IGD` backend
- [x] `libpcpnatpmp` is linked into the supported app build
- [x] Tweaks exposes `Automatic` / `UPnP IGD only` / `PCP/NAT-PMP only`
- [x] native tests cover `Automatic` as UPnP IGD first, then PCP/NAT-PMP
- [x] WinServ-only active prefs are removed from runtime behavior
- [x] supported `eMule-build` app builds pass for active architectures
- [ ] live-network NAT-mapping validation completed on current `main`
