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
**Current non-done count:** `61`
**Latest status refresh:** 2026-05-01

Latest review trail:

- [REVIEW-2026-05-01-release-readiness-regression-scan](REVIEW-2026-05-01-release-readiness-regression-scan.md)
- [REVIEW-2026-04-26-main-bug-concurrency-scan](REVIEW-2026-04-26-main-bug-concurrency-scan.md)
- [REVIEW-2026-04-26-emuleai-mods-broadband-scan](REVIEW-2026-04-26-emuleai-mods-broadband-scan.md)
- [REVIEW-2026-04-25-current-main-backlog-refresh](REVIEW-2026-04-25-current-main-backlog-refresh.md)
- [REVIEW-2026-04-20-emuleai-mods-main-backlog-pass](REVIEW-2026-04-20-emuleai-mods-main-backlog-pass.md)
- [REVIEW-2026-04-20-feature-expansion-beyond-stock](REVIEW-2026-04-20-feature-expansion-beyond-stock.md)
- [REVIEW-2026-04-18-emuleai-vs-main-hardening-pass](REVIEW-2026-04-18-emuleai-vs-main-hardening-pass.md)

## Operating Rules

**Priority scale:** Critical > Major > Minor > Trivial  
**Status values:** Open / In Progress / Blocked / Deferred / Done / Wont-Fix

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
`release/v0.72a-community` as the seam-enabled baseline where that comparison
is meaningful.

**Baseline stack rule:**

- `release/v0.72a-community` = seam-enabled community baseline
- `tracing-harness/v0.72a-community` = behavior-changing parity harness

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

---

## Priority Triage

### Do First — stabilization / hardening with minimal drift

1. **BUG-034, BUG-035** — continue targeted runtime logging/recovery work; the broad scan is still noisy

### Do Second — narrow stability items still close to current behavior

1. **CI-008** — keep expanding live and targeted regression coverage after the long-path and config-stability slices
2. **CI-010** — continue lowering the remaining app-local warning floor now that SDK and third-party warning mass is contained *(explicitly deferred / Blocked)*
3. **REF-028** — MbedTLS 4.0 upgrade once the current WebServer/TLS surface is stable
4. **FEAT-002** — SafeKad CGNAT fix
5. **FEAT-001** — FastKad diversity/stale-decay follow-through after the landed core port *(explicitly deferred / Blocked)*

### Do Later — useful, but not part of the current stabilization milestone

- **FEAT-017, REF-026, REF-032** — DPI/manifest/MFC-host modernization
- **FEAT-034** — keep manual shared-files reload/hash paths responsive on large trees; watcher/live sync is separate and done in FEAT-038
- **FEAT-043** — Known Clients list/history responsiveness for very large client histories
- **FEAT-044** — richer IP-filter input policy after the safe updater foundation
- **CI-001 through CI-006** — broader build/tooling modernization
- **REF-017, REF-018, REF-020, REF-021, REF-023, REF-025** — cleanup and legacy removal passes
- **REF-027** — CaptchaGenerator rewrite
- **REF-035, REF-036** — narrow modern-library hardening; WIL first, GSL only at tested parser/buffer boundaries
- **REF-029, REF-030** — async socket / resolver work; explicitly future phase, not part of the current stabilization plan
- **FEAT-014** — optional OpenAPI/external gateway follow-up after FEAT-013
- **FEAT-018 through FEAT-021** — larger product features outside the hardening milestone
- **CI-007** — Kad fuzz tests after the broader CI/toolchain stack is ready

### Expansion Track — explicitly beyond stock

- **FEAT-031, FEAT-035 through FEAT-044** — user-directed feature-expansion backlog; evaluate independently from the stabilization/hardening line

---

## Dependency Graph

