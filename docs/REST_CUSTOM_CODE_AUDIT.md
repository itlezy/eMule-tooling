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
- Native REST, qBittorrent compatibility, and Torznab compatibility now share
  the same exported `WebServerJson` CString/std::string conversion helpers for
  raw request bytes, UTF-8 JSON payload text, and API-key comparisons. This
  removed adapter-local copies of the same conversion code while preserving the
  compatibility-specific response formats.
- Torznab bounded integers, Torznab category IDs, and qBittorrent magnet size
  fields now reuse `WebServerJsonSeams::TryParseUnsignedDecimalValue` instead
  of carrying compatibility-local `atoi`/`strtoul`/`strtoull` conversions.
  Overflow handling is therefore shared with native `/api/v1` REST validation.
- Native REST endpoint ports, path IDs, and bounded query integers now route
  through the same strict unsigned-decimal parser before applying route-specific
  bounds. This removes remaining route-local `strtoul`/`strtoull` conversions.
- Native REST and qBittorrent compatibility JSON responses now share
  `WebServerJson::SerializeJsonUtf8`, which serializes through the pinned
  `nlohmann::json` dependency with the native REST replacement policy for
  invalid string data instead of carrying a qBit-local `dump()` wrapper.
- HTTP `Content-Length` parsing now uses a shared WebSocket seam backed by the
  strict REST unsigned-decimal parser instead of `atol`, rejecting signed,
  partial, overflowed, and oversized request bodies before `/api/v1`, Torznab,
  or qBittorrent compatibility dispatch.
- HTTP request-line parsing now lives in the same WebSocket seam and preserves
  exact method tokens instead of classifying by string prefix. Native `/api/v1`
  and qBittorrent compatibility already validate method tokens downstream;
  Torznab compatibility now rejects non-GET requests before search handling.
- qBittorrent compatibility route specs now use the exact HTTP method token and
  their declared auth requirement during dispatch, avoiding a second path-based
  auth allowlist.
- REST hash validation remains local and domain-specific because the public API
  requires exactly 32 lowercase MD4 hex characters, not general binary or hash
  parsing.
- REST endpoint token parsing remains local for now because route tokens may be
  hostnames or addresses with ports. Windows IP parsers such as `InetPton` are
  useful only after the API deliberately narrows a route to numeric IP input.

## Reviewed Helper Ledger

| Area | Helper or surface | Decision | Reason and evidence |
|------|-------------------|----------|---------------------|
| UTF-8 validation | `WebServerJsonSeams::TryNormalizeSearchText`, `StringConversion.cpp::utf8towc`, `GeoLocation.cpp` MMDB text conversion | Replaced | Strict UTF-8 validation now uses Windows `MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, ...)`; malformed text is rejected or ignored at the owning boundary instead of guessed by a custom scanner. |
| URL encoding | `WebServerJsonSeams::UrlEncodeUtf8` | Kept with reason | Compatibility links need RFC3986 component escaping for already-validated UTF-8 bytes. Windows whole-URL canonicalizers would also normalize URL shape, which is not the contract. Covered by native seam tests for spaces, plus signs, percent signs, and Torznab magnet display names. |
| URL decoding | `WebServerJsonSeams::TryUrlDecodeUtf8` | Kept with reason | REST route segments, query fields, Torznab parameters, qBit form fields, and nested magnet query strings share one strict percent decoder. It rejects malformed escapes before dispatch; Windows browser-style URL helpers are not a safe component-level replacement. |
| Query parsing | `WebServerJsonSeams::TryParseQueryString` and `TryParseUrlEncodedFields` | Kept with reason | Native REST and Torznab use one duplicate-rejecting decoded-field parser. Tests cover malformed escapes, duplicate query parameters, native query strings, Torznab query strings, and nested qBit magnet query strings. |
| qBit form parsing | `WebServerQBitCompatSeams::TryParseFormBody` | Kept with reason | qBittorrent compatibility needs `application/x-www-form-urlencoded` decoding with unique decoded field names and adapter-specific error text. The implementation delegates to the shared REST URL-encoded field parser; tests cover duplicate fields, empty names, malformed escapes, and required field checks. |
| XML escaping | `WebServerArrCompatSeams::XmlEscape` | Kept with reason | No pinned XML writer is currently part of the lightweight Torznab feed path. The helper is intentionally narrow, has a Doxygen comment, and seam tests cover element and attribute metacharacters used by feed result titles, descriptions, links, GUIDs, and Torznab attributes. |
| Numeric parsing | `WebServerJsonSeams::TryParseUnsignedDecimalValue` consumers | Replaced/shared | Adapter-local `atoi`/`strtoul`/`strtoull` paths were removed. Native route bounds, Torznab season/episode/year/category values, qBit magnet sizes, and HTTP `Content-Length` now share strict unsigned decimal parsing and overflow rejection. |
| Path canonicalization | Shared-directory REST, shared-file REST, static-file path seams, and category incoming paths | Replaced/shared | REST path entry points now route through `PathHelpers::CanonicalizePath`, `ParsePathRoot`, or `CanonicalizePathForComparison` before ownership checks and output echoing. Live evidence covers over-`MAX_PATH` Unicode roots, traversal rejection, missing-parent roots, category incoming-path echo, and shared-file long-path reload/list behavior. |
| REST/adapter file operations | Native REST shared-file and transfer delete commands plus Arr/qBit adapters | Replaced/shared | Source audit found no raw `CFile`, CRT stream, `CreateFile`, `FindFirstFile`, or attribute probes in the REST/adapter files. The only REST-side file deletion path is `ShellDeleteFile`, which delegates existence and direct deletion to `LongPathSeams`; native seam tests cover deep Unicode delete routing with and without recycle-bin mode. |
| Hash validation | REST and qBit eD2K hash selectors | Kept with reason | The API contract is domain-specific: exactly 32 lowercase MD4 hex characters for native selectors, with qBit compatibility normalizing accepted mutation hashes before native dispatch. General Windows or crypto parsers do not own this textual contract. |
| JSON construction | Native `/api/v1` and qBittorrent compatibility response assembly | Replaced/shared | Native REST and qBittorrent compatibility now share `WebServerJson::SerializeJsonUtf8`, backed by pinned `nlohmann::json` and the native REST invalid-string replacement policy. Native `/api/v1` success/error envelopes remain centralized in `BuildSuccessEnvelope` and `BuildErrorEnvelope`; qBit compatibility keeps its adapter-specific response shapes while reusing the serializer. |
| File I/O | REST-adjacent path and shared-file operations | Deferred | Recent REST path work moved ownership and canonicalization checks to `PathHelpers`, but a raw file-call audit is still open for code that touches file contents or filesystem state below the REST controller boundary. |
| Concurrency and lifetime | REST command dispatch, WebServer request parsing, session/auth state | Deferred | Stress evidence covers current behavior under mixed native REST, adapters, malformed traffic, and legacy HTML GETs. A source audit of synchronization ownership is still required before marking this fully reviewed. |

## Resolved Cleanup

- ASCII trim/lower/decimal parsing now lives in shared REST parser primitives
  consumed by both native `/api/v1` routing and compatibility command helpers.
- Torznab media search parsing now reuses the native REST ASCII trim and
  whitespace-normalization helpers instead of carrying compatibility-local
  duplicates.
- Percent decoding now rejects malformed `%` escapes for REST path/query and
  qBittorrent form parsing. This remains local unless a pinned URL parser with
  exact RFC3986 component semantics is introduced.
