# Preferences Reference

This file documents the preferences and preference-like INI keys used by the current `v0.72a-broadband-dev` branch.

It is based on:

- `srchybrid/Preferences.cpp`
- `srchybrid/Preferences.h`
- the `PPg*.cpp` preference pages
- [`AUDIT-DEFECTS.md`](AUDIT-DEFECTS.md)

## Table of Contents

- [Scope](#scope)
- [Legend](#legend)
- [UI-Exposed Preferences](#ui-exposed-preferences)
  - [General](#general) — [Connection And Throughput](#connection-and-throughput) — [Server / eD2k / Kad](#server--ed2k--kad) — [Directories, Files, And Download Behavior](#directories-files-and-download-behavior) — [Display / UI / Toolbar](#display--ui--toolbar) — [Security, Privacy, And Obfuscation](#security-privacy-and-obfuscation) — [Messaging / Chat](#messaging--chat) — [Notifications](#notifications) — [UPnP](#upnp) — [Broadband Branch Controls](#broadband-branch-controls)
- [Hidden Runtime Preferences](#hidden-runtime-preferences)
- [Hidden Or Legacy Keys Which Look Stale](#hidden-or-legacy-keys-which-look-stale-transitional-or-import-only)
- [UI Defaults Which Are Not First-Class CPreferences Keys](#ui-defaults-which-are-not-first-class-cpreferences-keys)
- [Technical Notes For Non-Obvious Settings](#technical-notes-for-non-obvious-settings)
  - [Throughput And Connection Control](#throughput-and-connection-control) — [Server / Kad Behavior](#server--kad-behavior) — [File I/O And Download Mechanics](#file-io-and-download-mechanics) — [Security / Messaging / Obfuscation](#security--messaging--obfuscation) — [UI / Rendering Internals](#ui--rendering-internals) — [Broadband Branch Controls](#broadband-branch-controls-1) — [Hidden Maintenance / Legacy Behavior Knobs](#hidden-maintenance--legacy-behavior-knobs)
- [Counters, Statistics, And State Stored In The Same INI](#counters-statistics-and-state-stored-in-the-same-ini)
- [TODO](#todo)
- [Practical Reading Guide](#practical-reading-guide)

## Scope

This document separates four different things which all live in `preferences.ini`:

1. real user-facing preferences
2. hidden/internal runtime preferences
3. compatibility or import-only keys
4. counters, statistics, and UI layout state

The first two groups are the actual behavior knobs.
The last two groups are documented because they still live in the same file, but they are not normal end-user settings.

## Legend

| Column | Meaning |
| --- | --- |
| `INI key` | The exact key name used in the INI file. |
| `Section` | INI section. If omitted in code, it is the main `eMule` section. |
| `Mode` | `RW` = read and written, `R` = read only, `W` = write only. |
| `UI` | Whether the setting is exposed in the Preferences dialogs. |
| `Default` | Default if the key is missing, based on current code. |
| `Explanation` | Practical purpose and effect. |

## UI-Exposed Preferences

### General

| INI key | Section | Mode | UI | Default | Explanation |
| --- | --- | --- | --- | --- | --- |
| `Nick` | `eMule` | `RW` | Yes | `DEFAULT_NICK` | The user nickname shown to peers. Saved as UTF-8. |
| `Language` | `eMule` | `RW` | Yes | Current OS / app default | UI language identifier. Changing it reloads most windows. |
| `BringToFront` | `eMule` | `RW` | Yes | `false` | Bring the main window to the foreground on relevant events. |
| `OnlineSignature` | `eMule` | `RW` | Yes | `false` | Enables the online signature/status output used by external tools or web pages. |
| `StartupMinimized` | `eMule` | `RW` | Yes | `false` | Start the main window minimized. This is persisted correctly. |
| `AutoStart` | `eMule` | `RW` | Yes | `false` | Start eMule automatically with Windows. |
| `PreventStandby` | `eMule` | `RW` | Yes | OS-dependent / `false` on old systems | Prevent system standby while the app is active. |

### Connection And Throughput

| INI key | Section | Mode | UI | Default | Explanation |
| --- | --- | --- | --- | --- | --- |
| `MaxUpload` | `eMule` | `RW` | Yes | `50000` | Upload speed limit in KiB/s for this branch. |
| `MaxDownload` | `eMule` | `RW` | Yes | `200000` | Download speed limit in KiB/s for this branch. |
| `DownloadCapacity` | `eMule` | `RW` | Yes | `200000` | Download line-capacity hint in KiB/s. Used for graphs and throughput logic. |
| `UploadCapacityNew` | `eMule` | `RW` | Yes | `50000` | Upload line-capacity hint in KiB/s. Important for the broadband controller. |
| `MaxConnections` | `eMule` | `RW` | Yes | existing app default | Hard cap for total connections. |
| `MaxHalfConnections` | `eMule` | `RW` | Yes | existing app default | Cap for half-open TCP connections. |
| `MaxConnectionsPerFiveSeconds` | `eMule` | `RW` | Yes | existing app default | Burst limiter for outbound connection attempts. |
| `Port` | `eMule` | `RW` | Yes | existing app default | Main TCP listening port. |
| `UDPPort` | `eMule` | `RW` | Yes | existing app default | Main UDP listening port. |
| `ServerUDPPort` | `eMule` | `RW` | Yes | existing app default | UDP port used for server communication. |
| `BindInterface` | `eMule` | `RW` | Yes | empty | Preferred network interface for P2P sockets. Empty means no interface restriction. |
| `BindInterfaceName` | `eMule` | `RW` | Yes | empty | Stored display name for the selected P2P bind interface, mainly to keep the UI readable if the adapter is currently missing. |
| `BindAddr` | `eMule` | `RW` | Yes | empty | Optional IPv4 address for P2P sockets. Empty means all addresses on the selected interface, or all interfaces when no interface is selected. |
| `ConditionalTCPAccept` | `eMule` | `RW` | Yes | existing app default | Controls conditional TCP accept behavior. This is an advanced network-side knob. |
| `ConnectionTimeout` | `eMule` | `RW` | Advanced tree | `30` seconds | Default TCP peer-connection timeout used by `EMSocket` and related connect/disconnect paths. |
| `DownloadTimeout` | `eMule` | `RW` | Advanced tree | `75` seconds | Inactivity timeout for receiving download payload blocks from a peer. |
| `UDPReceiveBufferSize` | `eMule` | `RW` | Advanced tree | `512 * 1024` | UDP receive socket buffer size in bytes. Exposed in Tweaks as KiB. |
| `BigSendBufferSize` | `eMule` | `RW` | Advanced tree | `512 * 1024` | Configured large TCP send buffer size in bytes for upload sockets. Exposed in Tweaks as KiB. |
| `UploadClientDataRate` | `eMule` | `RW` | Advanced tree | `8 * 1024 * 1024` | Ceiling for the heuristic per-client upload target used by the broadband slot controller. Exposed in Tweaks as KiB/s. |

### Server / eD2k / Kad

| INI key | Section | Mode | UI | Default | Explanation |
| --- | --- | --- | --- | --- | --- |
| `Reconnect` | `eMule` | `RW` | Yes | existing app default | Automatically reconnect to a server after disconnects. |
| `Serverlist` | `eMule` | `RW` | Yes | `false` | Auto-update the server list on startup. You asked to keep this default off. |
| `AddServersFromServer` | `eMule` | `RW` | Yes | `true` | Update the server list using server-provided data when connecting to a server. |
| `AddServersFromClient` | `eMule` | `RW` | Yes | existing app default | Accept server addresses from clients. |
| `Autoconnect` | `eMule` | `RW` | Yes | `false` | Automatically connect on startup. You asked to keep this default off because first launch can be messy otherwise. |
| `AutoConnectStaticOnly` | `eMule` | `RW` | Yes | `false` | Restrict auto-connect attempts to static servers only. |
| `DeadServerRetry` | `eMule` | `RW` | Yes | `5` | Number of failed tries after which a server is treated as dead and removed. |
| `SafeServerConnect` | `eMule` | `RW` | Yes | existing app default | More cautious server-connect strategy. |
| `ServerKeepAliveTimeout` | `eMule` | `RW` | Advanced tree | existing app default | Timeout used to keep the server connection alive. |
| `YourHostname` | `eMule` | `RW` | Yes | empty | Optional hostname override displayed/used by the app. |
| `NetworkED2K` | `eMule` | `RW` | Yes | `true` | Enable the eD2k network layer. |
| `NetworkKademlia` | `eMule` | `RW` | Yes | `true` | Enable the Kad network layer. |
| `Ed2kSearchMaxResults` | `eMule` | `RW` | Advanced tree | `0` | Maximum eD2k search results; `0` keeps the search uncapped. |
| `Ed2kSearchMaxMoreRequests` | `eMule` | `RW` | Advanced tree | `0` | Maximum extra eD2k search-more requests; `0` keeps the request count uncapped. |
| `KadFileSearchTotal` | `eMule` | `RW` | Advanced tree | `750` | Total Kad file-search budget; clamped to `100..5000`. |
| `KadKeywordSearchTotal` | `eMule` | `RW` | Advanced tree | `750` | Total Kad keyword-search budget; clamped to `100..5000`. |
| `KadFileSearchLifetime` | `eMule` | `RW` | Advanced tree | `90` seconds | Kad file-search lifetime; clamped to `30..180` seconds. |
| `KadKeywordSearchLifetime` | `eMule` | `RW` | Advanced tree | `90` seconds | Kad keyword-search lifetime; clamped to `30..180` seconds. |

### Directories, Files, And Download Behavior

| INI key | Section | Mode | UI | Default | Explanation |
| --- | --- | --- | --- | --- | --- |
| `IncomingDir` | `eMule` | `RW` | Yes | app default path | Directory used for completed downloads. |
| `TempDir` | `eMule` | `RW` | Yes | app default path | Primary temp directory for `.part` files. |
| `TempDirs` | `eMule` | `RW` | Yes | empty | Additional temp directories, stored as a `|`-separated list. |
| `MaxSourcesPerFile` | `eMule` | `RW` | Yes | `600` | Hard cap for sources tracked per file. |
| `AddNewFilesPaused` | `eMule` | `RW` | Yes | `false` | Add new downloads in paused state instead of starting immediately. |
| `PreviewPrio` | `eMule` | `RW` | Yes | `true` | Try to download preview chunks first. This is the setting you just changed to default on. |
| `AllocateFullFile` | `eMule` | `RW` | Yes | `false` | Preallocate the full output file size ahead of download progress. |
| `SparsePartFiles` | `eMule` | `RW` | Yes | `false` | Use sparse part-file allocation where supported. |
| `CommitFiles` | `eMule` | `RW` | Yes | `1` | Controls file commit behavior. Legacy low-level file I/O policy. |
| `CheckDiskspace` | `eMule` | `RW` | Yes | `false` | Enforce minimum free-disk-space checks. |
| `MinFreeDiskSpace` | `eMule` | `RW` | Yes | `5 * 1024 * 1024 * 1024` | Minimum free disk space threshold. Tweaks now edits this in GB. |
| `AutoArchivePreviewStart` | `eMule` | `RW` | Yes | `true` | Automatically start archive preview extraction. |
| `ExtractMetaData` | `eMule` | `RW` | Yes | `1` | Metadata extraction mode. |
| `ResolveSharedShellLinks` | `eMule` | `RW` | Yes | `false` | Resolve shell links in shared directories. |
| `ShowSharedFilesDetails` | `eMule` | `RW` | Yes | `true` | Show the shared-files details area. |
| `AutoShowLookups` | `eMule` | `RW` | Yes | `true` | Auto-show Kad lookups in the UI. |
| `RemoveFilesToBin` | `eMule` | `RW` | Yes | `true` | Send removed files to the recycle bin instead of deleting directly. |
| `RememberCancelledFiles` | `eMule` | `RW` | Yes | `true` | Keep memory of cancelled files. |
| `RememberDownloadedFiles` | `eMule` | `RW` | Yes | `true` | Keep memory of already-downloaded files. |
| `AutoClearCompleted` | `eMule` | `RW` | Yes | `false` | Automatically clear finished downloads from the list. |
| `FileBufferSize` | `eMule` | `RW` | Yes | `64 * 1024 * 1024` | Global file buffer size in bytes. Exposed via the Tweaks slider. |
| `QueueSize` | `eMule` | `RW` | Yes | derived from app default | Queue size cap. |

### Display / UI / Toolbar

| INI key | Section | Mode | UI | Default | Explanation |
| --- | --- | --- | --- | --- | --- |
| `ShowRatesOnTitle` | `eMule` | `RW` | Yes | `true` | Show current transfer rates in the window title. |
| `ShowExtControls` | `eMule` | Removed | No | ignored | Retired by `FEAT-051`; advanced/pro controls are now always on and old INI values are ignored. |
| `ShowDwlPercentage` | `eMule` | `RW` | Yes | `false` | Show extra download percentage information. |
| `IndicateRatings` | `eMule` | `RW` | Yes | `true` | Show file ratings in UI where supported. |
| `ToolTipDelay` | `eMule` | `RW` | Yes | existing app default | Delay before tooltips appear. |
| `ToolbarSetting` | `eMule` | `RW` | Yes | toolbar default | Toolbar layout/configuration string. |
| `ToolbarBitmap` | `eMule` | `RW` | Yes | empty | Custom toolbar bitmap path. |
| `ToolbarBitmapFolder` | `eMule` | `RW` | Yes | empty | Folder containing toolbar bitmaps. |
| `ToolbarLabels` | `eMule` | `RW` | Yes | toolbar default | Label mode for toolbar buttons. |
| `ToolbarIconSize` | `eMule` | `RW` | Yes | `32` | Toolbar icon size in pixels. |
| `WinaTransToolbar` | `eMule` | `RW` | Yes | `true` | Toolbar transparency integration on supported Windows versions. |
| `ShowDownloadToolbar` | `eMule` | `RW` | Yes | `true` | Show the download toolbar. |
| `SkinProfile` | `eMule` | `RW` | Yes | empty | Selected skin profile. |
| `SkinProfileDir` | `eMule` | `RW` | Yes | empty | Selected skin directory. |
| `DateTimeFormat` | `eMule` | `RW` | Yes | `%A, %c` | Main date/time format string. |
| `DateTimeFormat4Log` | `eMule` | `RW` | Yes | `%c` | Date/time format string used in logs. |
| `TransferDoubleClick` | `eMule` | `RW` | Yes | existing app default | Double-click action in transfer lists. |
| `ShowOverhead` | `eMule` | `RW` | Yes | `false` | Show protocol overhead in transfer display. |
| `ShowInfoOnCatTabs` | `eMule` | `RW` | Yes | `false` | Show info on category tabs. |
| `ShowCopyEd2kLinkCmd` | `eMule` | `RW` | Yes | `false` in older code path | Show the copy-ed2k-link context command. |

### Security, Privacy, And Obfuscation

| INI key | Section | Mode | UI | Default | Explanation |
| --- | --- | --- | --- | --- | --- |
| `FilterServersByIP` | `eMule` | `RW` | Yes | existing app default | Filter servers using the IP filter rules. |
| `FilterLevel` | `eMule` | `RW` | Yes | `127` | IP filter aggressiveness level. |
| `FilterBadIPs` | `eMule` | `RW` | Yes | existing app default | Filter LAN/bad IPs more generally. |
| `SecureIdent` | `eMule` | `RW` | Yes | `true` | Enable secure identification support. |
| `CryptLayerRequested` | `eMule` | `RW` | Yes | `true` | Request obfuscation when talking to peers. |
| `CryptLayerRequired` | `eMule` | `RW` | Yes | `false` | Require obfuscation. |
| `CryptLayerSupported` | `eMule` | `RW` | Yes | `true` | Advertise obfuscation support. |
| `EnableSearchResultSpamFilter` | `eMule` | `RW` | Yes | `true` | Filter obviously spammy search results. |
| `CheckFileOpen` | `eMule` | `RW` | Yes | `true` | Check for open/locked files before file operations. |
| `SeeShare` | `eMule` | `RW` | Yes | existing app default | Controls who can see your shared files. |
| `AdvancedSpamFilter` | `eMule` | `RW` | Yes | `true` | Enables the more advanced spam filter path. |

### Messaging / Chat

| INI key | Section | Mode | UI | Default | Explanation |
| --- | --- | --- | --- | --- | --- |
| `MessagesFromFriendsOnly` | `eMule` | `RW` | Yes | `false` | Restrict incoming messages to friends only. |
| `MessageUseCaptchas` | `eMule` | `RW` | Yes | `true` | Require captchas for chat where the anti-spam path is active. |
| `MessageEnableSmileys` | `eMule` | `RW` | Yes | `true` | Enable smiley rendering in messages. |
| `MessageFilter` | `eMule` | `RW` | Yes | built-in filter string | Text filter applied to incoming messages. |
| `CommentFilter` | `eMule` | `RW` | Yes | built-in filter string | Text filter applied to comments. |

### Notifications

| INI key | Section | Mode | UI | Default | Explanation |
| --- | --- | --- | --- | --- | --- |
| `NotifierConfiguration` | `eMule` | `RW` | Yes | notifier config path | Path to notifier configuration. |
| `NotifyOnDownload` | `eMule` | `RW` | Yes | `false` unless enabled by user | Notify on completed downloads. |
| `NotifyOnNewDownload` | `eMule` | `RW` | Yes | `false` unless enabled by user | Notify when a new download is added. |
| `NotifyOnChat` | `eMule` | `RW` | Yes | `false` unless enabled by user | Notify on incoming chat. |
| `NotifyOnLog` | `eMule` | `RW` | Yes | `false` unless enabled by user | Notify on log output. |
| `NotifyOnImportantError` | `eMule` | `RW` | Yes | `false` unless enabled by user | Notify on important errors. |
| `NotifierPopEveryChatMessage` | `eMule` | `RW` | Yes | `false` | Pop every chat message, not just first/important ones. |
| `NotifierDisplayMode` | `eMule` | `RW` | Yes | `1` | Notification display mode: `0` custom popup, `1` Windows toast, `2` classic tray balloon. Windows toast falls back to tray balloon when unavailable. |
| `NotifierUseSound` | `eMule` | `RW` | Yes | `ntfstNoSound` | Select notifier sound mode. |
| `NotifierSoundPath` | `eMule` | `RW` | Yes | empty | Custom sound file path. |

### UPnP

| INI key | Section | Mode | UI | Default | Explanation |
| --- | --- | --- | --- | --- | --- |
| `EnableUPnP` | `UPnP` | `RW` | Yes | `true` | Enable UPnP. You asked for this default on, including wizard flow. |
| `CloseUPnPOnExit` | `eMule` | `RW` | Yes | `true` | Remove UPnP mappings on exit. |
| `SkipWANIPSetup` | `eMule` | `RW` | Yes | `false` | Skip WAN IP setup path. |
| `SkipWANPPPSetup` | `eMule` | `RW` | Yes | `false` | Skip WAN PPP setup path. |
| `LastWorkingImplementation` | `eMule` | `RW` | No | `1` | Tracks which UPnP backend last worked. Internal, but persisted. |

### Broadband Branch Controls

| INI key | Section | Mode | UI | Default | Explanation |
| --- | --- | --- | --- | --- | --- |
| `MaxUploadClientsAllowed` | `UploadPolicy` | `RW` | Yes | `8` | Broadband steady-state upload-slot target. This is the main broadband slot-count knob. |
| `SlowUploadThresholdFactor` | `UploadPolicy` | `RW` | Yes | `0.33` | Per-slot rate factor below which warmed-up upload slots can be recycled. |
| `SlowUploadGraceSeconds` | `UploadPolicy` | `RW` | Yes | `30` | Time a warmed-up slow slot must remain below threshold before recycle. |
| `SlowUploadWarmupSeconds` | `UploadPolicy` | `RW` | Yes | `60` | Startup grace period for new upload slots before slow-slot recycling. |
| `ZeroUploadRateGraceSeconds` | `UploadPolicy` | `RW` | Yes | `10` | Time a warmed-up zero-rate slot can remain stalled before recycle. |
| `SlowUploadCooldownSeconds` | `UploadPolicy` | `RW` | Yes | `120` | Cooldown during which recycled clients keep a zero queue score. |
| `LowRatioBoostEnabled` | `UploadPolicy` | `RW` | Yes | `true` | Enables queue-score boosting for files under the low-ratio threshold. |
| `LowRatioThreshold` | `UploadPolicy` | `RW` | Yes | `0.5` | Ratio threshold below which files can receive low-ratio boosting. |
| `LowRatioScoreBonus` | `UploadPolicy` | `RW` | Yes | `50` | Additive score bonus for low-ratio files. |
| `LowIDScoreDivisor` | `UploadPolicy` | `RW` | Yes | `2` | Divisor applied to actual LowID clients in queue scoring. |
| `SessionTransferLimitMode` | `UploadPolicy` | `RW` | Yes | percent of file | Upload session transfer-limit mode. |
| `SessionTransferLimitValue` | `UploadPolicy` | `RW` | Yes | `55` | Upload session transfer-limit value interpreted by the selected mode. |
| `SessionTimeLimitSeconds` | `UploadPolicy` | `RW` | Yes | `3600` | Upload session time limit in seconds; `0` disables time-based rotation. |

## Hidden Runtime Preferences

These settings are active and meaningful. Most operator-safe knobs are now exposed in the Tweaks advanced tree or on the WebServer page. Riskier compatibility/debug internals remain documented-only but are now written back when preferences are saved, so user edits are not silently discarded.

| INI key | Section | Mode | UI | Default | Explanation |
| --- | --- | --- | --- | --- | --- |
| `CreateCrashDump` | `eMule` | `RW` | Advanced tree | `1` | Crash dump mode: disabled, ask, or create automatically. |
| `MaxLogFileSize` | `eMule` | `RW` | Advanced tree | `16777216` bytes | Maximum on-disk log file size. Tweaks edits it in KiB; `0` means no rotation limit. Direct INI values are bounded on load. |
| `MaxLogBuff` | `eMule` | `RW` | Advanced tree | `256` KiB | Maximum in-memory log view buffer. Direct INI values are bounded on load. |
| `LogFileFormat` | `eMule` | `RW` | Advanced tree | `Unicode` | On-disk log encoding: UTF-16 Unicode or UTF-8. |
| `FullVerbose` | `eMule` | `RW` | Advanced tree | `false` | Full verbose trace when verbose logging is enabled. |
| `HighresTimer` | `eMule` | `RW` | Advanced tree | `false` | Requests a high-resolution Windows timer while eMule is running. |
| `ICH` | `eMule` | `RW` | Advanced tree | `true` | Enables Intelligent Corruption Handling. |
| `DontCompressAvi` | `eMule` | `RW` | Advanced tree | `false` | Skips compression for AVI upload payloads. |
| `PreviewSmallBlocks` | `eMule` | `RW` | Advanced tree | `0` | Allows or forces preview availability before normal block-completeness checks are fully satisfied. |
| `BeepOnError` | `eMule` | `RW` | Advanced tree | `false` | Plays an audible alert on important errors. |
| `ShowCopyEd2kLinkCmd` | `eMule` | `RW` | Advanced tree | `false` | Shows a direct copy-ed2k-link context command. |
| `IconflashOnNewMessage` | `eMule` | `RW` | Advanced tree | `false` | Flashes the tray icon on new chat messages. |
| `DateTimeFormat` | `eMule` | `RW` | Advanced tree | `%A, %c` | General date/time display format. |
| `DateTimeFormat4Log` | `eMule` | `RW` | Advanced tree | `%c` | Log-line date/time display format. |
| `DateTimeFormat4Lists` | `eMule` | `RW` | Advanced tree | `%c` | Separate date/time format string for list controls. |
| `TxtEditor` | `eMule` | `RW` | Advanced tree | `notepad.exe` | Command used to open text output. |
| `RunCommandOnFileCompletion` | `FileCompletion` | `RW` | Files page | `false` | Enables a configured command when a download completes. |
| `FileCompletionProgram` | `FileCompletion` | `RW` | Files page | empty | Program path for the file-completion command. |
| `FileCompletionArguments` | `FileCompletion` | `RW` | Files page | empty | Argument template for the file-completion command. |
| `MaxChatHistoryLines` | `eMule` | `RW` | Advanced tree | `100` | Maximum retained chat/IRC history lines per view. Direct INI values are bounded on load. |
| `MaxMessageSessions` | `eMule` | `RW` | Advanced tree | `50` | Maximum retained peer message sessions. Direct INI values are bounded on load. |
| `RestoreLastMainWndDlg` | `eMule` | `RW` | Advanced tree | `false` | Restore the last active main tab on startup. |
| `RestoreLastLogPane` | `eMule` | `RW` | Advanced tree | `false` | Restore the selected log pane. |
| `FileBufferTimeLimit` | `eMule` | `RW` | Advanced tree | `120` seconds | Maximum age of buffered part-file data before forced flush. |
| `PreviewCopiedArchives` | `eMule` | `RW` | Advanced tree | `true` | Allow preview/archive-recovery logic on copied archives. |
| `InspectAllFileTypes` | `eMule` | `RW` | Advanced tree | `false` | Force metadata inspection on all file types, not just obvious media types. |
| `PreviewOnIconDblClk` | `eMule` | `RW` | Advanced tree | `false` | Use icon double-click as a preview action in the download list. |
| `ShowActiveDownloadsBold` | `eMule` | `RW` | Advanced tree | `false` | Render active downloads in bold. |
| `UseSystemFontForMainControls` | `eMule` | `RW` | Advanced tree | `false` | Use system fonts for major controls and list views. |
| `ReBarToolbar` | `eMule` | `RW` | Advanced tree | `true` | Enable rebar-based toolbar layout. |
| `ShowUpDownIconInTaskbar` | `eMule` | `RW` | Advanced tree | `false` | Show upload/download state in taskbar icon handling. |
| `AlwaysShowTrayIcon` | `eMule` | `RW` | Advanced tree | `false` | Keep the eMule notification-area icon visible while the app is running. Minimize-to-tray and tray-balloon notification delivery can still force tray visibility while this is disabled. |
| `ShowVerticalHourMarkers` | `eMule` | `RW` | Advanced tree | `true` | Draw vertical hour markers on statistics graphs. This now loads from `eMule` while falling back to the previous accidental `Statistics` placement. |
| `ForceSpeedsToKB` | `eMule` | `RW` | Advanced tree | `false` | Force speed-formatting helpers to prefer KB-based units. |
| `ExtraPreviewWithMenu` | `eMule` | `RW` | Advanced tree | `false` | Changes where preview actions appear in download-list UI/menu flow. |
| `KeepUnavailableFixedSharedDirs` | `eMule` | `RW` | Advanced tree | `false` | Keep fixed shared dirs even when currently unavailable during startup/shared-dir loading. |
| `PartiallyPurgeOldKnownFiles` | `eMule` | `RW` | Advanced tree | `true` | Allows more aggressive cleanup of stale known-file entries. |
| `RearrangeKadSearchKeywords` | `eMule` | `RW` | Advanced tree | `true` | Reorder Kad search keywords before issuing the search. |
| `MessageFromValidSourcesOnly` | `eMule` | `RW` | Advanced tree | `true` | Message acceptance gate used by `BaseClient.cpp`. |
| `GeoLocationLookupEnabled` | `eMule` | `RW` | Advanced tree | `true` | Enables IP geolocation display and automatic DB refresh checks. |
| `GeoLocationUpdatePeriodDays` | `eMule` | `RW` | Advanced tree | `30` days | Automatic geolocation DB refresh interval; clamped to `7..365`. |
| `GeoLocationLastUpdateTime` | `eMule` | `RW` | Geolocation updater | `0` | Last geolocation DB refresh attempt timestamp; `0` makes the enabled updater due on first run. |
| `PerfLog:Mode` | `PerfLog` | `RW` | Advanced tree | `0` | Performance logging enable/mode. Tweaks exposes this as an enable checkbox. |
| `PerfLog:FileFormat` | `PerfLog` | `RW` | Advanced tree | `0` | Performance logging output format: CSV or MRTG. |
| `PerfLog:File` | `PerfLog` | `RW` | Advanced tree | config-dir default | Performance logging base file path. |
| `PerfLog:Interval` | `PerfLog` | `RW` | Advanced tree | `5` minutes | Performance logging sample interval. |
| `MaxFileUploadSizeMB` | `WebServer` | `RW` | WebServer page | `5` | Maximum single WebServer upload size in MiB. |
| `AllowedIPs` | `WebServer` | `RW` | WebServer page | empty | Optional semicolon-separated IPv4 allow-list for WebServer clients. |
| `IPFilterUpdateEnabled` | `eMule` | `RW` | Security page | `false` | Enables post-startup automatic `ipfilter.dat` refreshes. |
| `IPFilterUpdatePeriodDays` | `eMule` | `RW` | Security page | `7` days | Day interval for automatic IP-filter update attempts; clamped to `1..365`. |
| `IPFilterLastUpdateTime` | `eMule` | `RW` | Automatic updater | `0` | Last automatic IP-filter update attempt timestamp. |
| `IPFilterUpdateUrl` | `eMule` | `RW` | Security page | `http://upd.emule-security.org/ipfilter.zip` | URL used by manual and automatic IP-filter updates. |

Documented-only active keys:

| INI key | Section | Mode | Default | Reason not exposed |
| --- | --- | --- | --- | --- |
| `AllowLocalHostIP` | `eMule` | `RW` | `false` | Low-level network identity exception with security implications. |
| `CryptTCPPaddingLength` | `eMule` | `RW` | `128` | Obfuscation protocol tuning; unsafe as a casual UI knob. |
| `UserSortedServerList` | `eMule` | `RW` | `false` | Legacy server-list ordering state, not a user workflow setting. |
| `DontRecreateStatGraphsOnResize` | `eMule` | `RW` | `false` | Narrow rendering workaround. |
| `StraightWindowStyles` | `eMule` | `RW` | `0` | Legacy window-style compatibility switch. |
| `RTLWindowsLayout` | `eMule` | `RW` | `false` | Locale/layout compatibility state handled by the UI. |
| `GeoLocationUpdateUrl` | `eMule` | `RW` | DB-IP template URL | Operational endpoint override; keep documented rather than casual UI. |
| `NotifierConfiguration` | `eMule` | `RW` | notifier config path | Separate notifier configuration file path. |

## Hidden Or Legacy Keys Which Look Stale, Transitional, Or Import-Only

| INI key | Section | Mode | Default | Explanation |
| --- | --- | --- | --- | --- |
| `FileBufferSizePref` | `eMule` | `R` | old compatibility import | Old file-buffer key. Current code reads it only as migration input, then uses `FileBufferSize`. |
| `QueueSizePref` | `eMule` | `R` | old compatibility import | Old queue-size key. Current code reads it only as migration input, then uses `QueueSize`. |
| `UploadCapacity` | `eMule` | `R` | legacy compatibility | Older upload-capacity key superseded by `UploadCapacityNew`. |
| `DownloadCapacity` | `eMule` | `R` | legacy compatibility | Older download-capacity key now treated as a signal to reset to broadband defaults. |
| `UploadCapacityNew` | `eMule` | `R` | legacy compatibility | Older upload-capacity key now treated as a signal to reset to broadband defaults. |
| `ResumeNextFromSameCat` | `eMule` | retired | n/a | No active preference member in current main. |
| `AdjustNTFSDaylightFileTime` | `eMule` | retired | n/a | No active preference member in current main. |
| `AICHTrustEveryHash` | `eMule` | retired | n/a | Removed as stale/unfinished; save now deletes old persisted values. |

## UI Defaults Which Are Not First-Class `CPreferences` Keys

These values are currently defaulted directly in UI code through `CPreferences` default helpers, not stored as first-class persisted preference members.

| Setting | Current default | Where it is implemented | Explanation |
| --- | --- | --- | --- |
| Server.met URL | `http://upd.emule-security.org/server.met` | `ServerWnd.cpp` | Default text shown in the server.met URL edit when empty. |
| Nodes.dat URL | `http://upd.emule-security.org/nodes.dat` | `KademliaWnd.cpp` | Default text shown in the Kad bootstrap URL edit when empty. |
| Kad bootstrap mode | `Load nodes from URL` | `KademliaWnd.cpp` | Default radio selection in the Kad tab. |

## Technical Notes For Non-Obvious Settings

This section explains what the more technical settings actually do in runtime terms.

### Throughput And Connection Control

| Setting | What it actually does |
| --- | --- |
| `DownloadCapacity` | This is not a live throttle by itself. It is the app's configured estimate of available downstream capacity. Code uses it for graph scaling, throughput heuristics, and any logic that wants a line-capacity hint instead of the current live rate. |
| `UploadCapacityNew` | This is the configured upstream-capacity hint. On this branch it feeds the broadband upload controller together with the active upload limit when slot targeting and per-slot throughput goals are derived. |
| `MaxUpload` | This is the actual upload limit presented to the rest of the app. The broadband controller treats it as one bound on the effective upload budget, so it directly constrains slot targeting and per-slot throughput goals. |
| `MaxDownload` | This is the active download speed limit. Unlike capacity, this is the operative cap used when download throttling logic is active. |
| `MaxConnections` | Hard cap on total tracked/open connections. It is a blunt resource guard, not a prioritization tool. |
| `MaxHalfConnections` | Caps not-yet-fully-open TCP connections. This mainly affects connect burst behavior and old Windows TCP stack sensitivity. |
| `MaxConnectionsPerFiveSeconds` | Burst limiter for new outbound connections. It smooths connection churn and protects both the local stack and remote peers from aggressive connect storms. |
| `ConditionalTCPAccept` | A lower-level network acceptance policy. It affects when the app accepts inbound TCP work under load instead of being a simple UI convenience setting. |
| `ConnectionTimeout` | Sets the default timeout budget for peer TCP sockets. The listen-socket and download paths extend this base timeout in specific states, but this is now the shared baseline. |
| `DownloadTimeout` | Controls how long a download peer may stay silent between completed payload blocks before the transfer is cancelled and put back on queue. |
| `UploadClientDataRate` | Caps the heuristic target rate for one upload slot. It does not replace the global upload throttle; it bounds the per-slot target derived by the broadband upload controller. |

### Server / Kad Behavior

| Setting | What it actually does |
| --- | --- |
| `Serverlist` | Controls whether startup will try to refresh the server list automatically. This is only the startup refresh behavior, not the broader “accept new servers from other places” policy. |
| `AddServersFromServer` | Lets connected servers feed additional server entries into the local server list. In practice this is the “update server list when connecting to a server” behavior. |
| `AddServersFromClient` | Lets clients contribute server addresses. This broadens discovery but also expands the trust surface. |
| `Autoconnect` | If enabled, the app starts trying to connect automatically at startup. It affects startup sequencing, which is why you reverted its default to `false`. |
| `AutoConnectStaticOnly` | Restricts auto-connect attempts to static servers. It narrows the candidate set rather than changing connection mechanics. |
| `DeadServerRetry` | Defines how many failed contacts a server can accumulate before being treated as dead in server-list maintenance paths. |
| `SafeServerConnect` | Chooses a more conservative connect strategy rather than simply “connect faster”. It reduces churn and poor target selection during automatic connect flows. |
| `NetworkED2K` / `NetworkKademlia` | These are top-level network enables. Disabling one removes that network's activity paths rather than merely hiding UI. |

### File I/O And Download Mechanics

| Setting | What it actually does |
| --- | --- |
| `FileBufferSize` | Caps how much data a part file keeps buffered before flushing. Larger values reduce write frequency and can improve sequential write behavior, but increase memory use and delay flushes. |
| `FileBufferTimeLimit` | Hidden companion to `FileBufferSize`. Even if the buffer does not fill, `PartFile.cpp` forces a flush once buffered data gets older than this threshold. |
| `UDPReceiveBufferSize` | Controls the UDP socket receive buffer size. Larger fixed values reduce packet-drop risk during bursts at the cost of some kernel buffer memory. |
| `BigSendBufferSize` | Controls the larger TCP send buffer target for upload sockets. Larger values can help keep fast upload slots fed without relying on tiny legacy buffers. |
| `QueueSize` | Caps the upload waiting queue size. It does not directly control upload slots; it limits how many clients can remain queued for service. |
| `PreviewPrio` | Biases downloads toward preview-relevant chunks first. It changes chunk-request preference, not just UI sorting. |
| `AllocateFullFile` | Causes destination files to be pre-sized up front. This can reduce fragmentation but increases upfront disk work and space reservation. |
| `SparsePartFiles` | Lets the filesystem avoid materializing all zero regions immediately. Useful on supported filesystems, but behavior depends on platform/filesystem support. |
| `CommitFiles` | Controls how aggressively the app commits file data to stable storage. It is a legacy durability/performance tradeoff rather than a user-facing convenience option. |
| `CheckDiskspace` / `MinFreeDiskSpace` | These gate download/write behavior when free space gets too low. They are operational safety checks, not UI-only warnings. |
| `PreviewCopiedArchives` | Hidden runtime switch used by archive preview/recovery paths. It determines whether copied archives are eligible for preview recovery behavior. |
| `InspectAllFileTypes` | Hidden runtime switch for metadata inspection. When enabled, file-info probing extends beyond the usual media-centric file types. |
| `PreviewOnIconDblClk` | Changes input behavior in the download list: double-clicking the icon zone becomes a preview action. |
| `ExtraPreviewWithMenu` | Hidden UI-flow modifier that changes how preview actions are exposed in the transfer list/menu logic. |

### Security / Messaging / Obfuscation

| Setting | What it actually does |
| --- | --- |
| `SecureIdent` | Enables the secure-identification system used to validate peer identity claims. This affects trust/credit-related flows, not encryption. |
| `CryptLayerRequested` | Advertises that the client would like obfuscated/encrypted peer traffic when the other side supports it. |
| `CryptLayerRequired` | Refuses plain connections where obfuscation is expected. This is much stronger than merely “prefer obfuscation”. |
| `CryptLayerSupported` | Announces protocol support for obfuscation. Disabling it removes that capability entirely. |
| `AdvancedSpamFilter` | Enables additional filtering logic for spam-like content beyond the simpler legacy path. |
| `MessageUseCaptchas` | Requires chat captcha checks where the message anti-spam path is active. It affects acceptance flow, not just presentation. |
| `MessageFromValidSourcesOnly` | Hidden message gate. In `BaseClient.cpp`, it restricts which peers can send messages through that path. It is exposed in Tweaks under Security & Filtering. |

### UI / Rendering Internals

| Setting | What it actually does |
| --- | --- |
| `UseSystemFontForMainControls` | Hidden rendering choice used by multiple list and window classes. It changes which font objects are applied to major controls. |
| `ReBarToolbar` | Hidden toolbar layout selector. It changes whether the app uses the rebar-style toolbar host instead of just recoloring an existing toolbar. |
| `ShowUpDownIconInTaskbar` | Hidden taskbar integration flag. It controls whether upload/download state feeds taskbar icon handling. |
| `ShowVerticalHourMarkers` | Hidden graph-rendering option. It affects how the statistics graph paints time markers. Current main writes it under `eMule` and falls back to the previous accidental `Statistics` key while loading. |
| `ForceSpeedsToKB` | Hidden formatting override. It changes unit-selection logic in the formatting helpers, not the underlying rate calculations. |
| `DateTimeFormat4Lists` | Hidden date formatting string used specifically by list controls, distinct from the main UI and log formats. |

### Broadband Branch Controls

| Setting | What it actually does |
| --- | --- |
| `MaxUploadClientsAllowed` | Sets the broadband branch's normal steady-state upload slot target. The queue/throttler logic tries to stabilize around this value instead of the old “many 25 KiB/s slots” model. |
| `SlowUploadThresholdFactor` | Controls how far below the calculated per-slot target a warmed-up upload slot can fall before it becomes a slow-slot recycle candidate. |
| `SlowUploadGraceSeconds` / `SlowUploadWarmupSeconds` / `ZeroUploadRateGraceSeconds` / `SlowUploadCooldownSeconds` | Control the slow-slot recycle timing windows and the score cooldown applied after recycle. |
| `LowRatioBoostEnabled` / `LowRatioThreshold` / `LowRatioScoreBonus` | Queue-score boost for under-seeded files. This affects who gets the next productive slot, not how many slots exist. |
| `LowIDScoreDivisor` | Queue-score divisor applied to actual LowID clients. This is deliberately harsh seeder policy: LowIDs are not banned, but they are deprioritized. |
| `SessionTransferLimitMode` / `SessionTransferLimitValue` | Controls when a productive upload slot should be rotated out based on delivered payload. Percent mode treats the value as a percent of the current upload file size; MiB mode treats it as an absolute MiB limit. |
| `SessionTimeLimitSeconds` | Time-based rotation limit for upload sessions. It complements transfer-based rotation so healthy slots can still rotate after long service times. |

### Hidden Maintenance / Legacy Behavior Knobs

| Setting | What it actually does |
| --- | --- |
| `KeepUnavailableFixedSharedDirs` | Hidden startup/shared-dir loading behavior. It decides whether fixed shared directories survive config load even when currently inaccessible. |
| `PartiallyPurgeOldKnownFiles` | Hidden known-file retention policy. It makes old known-file/AICH cleanup less aggressive, which can preserve more history at the cost of more stale entries. |
| `RearrangeKadSearchKeywords` | Hidden Kad search optimization. It changes the keyword order presented to Kad search logic, which can alter search matching behavior. |
| `RestoreLastMainWndDlg` / `RestoreLastLogPane` | Hidden session-restore flags for page/pane selection on startup. |

## Counters, Statistics, And State Stored In The Same INI

These are persisted, but they are not really "preferences". They are state, telemetry, or historical counters.

### Transfer Totals And Session Counters

| Key family | Explanation |
| --- | --- |
| `TotalDownloadedBytes`, `TotalUploadedBytes` | Cumulative transfer totals across sessions. |
| `DownSuccessfulSessions`, `DownFailedSessions`, `DownAvgTime`, `DownCompletedFiles`, `DownSessionCompletedFiles` | Download session counters and aggregates. |
| `UpSuccessfulSessions`, `UpFailedSessions`, `UpAvgTime` | Upload session counters and aggregates. |
| `LostFromCorruption`, `SavedFromCompression`, `PartsSavedByICH` | Recovery/integrity savings counters. |

### Protocol / Client-Family / Port-Family Data Totals

| Key family | Explanation |
| --- | --- |
| `DownData_*`, `UpData_*` | Data totals grouped by client family or source family. |
| `DownDataPort_*`, `UpDataPort_*` | Data totals grouped by port family. |
| `UpData_File`, `UpData_Partfile` | Upload totals grouped by file type/source of upload. |

### Overhead Counters

| Key family | Explanation |
| --- | --- |
| `DownOverhead*` | Download-side protocol overhead counters. |
| `UpOverhead*` | Upload-side protocol overhead counters. |

### Connection And Server Statistics

| Key family | Explanation |
| --- | --- |
| `Conn*` | Connection runtime totals, peak values, average rates, reconnect counts, and durations. |
| `SrvrsMost*` | High-water marks for server count, users online, and files available. |
| `SharedMostFilesShared`, `SharedLargest*` | High-water marks related to sharing size and file counts. |

### UI Layout And Window State

| Key family | Explanation |
| --- | --- |
| `SplitterbarPosition*` | Saved splitter positions for main panes. |
| `TransferWnd1`, `TransferWnd2` | Transfer window layout state. |
| `LastMainWndDlgID`, `LastLogPaneID` | Remembered last selected pages/panes. |
| `Toolbar*`, `Skin*` | Toolbar and skin configuration state. |
| `HyperTextFont`, `LogTextFont`, `Log*Color` | Saved fonts and colors. |
| `StatColor*`, `statsExpandedTreeItems`, `statsConnectionsGraphRatio`, `HasCustomTaskIconColor` | Statistics window presentation state. |

### Category Records

Categories are saved under their own numbered sections rather than as one flat preference block.

| Key | Explanation |
| --- | --- |
| `Count` in `General` | Number of user categories beyond the default one. |
| `Title`, `Incoming`, `Comment` | Category metadata. |
| `Color` | Category color. |
| `a4afPriority` | Category A4AF priority. |
| `AutoCat`, `Autocat`, `RegularExpression`, `AutoCatAsRegularExpression` | Auto-categorization rules. |
| `Filter`, `FilterNegator` | Category filter behavior. |
| `downloadInAlphabeticalOrder` | Per-category alphabetical ordering option. |
| `Care4All` | Category-wide "care for all" behavior flag. |

## TODO

The unresolved issues from [`AUDIT-DEFECTS.md`](AUDIT-DEFECTS.md) that matter
most for the preference system are:

| Item | Why it matters | Suggested follow-up |
| --- | --- | --- |
| WebServer exposure verification | `AllowedIPs` and `MaxFileUploadSizeMB` are now written back and exposed on the WebServer page. | Verify live WebServer allow-list and upload-limit behavior against running UI/REST scenarios. |
| Hidden runtime prefs listed above | They are now exposed in the Advanced tree and written back, but several remain niche or diagnostic. | Verify each edited setting in its affected subsystem before treating the UI as fully validated. |
| Documented-only active keys | Several low-level compatibility/security keys are intentionally not exposed. | Keep them documented and avoid adding UI without a specific operator workflow. |

## Practical Reading Guide

If you only care about real end-user settings, read:

1. `UI-Exposed Preferences`
2. `Broadband Branch Controls`
3. `UI Defaults Which Are Not First-Class CPreferences Keys`

If you are auditing weird legacy behavior, also read:

1. `Hidden Runtime Preferences`
2. `Hidden Or Legacy Keys Which Look Stale, Transitional, Or Import-Only`
3. `TODO`
