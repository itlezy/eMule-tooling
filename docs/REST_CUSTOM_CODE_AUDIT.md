# REST Custom Code Audit

This note tracks REST and compatibility-bridge helper code that was reviewed
against the workspace rule to prefer existing project, platform, standard
library, or pinned dependency APIs before writing custom logic.

## Current Findings

- `WebServerJsonSeams::TryNormalizeSearchText` now uses the Windows
  `MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, ...)` decoder for strict
  UTF-8 validation. This replaced a draft custom UTF-8 scanner before commit.
- `Ini2Helpers.h` already uses the same strict Windows decoder for UTF-8 INI
  text, so REST search validation is aligned with existing workspace encoding
  practice.
- `StringConversion.cpp::utf8towc` now delegates to the Windows
  `MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, ...)` decoder instead of
  carrying a hand-written UTF-8 scanner. Existing `ByteStreamToWideChar`
  fallback behavior remains responsible for non-UTF-8 legacy byte streams.
- `GeoLocation.cpp` now uses the same strict Windows UTF-8 decoder for MMDB
  country and city strings; malformed payload text is ignored instead of
  guessed through an ANSI fallback.
- `WebServerJsonSeams::UrlEncodeUtf8`, `UrlDecodeUtf8`,
  `TryParseQueryString`, and `WebServerQBitCompatSeams::TryParseFormBody`
  remain local helpers intentionally. Windows URL canonicalization helpers such
  as `InternetCanonicalizeUrl` operate on whole URLs and browser-style
  canonicalization rules, which are not a safe replacement for strict REST path
  segments, Torznab query parameters, and nested qBittorrent form values.
- REST hash validation remains local and domain-specific because the public API
  requires exactly 32 lowercase MD4 hex characters, not general binary or hash
  parsing.
- REST endpoint token parsing remains local for now because route tokens may be
  hostnames or addresses with ports. Windows IP parsers such as `InetPton` are
  useful only after the API deliberately narrows a route to numeric IP input.

## Resolved Cleanup

- ASCII trim/lower/decimal parsing now lives in shared REST parser primitives
  consumed by both native `/api/v1` routing and compatibility command helpers.
- Percent decoding now rejects malformed `%` escapes for REST path/query and
  qBittorrent form parsing. This remains local unless a pinned URL parser with
  exact RFC3986 component semantics is introduced.