```
CI-001 (CMake)
  ├── CI-002 (clang-format)
  ├── CI-003 (MSVC hardening — Phase A done, Phase B deferred)
  │     └── CI-006 (ASan)
  │           └── CI-007 (Kad fuzz tests)
  ├── CI-004 (clang-tidy)
  └── CI-005 (cppcheck)

REF-002 (SX v1 removal) ──► REF-005 (dead debug calls)

REF-017 (dead code sweep) ──► REF-018 (PeerCache/proxy cleanup)
REF-021 (remove warning suppressions) ──► REF-023 (fix sprintf sites revealed)
REF-025 (legacy feature removal) — coordinate with REF-003 (IRC strings)
REF-025 (legacy removal) ──► REF-027 (CaptchaGenerator: CxImage removal; easier post-REF-025)
REF-026 (manifest) — pair with FEAT-017 (DPI)
REF-028 (MbedTLS 4.0) — prerequisite for TLS 1.3 support
REF-035 (WIL RAII) — standalone leaf cleanup; coordinate with setup/build dependency pins
REF-035 (WIL RAII) ──► REF-036 (GSL contracts) as staged modern-library hardening, not broad style churn
REF-036 (GSL contracts) ──► CI-008 coverage before touching part-file, archive, parser, or REST boundaries

[Network stack — recommended order]
REF-029 (WSAPoll UDP backend) ──► REF-030 (async hostname resolver)
REF-029 (WSAPoll UDP) — coordinate with FEAT-018 (µTP demux)

[Boost — if adopted]
REF-008 (Boost.Asio) ──► REF-009 (Boost.Thread)
REF-008              ──► REF-011 (Boost.Chrono timers)
REF-008              supersedes REF-029 (WSAPoll UDP) and REF-030 (hostname resolver)

[BUG-009/010/011/012 — DONE in commit 4b4087d]
[BUG-011 — complete fix in commit 0300a9d]
[BUG-001 — DONE in commit 4a02669; REF-004 prefs audit substantially resolved]
[BUG-015 — DONE in commit 6c161c0]
[BUG-016 — DONE in commit 06eaefe]

FEAT-008 (oracle seams) ──► FEAT-009 (mirror audit)
FEAT-013 (WebServer REST) ──► FEAT-014 (OpenAPI / optional external gateway)
FEAT-013 (WebServer REST) ──► BUG-069 (static-file path containment and bounded serving)
FEAT-013 (WebServer REST) ──► BUG-073 (WebServer session-state synchronization)
FEAT-011 (CShield) ──► FEAT-012 (PR_TCPERRORFLOODER, can standalone)
FEAT-015 (slot allocation) ──► FEAT-016 (modern limits — coordinate Opcodes.h values)
FEAT-015 (slot allocation) ──► FEAT-023 (optional scoring/UI extras kept separate)
FEAT-024 (share-ignore policy) ──► CI-009 (share-ignore regressions)
FEAT-025 (filename normalization) — standalone intake/completion hardening
FEAT-026 (shared startup cache) ──► FEAT-027 (startup sequencing, profiling, and startup-path churn cleanup)
FEAT-027 (startup sequencing/profiling) ──► FEAT-028 (shared-files control virtualization and churn reduction)
FEAT-028 (shared-files virtualization) ──► FEAT-034 (manual reload freeze reduction on the same surface)
FEAT-038 (shared-files watcher/live sync) — DONE, separate from remaining FEAT-034 filesystem-I/O hardening
BUG-041 (Known Clients stale-row guard) ──► FEAT-043 (Known Clients history/list responsiveness)
FEAT-015/023 (upload controller/scoring) ──► FEAT-037 (release-oriented sharing controls)
FEAT-017 (DPI) ──► REF-026 (manifest) — apply together
FEAT-017 (DPI) ──► REF-032 (modern MFC layout hosts) — apply on the same UI surfaces
FEAT-017 (DPI) ──► FEAT-019 (dark mode — pair for modern UI milestone)
FEAT-018 (µTP) ──► coordinate with REF-029 (WSAPoll UDP demux)
FEAT-018 (µTP) ──► FEAT-036 (hole-punch and relay retry coordination)
FEAT-032 (NAT mapping modernization) ──► FEAT-036 (connectivity stack follow-up)
FEAT-035 (IPv6 dual-stack) ──► coordinate with FEAT-036 (future connectivity path)
FEAT-042 (IP-filter updater) ──► FEAT-044 (IP-filter input policy)
FEAT-013 (REST API) ──► FEAT-040 (headless/web/mobile control surface)
FEAT-014 (OpenAPI/external gateway) ──► FEAT-040 (remote-controller/product layer)
BUG-068 (download progress drawing) ──► CI-008 (UI/live regression coverage)
BUG-069/073 (WebServer hardening) ──► CI-008 (WebServer/REST concurrency and static-file regressions)
BUG-027/036 (safe promotion pattern) ──► BUG-071/072 (remaining server/Kad persistence saves)
BUG-002/013/074 (ArchiveRecovery/preview bugs) — Wont-Fix; feature retained unchanged by product decision
CI-006 (ASan) ──► BUG-018/019 follow-up concurrency verification
```

---

## Confirmed Already in main (do NOT re-open)

These items were verified in `eMule-main` and are genuinely done:

