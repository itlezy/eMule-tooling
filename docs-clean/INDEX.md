# eMule Clean Backlog — Issue Index

This directory is the active backlog and revalidation layer for this repo.
Use [`../docs/INDEX.md`](../docs/INDEX.md) for long-form background and
reference reading.

> Historical reference only: `stale-v0.72a-experimental-clean` and
> `analysis\stale-v0.72a-experimental-clean` are retired reference sources, not
> active branch targets or current baselines. Use them only as provenance or
> idea-extraction sources; landed status is determined against `main`. See
> [Historical References](../docs/HISTORICAL-REFERENCES.md).

## Current Snapshot

**Source of truth:** `EMULE_WORKSPACE_ROOT\workspaces\v0.72a\app\eMule-main` (`main` branch)  
**Current non-done count:** `78`
**Latest status refresh:** 2026-05-02
**Broadband release status:** pre-release stabilization; no official release
tag or package should be cut until the Release 1.0 gates are revalidated and
the operator steps are complete.
**First-release backlog view:** [RELEASE-1.0](RELEASE-1.0.md)
**First-release checklist:** [RELEASE-1.0-CHECKLIST](RELEASE-1.0-CHECKLIST.md)
**First-release runbook:** [RELEASE-1.0-RUNBOOK](RELEASE-1.0-RUNBOOK.md)
**First-release REST/Arr deep plan:** [RELEASE-1.0 REST/Arr deep plan](RELEASE-1.0-REST-ARR-EXECUTION-PLAN.md)

Latest review trail:

- [RELEASE-1.0](RELEASE-1.0.md)
- [RELEASE-1.0-CHECKLIST](RELEASE-1.0-CHECKLIST.md)
- [RELEASE-1.0-RUNBOOK](RELEASE-1.0-RUNBOOK.md)
- [RELEASE-1.0 REST/Arr deep plan](RELEASE-1.0-REST-ARR-EXECUTION-PLAN.md)
- [REVIEW-2026-05-02-outbound-bind-compliance-audit](REVIEW-2026-05-02-outbound-bind-compliance-audit.md)
- [REVIEW-2026-05-01-release-readiness-regression-scan](REVIEW-2026-05-01-release-readiness-regression-scan.md)
- [REVIEW-2026-04-26-main-bug-concurrency-scan](REVIEW-2026-04-26-main-bug-concurrency-scan.md)
- [REVIEW-2026-04-26-emuleai-mods-broadband-scan](REVIEW-2026-04-26-emuleai-mods-broadband-scan.md)
- [REVIEW-2026-04-25-current-main-backlog-refresh](REVIEW-2026-04-25-current-main-backlog-refresh.md)
- [REVIEW-2026-04-20-emuleai-mods-main-backlog-pass](REVIEW-2026-04-20-emuleai-mods-main-backlog-pass.md)
- [REVIEW-2026-04-20-feature-expansion-beyond-stock](REVIEW-2026-04-20-feature-expansion-beyond-stock.md)
- [REVIEW-2026-04-18-emuleai-vs-main-hardening-pass](REVIEW-2026-04-18-emuleai-vs-main-hardening-pass.md)

## Operating Rules

**Priority scale:** Critical > Major > Minor > Trivial  
**Status values:** Open / In Progress / Blocked / Deferred / Passed / Done /
Wont-Fix

**Directory role:** `docs-clean/` owns current backlog status and dated
revalidation notes; `docs/` owns long-form background and historical reference
analysis.

**Important:** Items marked Done below are verified in `eMule-main`. Items marked In
Progress may already be implemented on dedicated bug/feature branches but are not
considered landed until merged to `main`. Experimental-only work (see individual docs) is
not in `main` unless the item status below says otherwise.

**Revalidation rule:** Before implementing any item, re-check it against current `main`
and current dependency pins.

**Regression rule:** New feature/fix work from this backlog should include targeted
regression checks. When behavior changes, compare `main` against
`release/v0.72a-community` as the seam-enabled parity and regression baseline
where that comparison is meaningful.

**Baseline stack rule:**

- `release/v0.72a-community` = seam-enabled parity and regression baseline,
  test-only
- `tracing-harness/v0.72a-community` = behavior-changing variant-client parity
  harness, not the default baseline
