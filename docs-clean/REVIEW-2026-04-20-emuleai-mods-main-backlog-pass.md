# Review 2026-04-20 - eMuleAI, Mods, Main, and Web-Demand Backlog Pass

## Scope

Focused comparison of:

- `analysis\emuleai`
- current `workspaces\v0.72a\app\eMule-main`
- `analysis\mods-archive` with focused Xtreme checks on shared-file and known-file behavior
- `analysis\stale-v0.72a-experimental-clean` as retired reference-only provenance
- a small 2026 web-demand scan for current community signals

The pass stayed constrained to the branch goal from workspace policy:

- minimal drift from stock eMule
- prioritize networking, performance, file-handling, security-adjacent hardening, and
  bug fixes
- ignore theme and translation work

## Local Main Catch-Up

Two important backlog-state corrections were needed after rechecking the current local
`main` history:

### FEAT-033 is already landed

Local commit `e15e9f4` lands a worthwhile low-drift storage hardening slice:

- separate config/temp/incoming disk-space floors
- protected-volume aggregation and stop/save behavior in `DownloadQueue`
- Tweaks exposure for the separate floors
- retirement of the old Import Parts / `PartFileConvert` path

This should be tracked as `Done`, not as a future candidate.

### REF-032 is partial only

Local commits `b4206dc`, `e78ab5a`, `3f6994b`, `092b88e`, and `0fcfade` clearly moved the
preferences/layout cleanup forward, but they do not complete the item:

- `CPreferencesDlg` still derives from `CTreePropSheet`
- `TreePropSheet.*` is still active
- many dialogs still depend on `ResizableLib`
- the tree still has no live `CMFCPropertySheet` / `CMFCDynamicLayout` adoption

So `REF-032` should move from `Open` to `In Progress`, but not to `Done`.

## New Backlog Promotions

### BUG-036 - atomic save for known.met and cancelled.met

Current `main` still saves both files in place from `CKnownFileList::Save()`. That leaves
the same class of truncation window that already justified earlier atomic-write hardening
for `part.met` and `ipfilter.dat`.

`analysis\emuleai` already shows the low-drift pattern for `known.met` by writing
`known.met.tmp` and promoting it with `MoveFileEx(..., MOVEFILE_REPLACE_EXISTING)`. The
retired stale branch and focused Xtreme archive do not carry that hardening, which makes
this a real remaining delta worth promoting.

### BUG-037 - destructive same-hash KnownFile replacement

Current `main` still has the historical `SafeAddKFile()` same-hash replacement path that
the source itself warns can create unshared files or GUI/logical share mismatches.

`analysis\emuleai` proves the broader duplicate-tracking problem space, while the Xtreme
archive shows this is also long-standing mod-side knowledge. The branch should not import
the full duplicate-history feature set, but it should track the core hash-only
destructive replacement bug.

### FEAT-034 - narrow non-blocking shared-files reload

Current `main` `CSharedFileList::Reload()` still calls `FindSharedFiles(false)`
synchronously. `analysis\emuleai` and the focused Xtreme archive both show background
scan/coalescing approaches that avoid UI stalls.

This is promoted only as a narrow performance candidate:

- manual reload responsiveness
- no always-on watcher
- no broader share-policy drift
- low priority behind correctness fixes

## Web-Demand Scan

The web scan was used only to filter backlog candidates, not to drive broad product drift.

### Strong current signals

- `eMule Qt` positions its March 5, 2026 announcement around features "the community has
  been asking for", specifically daemon/GUI split, REST/web control, IPv6, and NAT
  traversal:
  https://emule-qt.org/2026/03/05/hello-emule-2026/
- recent `aMule Web Controller` / `aMuTorrent` posts in January-February 2026 show that
  web control, automation, and modern remote UX are still active demand surfaces:
  https://www.reddit.com/r/selfhosted/comments/1q2y41z/amule_web_controller_a_modern_replacement_for_the/
  https://www.reddit.com/r/emule/comments/1r4geha/amule_web_controller_is_now_amutorrent_a_unified/

This is inference, not a formal survey, but it is a useful current signal.

### Recurring operational pain

- VPN / Kad / UDP friendliness remains a recurring user problem:
  https://www.reddit.com/r/Piracy/comments/14zcygi/emule_kad_and_vpn_no_uploads/
- large queue / large tree sluggishness is a long-running complaint:
  https://www.reddit.com/r/digitalpiracy/comments/uk68me/issues_with_emule/

These are not enough to justify big new subsystem work on a low-drift branch, but they do
support continuing the already-selected networking/performance hardening direction.

## Backlog Outcome

The filtered result of this pass is:

- mark landed `FEAT-033` as `Done`
- correct `REF-032` to `In Progress`
- add `BUG-036`
- add `BUG-037`
- add low-priority `FEAT-034`

## Explicit Non-Promotions

The pass intentionally did not promote these areas:

- IPv6 support
- NAT traversal / buddy extensions
- source saver / source cache product features
- filesystem watcher behavior
- dark mode, themes, and translation changes

Reason: they are either already represented elsewhere, too feature-drifty for the current
branch goal, or too broad to justify on the present evidence.
