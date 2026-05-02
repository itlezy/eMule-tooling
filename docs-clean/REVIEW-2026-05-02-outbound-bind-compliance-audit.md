---
id: REVIEW-2026-05-02-outbound-bind-compliance-audit
title: Outbound bind compliance audit for VPN/interface binding
date: 2026-05-02
scope: eMule-main main outbound socket and helper-traffic review
---

# Outbound Bind Compliance Audit

This review audited outbound network paths in
`EMULE_WORKSPACE_ROOT\workspaces\v0.72a\app\eMule-main` on `main`, with the
specific question of whether traffic honors the configured eMule bind address
or bind interface.

No app source changes were made for this review.

## Product Decision

The current state is accepted as-is for now.

Core eD2K/Kad/server/peer traffic is bind-compliant. Auxiliary helper traffic
is documented as non-P2P system or user traffic and is not treated as an
immediate runtime download/network risk. If the product later requires strict
all-process egress enforcement while VPN protection is enabled, the helper
traffic listed below is the first place to harden.

## Summary

The normal P2P transfer and control paths use `thePrefs.GetBindAddr()` or
`thePrefs.GetBindAddrA()` when creating sockets. With a specific interface
selected and resolved to an address, normal ed2k/Kad/server/peer sockets should
either bind to that address or fail.

The remaining unbound traffic is mostly outside the core P2P stack:

- WinInet-based update and file download helpers
- automatic IP filter and GeoLocation refreshes
- SMTP notifier
- IRC client
- external browser handoff for online help
- WebServer inbound listener, which has its own `WebBindAddr`

These paths can use the operating system's default route or their own subsystem
policy instead of eMule's P2P bind address.

## Classification

### P2P bound

These paths are bind-compliant for the current P2P surface:

| Path | Classification | Evidence |
|------|----------------|----------|
| Server TCP connect | P2P bound | `srchybrid/ServerConnect.cpp` creates `CServerSocket` with `thePrefs.GetBindAddr()` before connecting to a server. |
| Peer TCP connect | P2P bound | `srchybrid/ListenSocket.cpp` creates `CClientReqSocket` with `thePrefs.GetBindAddr()` before outbound peer connects. |
| `CEMSocket` TCP base | P2P bound | `srchybrid/EMSocket.cpp` creates sockets with `thePrefs.GetBindAddr()`. |
| Peer TCP listen socket | P2P bound | `srchybrid/ListenSocket.cpp` starts the listening socket with `thePrefs.GetBindAddr()`. |
| Client/Kad UDP socket | P2P bound | `srchybrid/ClientUDPSocket.cpp` creates the UDP socket on `thePrefs.GetUDPPort()` with `thePrefs.GetBindAddr()`. |
| Server UDP socket | P2P bound | `srchybrid/UDPSocket.cpp` creates the server UDP socket with `thePrefs.GetBindAddrW()`. |
| Pinger helper | P2P-adjacent bound | `srchybrid/Pinger.cpp` derives the raw ICMP and UDP ping bind address from `thePrefs.GetBindAddrA()`. |
| Proxy-layer P2P sockets | P2P bound via owner socket | `CAsyncSocketEx` and layer retry paths bind newly-created sockets before `connect()`. |

Impact: these are the important download, upload, server-control, Kad, and peer
paths. The VPN/interface binding work covers the core runtime traffic that can
identify or exchange data with the P2P network.

### Bind-aware NAT traversal

These paths are not normal peer/server traffic, but they are aware of the P2P
bind address:

| Path | Classification | Evidence |
|------|----------------|----------|
| MiniUPnP discovery | Bind-aware | `srchybrid/UPnPImplMiniLib.cpp` passes `thePrefs.GetBindAddrA()` to `upnpDiscover()`. |
| PCP/NAT-PMP source address | Bind-aware when bound | `srchybrid/UPnPImplPcpNatPmp.cpp` uses `thePrefs.GetBindAddrA()` as the source address when it is present and parseable. |
| PCP/NAT-PMP route probe | Unbound only when no bind address exists | If no bind address is configured, `UPnPImplPcpNatPmp.cpp` creates a UDP socket and `connect()`s to `1.1.1.1:9` only to discover the OS-selected local source address. |

Impact: with a specific bind interface/address selected, PCP/NAT-PMP should use
that source address. The unbound `1.1.1.1:9` route probe is not a bind-mode VPN
leak in the configured-bind case, but it should be guarded if a future strict
"no unbound probes" policy is added.