- `release/v0.72a-broadband` = broadband pre-release stabilization branch and
  the only release-intent branch

---

## Bugs

| ID | Priority | Status | Title |
|----|----------|--------|-------|
| [BUG-001](BUG-001.md) | Major | **Done** | 17+ load-only hidden prefs not written back to preferences.ini |
| [BUG-002](BUG-002.md) | Minor | Wont-Fix | ASSERT(0) FIXME in ArchiveRecovery.cpp — silent fail in release *(kept as-is by product decision)* |
| [BUG-003](BUG-003.md) | Minor | **Done** | Historical large-file FIXME markers overstated the remaining live issue |
| [BUG-004](BUG-004.md) | Minor | **Done** | IPFilter overlapping IP ranges not handled — acknowledged correctness gap |
| [BUG-005](BUG-005.md) | Minor | Wont-Fix | Kad buddy connections broken when RequireCrypt is enabled |
| [BUG-006](BUG-006.md) | Minor | Wont-Fix | Weak RNG for crypto challenge — rand() seeded with time(NULL) *(accepted risk by product decision)* |
| [BUG-007](BUG-007.md) | Minor | **Done** | Ring.h — three UB + correctness bugs in CRing\<T\> (CODEREV_003, 004, 011) |
| [BUG-008](BUG-008.md) | Minor | Wont-Fix | CaptchaGenerator — rand() & 8 bimodal jitter *(low release value; leave to REF-027 if reopened)* |
| [BUG-009](BUG-009.md) | Minor | **Done** | PartFile — non-atomic part.met replacement (_tremove + _trename crash window) |
| [BUG-010](BUG-010.md) | Minor | **Done** | PartFile — part.met write on low disk space risks truncation/corruption |
| [BUG-011](BUG-011.md) | Minor | **Done** | Race — shareddir_list iterated without lock in SendSharedDirectories |
| [BUG-012](BUG-012.md) | Minor | **Done** | CPartFile destructor calls FlushBuffer after write thread has already exited |
| [BUG-013](BUG-013.md) | Minor | Wont-Fix | ArchiveRecovery.cpp — three unchecked malloc() calls crash on OOM *(kept as-is by product decision)* |
| [BUG-014](BUG-014.md) | Minor | **Done** | ZIPFile.cpp — WriteFile return value silently discarded on two paths |
| [BUG-015](BUG-015.md) | Minor | **Done** | GetTickCount() 49-day overflow in ban expiry and download timeout checks |
| [BUG-016](BUG-016.md) | Minor | **Done** | UDP obfuscation applied when crypt layer is disabled — IsCryptLayerEnabled() guard missing |
| [BUG-017](BUG-017.md) | Minor | **Done** | UDP throttler deadlock — sendLocker held when signaling QueueForSendingControlPacket |
| [BUG-018](BUG-018.md) | Minor | **Done** | Part-file hash layout drift — hash tree can mutate during concurrent hashing |
| [BUG-019](BUG-019.md) | Minor | **Done** | AICH sync thread concurrency — UI deadlocks, starvation, incomplete/duplicate nodes |
| [BUG-020](BUG-020.md) | Minor | **Done** | Client socket teardown ordering — cross-link not cleared before Safe_Delete |
| [BUG-021](BUG-021.md) | Minor | **Done** | Upload queue lock inversion + socket I/O result mishandling + inflate buffer aliasing |
| [BUG-022](BUG-022.md) | Major | **Done** | Long-path delete-to-recycle-bin still breaks in ShellDeleteFile |
| [BUG-023](BUG-023.md) | Minor | **Done** | Shared-file ED2K published column shows a false `No` after publish-state reset |
| [BUG-024](BUG-024.md) | Minor | **Done** | `statUTC(HANDLE)` returns corrupted `st_size` by using `nFileIndexLow` |
| [BUG-025](BUG-025.md) | Minor | **Done** | KnownFile hashing open failures log stale or wrong error text on Win32 open failure |
| [BUG-026](BUG-026.md) | Major | **Done** | Search tab teardown frees live result/tab payload objects before the UI detaches them |
| [BUG-027](BUG-027.md) | Major | **Done** | IP filter update can delete the live `ipfilter.dat` before replacement promotion succeeds |
| [BUG-028](BUG-028.md) | Minor | Wont-Fix | MP3 ID3 metadata extraction is ANSI-only; non-ACP filenames can silently lose tags |
| [BUG-029](BUG-029.md) | Major | **Done** | Long-path tail hardening across config, media, shell, and GeoLocation surfaces |
| [BUG-030](BUG-030.md) | Minor | **Done** | Obfuscated server logins can advertise redundant callback crypto flags and require extra attempts |
| [BUG-031](BUG-031.md) | Minor | Deferred | Shared-file hashing fails too eagerly on transient sharing and lock violations |
| [BUG-032](BUG-032.md) | Minor | **Done** | AICH hashset save can fail spuriously after hashing because `known2.met` lock wait times out |
| [BUG-033](BUG-033.md) | Minor | Wont-Fix | WebSocket and MiniUPnP shutdown still use forced thread termination |
| [BUG-034](BUG-034.md) | Minor | In Progress | Release paths silently swallow unexpected exceptions via catch (...) plus ASSERT(0) |
| [BUG-035](BUG-035.md) | Minor | In Progress | Historical control-flow still uses bare ASSERT(0) without recovery or logging |
| [BUG-036](BUG-036.md) | Major | **Done** | `known.met` and `cancelled.met` still save in place and can truncate on failure |
| [BUG-037](BUG-037.md) | Major | **Done** | Same-hash KnownFile replacement can unshare or mis-track equivalent files |
| [BUG-038](BUG-038.md) | Minor | **Done** | Shared Files sort can retain stale rows after backing data changes |
| [BUG-039](BUG-039.md) | Minor | **Done** | Client list lacked a reusable safe pointer membership check |
| [BUG-040](BUG-040.md) | Major | **Done** | Downloading Clients list could dereference stale client rows |
| [BUG-041](BUG-041.md) | Major | **Done** | Known Clients list could dereference stale client rows |
| [BUG-042](BUG-042.md) | Major | **Done** | Upload list could dereference stale upload rows |
| [BUG-043](BUG-043.md) | Major | **Done** | Queue list could dereference stale queue rows |
| [BUG-044](BUG-044.md) | Major | **Done** | Download source rows could outlive their backing source objects |
| [BUG-045](BUG-045.md) | Minor | **Done** | Server list could dereference stale server rows |
| [BUG-046](BUG-046.md) | Major | **Done** | Kad contact list could dereference stale contact rows |
| [BUG-047](BUG-047.md) | Major | **Done** | Kad search list could dereference stale search rows |
| [BUG-048](BUG-048.md) | Minor | **Done** | IRC nick rows were not cleared before nick objects were deleted |
| [BUG-049](BUG-049.md) | Minor | **Done** | IRC channel tabs were not detached before channel objects were deleted |
| [BUG-050](BUG-050.md) | Minor | **Done** | Chat tabs were not detached before chat items were deleted |
| [BUG-051](BUG-051.md) | Minor | **Done** | IRC channel rows were not cleared before channel entries were deleted |
| [BUG-052](BUG-052.md) | Minor | **Done** | Kad search constructor accidentally added placeholder rows |
| [BUG-053](BUG-053.md) | Major | **Done** | part.met backup could be refreshed from the newly written metadata |
| [BUG-054](BUG-054.md) | Major | **Done** | ESC in shared-file delete confirmation could still delete files |
| [BUG-055](BUG-055.md) | Major | **Done** | AICH recovery accepted invalid part bounds |
| [BUG-056](BUG-056.md) | Major | **Done** | Download Clients list could dereference stale rows during display callbacks |
| [BUG-057](BUG-057.md) | Minor | **Done** | Close All Search Results could leave Kad keyword searches running |
| [BUG-058](BUG-058.md) | Minor | **Done** | Tree option value labels could contain the parser separator |
| [BUG-059](BUG-059.md) | Trivial | **Done** | Download Remaining column alignment was inconsistent |
| [BUG-060](BUG-060.md) | Major | **Done** | REST API should stay available when web templates are absent |
| [BUG-061](BUG-061.md) | Major | **Done** | Legacy web interface template was missing from the shipped tree |
| [BUG-062](BUG-062.md) | Minor | **Done** | Obfuscated server timeout did not retry plain connection promptly |
| [BUG-063](BUG-063.md) | Major | **Done** | ESC in shared-directory delete confirmation could still delete directories |
| [BUG-064](BUG-064.md) | Minor | **Done** | Client list secondary display path needed stale-row guarding |
| [BUG-065](BUG-065.md) | Minor | **Done** | Queue list secondary display path needed stale-row guarding |
| [BUG-066](BUG-066.md) | Minor | **Done** | Upload list secondary display path needed stale-row guarding |
| [BUG-067](BUG-067.md) | Minor | **Done** | REST log route lacked the expected get alias seam |
| [BUG-068](BUG-068.md) | Minor | **Done** | Download progress-bar drawing can leak GDI state into neighboring list cells |
| [BUG-069](BUG-069.md) | Major | **Done** | WebServer static resource requests can escape the web root and allocate whole files |
| [BUG-070](BUG-070.md) | Minor | **Done** | Ignored helper-thread launch failures can hang shutdown waits |
| [BUG-071](BUG-071.md) | Major | **Done** | server.met persistence still uses destructive backup and promotion moves |
| [BUG-072](BUG-072.md) | Minor | **Done** | Kad preferences and routing snapshots still save in place |
| [BUG-073](BUG-073.md) | Major | **Done** | WebServer session and bad-login state is mutated from request threads without synchronization |
| [BUG-074](BUG-074.md) | Minor | Wont-Fix | Archive preview scanner uses volatile cancellation and synchronous UI handoff |
| [BUG-075](BUG-075.md) | Major | **Done** | REST and WebServer typed error consistency |
| [BUG-076](BUG-076.md) | Major | **Done** | WebServer malformed request hardening for REST and legacy HTML |
| [BUG-077](BUG-077.md) | Minor | **Done** | WebServer concurrent REST and legacy HTML soak coverage |

