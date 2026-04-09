# eMule Clean Backlog — Issue Index

**Source of truth:** `EMULE_WORKSPACE_ROOT\workspaces\v0.72a\app\eMule-main` (`main` branch)  
**Rebuilt:** 2026-04-08 — clean slate from git log + old docs salvage + fresh code audit  
**Priority scale:** Critical > Major > Minor > Trivial  
**Status values:** Open / In Progress / Blocked / Done / Wont-Fix  
**Important:** ALL items marked [DONE] in the old `docs/` folder were completed on the
stale experimental branch (`archive/v0.72a-experimental-clean-provisional-20260404`) only.
The current `eMule-main` branch has none of those changes. Every issue here is genuinely
open against main.
**Revalidation rule:** branch/build/dependency hygiene landed after this backlog rebuild.
Before implementing any item, re-check it against current `main` and current dependency pins.
**Regression rule:** new feature/fix work from this backlog should include targeted
regression checks. When behavior changes, compare `main` against
`oracle/v0.72a-build` as the seam-enabled oracle baseline derived from the
`build` release branch where that comparison is meaningful.

---

## Bugs

| ID | Priority | Status | Title |
|----|----------|--------|-------|
| [BUG-001](BUG-001.md) | Major | Open | 17+ load-only hidden prefs not written back to preferences.ini |
| [BUG-002](BUG-002.md) | Minor | Open | ASSERT(0) FIXME in ArchiveRecovery.cpp — silent fail in release |
| [BUG-003](BUG-003.md) | Minor | Open | Large-file AICH / metadata paths incomplete — FIXME markers in place |
| [BUG-004](BUG-004.md) | Minor | Open | IPFilter overlapping IP ranges not handled — acknowledged correctness gap |
| [BUG-005](BUG-005.md) | Minor | Open | Kad buddy connections broken when RequireCrypt is enabled |
| [BUG-006](BUG-006.md) | Minor | Open | Weak RNG for crypto challenge — rand() seeded with time(NULL) (accepted risk) |
| [BUG-007](BUG-007.md) | Minor | Open | Ring.h — three UB + correctness bugs in CRing\<T\> (CODEREV_003, 004, 011) |
| [BUG-008](BUG-008.md) | Minor | Open | CaptchaGenerator — rand() & 8 bimodal jitter (only 0 or 8, never 1-7) |
| [BUG-009](BUG-009.md) | Minor | Open | PartFile — non-atomic part.met replacement (_tremove + _trename crash window) |
| [BUG-010](BUG-010.md) | Minor | Open | PartFile — part.met write on low disk space risks truncation/corruption |
| [BUG-011](BUG-011.md) | Minor | Open | Race — shareddir_list iterated without lock in SendSharedDirectories |
| [BUG-012](BUG-012.md) | Minor | Open | CPartFile destructor calls FlushBuffer after write thread has already exited |
| [BUG-013](BUG-013.md) | Minor | Open | ArchiveRecovery.cpp — three unchecked malloc() calls crash on OOM |
| [BUG-014](BUG-014.md) | Minor | Open | ZIPFile.cpp — WriteFile return value silently discarded on two paths |
| [BUG-015](BUG-015.md) | Minor | Open | GetTickCount() 49-day overflow in ban expiry and download timeout checks |

---

## Refactors

| ID | Priority | Status | Title |
|----|----------|--------|-------|
| [REF-001](REF-001.md) | Major | Open | Replace custom CZIPFile with minizip |
| [REF-002](REF-002.md) | Major | Open | Remove Source Exchange v1 branches |
| [REF-003](REF-003.md) | Trivial | Open | Rename stale IRC string resources |
| [REF-004](REF-004.md) | Minor | Open | Audit and disposition 17 load-only preference keys |
| [REF-005](REF-005.md) | Trivial | Open | Remove dead DebugSourceExchange commented-out calls |
| [REF-006](REF-006.md) | Trivial | Open | GetCategory should be const in DownloadListCtrl |
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
| [FEAT-015](FEAT-015.md) | Major | Open | Broadband upload slot controller — budget-based cap + slow-slot reclamation |
| [FEAT-016](FEAT-016.md) | Major | Open | Modern limits — update stale hard-coded defaults for broadband/modern hardware |
| [FEAT-017](FEAT-017.md) | Major | Open | DPI awareness — Per-Monitor V2 manifest + hardcoded pixel audit |