| Item | Evidence |
|------|---------|
| C++17 standard baseline (WWMOD_021) | commit `93797f3 Set explicit C++17 baseline` |
| CaptchaGenerator GDI fix (CODEREV_001) | commit `2251e6d` |
| BBUG_001-006 security packet hardening | Verified in packet handler code |
| Long-path core support (FEAT-010 phase 1) | commit `ae79667 Add comprehensive Windows long-path support` |
| BUG-009 — atomic part.met replacement | commit `4b4087d` — `ReplaceFileAtomically` in PartFile.cpp |
| BUG-010 — disk-space guard before .met write | commit `4b4087d` — `CanWritePartMetFiles` in Emule.cpp |
| BUG-011 — shareddir_list race fixed | commit `4b4087d` — `CopySharedDirectoryList` + `m_csSharedDirList` |
| BUG-012 — destructor flush guard | commit `4b4087d` — `PartFilePersistenceSeams::ShouldFlushPartFileOnDestroy` |
| BUG-015 — GetTickCount64 migration | commit `6c161c0 Migrate monotonic timing to GetTickCount64` |
| CI-003 Phase A — SDL + CFG hardening | commit `5557216 Enable Phase A MSVC hardening for app builds` |
| BUG-011 — shareddir_list race (complete fix) | commit `0300a9d Fix shared directory list race` — CopySharedDirectoryList, ReplaceSharedDirectoryList, AddSharedDirectoryIfAbsent, IsSharedDirectoryListed all locked; PPgDirectories, SharedDirsTreeCtrl, SharedFileList, BaseClient updated |
| BUG-001 — hidden prefs write-back + UI exposure | commit `4a02669 Persist and expose hidden runtime preferences` — 19 write-backs added to Preferences.cpp::Save(); PPgTweaks advanced tree updated |
| BUG-016 — UDP crypt layer guard | commit `06eaefe Guard UDP obfuscation when crypt layer is disabled` — IsCryptLayerEnabled() check added to SendPacket() and SendControlData() |
| BUG-007 — CRing pointer-state hardening | commit `0d7b0fe` — consistent empty sentinel, logical-bounds assertions, wrapped-growth copy fix |
| BUG-017 — UDP throttler lock inversion | commit `6cf4967` — UDP socket throttler wake-up moved out of `sendLocker` critical sections |
| BUG-019 — AICH sync thread concurrency | commit `6e466d2` — merged bounded waits, duplicate/incomplete node healing, and queued display refresh handoff |
| BUG-020 — Client socket lifetime ordering | squash-merged from `fix/bug020-client-socket-lifetime` — teardown detach ordering and hello attach ownership handoff |
| BUG-021 — Upload/socket hardening | squash-merged from `fix/bug021-upload-socket-hardening` — socket I/O result handling, upload retirement locking, inflate buffer ownership |
| FEAT-015 — Broadband upload slot controller | commit `d731bbe` — stabilized broadband upload slot allocation |
| FEAT-016 — Modern runtime limits | commit `860d7a5` — modernized fixed runtime limits for broadband defaults |
| FEAT-023 — Broadband queue scoring extras | commit `5470d69` — added queue scoring and score breakdown UI |
| FEAT-024 — Share-ignore policy | commit `462c73b` — centralized share-ignore rules plus additive `shareignore.dat` |
| FEAT-025 — Filename normalization | commit `021cb5b` — normalized download filenames on intake and completion |
| REF-007 — WebM / Matroska MIME split | commit `32d6ac1` — modernized MIME sniffing and WebM classification |
| FEAT-020 — DB-IP geolocation | commit `aaf253f` — added DB-IP city geolocation UI and updater |
| FEAT-022 — Startup config override | commit `fc70cf9` — `-c` startup config-root override through `StartupConfigOverride.h` |
| FEAT-026 — Shared startup cache | current `main` shared-startup line — `KnownFileLookupIndex`, `SharedStartupCachePolicy`, and `sharedcache.dat` are present |
| FEAT-027 — Startup profiling | commit `1d461c8` — trace-backed startup and readiness profiling |
| FEAT-028 — Shared Files virtualization | commit `fc70cf9` — owner-data Shared Files list with hardened reload/state handling |
| FEAT-029 — Search result ceilings | commit `1dd710c` — configurable ed2k and moderate Kad search result/lifetime ceilings |
| FEAT-030 — Bind policy completion | commits `a762ea1`, `ca80a00`, `6244a50` — `WebBindAddr`, ancillary bind audit completion, and follow-up UI restoration |
| FEAT-033 — Disk-space floor hardening and legacy import-flow retirement | commit `e15e9f4` — separate protected disk floors plus stop/save behavior and legacy import-flow removal |
| FEAT-038 — Shared-files watcher/live sync | commits `138f577`, `60b3b44` — monitored shared roots, persisted watcher state, watcher loop, and Shared Files update handoff |
| FEAT-013 — In-process WebServer REST API | commits `94e0884`, `8d0832a` — `/api/v1` JSON surface, hashed `X-API-Key` auth, `WebServerJson.cpp`, vendored `nlohmann/json.hpp`, and upload-tuning parity mapped to the broadband controller |
| BUG-029 — Long-path tail hardening | current `main` commit series `bb7ef92` through `1e71a16` |
| BUG-030 — Server login crypt flags | commit `f9bb14b` — suppress callback crypt request/require flags on already-obfuscated server sockets |
| BUG-032 — AICH hashset save timeout | commit `8a5a33c` — wait normally for the `known2.met` mutex instead of failing after 5 seconds |
| REF-019 — EncryptedStreamSocket protocol errors | commit `93b3450` — `FailEncryptedStream` helper plus explicit disconnect paths in `EncryptedStreamSocket.cpp` |

---

## Experimental Branch Reference

These items have complete or near-complete implementations in the experimental branch. Some
have since landed in `eMule-main`; others remain reference-only. Each individual doc has an
"Experimental Reference Implementation" section with current porting notes.

