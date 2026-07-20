# Architecture

## Geometry flow

The repository follows one directional flow:

```text
parameters
    -> canonical 2D part profiles
        -> 3D extrusion and assembly transforms
        -> 2D material sheets and operation exports
```

Assembly geometry and cutter geometry must not be separately redrawn. Purchased
hardware and motion envelopes are preview geometry and do not enter fabrication
exports.

## Repository areas

- `cutter_lib/`: reusable component families and manufacturing helpers.
- `project/`: reference assemblies demonstrating library composition.
- `templates/`: governed starting points for new work.
- `tests/`: API inventory, static governance checks, and render acceptance.
- `docs/`: standards, API reference, walkthroughs, and design decisions.

## File roles

A governed entry file does three jobs: declares the public wrapper, exposes a
Customizer example, and renders when opened directly. A `_2d.scad` file holds a
profile primitive and is exempt from the entry-file UI. Files are imported with
`use`; executable examples therefore do not leak into consumers.

The authoritative list of governed entry files is `tests/public_files.txt`.

## Component families

Prefixes identify related declarations. New families must choose one clear,
documented prefix and avoid overloading an existing prefix with unrelated
meaning. Public modules use named arguments in examples.

## Project entry points

A complete assembly should separate configuration, part definitions, assembly
placement, and sheet layout where its complexity warrants it. Its primary entry
point resolves `make_3d` into an output mode and routes to assembly, layout,
single-part, calibration, exploded, or debug output.