---

## Build / CI / Tooling

| ID | Priority | Status | Title |
|----|----------|--------|-------|
| [CI-001](CI-001.md) | Major | Open | CMake migration — replace emule.vcxproj with CMakeLists.txt + Ninja |
| [CI-002](CI-002.md) | Minor | Open | clang-format — enforce consistent code formatting |
| [CI-003](CI-003.md) | Minor | In Progress | MSVC compiler hardening — SDL, guard:cf, /WX |
| [CI-004](CI-004.md) | Minor | Open | clang-tidy — integrate static analysis |
| [CI-005](CI-005.md) | Minor | Open | cppcheck — integrate complementary bug-class analysis |
| [CI-006](CI-006.md) | Minor | Open | MSVC AddressSanitizer — enable for debug builds |
| [CI-007](CI-007.md) | Minor | Open | Kad — Expand integration and fuzz test coverage |

---

## Priority Triage

### Do First — Critical / Major, high ROI, low risk

1. **FEAT-017** — DPI awareness (P0): every user on a modern display sees a blurry UI; manifest change + pixel audit
2. **BUG-001** — Hidden prefs not saved: low-risk, high user-impact
3. **BUG-009** — Atomic part.met replacement: eliminate crash window in save path
4. **BUG-010** — Part.met low-disk guard: prevent truncated metadata on full disk
5. **BUG-011** — shareddir_list race: lock-free iteration from non-UI thread
6. **BUG-012** — CPartFile destructor: flush after write thread exits
7. **BUG-007** — Ring.h UB: two undefined-behavior pointers + missing bounds check
8. **FEAT-016** — Modern limits: raise stale defaults, zero protocol risk
9. **FEAT-015** — Broadband upload controller: full spec available, stale branch reference
10. **REF-001** — Replace CZIPFile with minizip: isolated, 3 call sites
11. **REF-002** — Remove Source Exchange v1: targeted cleanup, ~250 lines
12. **CI-001** — CMake migration: unlocks all static analysis tools

### Do Second — Major, higher effort

13. **FEAT-002** — SafeKad CGNAT fix: affects all users behind NAT

### Do After CI-001 — Tooling chain (Minor, unblocked by CMake)

17. **REF-017** — Dead code sweep: Win9x guards, #if 0 blocks, PROXY comments
18. **REF-018** — PeerCache opcodes + Win95 detection + legacy INI keys
19. **REF-019** — ASSERT(0) → OnError() in EncryptedStreamSocket
20. **REF-020** — Static-link always-present Win10 APIs
21. **REF-021** — Remove warning suppressions + fix deprecated Winsock APIs
22. **REF-023** — Unsafe sprintf → safe equivalents (after REF-021 surfaces them)
23. **CI-002** — clang-format
24. **CI-003** — MSVC hardening (/WX, /sdl, /guard:cf)
25. **CI-004** — clang-tidy
26. **CI-005** — cppcheck
27. **CI-006** — AddressSanitizer

### Do Later — Minor / Trivial

- **BUG-002 through BUG-006** — targeted bug fixes
- **BUG-008** — CaptchaGenerator rand() & 8 (one-liner)
- **BUG-013** — ArchiveRecovery malloc null checks (3-line fix)
- **BUG-014** — ZIPFile WriteFile return check (2-line fix)
- **BUG-015** — GetTickCount 49-day wrap in ban/timeout (3-line fix, high value)
- **REF-004** — Prefs audit (coordinate with BUG-001)
- **REF-015** — miniupnpc removal: one-line switch, safe at any time
- **REF-016** — ResizableLib inline: no dialog source changes
- **REF-022** — types.h → `<cstdint>`: mechanical, low risk
- **REF-024** — Opcodes.h `#define` → `constexpr`: mechanical
- **FEAT-001, 003–006** — Kad quality improvements
- **FEAT-007** — Windows Property Store metadata
- **FEAT-008, 009** — Oracle/mirror guard seams
- **FEAT-010** — Long path support phase 2: shell/UI follow-up after core filesystem landing
- **FEAT-011, 012** — CShield + TCP flood defense: port from eMuleAI
- **FEAT-013, 014** — REST API sidecar: full contract specified
- **CI-007** — Kad fuzz tests (after CI-006 ASan baseline)

