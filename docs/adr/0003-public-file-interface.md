# ADR 0003: Public file interface

- Status: accepted
- Date: 2026-07-21

## Context

Library files currently vary in whether opening them shows parameters or useful
geometry.

## Decision

Every declared entry file not ending in `_2d.scad` exposes `make_3d`, an
`[Example]` Customizer section, and non-empty standalone 2D and 3D examples.
`_2d.scad` profile primitives are exempt and are exercised through wrappers or
tests. The inventory is stored in `tests/public_files.txt`.

## Consequences

Users can learn components by opening any entry file, while low-level profile
files remain compact and composable.
