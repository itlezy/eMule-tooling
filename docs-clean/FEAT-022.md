---
id: FEAT-022
title: Startup config directory override — -c flag for alternate preferences path
status: Open
priority: Minor
category: feature
labels: [startup, config, testing, portability, sysadmin]
milestone: ~
created: 2026-04-10
source: stale-v0.72a-experimental-clean, commit f8ef5c1
---

## Summary

eMule currently hardcodes its configuration directory to a fixed location relative to the
binary or the user's `%APPDATA%`. There is no way to specify an alternate config directory
at launch, making it difficult to:

- Run multiple isolated eMule instances with separate configs
- Run automated tests with a controlled configuration state
- Support portable installation modes
- Use separate configs for different network environments

The experimental branch adds a `-c <path>` command-line switch that overrides the config
directory at startup, before any preference loading occurs.

## Experimental Reference Implementation

**Source:** `stale-v0.72a-experimental-clean`, commit `f8ef5c1 FEAT: add config directory
startup override` (196 insertions / 19 deletions)

**New file:**
- `srchybrid/StartupConfigOverride.h` — `CStartupConfigOverride` class and helpers (+103 lines)

**Modified files:**
- `srchybrid/Emule.cpp` — argument parsing, `-c` flag extraction, `SetConfigDir()` call
  before `InitApp()` (+68 lines)
- `srchybrid/Emule.h` — new `GetConfigDir()` accessor (+3 lines)
- `srchybrid/EmuleDlg.cpp` — uses `GetConfigDir()` instead of hardcoded path (+5 lines)
- `srchybrid/Preferences.cpp` — `CPreferences::Init()` respects the override (+12 lines)

**Usage:**
```
eMule.exe -c "%EMULE_WORKSPACE_ROOT%\profiles\instance1"
eMule.exe -c "%APPDATA%\eMule-test"
```

The override is applied before startup config initialization, so all files
(`preferences.ini`, `known.met`, `part.met` root, etc.) are redirected to the specified
directory.

## Use Cases

1. **Automated testing** (primary motivation): the experimental test harness uses `-c` to
   point each test run at a deterministic temp directory, ensuring test isolation without
   touching the developer's live config.

2. **Multiple instances**: run a "test" and a "live" instance with different configs
   simultaneously.

3. **Portable mode**: set `-c` to a relative path (`.`) for a fully portable installation
   on a USB drive.

4. **Staging configs**: operators managing eMule in multi-user environments can assign
   per-user config directories.

## Implementation Notes

- The override path must be resolved before any `thePrefs.GetMuleDirectory()` call
- Relative paths resolved relative to the binary location (not CWD)
- Environment variable expansion in the path (`%APPDATA%`, `%TEMP%`) handled by the
  `CStartupConfigOverride` helper
- Long-path aware: use `\\?\` prefix if path exceeds MAX_PATH (coordinate with FEAT-010)

## Acceptance Criteria

- [ ] `-c <path>` command-line argument parsed before preference initialization
- [ ] All config file paths (`preferences.ini`, known files, temp dirs) redirected to the
  override directory
- [ ] Missing override directory created automatically
- [ ] Relative path expansion documented
- [ ] No change in behavior when `-c` is not specified (backward compatible)
- [ ] Works with the existing portable-mode detection if any
