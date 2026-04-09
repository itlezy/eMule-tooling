---
id: FEAT-001
title: Kad FastKad — add diversity-aware bootstrap ranking and aggressive stale decay
status: Open
priority: Minor
category: feature
labels: [kad, fastkad, routing, bootstrap]
milestone: ~
created: 2026-04-08
source: AUDIT-KAD.md (AUD_KAD_004, AUD_KAD_005)
---

## Summary

`FastKad` is the local bootstrap quality cache in the target. It persists
response-time hints in `nodes.fastkad.dat` and uses recency, health, and
observed latency for bootstrap ranking. It is worth keeping and extending.

**Current weaknesses (AUD_KAD_005):**

- Bootstrap ranking is not diversity-aware — may over-prefer a dense cluster
  of once-good nodes in the same subnet.
- Long-dormant nodes can retain stale positive hints indefinitely.
- No explicit subnet balancing in bootstrap candidate selection.
- No jitter tracking — only approximate response-time spread.
- Quality is global, not segmented by operation type (bootstrap vs hello
  verification vs search).

## Protocol Compatibility

All improvements are **local policy only** — no Kad packet changes.

## Proposed Improvements

1. **Diversity bias** — when ranking bootstrap candidates, apply a per-subnet
   preference limit (e.g. max 1 preferred candidate per `/24`).
2. **Aggressive stale decay** — increase health decay rate for nodes that have
   not responded recently. Cap very old dormant sidecar influence.
3. **Jitter tracking** — add variance/jitter field alongside mean response time
   to avoid over-trusting high-variance nodes.
4. **Operation-type quality bands** — track separate quality estimates for:
   - bootstrap traffic
   - hello verification
   - search-response traffic
5. **Adaptive concurrency** — use adaptive concurrency limits in addition to
   adaptive timeout.

## Files

- `srchybrid/kademlia/utils/FastKad.h` / `FastKad.cpp`
- `srchybrid/kademlia/kademlia/Kademlia.h` / `.cpp` — bootstrap progress state

## Experimental Reference Implementation

**Status in `stale-v0.72a-experimental-clean`:** Core bootstrap-ranking implementation is done. `FastKad.cpp/h` is present in `srchybrid/kademlia/utils/` and includes:
- `CFastKad` class with `NodeKey` (ID + UDP port), `NodeState` (health score, last success, response time), and `SidecarEntry` for persistence
- `TrackNodeResponse`, `TrackNodeReachable`, `TrackNodeFailure` for node health tracking
- `GetBootstrapPriority(ID, port)` — returns a priority score combining health and recency for bootstrap candidate ranking
- `LoadNodesMetadata` / `SaveNodesMetadata` — persistent sidecar in `nodes.fastkad.dat` (binary, magic `KDF1`)
- Response time mean estimated via exponential mean; health clamped to `[-50, +50]` range
- `NodesDatSupport.cpp/h` added for `nodes.dat` refresh/update helpers

**What's NOT done yet (still on the proposed list):**
- Diversity-aware subnet balancing in bootstrap candidate selection
- Operation-type quality bands (bootstrap vs search vs hello)
- Adaptive concurrency limits

**Porting note:** `FastKad.cpp/h` and `NodesDatSupport.cpp/h` are new files — add them to `emule.vcxproj` and include `FastKad.h` in `Kademlia.h`/`.cpp`. The bootstrap call in `Kademlia.cpp` needs a `GetBootstrapPriority`-ordered sort added to the node list preparation. The integration is commit `4798953` in experimental.
