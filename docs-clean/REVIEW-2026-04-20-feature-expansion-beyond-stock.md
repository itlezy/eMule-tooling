# Review 2026-04-20 - Feature Expansion Beyond Stock

## Scope

This pass was user-directed and intentionally changes the backlog filter:

- previous default: minimum drift from stock eMule
- this pass: add worthwhile higher-drift product features as backlog candidates

Sources used:

- current `analysis\emuleai` release notes and codebase
- historical mod feature catalogs and FAQs
- current web demand signals around modern ED2K remote control and connectivity

Theme and translation work remained out of scope.

## Existing Feature Drift Correction

`FEAT-031` already existed on disk but had drifted out of `docs-clean/INDEX.md`.

That item is restored to the active index in this pass:

- [FEAT-031](FEAT-031.md) — auto-browse compatible remote shared-file inventories with
  persisted cache

## New Feature Promotions

### FEAT-035 - IPv6 dual-stack networking

Promoted because:

- eMuleAI already carries an early IPv6 line
- eMule Qt now publicly lists IPv6 as an upcoming community-requested feature
- dual-stack connectivity is becoming harder to ignore on modern networks

### FEAT-036 - NAT traversal and extended source exchange

Promoted because:

- LowID/NAT/VPN connectivity remains one of the clearest current user pain points
- eMuleAI explicitly pushes beyond stock behavior here with relay-assisted and traversal
  work
- this is the natural next expansion step after `FEAT-032`

### FEAT-037 - release-oriented sharing controls

Promoted because:

- PowerShare, Release Bonus, Share Only The Need, and related release policies are among
  the most consistently cited historical mod differentiators
- if the branch is now allowed to go beyond stock, this is one of the most recognizably
  eMule-native mod feature clusters worth tracking

### FEAT-038 - shared-files watcher and live recursive sync

Promoted because:

- eMuleAI already demonstrates the live watcher direction
- it is meaningfully different from the narrower `FEAT-034` manual-reload improvement
- it offers a concrete large-library usability improvement once stock-only constraints are
  relaxed

### FEAT-039 - download checker / duplicate intake guard

Promoted because:

- it is a clear file-handling convenience feature with minimal protocol risk
- it complements, but does not replace, the `KnownFileList` correctness fixes

### FEAT-040 - headless core with modern web/mobile controller

Promoted because current demand signals now point well beyond the original desktop-only
stock shape:

- eMule Qt explicitly advertises daemon/GUI split plus REST/web control:
  https://emule-qt.org/2026/03/05/hello-emule-2026/
- current self-hosted ED2K controller work shows active demand for remote management,
  multi-user permissions, API keys, and mobile-friendly interfaces:
  https://www.reddit.com/r/selfhosted/comments/1q2y41z/amule_web_controller_a_modern_replacement_for_the/
  https://www.reddit.com/r/selfhosted/comments/1rgb9mv/amutorrent_v32_now_supports_5_download_clients/

This is the broadest feature promoted in this pass and should be treated as a separate
product track, not a stabilization task.

## Historical Mod Signals

Historical mod catalogs strongly support promotion of release/distribution-focused features.

Representative references:

- MorphXT FAQ feature list includes Smart A4AF, Source Load Saver, SUC, Upload Speed
  Sense, PowerShare, Share Only The Need, and Downloaded History:
  https://wiki.emule-web.de/Morphxt_faq
- Mephisto and related mod catalogs continue the same release/upload-policy direction:
  https://mephisto.emule-web.de/eng_faq.html
- the eMule feature-category archive shows how central PowerShare, Release Bonus, Slot
  Focus, Source Cache, and similar features were in the historical mod ecosystem:
  https://wiki.emule-web.de/Category%3AFeatures

## Current Web Signals

Useful current signals are clustered around:

- remote/web control
- automation/API use
- modern deployment patterns
- better connectivity under modern NAT and address conditions

This is inference from current projects and community tooling, not a formal feature poll.
Still, the direction is clear enough to justify adding the expansion-track FEAT items.

## Outcome

This pass:

- restores `FEAT-031` to the active index
- adds `FEAT-035` through `FEAT-040`
- explicitly records these items as a feature-expansion track beyond the previous
  stock-preserving backlog filter