---

## Refactors

| ID | Priority | Status | Title |
|----|----------|--------|-------|
| [REF-001](REF-001.md) | Major | Wont-Fix | Keep the existing CZIPFile implementation |
| [REF-002](REF-002.md) | Major | **Done** | Remove Source Exchange v1 branches |
| [REF-003](REF-003.md) | Trivial | Open | Rename stale IRC string resources *(or full IRC removal — see REF-025)* |
| [REF-004](REF-004.md) | Minor | **Done** | Audit and disposition 17 load-only preference keys |
| [REF-005](REF-005.md) | Trivial | Open | Remove dead DebugSourceExchange commented-out calls |
| [REF-006](REF-006.md) | Trivial | **Done** | GetCategory should be const in DownloadListCtrl |
| [REF-007](REF-007.md) | Trivial | **Done** | WebM vs MKV disambiguation in MIME detection |
| [REF-015](REF-015.md) | Minor | Wont-Fix | Keep miniupnpc as the active UPnP backend |
| [REF-016](REF-016.md) | Trivial | Wont-Fix | Keep ResizableLib out-of-tree instead of inlining it |
| [REF-017](REF-017.md) | Minor | **Done** | Revalidate and close the dead-code sweep backlog item |
| [REF-018](REF-018.md) | Minor | **Done** | Remove defunct PeerCache surface and legacy INI fallback reads |
| [REF-019](REF-019.md) | Minor | **Done** | Replace ASSERT(0) + "must be a bug" with OnError() in EncryptedStreamSocket |
| [REF-020](REF-020.md) | Minor | **Done** | Replace dynamic loading of always-present Win10 APIs with static linking |
| [REF-021](REF-021.md) | Minor | Blocked | Remove blanket warning suppressions and replace deprecated Winsock APIs |
| [REF-022](REF-022.md) | Trivial | Open | Replace custom type aliases in types.h with \<cstdint\> standard types |
| [REF-023](REF-023.md) | Minor | Open | Replace unsafe sprintf/_stprintf/wsprintf with safe equivalents |
| [REF-024](REF-024.md) | Trivial | Open | Convert #define constants in Opcodes.h to constexpr in namespace |
| [REF-025](REF-025.md) | Minor | In Progress | Remove legacy feature set — IRC, SMTP, Scheduler, MiniMule, wizard, splash, update checker |
| [REF-026](REF-026.md) | Minor | **Done** | Manifest — keep Win10/11+ compatibility GUID only and move Common Controls into manifests |
| [REF-027](REF-027.md) | Minor | Open | CaptchaGenerator — replace CxImage with ATL CImage / native GDI (community ref) |
| [REF-028](REF-028.md) | Minor | Open | Upgrade MbedTLS to 4.0 — API rename + TLS 1.3 readiness (community ref) |
| [REF-029](REF-029.md) | Major | Open | Move UDP sockets to WSAPoll backend — AsyncDatagramSocket (experimental ref) |
| [REF-030](REF-030.md) | Minor | Open | Replace WSAAsyncGetHostByName with worker-thread resolver in DownloadQueue (experimental ref) |
| [REF-031](REF-031.md) | Minor | **Done** | Review upload queue scoring against community and stale baselines |
| [REF-032](REF-032.md) | Minor | In Progress | Use MFC-native property sheets and dynamic layout instead of CTreePropSheet / ResizableLib |
| [REF-033](REF-033.md) | Trivial | Open | Remove remaining IE/MSHTML drag-drop, HTML Help, and legacy IE web-client baggage |
| [REF-034](REF-034.md) | Minor | Open | Upgrade Crypto++ from 8.4 to 8.9 and refresh the local MSVC/ARM64 project fork |
| [REF-035](REF-035.md) | Minor | Open | Adopt WIL for narrow Windows and COM RAII cleanup |
| [REF-036](REF-036.md) | Minor | Open | Adopt GSL contracts for buffer and pointer boundary hardening |