| Item | Experimental Status | Key files |
|------|--------------------|-----------| 
| BUG-001 — load-only prefs | All 18 write-backs added | `Preferences.cpp` |
| BUG-007 — Ring.h UB | Landed in `main` via smaller pointer-state fix; experimental index rewrite kept as reference only | `Ring.h` |
| REF-007 — WebM vs MKV MIME | Done in `main` via the narrow MIME port | `MediaInfo.cpp`, `OtherFunctions.cpp` |
| REF-017 — Win9x dead code | Fully removed (0 remaining) | Spread across codebase |
| REF-018 — PeerCache/proxy cleanup | Done; proxy fully removed | `Opcodes.h`, `BaseClient.cpp`, removed files |
| REF-019 — EncryptedStreamSocket ASSERT | Done: `FailEncryptedStream` helper | `EncryptedStreamSocket.cpp` |
| REF-020 — Static Win10 APIs | Done: Win10-only cleanup landed in `6ae47ec` | `Emule.cpp`, `EmuleDlg.cpp`, `Preferences.cpp`, `Mdump.cpp`, `OtherFunctions.cpp`, `emule.vcxproj` |
| REF-021 — Deprecated Winsock APIs | Done: inet_addr replaced, suppression removed | `stdafx.h`, `ServerConnect.cpp` |
| REF-023 — Unsafe sprintf | Done: ~0 remaining | Codebase-wide |
| REF-025 — Legacy feature removal | IRC, SMTP, Scheduler, MiniMule, Wizard removed | ~20+ files removed |
| REF-026 — Manifest Win10-only + Common Controls | Done | `res/emulex64.manifest`, `res/emuleARM64.manifest` |
| FEAT-001 — FastKad | Core impl done | `FastKad.cpp/h`, `NodesDatSupport.cpp/h` |
| FEAT-002 — SafeKad | Core impl done | `SafeKad.cpp/h` |
| FEAT-004 — KadPublishGuard | Partial (PUBLISH_SOURCE only) | `KadPublishGuard.cpp/h` |
| FEAT-013 — PipeApiServer | Substantially done | `PipeApiServer.cpp/h`, `PipeApiServerPolicy.h`, `nlohmann/` |
| FEAT-016 — Modern limits | Done: `ModernLimits.h` + Opcodes.h + Preferences.cpp | `ModernLimits.h`, `Opcodes.h`, `Preferences.cpp` |
| BUG-017 — UDP throttler deadlock | Done in `main` | `ClientUDPSocket.cpp`, `UDPSocket.cpp` |
| BUG-018 — Part-file hash layout drift | Current branch port in progress; see `BUG-018.md` | `PartFile.cpp`, `KnownFile.cpp`, `SharedFileList.cpp` |
| BUG-019 — AICH sync thread concurrency | Done in `main` | `AICHSyncThread.cpp`, `EmuleDlg.cpp`, `DownloadClient.cpp`, `PartFile.cpp` |
| BUG-020 — Client socket teardown ordering | Done in `main` | `BaseClient.cpp`, `ClientList.cpp`, `ListenSocket.cpp` |
| BUG-021 — Upload queue lock inversion + socket I/O + inflate buffer | Done in `main` | `UploadQueue.cpp`, `EMSocket.cpp`, `ClientUDPSocket.cpp`, `DownloadClient.cpp` |
| REF-029 — WSAPoll UDP backend | Done: AsyncDatagramSocket + WSAPoll thread | `AsyncDatagramSocket.cpp/h`, `ClientUDPSocket.cpp`, `UDPSocket.cpp` |
| REF-030 — Async hostname resolver | Done: worker-thread getaddrinfo replaces WSAAsyncGetHostByName | `DownloadQueue.cpp/h` |
| FEAT-022 — Startup config directory override | Done in `main`: `-c` flag + `StartupConfigOverride.h` | `Emule.cpp`, `StartupConfigOverride.h`, `Preferences.cpp` |

---

## Source Documents (old docs salvaged from docs/)

| Old doc | Status | Salvaged into |
|---------|--------|--------------|
| `AUDIT-BUGS.md` | All 50 bugs triaged — 40 fixed (stale branch), 8 open | BUG-002 to BUG-006 |
| `AUDIT-DEFECTS.md` | Fully triaged | BUG-001, REF-004 |
| `AUDIT-SECURITY.md` | Historical branch audit; its "web server removed" note is stale vs current `main` | BUG-006, REF-021, REF-028 |
| `AUDIT-DEADCODE.md` | Partially done | REF-002 through REF-007, REF-017, REF-018, REF-019 |
| `REFACTOR-TASKS.md` | REFAC_002, 008, 012, 013, 014, 017 remain | REF-001, REF-002, REF-007, REF-017, REF-018, REF-019, BUG-002 |
| `AUDIT-KAD.md` | Fresh analysis | FEAT-001 through FEAT-006, CI-007 |
| `AUDIT-CODEQUALITY.md` | Fresh | CI-001 through CI-006 |
| `DEP-STATUS.md` | Historical dependency review; removal claims are stale vs current `main` | REF-015, REF-016, FEAT-007, REF-028 |
| `PLAN-BOOST.md` | New (2026-04-08) | REF-008 through REF-014 |
| `PLAN-MODERNIZATION-2026.md` | Reference only — too broad for backlog | Not directly converted |
| `CI-BASELINE.md` | Operational reference | No issues; CI infra is live |
| `GUIDE-LONGPATHS.md` | Core implementation spec landed; shell/UI follow-up and shared-directory recursion hardening are now merged in FEAT-010 | FEAT-010 |
| `FEATURE-PEERS-BANS.md` | FEAT_011/012 not started; FEAT_009 merged to SafeKad; FEAT_010 rejected | FEAT-011, FEAT-012 |
| `PLAN-API-SERVER.md` | Full canonical contract | FEAT-013, FEAT-014 |
| `DEP-REMOVAL.md` | DEP_001 keep; DEP_002/006 done; DEP_003/005 candidates | REF-015, REF-016 |
| `DEP-REMOVAL-DLL.md` | DLL analysis; miniupnpc + zlib good candidates | REF-015 (no DLL path chosen) |
| `FEATURE-KAD.md` | Cross-ref for FEAT_002-006; partially overlaps AUDIT-KAD | FEAT-001 through FEAT-006 |
| `FEATURE-BROADBAND.md` | Broadband branch design; stabilization scope now split between slot allocation and extras | FEAT-015, FEAT-023 |
| `FEATURE-MODERN-LIMITS.md` | Historical reference; FEAT-016 later landed in main | FEAT-016 |
| `FEATURE-THUMBS.md` | Thumbnail feature RETIRED in experimental; IMediaDet in FileInfoDialog.cpp pending | Not converted (needs audit) |
| `EXTRAS_VPNKILLSWITCHDESIGN.md` | External helper tool — not in-process; deferred | Not converted |
| `AUDIT-WWMOD.md` | Win10+ modernization catalog; many "fixed in broadband-dev" statuses are branch-local, not current `main` | REF-017 through REF-024, FEAT-017, REF-032 |
| `AUDIT-CODEREVIEW.md` | CODEREV_001 fixed in main; 002/003/004/011 not in main; 006/007 still need revalidation because WebSocket is still live | BUG-007, BUG-008, REF-028 |
| eMuleAI v1.3 analysis | Initial source for `ReplaceFileAtomically`, `CanWritePartMetFiles`, shareddir lock, destructor guard, and feature references | BUG-009 through BUG-012 (Done), FEAT-018 through FEAT-022 |
| `eMuleAI` hardening revalidation (2026-04-18) | Current `main` already contains REF-007, FEAT-020/022/026/027/028, BUG-029, BUG-030, and now BUG-032; remaining stock-friendly candidate is the narrow hashing-open retry bug | BUG-031 |
| `eMuleAI` + mods + web revalidation (2026-04-20) | Local `main` catch-up through `FEAT-033`, focused KnownFile persistence/dedup review, and filtered current community-demand scan | FEAT-033, REF-032, BUG-036, BUG-037, FEAT-034 |
| Feature expansion pass beyond stock (2026-04-20) | User-directed backlog expansion using current eMuleAI feature notes, historical mod catalogs, and fresh web-demand signals | FEAT-031, FEAT-035, FEAT-036, FEAT-037, FEAT-038, FEAT-039, FEAT-040 |
| Current main, eMuleAI v1.4, and backlog refresh (2026-04-25) | Current `main` catch-up through `b5d253b`, landed BUG-038 through BUG-067 docs, FEAT-034/TEST-034 refresh, eMuleAI v1.4 feature backlog additions, and source-scan pending-item summary | BUG-034 through BUG-067, FEAT-034, FEAT-037, FEAT-041, FEAT-042, CI-008 |
| eMuleAI + mods broadband scan (2026-04-26) | Further comparison of current `main` against eMuleAI and historical mod archives for close-stock broadband feature selection | BUG-004, BUG-028, BUG-068, FEAT-038, FEAT-043, FEAT-044 |
| Current main bug/concurrency scan (2026-04-26) | Direct current-main scan for WebServer races/path containment, remaining destructive persistence paths, helper-thread shutdown waits, and archive-preview worker handoff | BUG-069 through BUG-074 |
| Release readiness regression scan (2026-05-01) | Current `main` scan through `6697302` for recent broadband stabilization changes, release-update checker risk, silent failure paths, and thread/message boundaries | BUG-034, BUG-035, REF-025 |
| `stale-v0.72a-experimental-clean` diff (2026-04-09) | 378 commits; 16 backlog items with reference impls | See Experimental Branch Reference table above |

