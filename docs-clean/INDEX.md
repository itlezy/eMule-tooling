# eMule Clean Backlog — Issue Index

**Source of truth:** `EMULE_WORKSPACE_ROOT\workspaces\v0.72a\app\eMule-main` (`main` branch)  
**Rebuilt:** 2026-04-08 — clean slate from git log + old docs salvage + fresh code audit  
**Revalidated:** 2026-04-09 — deep diff against `stale-v0.72a-experimental-clean` (378 commits); BUG-009/010/011/012/015 confirmed Done in main; experimental reference implementations documented for all items done there  
**Revalidated:** 2026-04-10 — full cross-variant analysis pass: eMule-main new commits (06eaefe/4a02669/0300a9d), community-0.72 (irwir, 10 commits through 2026-01-05), eMuleAI (2026 release), stale-v0.72a-experimental-clean (378 commits, deep FIX/BUG CPP pass). BUG-001/BUG-016 confirmed Done in main; BUG-017 through BUG-021 new from experimental; REF-027 through REF-030 new from community+experimental; FEAT-018 through FEAT-022 new from eMuleAI+experimental.  
**Priority scale:** Critical > Major > Minor > Trivial  
**Status values:** Open / In Progress / Blocked / Done / Wont-Fix  
**Important:** Items marked Done below are verified in `eMule-main`. Items marked In Progress may already be implemented on dedicated bug/feature branches but are not considered landed until merged to `main`. Experimental-only work (see individual docs) is NOT in main unless the item status below says otherwise.  
**Revalidation rule:** Before implementing any item, re-check it against current `main` and current dependency pins.  
**Regression rule:** new feature/fix work from this backlog should include targeted
regression checks. When behavior changes, compare `main` against
`oracle/v0.72a-build` as the seam-enabled oracle baseline derived from the
`build` release branch where that comparison is meaningful.
**Oracle stack rule:** the old 0.72a comparison stack is layered, not flat:
- `oracle/v0.72a-build` = baseline seam-enabled oracle
- `tracing/v0.72a` = observability-only derivative of oracle
- `tracing-harness/v0.72a` = behavior-changing parity-harness derivative of tracing

---

## Bugs

| ID | Priority | Status | Title |
|----|----------|--------|-------|
| [BUG-001](BUG-001.md) | Major | **Done** | 17+ load-only hidden prefs not written back to preferences.ini |
| [BUG-002](BUG-002.md) | Minor | Open | ASSERT(0) FIXME in ArchiveRecovery.cpp — silent fail in release *(retire feature or fix)* |
| [BUG-003](BUG-003.md) | Minor | Open | Large-file AICH / metadata paths incomplete — FIXME markers in place |
| [BUG-004](BUG-004.md) | Minor | Open | IPFilter overlapping IP ranges not handled — acknowledged correctness gap |
| [BUG-005](BUG-005.md) | Minor | Open | Kad buddy connections broken when RequireCrypt is enabled |
| [BUG-006](BUG-006.md) | Minor | Open | Weak RNG for crypto challenge — rand() seeded with time(NULL) (accepted risk) |
| [BUG-007](BUG-007.md) | Minor | **Done** | Ring.h — three UB + correctness bugs in CRing\<T\> (CODEREV_003, 004, 011) |
| [BUG-008](BUG-008.md) | Minor | Open | CaptchaGenerator — rand() & 8 bimodal jitter (only 0 or 8, never 1-7) *(resolved if REF-027 lands)* |
| [BUG-009](BUG-009.md) | Minor | **Done** | PartFile — non-atomic part.met replacement (_tremove + _trename crash window) |
| [BUG-010](BUG-010.md) | Minor | **Done** | PartFile — part.met write on low disk space risks truncation/corruption |
| [BUG-011](BUG-011.md) | Minor | **Done** | Race — shareddir_list iterated without lock in SendSharedDirectories |
| [BUG-012](BUG-012.md) | Minor | **Done** | CPartFile destructor calls FlushBuffer after write thread has already exited |
| [BUG-013](BUG-013.md) | Minor | Open | ArchiveRecovery.cpp — three unchecked malloc() calls crash on OOM *(retire feature or fix)* |
| [BUG-014](BUG-014.md) | Minor | **Done** | ZIPFile.cpp — WriteFile return value silently discarded on two paths |
| [BUG-015](BUG-015.md) | Minor | **Done** | GetTickCount() 49-day overflow in ban expiry and download timeout checks |
| [BUG-016](BUG-016.md) | Minor | **Done** | UDP obfuscation applied when crypt layer is disabled — IsCryptLayerEnabled() guard missing |
| [BUG-017](BUG-017.md) | Minor | **Done** | UDP throttler deadlock — sendLocker held when signaling QueueForSendingControlPacket |
| [BUG-018](BUG-018.md) | Minor | In Progress | Part-file hash layout drift — hash tree can mutate during concurrent hashing |
| [BUG-019](BUG-019.md) | Minor | **Done** | AICH sync thread concurrency — UI deadlocks, starvation, incomplete/duplicate nodes |
| [BUG-020](BUG-020.md) | Minor | **Done** | Client socket teardown ordering — cross-link not cleared before Safe_Delete |
| [BUG-021](BUG-021.md) | Minor | **Done** | Upload queue lock inversion + socket I/O result mishandling + inflate buffer aliasing |

