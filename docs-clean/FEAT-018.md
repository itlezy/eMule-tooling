---
id: FEAT-018
title: µTP (Micro Transport Protocol) transport layer — CUtpSocket / libutp
status: Open
priority: Minor
category: feature
labels: [network, utp, transport, congestion-control, libutp]
milestone: ~
created: 2026-04-10
source: eMuleAI (CUtpSocket.cpp/h, UtpSocket attribution to David Xanatos / NeoLoader, 2013/2026)
---

## Summary

µTP (Micro Transport Protocol, also known as uTorrent Transport Protocol) is a UDP-based
transport protocol designed to provide reliable, ordered delivery with congestion control
that is friendlier to the network than TCP. It is the transport used by BitTorrent for
"bandwidth management" — it backs off under load while TCP does not, reducing latency on
shared connections.

eMuleAI implements µTP via `CUtpSocket` (a `CAsyncSocketExLayer` subclass) backed by
**libutp** (Bram Cohen's reference µTP library, used by BitTorrent / qBittorrent). This
allows eMule connections to use µTP in place of raw TCP where both peers support it.

## eMuleAI Reference Implementation

**Source files in `eMuleAI/`:**
- `CUtpSocket.cpp` / `CUtpSocket.h` — the socket layer wrapper (~400+ lines)
- `eMuleAI/Buffer.cpp` / `Buffer.h` — auxiliary byte-buffer abstraction used by CUtpSocket
- Dependency: `libutp/include/libutp/utp.h` — libutp external library

**Architecture:**

`CUtpSocket` inherits `CAsyncSocketExLayer`, slotting into the existing layered socket model
alongside `CEncryptedStreamSocket`. It overrides `Create`, `Connect`, `Receive`, `Send`,
`Close`, and `GetPeerName`.

Key runtime details:
- Uses two `CCriticalSection` locks: `g_utpSocketsLock` (socket set), `g_utpRuntimeLock`
  (libutp API serialization)
- MTU discovery via `GetBestInterfaceEx` + `GetIpInterfaceEntry` (IP Helper API, runtime-loaded)
- Peer endpoint hinting via `ExpectPeer()` for inbound accept matching
- Multiple libutp context tracking for multi-context environments
- Socket cap: `kMaxUtpSockets = 2048`
- High-resolution timing via `QueryPerformanceCounter`

**Dynamic MTU query:** `CUtpSocket.cpp` implements `QueryMtuForPeer()` using `GetBestInterfaceEx`
and `GetIpInterfaceEntry` loaded at runtime from `iphlpapi.dll`. Falls back to a conservative
MTU if the query fails.

## Why This Matters

For eMule users on shared connections (home routers, CGNAT, shared ISP infrastructure),
eMule's TCP connections currently compete aggressively with other traffic (web browsing,
video streaming). µTP would make eMule a "background" protocol, dramatically reducing
latency impact on the shared connection while maintaining throughput when the network is idle.

This is the single networking improvement most likely to improve user experience on modern
home networks. qBittorrent, Transmission, and Deluge all default to µTP.

## Integration Considerations

1. **Negotiation**: µTP requires protocol-level negotiation. Both peers must support it.
   This requires an eMule extension flag or a fallback-to-TCP mechanism. eMuleAI's approach
   is to try µTP first and fall back to TCP on failure.

2. **libutp dependency**: libutp is a C library. Requires adding it as a submodule or
   vendoring it. It is MIT-licensed and actively maintained by BitTorrent Inc.

3. **Layer insertion**: `CUtpSocket` slots in as an `CAsyncSocketExLayer` layer. The existing
   `CEncryptedStreamSocket` layer still works on top. No protocol changes needed.

4. **UDP multiplexing**: µTP runs over UDP. The existing `CClientUDPSocket` / `CUDPSocket`
   infrastructure would need to demultiplex µTP packets from eMule UDP packets.
   eMuleAI's approach uses `ProcessUtpPacket()` called from the UDP receive path.

5. **Coordinate with REF-029** (WSAPoll UDP backend): If the UDP sockets are migrated to
   WSAPoll, µTP demultiplexing needs to work in that framework.

## Acceptance Criteria

- [ ] libutp added as a submodule or vendored in `srchybrid/libutp/`
- [ ] `CUtpSocket` / `CUtpSocket.h` implemented and compilable
- [ ] µTP negotiation flag defined in extension bits (coordinate with protocol team)
- [ ] Fall-back to TCP if µTP fails or peer doesn't support it
- [ ] µTP packets demultiplexed from standard eMule UDP in `CClientUDPSocket::OnReceive`
- [ ] No regression in standard TCP eMule transfers
- [ ] Preferences toggle: enable/disable µTP (default: enabled)