---

*Issues are tracked here, not in the old `docs/` folder. The `docs/` folder is
historical reference only.*

*Total non-done: 3 bugs + 23 refactors/boost items + 26 features + 9 CI = **61 non-done issues**.*

*Status refresh through 2026-05-01: current `main` is reconciled through `6697302`; `FEAT-038` is documented as Done; `BUG-068`, `FEAT-043`, and `FEAT-044` were added from the eMuleAI/mod scan; `BUG-069` through `BUG-074` were added from the direct current-main bug/concurrency scan; `BUG-028` was refreshed with cross-variant notes and is now Wont-Fix by product decision to accept the retained `id3lib` fallback risk; `BUG-004`, `BUG-023`, `BUG-070`, and `BUG-072` are now Done; `BUG-002`, `BUG-006`, `BUG-008`, `BUG-013`, and `BUG-074` are Wont-Fix by product decision; `BUG-031` is Deferred.*
*Release-readiness scan through 2026-05-01: current `main` was reviewed from `10a6c20` through `6697302`; no rollback-level regression was found in the recent broadband stabilization slices; `BUG-034` / `BUG-035` stay active with `ClientUDPSocket.cpp` unknown UDP exception diagnostics as the next high-signal target; the GitHub release update checker has one small parser hardening follow-up for overflowed version components.*
*REST live proof on 2026-05-01: the redesigned `/api/v1` surface passed the isolated Debug x64 live smoke with one server search, one Kad search, and clean shutdown; report `repos\eMule-build-tests\reports\rest-api-smoke\20260501-154017-eMule-main-debug`.*
*Modern-library hardening review on 2026-05-01: added `REF-035` and `REF-036` for narrow WIL RAII and GSL buffer/pointer contracts; WIL is the preferred first slice, while GSL should stay limited to tested parser, persistence, REST, or byte-buffer boundaries.*

## History

**Rebuilt:** 2026-04-08 — clean slate from git log + old docs salvage + fresh code audit

**Revalidated:** 2026-04-09 — deep diff against `stale-v0.72a-experimental-clean`
(378 commits); BUG-009/010/011/012/015 confirmed Done in main; experimental reference
implementations documented for all items done there

**Revalidated:** 2026-04-10 — full cross-variant analysis pass: eMule-main new commits
(06eaefe/4a02669/0300a9d), community-0.72 (irwir, 10 commits through 2026-01-05),
eMuleAI (2026 release), stale-v0.72a-experimental-clean (378 commits, deep FIX/BUG CPP
pass). BUG-001/BUG-016 confirmed Done in main; BUG-017 through BUG-021 new from
experimental; REF-027 through REF-030 new from community+experimental; FEAT-018 through
FEAT-022 new from eMuleAI+experimental.

**Revalidated:** 2026-04-12 — focused `community-0.72` vs `eMule-main` `srchybrid` diff
review for stabilization/hardening only. Confirmed long-path shell delete gap
(`BUG-022`), refreshed FEAT-010 scope, pivoted REST planning to extend `WebServer.cpp`,
and added regression-expansion item `CI-008`. Async socket remains explicitly deferred
for a future phase.

**Updated:** 2026-04-13 — `main` now includes the FEAT-010 long-path/share-state
stabilization line, the FEAT-024 centralized share-ignore policy with additive
`shareignore.dat`, and FEAT-025 filename normalization on download intake/completion.
CI-008 long-path regressions and CI-009 share-ignore regressions are landed as well.