---

## Refactors

| ID | Priority | Status | Title |
|----|----------|--------|-------|
| [REF-001](REF-001.md) | Major | Open | Replace custom CZIPFile with minizip |
| [REF-002](REF-002.md) | Major | **Done** | Remove Source Exchange v1 branches |
| [REF-003](REF-003.md) | Trivial | Open | Rename stale IRC string resources *(or full IRC removal — see REF-025)* |
| [REF-004](REF-004.md) | Minor | Open | Audit and disposition 17 load-only preference keys |
| [REF-005](REF-005.md) | Trivial | Open | Remove dead DebugSourceExchange commented-out calls |
| [REF-006](REF-006.md) | Trivial | **Done** | GetCategory should be const in DownloadListCtrl |
| [REF-007](REF-007.md) | Trivial | Open | WebM vs MKV disambiguation in MIME detection |
| [REF-015](REF-015.md) | Minor | Open | Switch UPnP from miniupnpc to UPnPImplWinServ — remove miniupnpc submodule |
| [REF-016](REF-016.md) | Trivial | Open | Inline ResizableLib into source tree — remove submodule |
| [REF-017](REF-017.md) | Minor | Open | Dead code sweep — Win9x/NT4 guards, PROXY comments, #if 0 blocks |
| [REF-018](REF-018.md) | Minor | Open | Remove defunct PeerCache opcodes, Win95 detection, and legacy INI keys |
| [REF-019](REF-019.md) | Minor | Open | Replace ASSERT(0) + "must be a bug" with OnError() in EncryptedStreamSocket |
| [REF-020](REF-020.md) | Minor | Open | Replace dynamic loading of always-present Win10 APIs with static linking |
| [REF-021](REF-021.md) | Minor | Open | Remove blanket warning suppressions and replace deprecated Winsock APIs |
| [REF-022](REF-022.md) | Trivial | Open | Replace custom type aliases in types.h with \<cstdint\> standard types |
| [REF-023](REF-023.md) | Minor | Open | Replace unsafe sprintf/_stprintf/wsprintf with safe equivalents |
| [REF-024](REF-024.md) | Trivial | Open | Convert #define constants in Opcodes.h to constexpr in namespace |
| [REF-025](REF-025.md) | Minor | Open | Remove legacy feature set — IRC, SMTP, Scheduler, MiniMule, wizard, splash, update checker |
| [REF-026](REF-026.md) | Minor | Open | Manifest — drop legacy OS entries, add Common Controls 6.0 dependency |
| [REF-027](REF-027.md) | Minor | Open | CaptchaGenerator — replace CxImage with ATL CImage / native GDI (community ref) |
| [REF-028](REF-028.md) | Minor | Open | Upgrade MbedTLS to 4.0 — API rename + TLS 1.3 readiness (community ref) |
| [REF-029](REF-029.md) | Major | Open | Move UDP sockets to WSAPoll backend — AsyncDatagramSocket (experimental ref) |
| [REF-030](REF-030.md) | Minor | Open | Replace WSAAsyncGetHostByName with worker-thread resolver in DownloadQueue (experimental ref) |
| [REF-031](REF-031.md) | Minor | **Done** | Review upload queue scoring against community and stale baselines |

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
| [FEAT-001](FEAT-001.md) | Minor | Open | Kad FastKad — diversity-aware bootstrap ranking + aggressive stale decay |
| [FEAT-002](FEAT-002.md) | Major | Open | Kad SafeKad — layered trust model / CGNAT fix |
| [FEAT-003](FEAT-003.md) | Minor | Open | Kad — Response usefulness scoring + subnet-diversity search fanout |
| [FEAT-004](FEAT-004.md) | Minor | Open | Kad — Generalise KadPublishGuard abuse budget beyond PUBLISH_SOURCE |
| [FEAT-005](FEAT-005.md) | Minor | Open | Kad — Restore network-change grace handling |
| [FEAT-006](FEAT-006.md) | Minor | Open | Kad — Add observability counters (trust, budget, bootstrap) |
| [FEAT-007](FEAT-007.md) | Minor | Open | Windows Property Store integration for non-media file metadata |
| [FEAT-008](FEAT-008.md) | Trivial | Open | Oracle protocol guard seams — integrate stale branch test scaffolding |
| [FEAT-009](FEAT-009.md) | Trivial | Open | Mirror audit guard seam — WIP from stale branch parent |
| [FEAT-010](FEAT-010.md) | Minor | Open | Long path support phase 2 — shell/UI icon, browse, and path-helper audit |
| [FEAT-011](FEAT-011.md) | Minor | Open | CShield — integrate ED2K anti-leecher engine (44 bad-client categories) |
| [FEAT-012](FEAT-012.md) | Minor | Open | PR_TCPERRORFLOODER — TCP listen-socket flood defense |
| [FEAT-013](FEAT-013.md) | Minor | Open | REST API — CPipeApiServer (C++ named pipe IPC server) |
| [FEAT-014](FEAT-014.md) | Minor | Open | REST API — emule-sidecar (Node.js/TypeScript HTTP sidecar) |
| [FEAT-015](FEAT-015.md) | Major | **Done** | Broadband upload slot controller — budget-based cap + slow-slot reclamation |
| [FEAT-016](FEAT-016.md) | Major | **Done** | Modern limits — update stale hard-coded defaults for broadband/modern hardware |
| [FEAT-017](FEAT-017.md) | Major | Open | DPI awareness — Per-Monitor V2 manifest + hardcoded pixel audit |
| [FEAT-018](FEAT-018.md) | Minor | Open | µTP transport layer — CUtpSocket / libutp (eMuleAI ref) |
| [FEAT-019](FEAT-019.md) | Minor | Open | Dark mode UI — system-aware Windows 10 dark theme (eMuleAI ref) |
| [FEAT-020](FEAT-020.md) | Trivial | Open | GeoLite2 IP geolocation — country flag + city per peer (eMuleAI ref) |
| [FEAT-021](FEAT-021.md) | Minor | Open | SourceSaver — persist download source lists between sessions (eMuleAI ref) |
| [FEAT-022](FEAT-022.md) | Minor | Open | Startup config directory override — -c flag for alternate preferences path (experimental ref) |
| [FEAT-023](FEAT-023.md) | Minor | **Done** | Broadband queue scoring and ratio/cooldown UI extras |

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