### Non-P2P system or user traffic

These paths are not app-level bind-compliant today:

| Path | Classification | Evidence |
|------|----------------|----------|
| GitHub release/version check | Non-P2P system HTTP | `srchybrid/ReleaseUpdateCheck.cpp` uses WinInet `InternetOpen()` and `InternetOpenUrl()` with system routing/proxy behavior. |
| Manual HTTP downloads | Non-P2P user HTTP | `srchybrid/HttpDownloadDlg.cpp` uses WinInet `InternetOpen()`, `InternetConnect()`, `HttpOpenRequest()`, and `HttpSendRequest()`. This covers server.met downloads, nodes.dat downloads, language downloads, and manual IP filter downloads. |
| Automatic IP filter refresh | Non-P2P system HTTP | `srchybrid/IPFilterUpdater.cpp` calls `DirectDownload::DownloadUrlToFile()`, which uses WinInet directly. |
| Automatic GeoLocation refresh | Non-P2P system HTTP | `srchybrid/GeoLocation.cpp` calls `DirectDownload::DownloadUrlToFile()`, which uses WinInet directly. |
| Direct download helper | Non-P2P system HTTP | `srchybrid/DirectDownload.cpp` uses WinInet direct mode and has no eMule bind-address hook. |
| SMTP notifier | Non-P2P user SMTP | `srchybrid/SendMail.cpp` uses `mbedtls_net_connect()` directly and does not bind the local socket to `thePrefs.GetBindAddr()`. |
| IRC client | Non-P2P user chat | `srchybrid/IrcMain.cpp` calls `CIrcSocket::Create()` without passing the eMule bind address, so the IRC socket binds to any/default local interface. |

Impact: if VPN protection is interpreted as "protect P2P traffic", these paths
are acceptable current behavior. If it is interpreted as "all eMule-owned
network traffic must use the VPN interface", these are leak candidates because
they may follow the OS default route while the selected bind interface is still
present.

### Out of scope or separately bound

| Path | Classification | Evidence |
|------|----------------|----------|
| Online help URL | External process handoff | `srchybrid/Emule.cpp` opens the help URL through the browser; any network traffic belongs to the browser process, not eMule's socket layer. |
| WebServer/WebSocket | Inbound listener with separate bind policy | `srchybrid/WebSocket.cpp` binds the embedded web listener through `WebBindAddr`, not the P2P bind address. |
| Public IP discovery through peers/servers | P2P bound by transport | Public IP answers are carried over already-bound server or peer protocol sockets rather than through a separate HTTP service. |

## Actual Impact

The current bind feature protects the traffic most users mean when they say
"eMule network traffic": ed2k server TCP/UDP, peer TCP, client/Kad UDP, and
Kad/server control traffic.

The current bind feature does not guarantee that every auxiliary eMule feature
uses the selected VPN interface. A user who enables version checks, automatic
IP filter refresh, automatic GeoLocation refresh, SMTP notifications, IRC, or
manual WinInet downloads should assume those operations use normal OS routing.

The existing "exit if bound interface is lost" option reduces the window for
accidental P2P fallback when the selected interface disappears. It does not make
WinInet, mbedTLS SMTP, IRC, or external browser traffic app-bound.

## Future Hardening Options

No new backlog item is opened by this note. If strict all-app VPN egress becomes
a product goal, the preferred order is:

1. Gate auxiliary network helpers while VPN protection is active:
   version checks, automatic IP filter refresh, automatic GeoLocation refresh,
   SMTP notifier, IRC, and manual WinInet download dialogs.
2. Replace WinInet helper downloads with an app-owned HTTP(S) client that can
   bind sockets explicitly, or route all such requests through an explicitly
   configured proxy model.
3. Replace `mbedtls_net_connect()` in the SMTP notifier with an app-owned
   connect-and-bind wrapper before TLS setup, if SMTP remains in scope.
4. Pass `thePrefs.GetBindAddr()` through the IRC socket creation path, or retire
   IRC under the broader legacy-removal plan.
5. Guard the PCP/NAT-PMP no-bind `1.1.1.1:9` route probe if future policy
   forbids unbound route probes even when no bind address is configured.

## Related Tracking

- `FEAT-030` covers the already-landed P2P bind-policy completion.
- `REF-025` covers possible removal of legacy IRC and SMTP surfaces.
- `FEAT-042` covers automatic IP filter update scheduling; its download helper
  remains classified here as non-P2P system HTTP.
- This review intentionally does not change `docs-clean` non-done counts.