**Revalidated:** 2026-04-13 — current app workspace HEAD (`e1ecdee`, branch
`feature/feat028-shared-files-virtual-list`) is ahead of `main` (`021cb5b`) by
FEAT-026/027 startup work. Added `BUG-023`, added `FEAT-025`/`026`/`027`, corrected
FEAT-015/016/023 item docs to match `main`, and recorded historical `docs/` drift in
[REVIEW-2026-04-13-main-workspace-revalidation](REVIEW-2026-04-13-main-workspace-revalidation.md).

**Revalidated:** 2026-04-13 — Windows/MFC/toolchain deep dive. Confirmed current `main`
still links WebServer/MbedTLS/id3lib, current local toolchain is VS 2022 `v143` / MFC
14.x, current code uses zero modern MFC UI host/layout classes, and `emule.vcxproj`
still carries VC71-upgrade baggage plus DPI-off manifest settings. Added `REF-032`,
corrected stale dependency/security source-doc rows, and recorded the details in
[REVIEW-2026-04-13-windows-mfc-toolchain-deep-dive](REVIEW-2026-04-13-windows-mfc-toolchain-deep-dive.md).

**Revalidated:** 2026-04-14 — focused bug-only pass on current `main`. Added `BUG-024`
for the live `statUTC(HANDLE)` size-field corruption and `BUG-025` for wrong/stale
hashing open diagnostics in `CKnownFile`. Recorded the pass in
[REVIEW-2026-04-14-main-bug-pass](REVIEW-2026-04-14-main-bug-pass.md).

**Revalidated:** 2026-04-14 — deeper bug-only follow-up on current `main`. Added
`BUG-026` for search-tab teardown lifetime violations and `BUG-027` for destructive
IP-filter promotion failure. Recorded the follow-up in
[REVIEW-2026-04-14-main-bug-pass-deeper](REVIEW-2026-04-14-main-bug-pass-deeper.md).

**Revalidated:** 2026-04-14 — deeper Windows/API and dependency pass. Added `BUG-028`
for ANSI-only `id3lib` path handling in current MP3 metadata extraction, refreshed
`REF-021` / `REF-030` with the remaining live Winsock and message-DNS surface, and
recorded the deeper findings in
[REVIEW-2026-04-14-api-deep-pass-id3lib-unicode](REVIEW-2026-04-14-api-deep-pass-id3lib-unicode.md).

**Updated:** 2026-04-18 — persisted fresh startup/shutdown profiling conclusions under
`FEAT-026`, `FEAT-027`, and `CI-008`, using the current `eMule-main` startup matrix
`20260418-121956-eMule-main-debug` plus shutdown probes
`shutdown-probe-20260418-122546-profiling` and
`shutdown-repeat-20260418-122927`.

**Updated:** 2026-04-18 — `main` now includes `BUG-026` search-tab teardown lifetime
hardening in commit `8ba6248`; `BUG-026` is marked Done.

**Updated:** 2026-04-18 — `main` now includes `BUG-027` IP-filter promotion hardening in
commit `cc3553b`; `BUG-027` is marked Done.

**Updated:** 2026-04-18 — `main` now includes `BUG-025` KnownFile hash-open diagnostics
hardening in commit `897c207`; `BUG-025` is marked Done.

**Updated:** 2026-04-18 — `main` now includes `BUG-024` handle-based `statUTC`
size-field correction in commit `f33f38b`; `BUG-024` is marked Done.

**Revalidated:** 2026-04-18 — focused `eMuleAI` vs current `eMule-main` hardening pass.
Corrected stale landed statuses for `REF-007`, `FEAT-020`, `FEAT-022`, `FEAT-026`, and
`FEAT-027`; added landed `BUG-029` and `FEAT-028`; promoted new stock-friendly hardening
bugs `BUG-030` / `BUG-031` / `BUG-032`; refreshed `CI-008` with long-config `-c` live UI
stability coverage; recorded the pass in
[REVIEW-2026-04-18-emuleai-vs-main-hardening-pass](REVIEW-2026-04-18-emuleai-vs-main-hardening-pass.md).

**Updated:** 2026-04-18 — `main` now includes `BUG-030` server-login crypt-flag
hardening in commit `f9bb14b`; `BUG-030` is marked Done.

**Updated:** 2026-04-18 — `main` now includes `BUG-032` AICH hashset save timeout
removal in commit `8a5a33c`; `BUG-032` is marked Done.

**Updated:** 2026-04-18 — `main` now includes `REF-019` `EncryptedStreamSocket`
protocol-error hardening in commit `93b3450`; `REF-019` is marked Done.

**Updated:** 2026-04-18 — narrow `REF-017` dead-code cleanup landed in current `main`:
all remaining `CCM_SETUNICODEFORMAT` no-op calls, `MAXCON5WIN9X`, and one stale WinNT
note were removed.

**Updated:** 2026-04-18 — `REF-017` is now marked Done after revalidation confirmed that
the only original targeted leftovers are intentionally retained `deadlake PROXYSUPPORT`
comments and no further live dead-code workload remains.

**Updated:** 2026-04-18 — `main` now includes `REF-018` defunct PeerCache surface
removal plus legacy `FileBufferSizePref` / `QueueSizePref` load-read cleanup in commit
`6751a50`; `REF-018` is marked Done.

**Updated:** 2026-04-18 — `main` now includes `REF-026` manifest cleanup in commit
`444f6ec`: Windows 10 / 11+ compatibility is declared via the Windows 10 GUID only,
Common Controls 6.0 moved from linker pragmas into the embedded manifests, and DPI
enablement remains deferred to `FEAT-017`.