---

## Boost Migration (deferred — pending architecture decision)

> These items replace MFC/Win32 primitives with Boost equivalents. They are
> grouped separately because the decision to adopt Boost is independent of the
> rest of the backlog. If Boost is not adopted, these are Wont-Fix; if it is,
> REF-008 must land before REF-009/011.

| ID | Priority | Status | Title |
|----|----------|--------|-------|
| [REF-008](REF-008.md) | Major | Open | Replace CAsyncSocketEx with Boost.Asio (71+ files) |
| [REF-009](REF-009.md) | Major | Open | Replace CCriticalSection + CWinThread with boost::mutex + boost::thread |
| [REF-010](REF-010.md) | Major | Open | Replace raw owned pointers with smart pointers |
| [REF-011](REF-011.md) | Minor | Open | Replace GetTickCount / SetTimer with boost::chrono + Asio timers |
| [REF-012](REF-012.md) | Minor | Open | Replace CFile + path concatenation with boost::filesystem |
| [REF-013](REF-013.md) | Minor | Open | Replace CString + sprintf with std::string + boost::format |
| [REF-014](REF-014.md) | Minor | Open | Replace CRing\<T\> with boost::circular_buffer |

---

## Features

| ID | Priority | Status | Title |
|----|----------|--------|-------|
| [FEAT-001](FEAT-001.md) | Minor | Blocked | Kad FastKad — diversity-aware bootstrap ranking + aggressive stale decay |
| [FEAT-002](FEAT-002.md) | Major | Open | Kad SafeKad — layered trust model / CGNAT fix |
| [FEAT-003](FEAT-003.md) | Minor | Open | Kad — Response usefulness scoring + subnet-diversity search fanout |
| [FEAT-004](FEAT-004.md) | Minor | Open | Kad — Generalise KadPublishGuard abuse budget beyond PUBLISH_SOURCE |
| [FEAT-005](FEAT-005.md) | Minor | Open | Kad — Restore network-change grace handling |
| [FEAT-006](FEAT-006.md) | Minor | Open | Kad — Add observability counters (trust, budget, bootstrap) |
| [FEAT-007](FEAT-007.md) | Minor | Open | Windows Property Store integration for non-media file metadata |
| [FEAT-008](FEAT-008.md) | Trivial | Open | Oracle protocol guard seams — integrate stale branch test scaffolding |
| [FEAT-009](FEAT-009.md) | Trivial | Open | Mirror audit guard seam — WIP from stale branch parent |
| [FEAT-010](FEAT-010.md) | Minor | **Done** | Long path support phase 2 — shell/UI, shared-directory recursion, exact-name paths, and path-helper audit |
| [FEAT-011](FEAT-011.md) | Minor | Open | CShield — integrate ED2K anti-leecher engine (44 bad-client categories) |
| [FEAT-012](FEAT-012.md) | Minor | **Done** | PR_TCPERRORFLOODER — TCP listen-socket flood defense |
| [FEAT-013](FEAT-013.md) | Major | **Done** | REST API — add authenticated in-process JSON endpoints to WebServer |
| [FEAT-014](FEAT-014.md) | Minor | Open | REST API follow-up — OpenAPI docs and optional external gateway |
| [FEAT-015](FEAT-015.md) | Major | **Done** | Broadband upload slot controller — budget-based cap + slow-slot reclamation |
| [FEAT-016](FEAT-016.md) | Major | **Done** | Modern limits — update stale hard-coded defaults for broadband/modern hardware |
| [FEAT-017](FEAT-017.md) | Major | Open | DPI awareness — Per-Monitor V2 manifest + hardcoded pixel audit |
| [FEAT-018](FEAT-018.md) | Minor | Open | µTP transport layer — CUtpSocket / libutp (eMuleAI ref) |
| [FEAT-019](FEAT-019.md) | Minor | Open | Dark mode UI — system-aware Windows 10 dark theme (eMuleAI ref) |
| [FEAT-020](FEAT-020.md) | Trivial | **Done** | DB-IP city geolocation — location label and flag per peer |
| [FEAT-021](FEAT-021.md) | Minor | Open | SourceSaver — persist download source lists between sessions (eMuleAI ref) |
| [FEAT-022](FEAT-022.md) | Minor | **Done** | Startup config directory override — `-c` flag for alternate preferences path |
| [FEAT-023](FEAT-023.md) | Minor | **Done** | Broadband queue scoring and ratio/cooldown UI extras |
| [FEAT-024](FEAT-024.md) | Minor | **Done** | Share-ignore policy with additive `shareignore.dat` |
| [FEAT-025](FEAT-025.md) | Minor | **Done** | Normalize download filenames on intake and completion |
| [FEAT-026](FEAT-026.md) | Minor | **Done** | Shared startup cache with known.met lookup index and `sharedcache.dat` |
| [FEAT-027](FEAT-027.md) | Minor | **Done** | Startup sequencing fix, startup profiling, and shared-view startup churn cleanup |
| [FEAT-028](FEAT-028.md) | Minor | **Done** | Virtualize and harden shared files list |
| [FEAT-029](FEAT-029.md) | Minor | **Done** | Search result ceilings — configurable ed2k expansion plus moderate Kad totals/lifetimes |
| [FEAT-030](FEAT-030.md) | Minor | **Done** | Bind policy completion — global `BindAddr` everywhere else, separate `WebBindAddr` for WebServer |
| [FEAT-031](FEAT-031.md) | Minor | Open | Auto-browse compatible remote shared-file inventories with persisted cache |
| [FEAT-032](FEAT-032.md) | Minor | In Progress | NAT mapping modernization — keep MiniUPnP, drop WinServ, add PCP/NAT-PMP |
| [FEAT-033](FEAT-033.md) | Minor | **Done** | Disk-space floor hardening and legacy import-flow retirement |
| [FEAT-034](FEAT-034.md) | Minor | In Progress | Shared-files reload should stop blocking the UI on large trees |
| [FEAT-035](FEAT-035.md) | Major | Open | IPv6 dual-stack networking for peers, friends, Kad, and server surfaces |
| [FEAT-036](FEAT-036.md) | Major | Open | NAT traversal and extended source exchange for LowID-to-LowID connectivity |
| [FEAT-037](FEAT-037.md) | Minor | Open | Release-oriented sharing controls — PowerShare, Release Bonus, and Share Only The Need |
| [FEAT-038](FEAT-038.md) | Minor | **Done** | Shared-files watcher and live recursive share sync |
| [FEAT-039](FEAT-039.md) | Minor | Open | Download checker — duplicate and near-duplicate intake guard |
| [FEAT-040](FEAT-040.md) | Major | Open | Headless core with modern web/mobile controller and multi-user permissions |
| [FEAT-041](FEAT-041.md) | Minor | Open | Download Inspector automation for stale downloads and majority-name rename |
| [FEAT-042](FEAT-042.md) | Minor | **Done** | Automatic IP filter update scheduling |
| [FEAT-043](FEAT-043.md) | Minor | Open | Known Clients history and incremental list refresh performance |
| [FEAT-044](FEAT-044.md) | Minor | Open | IP filter input policy - PeerGuardian lists, whitelist, and private-IP exemption |
| [FEAT-045](FEAT-045.md) | Major | Open | REST transfer detail endpoint for controller parity |
| [FEAT-046](FEAT-046.md) | Major | Open | REST server and Kad bootstrap/import APIs |
| [FEAT-047](FEAT-047.md) | Minor | Passed | REST search API completeness pass |
| [FEAT-048](FEAT-048.md) | Minor | Open | REST upload queue control completeness |
| [FEAT-049](FEAT-049.md) | Minor | Open | Curated REST preference expansion |
| [FEAT-050](FEAT-050.md) | Minor | **Done** | Launch external program on completed download |
| [FEAT-051](FEAT-051.md) | Minor | **Done** | Pro-user context menus and always-on advanced controls |
| [FEAT-052](FEAT-052.md) | Minor | **Done** | Main-shell keyboard shortcuts and mnemonic audit |
| [FEAT-053](FEAT-053.md) | Minor | **Done** | Classic tray balloon notification mode |
| [FEAT-054](FEAT-054.md) | Minor | **Done** | Normalize download message filename display |

