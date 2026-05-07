# Backlog Dependency Graph

This graph captures useful implementation ordering hints. It is not a release
gate; Release 1 status is controlled by
[RELEASE-1.0](../../docs-clean/RELEASE-1.0.md).

## Build And Tooling

```text
CI-001 (CMake)
  -> CI-002 (clang-format)
  -> CI-003 (MSVC hardening)
       -> CI-006 (ASan)
            -> CI-007 (Kad fuzz tests)
  -> CI-004 (clang-tidy)
  -> CI-005 (cppcheck)
```

## Refactor Sequences

```text
REF-002 -> REF-005
REF-017 -> REF-018
REF-021 -> REF-023
REF-025 -> REF-003 and REF-027
REF-026 pairs with FEAT-017
REF-035 -> REF-036 -> CI-008 coverage
```

## Network And Controller Work

```text
REF-029 -> REF-030
FEAT-018 coordinates with REF-029 and FEAT-036
FEAT-032 -> FEAT-036
FEAT-035 coordinates with FEAT-036
FEAT-013 -> FEAT-014 and FEAT-040
FEAT-013 -> BUG-069, BUG-073, BUG-075, BUG-076, BUG-077
BUG-075/BUG-076 -> CI-014/CI-015
CI-011 -> CI-012, CI-013, CI-014, CI-015, CI-016
CI-011 -> AMUT-001 and ARR-001
FEAT-045 -> AMUT-002
```

## Product Feature Ordering

```text
FEAT-015 -> FEAT-016 and FEAT-023
FEAT-015/FEAT-023 -> FEAT-037
FEAT-024 -> CI-009
FEAT-026 -> FEAT-027 -> FEAT-028 -> FEAT-034
FEAT-038 is complete and separate from FEAT-034
FEAT-042 -> FEAT-044
```

If this graph conflicts with an item doc or the workspace policy, prefer the
item doc for local implementation state and the policy for workflow rules.