---

## Dependency Graph

```
CI-001 (CMake)
  ├── CI-002 (clang-format)
  ├── CI-003 (MSVC hardening)
  │     └── CI-006 (ASan)
  │           └── CI-007 (Kad fuzz tests)
  ├── CI-004 (clang-tidy)
  └── CI-005 (cppcheck)

REF-002 (SX v1 removal) ──► REF-005 (dead debug calls)

[Boost — if adopted]
REF-008 (Boost.Asio) ──► REF-009 (Boost.Thread)
REF-008              ──► REF-011 (Boost.Chrono timers)

REF-021 (remove warning suppressions) ──► REF-023 (fix sprintf sites revealed)

BUG-009 (atomic part.met) ──┐
BUG-010 (disk-space guard) ─┤ share CanWritePartMetFiles / ReplaceFileAtomically
BUG-012 (destructor flush) ─┘ coordinate in same PartFile.cpp pass

FEAT-008 (oracle seams) ──► FEAT-009 (mirror audit)
FEAT-013 (CPipeApiServer) ──► FEAT-014 (Node.js sidecar)
FEAT-011 (CShield) ──► FEAT-012 (PR_TCPERRORFLOODER, can standalone)
FEAT-015 (upload controller) ──► FEAT-016 (modern limits — coordinate Opcodes.h values)
BUG-001 (prefs not saved) ◄── REF-004 (prefs audit)
FEAT-017 (DPI) ──► REF-017 (dead Win9x pixel-guard comments removed first)
```

---

## Confirmed Already in main (do NOT re-open)

These items were verified in `eMule-main` and are genuinely done:

| Item | Evidence |
|------|---------|
| C++17 standard baseline (WWMOD_021) | commit `93797f3 Set explicit C++17 baseline` |
| CaptchaGenerator GDI fix (CODEREV_001) | commit `2251e6d` |
| MbedTLS + SMTP + web server removal | Verified absent from srchybrid/ |
| id3lib removal → MediaInfo | Verified MediaInfo present, id3lib absent |
| BBUG_001-006 security packet hardening | Verified in packet handler code |

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
| `FEATURE-BROADBAND.md` | FEAT_001 done on stale branch only — NOT in main | FEAT-015 |
| `FEATURE-MODERN-LIMITS.md` | FEAT_013-019 done on stale branch only — NOT in main | FEAT-016 |
| `FEATURE-THUMBS.md` | Thumbnail feature RETIRED; IMediaDet in FileInfoDialog.cpp pending | Not converted (needs audit) |
| `EXTRAS_VPNKILLSWITCHDESIGN.md` | External helper tool — not in-process; deferred | Not converted |
| `AUDIT-WWMOD.md` | Win10+ modernization catalog — triaged 2026-04-08 | REF-017 through REF-024, FEAT-017 |
| `AUDIT-CODEREVIEW.md` | CODEREV_001 fixed in main; 002/003/004/011 not in main; 006/007 stale (WebSocket removed) | BUG-007, BUG-008 |
| eMuleAI v1.3 analysis | ReplaceFileAtomically, CanWritePartMetFiles, shareddir lock, destructor guard | BUG-009 through BUG-012 |

---

*Issues are tracked here, not in the old `docs/` folder. The `docs/` folder is
historical reference only.*

*Total: 15 bugs + 17 refactors + 7 boost (deferred) + 17 features + 7 CI = **63 open issues***