---

## Build / CI / Tooling

| ID | Priority | Status | Title |
|----|----------|--------|-------|
| [CI-001](CI-001.md) | Major | Open | CMake migration — replace emule.vcxproj with CMakeLists.txt + Ninja |
| [CI-002](CI-002.md) | Minor | Open | clang-format — enforce consistent code formatting |
| [CI-003](CI-003.md) | Minor | In Progress | MSVC compiler hardening — SDL, guard:cf, /WX (Phase A done: SDL+CFG in commit `5557216`) |
| [CI-004](CI-004.md) | Minor | Open | clang-tidy — integrate static analysis |
| [CI-005](CI-005.md) | Minor | Open | cppcheck — integrate complementary bug-class analysis |
| [CI-006](CI-006.md) | Minor | Open | MSVC AddressSanitizer — enable for debug builds |
| [CI-007](CI-007.md) | Minor | Open | Kad — Expand integration and fuzz test coverage |
| [CI-008](CI-008.md) | Minor | In Progress | Expand regression coverage for part files, long paths, and WebServer/REST |
| [CI-009](CI-009.md) | Minor | **Done** | Share-ignore regression coverage and Release test-build stabilization |
| [CI-010](CI-010.md) | Minor | Blocked | Reduce remaining app-local warning debt after external noise cleanup |
| [CI-011](CI-011.md) | Major | **Done** | Broadband release live E2E coverage umbrella |
| [CI-012](CI-012.md) | Major | Open | Stabilize Shared Files dynamic folder lifecycle E2E |
| [CI-013](CI-013.md) | Major | Open | Download and search UI live scenarios |
| [CI-014](CI-014.md) | Major | **Done** | REST contract manifest and live completeness gate |
| [CI-015](CI-015.md) | Major | **Done** | REST malformed and concurrent request matrix |
| [CI-016](CI-016.md) | Minor | Open | REST-only main vs community regression lane |
| [CI-017](CI-017.md) | Minor | **Done** | Normalize active workspace line-ending policy to LF by default |

---

## Controller Integrations

| ID | Priority | Status | Title |
|----|----------|--------|-------|
| [AMUT-001](AMUT-001.md) | Major | **Done** | aMuTorrent eMule BB browser smoke coverage |
| [AMUT-002](AMUT-002.md) | Major | Open | aMuTorrent transfer detail hydration |
| [ARR-001](ARR-001.md) | Major | **Done** | Full Arr release E2E validation |

---

## Release Focus

The first-release gate is controlled by [RELEASE-1.0](RELEASE-1.0.md). Use
that page for gate status, candidate decisions, and release validation scope.

REST, aMuTorrent, and Arr implementation detail lives in the
[RELEASE-1.0 REST/Arr deep plan](RELEASE-1.0-REST-ARR-EXECUTION-PLAN.md).

## Reference Material

- [Backlog history](../docs/history/BACKLOG-HISTORY.md)
- [Backlog dependency graph](../docs/history/BACKLOG-DEPENDENCY-GRAPH.md)
- [Backlog source salvage](../docs/history/BACKLOG-SOURCE-SALVAGE.md)

Issues are tracked here, not in the old `docs/` folder. The `docs/` folder
contains historical reference, architecture notes, audits, and plans.