---

## Priority Triage

### Do First — Critical / Major, high ROI, low risk

1. **FEAT-017** — DPI awareness (P0): every user on a modern display sees a blurry UI; manifest change + pixel audit
2. **REF-026** — Manifest cleanup: drop legacy OS entries, add Common Controls dep (quick win, pairs with FEAT-017)
3. **BUG-018** — Part-file hash layout drift: active stabilization branch is replacing stale hash write-back and progress-owner posting
4. **REF-001** — Replace CZIPFile with minizip: isolated, 3 call sites
5. **REF-029** — WSAPoll UDP backend: experimental impl done, significant network quality improvement
6. **CI-001** — CMake migration: unlocks all static analysis tools

### Do Second — Major, higher effort

9. **FEAT-002** — SafeKad CGNAT fix: affects all users behind NAT; full implementation done in experimental
10. **FEAT-001** — FastKad bootstrap ranking: full implementation done in experimental, ready to port

### Do After CI-001 — Tooling chain (Minor, unblocked by CMake)

11. **REF-017** — Dead code sweep: Win9x guards, #if 0 blocks, PROXY comments; fully done in experimental
12. **REF-025** — Legacy feature removal: IRC, SMTP, Scheduler, MiniMule, wizard; fully done in experimental
13. **REF-018** — PeerCache opcodes + Win95 detection + legacy INI keys; fully done in experimental
14. **REF-019** — ASSERT(0) → FailEncryptedStream/OnError(); done in experimental
15. **REF-020** — Static-link always-present Win10 APIs; done in experimental
16. **REF-021** — Remove warning suppressions + fix deprecated Winsock APIs; done in experimental
17. **REF-023** — Unsafe sprintf → safe equivalents; done in experimental (cleanup after REF-021)
18. **FEAT-013** — PipeApiServer: full implementation done in experimental
19. **FEAT-022** — Startup -c config override: experimental impl done; low risk, high test utility
20. **CI-002** — clang-format
21. **CI-003** — MSVC hardening Phase B (/WX, /permissive-)
22. **CI-004** — clang-tidy
23. **CI-005** — cppcheck
24. **CI-006** — AddressSanitizer