**Updated:** 2026-04-18 — `REF-001`, `REF-015`, and `REF-016` are now marked `Wont-Fix`
to preserve the current low-drift branch direction: keep the existing ZIP reader, keep
miniupnpc in the UPnP stack, and keep ResizableLib out-of-tree.

**Updated:** 2026-04-18 — search-result expansion is now tracked separately from
`FEAT-016` as new `FEAT-029`: configurable ed2k result ceilings plus moderate Kad
totals/lifetimes with Tweaks exposure.

**Updated:** 2026-04-18 — `main` now includes standalone `FEAT-012` TCP listen-socket
error-flood defense: accepted incoming pre-handshake TCP error/close bursts are tracked
per IP and banned through the stock banned-IP path, with Tweaks hidden-security settings
for enable/interval/threshold.

**Updated:** 2026-04-18 — bind-policy completion is now tracked as `FEAT-030`: keep
global `BindAddr` on all non-web socket paths, add separate `WebBindAddr`, and audit
remaining socket openers such as `Pinger`.

**Updated:** 2026-04-19 — local `main` now includes the core `FEAT-001` FastKad /
`nodes.fastkad.dat` port in commit `125720f`; `FEAT-001` is now `In Progress` rather
than `Open` because its bootstrap diversity and stale-decay follow-through remains
unfinished.

**Updated:** 2026-04-19 — current `main` now completes `REF-004`: the original
hidden-preference write-back fix from `4a02669` is now paired with Extended-options
exposure/validation cleanup (`6c792d9`, `e6f0625`, `910828c`, `d3ccfd1`), and the
retired `AICHTrustEveryHash` key is explicitly deleted from persisted config.

**Updated:** 2026-04-19 — current `main` now includes the first `REF-025` cleanup slice
in commit `3105ee3` (`chore: remove Connection options wizard entry`); the full
legacy-feature removal remains unfinished, so `REF-025` is now `In Progress`.

**Updated:** 2026-04-19 — current `main` now includes the `BUG-028` mitigation commit
`5cc8e59` (`prefer MediaInfo.dll for AV metadata routing`); the Unicode-unsafe `id3lib`
fallback remains, so the item is now `In Progress` rather than `Open`.

**Updated:** 2026-04-19 — `BUG-005` is now marked `Wont-Fix` by explicit product
decision: Kad buddy callback encryption / `RequireCrypt` incompatibility is understood
but intentionally not pursued on the current branch direction. `REF-021` remains valid
but is explicitly deferred for now; it is still tracked as `Blocked` pending a
separate disposition pass for refactor items.

**Updated:** 2026-04-19 — added `BUG-033` to persist the explicit `Wont-Fix` decision
for the shutdown-only `TerminateThread` fallbacks in `WebSocket.cpp` and
`UPnPImplMiniLib.cpp`.

**Updated:** 2026-04-19 — added `BUG-034` to track the broader release-silent
`catch (...)` plus `ASSERT(0)` pattern across `ArchiveRecovery`, `Collection`,
`WebServer`, `ServerSocket`, and similar paths. This stays `Open`; future fixes should
add explicit logging where practical rather than silently swallowing unexpected
exceptions.

**Updated:** 2026-04-19 — added `BUG-035` to track the broader non-exception
control-flow debt where live runtime paths still rely on bare `ASSERT(0)` placeholders
without proper recovery or logging. Representative current anchors include
`TreePropSheet.cpp`, `TransferWnd.cpp`, and `SHAHashSet.cpp`.

**Updated:** 2026-04-19 — added `CI-010` to track the remaining app-local warning debt
after the external-header noise reduction pass. This keeps real source-fix buckets
(`C5262`, `C4244`, targeted `C5219`) separate from the deferred `REF-021` Winsock
cleanup and from framework-heavy `C4191` triage.

**Updated:** 2026-04-19 — `BUG-031`, `CI-010`, and the remaining `FEAT-001` FastKad
follow-through were explicitly deferred by product decision. `BUG-031` is now tracked
with the first-class `Deferred` status; `CI-010` and `FEAT-001` remain `Blocked`
pending a separate disposition pass for CI and feature items.

**Updated:** 2026-04-19 — `main` now includes the `BUG-003` cleanup in commit `a0a7d18`:
the real remaining issue was narrowed to Kad metadata 64-bit formatting, that formatter
is fixed, and the other historical `FIXME LARGE FILES` markers were removed as stale
overstatements. `BUG-003` is marked Done.

**Updated:** 2026-04-19 — current `main` now includes the MiniMule-specific `REF-025`
cleanup slice in commit `867d303` (`REF-025: remove MiniMule feature`); the broader
legacy-feature removal remains unfinished, so `REF-025` stays `In Progress`.

**Updated:** 2026-04-19 — post-MiniMule revalidation added `REF-033` to track the
smaller remaining IE-era baggage still present in current `main`: MSHTML-based
`DropTarget` HTML parsing, HTML Help, stale IE-specific web-template branches, and
leftover browser-hosting markers.

**Updated:** 2026-04-19 — added `REF-034` to track the real Crypto++ refresh candidate
surfaced by the dependency advisory report: move from the current 8.4-based fork to a
reviewed 8.9-based fork while preserving the narrow local `cryptlib.vcxproj` carry set
for MSVC warnings and ARM64 support.

**Updated:** 2026-05-01 — added `REF-035` and `REF-036` from the modern-library
hardening review. `REF-035` tracks WIL for narrow Windows, WinRT, COM, and handle
RAII in leaf cleanup sites such as toast notifications, path helpers, part-file
allocation, and WinInet ownership. `REF-036` tracks GSL only for tested
buffer/pointer contracts such as SafeFile/PartFile hash buffers, archive-recovery
byte readers, and REST/test helper boundaries.

