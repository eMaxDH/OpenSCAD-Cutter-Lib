# Design standard

## Canonical profile rule

Every laser-cut part has exactly one authoritative 2D manufacturing module.
The normal form is:

```scad
module example_part_2d(size=[40, 20], ...) {
    difference() {
        square(size);
        // holes, slots, and other manufactured features
    }
}

module example_part(size=[40, 20], thickness=3, make_3d=false, ...) {
    if (make_3d)
        linear_extrude(height=thickness)
            example_part_2d(size=size, ...);
    else
        example_part_2d(size=size, ...);
}
```

The 3D branch may transform the profile before extrusion when material
orientation requires it. It may not substitute a simplified solid.

## Coordinates and dimensions

- Documented dimensions are millimetres.
- Width is X, depth is Y, and assembled height is Z.
- Flat manufacturing profiles lie in the XY plane at Z=0.
- Material thickness extends along the part's local positive Z before assembly
  transforms.
- A part profile should use a stable, documented origin suitable for layout.

## Assembly and layout

- Assemblies position, rotate, mirror, and colour canonical parts.
- Layouts use those same profiles and stable part IDs.
- Declared bounds must contain the real geometry.
- Parts must remain inside sheet margins and may not overlap at the configured
  spacing.
- Quantity belongs to the part manifest/layout, not an undocumented visual copy.

## Manufacturing and preview geometry

Manufactured geometry includes outside contours, holes, slots, engraving, and
scores. Purchased pins, fasteners, electronics, motion sweeps, clearances, and
sheet boundaries are preview/reference geometry and must not contaminate cut
exports.

## Parameters and validation

Public parameters require meaningful names, units, defaults, and valid ranges.
Use assertions for impossible geometry and warnings for values that are valid
but outside tested fabrication ranges. Positive fit clearance always means a
looser finished fit.

## Standalone contract

Every file in `tests/public_files.txt` must:

- define `make_3d = true; // [false:true]` or an equivalent boolean default;
- contain a literal `/* [Example] */` Customizer section;
- render non-empty default 2D and 3D output;
- be safe to import with `use`; and
- remain compatible with OpenSCAD 2021.01.

Files ending in `_2d.scad` are exempt, but their public modules must be exercised
by a governed wrapper or acceptance fixture.
