---
id: FEAT-020
title: GeoLite2 IP geolocation — country flag and city display per peer
status: Open
priority: Trivial
category: feature
labels: [ui, geolocation, geoip, network, peer-info]
milestone: ~
created: 2026-04-10
source: eMuleAI (GeoLite2.cpp/h, GeoLite2PP.cpp/hpp, CGeoLite2 class, 2026)
---

## Summary

eMuleAI integrates MaxMind's **GeoLite2** free geolocation database to display a country
flag icon and optional country/city label next to each peer in the client list, server list,
and search results. This is a common feature in many eMule mods.

## eMuleAI Reference Implementation

**Source files:**
- `eMuleAI/GeoLite2.cpp` / `GeoLite2.h` — `CGeoLite2` class: database loading, IP lookup,
  flag index resolution
- `eMuleAI/GeoLite2PP.cpp` / `GeoLite2PP.hpp` — `GeoLite2PP` C++ wrapper around MaxMind's
  MMDB reader library
- `eMuleAI/GeoLite2PP_error_category.cpp` / `GeoLite2PP_error_category.hpp` — error handling
- `eMuleAI/GeoLiteDownloadDlg.cpp` / `GeoLiteDownloadDlg.h` — dialog for downloading the
  GeoLite2 database
- `eMuleAI/Address.cpp` / `Address.h` — `CAddress` class: abstraction for IPv4/IPv6 + MAC
  addresses used by geolocation and other features

**Display modes:**
```cpp
enum GeoLite2Mode {
    GL2_DISABLE = 0,
    GL2_COUNTRYCODE,   // e.g., "DE"
    GL2_COUNTRY,       // e.g., "Germany"
    GL2_COUNTRYCITY    // e.g., "Germany / Frankfurt"
};
```

**Flag system:** 254 country code → resource ID mappings (`CountryCodeFlag_Struct`,
`CountryCodeFlagArraySize = 254`). Flags are 20×14 pixel bitmaps embedded in the resource.

**Data structure:**
```cpp
struct GeolocationData_Struct {
    CString Country;
    CString CountryCode;
    CString City;
    WORD    FlagIndex;
};
typedef CTypedPtrArray<CPtrArray, GeolocationData_Struct*> CGeoLite2Array;
```

## Database

GeoLite2 Country / City databases are free from MaxMind with registration. They are in
MaxMind's MMDB binary format. Updates monthly. eMuleAI includes a download dialog
(`GeoLiteDownloadDlg`) to fetch the database at runtime.

The MMDB reader library (`libmaxminddb` or the `GeoLite2PP` wrapper) must be linked.
GeoLite2PP is a header-only C++ wrapper around the C library.

## Implementation Considerations

1. **CAddress class**: eMuleAI uses a `CAddress` abstraction (`eMuleAI/Address.cpp`)
   throughout its code for IP addresses. Our codebase uses `uint32` for IPv4. Consider
   whether to adopt `CAddress` or adapt the lookup to work with `uint32`.

2. **Privacy**: Displaying peer geolocation is purely local (no external call per peer lookup);
   only the GeoLite2 database download touches the network.

3. **License**: GeoLite2 requires attribution and a MaxMind account. Database cannot be
   bundled in the binary; must be downloaded separately.

4. **Column injection**: Each list view (client list, sources list, server list) needs a
   new "Flag" column or inline rendering in the IP column. This affects `CMuleListCtrl`
   subclasses.

## Priority Note

This is **Trivial** — it is purely informational UI and has no effect on protocol behavior.
It is a popular mod feature but not a correctness or performance improvement. Defer until
after higher-priority UI work (FEAT-017 DPI, FEAT-019 dark mode).

## Acceptance Criteria

- [ ] GeoLite2 MMDB reader linked (GeoLite2PP or libmaxminddb)
- [ ] `CGeoLite2::Lookup(uint32 ip)` returns country code + flag index
- [ ] Client list "Country" column or flag icon in IP column
- [ ] GeoLite2 database path configurable in Preferences → Directories
- [ ] Database absence is silent (feature degrades gracefully to no flag)
- [ ] Preferences toggle: off / country code / country / country+city