**Updated:** 2026-04-19 — current `main` now includes `FEAT-013` in commits `94e0884`
and `8d0832a`: the REST surface is delivered in-process through `WebServer.cpp` /
`WebSocket.cpp` with a dedicated `WebServerJson.cpp` route layer, hashed `X-API-Key`
auth, the experimental JSON contract reused without the named-pipe/sidecar runtime
stack, and the experimental upload-tuning fields mapped onto the current broadband
upload-budget controller. `FEAT-013` is marked Done.

**Updated:** 2026-04-19 — `CI-008` now includes the first concrete REST regression slice
on current `main`: native `web_api.tests.cpp` coverage for the landed `/api/v1`
route/contract helpers plus the live `run-rest-api-smoke.ps1` harness for `X-API-Key`
auth, representative read routes, live server/Kad/search scenarios, and HTML-vs-REST
separation. The live harness now records an explicit degraded-network search skip when a
session makes real connect/bootstrap attempts but never reaches a searchable network
state.

**Updated:** 2026-04-20 — added `FEAT-032` to track the NAT-mapping modernization pass
now implemented locally on current `main`: remove the Windows-service UPnP backend, keep
MiniUPnP as the `UPnP IGD` path, add `libpcpnatpmp` for `PCP/NAT-PMP`, and expose a
Tweaks backend-mode selector. The code/build phase is complete, but the item stays
`In Progress` pending live-network validation.

**Revalidated:** 2026-04-20 — fresh local-`main` catch-up through `c06f403` plus
focused `eMuleAI`, `mods-archive`, and retired-stale comparisons. Recorded the pass in
[REVIEW-2026-04-20-emuleai-mods-main-backlog-pass](REVIEW-2026-04-20-emuleai-mods-main-backlog-pass.md),
added landed `FEAT-033`, moved `REF-032` to `In Progress`, promoted `BUG-036` /
`BUG-037`, and added the narrow performance candidate `FEAT-034`.

**Expanded:** 2026-04-20 — user-directed feature-expansion pass beyond the usual
stock-preserving line. Restored missing `FEAT-031` to the active index and added
higher-drift expansion items `FEAT-035` through `FEAT-040` from current eMuleAI release
notes, historical mod feature catalogs, and fresh web-demand signals. Recorded in
[REVIEW-2026-04-20-feature-expansion-beyond-stock](REVIEW-2026-04-20-feature-expansion-beyond-stock.md).

**Revalidated:** 2026-04-25 — current `main` catch-up through `b5d253b` and current
tests repo catch-up through `cac7b93`. Added landed `BUG-038` through `BUG-067`, moved
`BUG-036` to Done, moved `BUG-034` / `BUG-035` / `BUG-037` to In Progress, refreshed
`FEAT-034` and `CI-008`, and incorporated eMuleAI v1.4 feature backlog candidates as
`FEAT-041` and `FEAT-042`. Recorded in
[REVIEW-2026-04-25-current-main-backlog-refresh](REVIEW-2026-04-25-current-main-backlog-refresh.md).

**Revalidated:** 2026-04-26 — further eMuleAI and mod archive scan for close-stock
broadband feature selection. Marked `FEAT-038` Done after current-main watcher/live sync
verification, added `BUG-068`, `FEAT-043`, and `FEAT-044`, and refreshed `BUG-004` /
`BUG-028` with cross-variant notes. Recorded in
[REVIEW-2026-04-26-emuleai-mods-broadband-scan](REVIEW-2026-04-26-emuleai-mods-broadband-scan.md).

**Updated:** 2026-04-26 — current `main` now includes `BUG-070` helper-thread launch
failure hardening in app commit `7cbdbc9` and tests commit `60ec43a`: upload disk
I/O, part-file writes, and upload bandwidth throttling capture `AfxBeginThread`
failures, avoid invalid IOCP posts, avoid impossible shutdown waits, and carry native
seam coverage for the launch-failure decisions.

**Updated:** 2026-04-26 — current `main` now includes `BUG-072` Kad persistence
promotion hardening in app commit `efb8871` and tests commit `f31b890`:
`preferencesKad.dat` and `nodes.dat` are saved through checked temp-file promotion,
the bootstrap-empty guard is preserved, and FastKad sidecar metadata is ordered after
successful `nodes.dat` promotion.

**Updated:** 2026-04-26 — current `main` now includes `BUG-004` IP filter overlap
normalization in app commit `743b914` and tests commit `d0af7be`: overlapping ranges
are split into sorted non-overlapping segments, the lowest numeric filter level wins
inside overlaps, and adjacent same-level segments are merged before lookup.

**Updated:** 2026-04-27 — current `main` now includes `BUG-023` ED2K
publish-state refresh handling in app commit `10a6c20`: shared files keep their
visible published state while an ED2K republish is pending, the next server offer
includes pending files, and the pending state clears after packet inclusion.

**Revalidated:** 2026-05-01 — current `main` was scanned from `10a6c20`
through `6697302` for release regressions, silent failure paths, update-checker
risks, and thread/message boundaries. Recorded in
[REVIEW-2026-05-01-release-readiness-regression-scan](REVIEW-2026-05-01-release-readiness-regression-scan.md).

**Live-proofed:** 2026-05-01 — redesigned `/api/v1` REST passed the isolated
Debug x64 live smoke with one server search, one Kad search, and clean shutdown.
The run is recorded in
[REVIEW-2026-05-01-release-readiness-regression-scan](REVIEW-2026-05-01-release-readiness-regression-scan.md).
