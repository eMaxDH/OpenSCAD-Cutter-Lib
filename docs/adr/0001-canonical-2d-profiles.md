# ADR 0001: Canonical 2D manufacturing profiles

- Status: accepted
- Date: 2026-07-21

## Context

Separately drawn 2D layouts and 3D previews drift, causing slots, tabs, and
outlines shown in the assembly to differ from laser-cut parts.

## Decision

Every manufactured rigid part has one authoritative 2D module. The 3D part is
created by extruding and transforming that profile. Layouts place the same
profile. Preview-only hardware is explicitly excluded from manufacturing.

## Consequences

Part implementations may require refactoring, but assembly and cutter output
remain mechanically synchronized and can share parameter tests.