### Do Later — Minor / Trivial

- **BUG-002, BUG-013** — ArchiveRecovery bugs: consider full feature removal (REF-025 path) as easier than patching; community (irwir) added const-correctness fixes in `24d1de7` as partial improvement reference
- **BUG-003 through BUG-006** — targeted bug fixes
- **BUG-008** — CaptchaGenerator rand() & 8 (one-liner; or resolved by REF-027 full rewrite)
- **BUG-018** — currently in progress on `fix/bug018-partfile-hash-drift`; merge before starting another hashing-concurrency branch
- **REF-003** — subsumed by REF-025 (IRC removal); only relevant if IRC is kept
- **REF-004** — Prefs audit (coordinate with BUG-001 Done; mostly resolved)
- **REF-007** — WebM vs MKV MIME: done in experimental (MediaInfo.cpp)
- **REF-015** — miniupnpc removal: one-line switch, safe at any time
- **REF-016** — ResizableLib inline: no dialog source changes
- **REF-022** — types.h → `<cstdint>`: mechanical, low risk
- **REF-024** — Opcodes.h `#define` → `constexpr`: mechanical (coordinate with FEAT-016)
- **REF-027** — CaptchaGenerator → ATL CImage: community reference; port after REF-025 if CxImage not otherwise removed
- **REF-028** — MbedTLS 4.0 upgrade: community reference; needed for TLS 1.3; coordinate with DEP-STATUS
- **REF-030** — Async hostname resolver: experimental impl done; port after REF-029 (WSAPoll)
- **FEAT-003, 005, 006** — Kad quality improvements (no experimental impl yet)
- **FEAT-004** — KadPublishGuard generalization: partial impl in experimental
- **FEAT-007** — Windows Property Store metadata
- **FEAT-008, 009** — Oracle/mirror guard seams
- **FEAT-010** — Long path support phase 2: shell/UI follow-up after core filesystem landing
- **FEAT-011, 012** — CShield + TCP flood defense: port from eMuleAI (Shield.cpp/h has full 44-category implementation)
- **FEAT-014** — REST API Node.js sidecar: full contract specified
- **FEAT-018** — µTP transport: eMuleAI reference available; high impact but large scope (libutp dependency)
- **FEAT-019** — Dark mode UI: eMuleAI reference available; pair with FEAT-017 (DPI)
- **FEAT-020** — GeoLite2 geolocation: eMuleAI reference available; trivial priority
- **FEAT-021** — SourceSaver: eMuleAI reference available; minor quality-of-life
- **CI-007** — Kad fuzz tests (after CI-006 ASan baseline)

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
FEAT-013 (CPipeApiServer) ──► FEAT-014 (Node.js sidecar)
FEAT-011 (CShield) ──► FEAT-012 (PR_TCPERRORFLOODER, can standalone)
FEAT-015 (slot allocation) ──► FEAT-016 (modern limits — coordinate Opcodes.h values)
FEAT-015 (slot allocation) ──► FEAT-023 (optional scoring/UI extras kept separate)
FEAT-017 (DPI) ──► REF-026 (manifest) — apply together
FEAT-017 (DPI) ──► FEAT-019 (dark mode — pair for modern UI milestone)
FEAT-018 (µTP) ──► coordinate with REF-029 (WSAPoll UDP demux)
CI-006 (ASan) ──► BUG-018/019 follow-up concurrency verification
```

---

## Confirmed Already in main (do NOT re-open)

These items were verified in `eMule-main` and are genuinely done:

| Item | Evidence |
|------|---------|
| C++17 standard baseline (WWMOD_021) | commit `93797f3 Set explicit C++17 baseline` |
| CaptchaGenerator GDI fix (CODEREV_001) | commit `2251e6d` |
| MbedTLS + web server removal | Verified absent from srchybrid/ |
| id3lib removal → MediaInfo | Verified MediaInfo present, id3lib absent |
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

---

## Experimental Branch Reference

These items have complete or near-complete implementations in the experimental branch. Some
have since landed in `eMule-main`; others remain reference-only. Each individual doc has an
"Experimental Reference Implementation" section with current porting notes.

| Item | Experimental Status | Key files |
|------|--------------------|-----------| 
| BUG-001 — load-only prefs | All 18 write-backs added | `Preferences.cpp` |
| BUG-007 — Ring.h UB | Landed in `main` via smaller pointer-state fix; experimental index rewrite kept as reference only | `Ring.h` |
| REF-007 — WebM vs MKV MIME | Done in MediaInfo.cpp | `MediaInfo.cpp` |
| REF-017 — Win9x dead code | Fully removed (0 remaining) | Spread across codebase |
| REF-018 — PeerCache/proxy cleanup | Done; proxy fully removed | `Opcodes.h`, `BaseClient.cpp`, removed files |
| REF-019 — EncryptedStreamSocket ASSERT | Done: `FailEncryptedStream` helper | `EncryptedStreamSocket.cpp` |
| REF-020 — Static Win10 APIs | Done: direct calls replacing GetProcAddress | `Emule.cpp`, `EmuleDlg.cpp` |
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
| FEAT-022 — Startup config directory override | Done: -c flag + StartupConfigOverride.h | `Emule.cpp`, `StartupConfigOverride.h`, `Preferences.cpp` |

---

## Source Documents (old docs salvaged from docs/)

| Old doc | Status | Salvaged into |
|---------|--------|--------------|
| `AUDIT-BUGS.md` | All 50 bugs triaged — 40 fixed (stale branch), 8 open | BUG-002 to BUG-006 |
| `AUDIT-DEFECTS.md` | Fully triaged | BUG-001, REF-004 |
| `AUDIT-SECURITY.md` | Partially stale (web server removed) | BUG-006 |
| `AUDIT-DEADCODE.md` | Partially done | REF-002 through REF-007, REF-018, REF-019 |
| `REFACTOR-TASKS.md` | REFAC_002, 008, 013, 017 remain | REF-001, REF-002, REF-007, BUG-002 |
| `AUDIT-KAD.md` | Fresh analysis | FEAT-001 through FEAT-006, CI-007 |
| `AUDIT-CODEQUALITY.md` | Fresh | CI-001 through CI-006 |
| `DEP-STATUS.md` | All deps current; Mbed TLS + id3lib removed | No open issues |
| `PLAN-BOOST.md` | New (2026-04-08) | REF-008 through REF-014 |
| `PLAN-MODERNIZATION-2026.md` | Reference only — too broad for backlog | Not directly converted |
| `CI-BASELINE.md` | Operational reference | No issues; CI infra is live |
| `GUIDE-LONGPATHS.md` | Core implementation spec largely landed; remaining shell/UI follow-up tracked in FEAT-010 | FEAT-010 |
| `FEATURE-PEERS-BANS.md` | FEAT_011/012 not started; FEAT_009 merged to SafeKad; FEAT_010 rejected | FEAT-011, FEAT-012 |
| `PLAN-API-SERVER.md` | Full canonical contract | FEAT-013, FEAT-014 |
| `DEP-REMOVAL.md` | DEP_001 keep; DEP_002/006 done; DEP_003/005 candidates | REF-015, REF-016 |
| `DEP-REMOVAL-DLL.md` | DLL analysis; miniupnpc + zlib good candidates | REF-015 (no DLL path chosen) |
| `FEATURE-KAD.md` | Cross-ref for FEAT_002-006; partially overlaps AUDIT-KAD | FEAT-001 through FEAT-006 |
| `FEATURE-BROADBAND.md` | Broadband branch design; stabilization scope now split between slot allocation and extras | FEAT-015, FEAT-023 |
| `FEATURE-MODERN-LIMITS.md` | Historical reference; FEAT-016 later landed in main | FEAT-016 |
| `FEATURE-THUMBS.md` | Thumbnail feature RETIRED in experimental; IMediaDet in FileInfoDialog.cpp pending | Not converted (needs audit) |
| `EXTRAS_VPNKILLSWITCHDESIGN.md` | External helper tool — not in-process; deferred | Not converted |
| `AUDIT-WWMOD.md` | Win10+ modernization catalog — triaged 2026-04-08 | REF-017 through REF-024, FEAT-017 |
| `AUDIT-CODEREVIEW.md` | CODEREV_001 fixed in main; 002/003/004/011 not in main; 006/007 stale (WebSocket removed) | BUG-007, BUG-008 |
| eMuleAI v1.3 analysis | ReplaceFileAtomically, CanWritePartMetFiles, shareddir lock, destructor guard | BUG-009 through BUG-012 (Done) |
| `stale-v0.72a-experimental-clean` diff (2026-04-09) | 378 commits; 16 backlog items with reference impls | See Experimental Branch Reference table above |

---

*Issues are tracked here, not in the old `docs/` folder. The `docs/` folder is
historical reference only.*

*Total non-done: 8 open bugs + 1 in-progress bug + 28 refactors/boost items + 20 features + 7 CI = **64 non-done issues**.*

*Status refresh through 2026-04-12: BUG-007/014/017/019/020/021 and REF-002/006 are now done in `main`; FEAT-015/016/023 are done; BUG-018 is active on `fix/bug018-partfile-hash-drift`.*
