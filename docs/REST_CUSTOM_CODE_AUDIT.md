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
- Torznab API-key checks now reuse the same normalized Torznab query parser as
  request dispatch, so malformed or duplicate query parameters are classified
  as `400 Bad Request` before authentication instead of being hidden as an auth
  miss.
- qBittorrent compatibility filters now reuse the shared query parser for the
  optional `category` filter. Malformed or duplicate category query fields fail
  closed with `400 Bad Request` instead of widening to an unfiltered transfer
  list.
- qBittorrent compatibility request classification now mirrors native `/api/v1`
  routing: the dispatcher recognizes the raw `/api/v2` namespace first, then
  the compatibility handler runs strict shared path decoding and returns
  `400 Bad Request` for malformed path escapes.
- Torznab compatibility request classification now follows the same pattern:
  raw `/indexer/emulebb/api` malformed-path candidates are routed to the
  compatibility handler, which uses the shared REST path-escape validator
  before authentication and query parsing.
- qBittorrent session-cookie matching now parses exact semicolon-delimited
  cookie pairs instead of accepting a matching `SID=...` suffix attached to a
  different cookie name.
- qBittorrent compatibility login validation now lives in the qBit seam and
  requires the exact configured username plus API key. This keeps credential
  parsing local to the form decoder while avoiding another controller-only
  auth rule.
- Torznab bounded integers, Torznab category IDs, and qBittorrent magnet size
  fields now reuse `WebServerJsonSeams::TryParseUnsignedDecimalValue` instead
  of carrying compatibility-local `atoi`/`strtoul`/`strtoull` conversions.
  Overflow handling is therefore shared with native `/api/v1` REST validation.
- Native REST endpoint ports, path IDs, and bounded query integers now route
  through the same strict unsigned-decimal parser before applying route-specific
  bounds. This removes remaining route-local `strtoul`/`strtoull` conversions.
- HTTP `Content-Length` parsing now uses a shared WebSocket seam backed by the
  strict REST unsigned-decimal parser instead of `atol`, rejecting signed,
  partial, overflowed, and oversized request bodies before `/api/v1`, Torznab,
  or qBittorrent compatibility dispatch.
- REST hash validation remains local and domain-specific because the public API
  requires exactly 32 lowercase MD4 hex characters, not general binary or hash
  parsing.
- REST endpoint token parsing remains local for now because route tokens may be
  hostnames or addresses with ports. Windows IP parsers such as `InetPton` are
  useful only after the API deliberately narrows a route to numeric IP input.

## Resolved Cleanup

- ASCII trim/lower/decimal parsing now lives in shared REST parser primitives
  consumed by both native `/api/v1` routing and compatibility command helpers.
- Torznab media search parsing now reuses the native REST ASCII trim and
  whitespace-normalization helpers instead of carrying compatibility-local
  duplicates.
- Percent decoding now rejects malformed `%` escapes for REST path/query and
  qBittorrent form parsing. This remains local unless a pinned URL parser with
  exact RFC3986 component semantics is introduced.
