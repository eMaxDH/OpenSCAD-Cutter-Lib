# Manufacturing standard

## Measurement model

Dimensions are expressed in millimetres. `kerf` is the complete measured width
removed by the beam. Internal and external compensation must use the shared
helpers in `cutter_lib/materials/cm_manufacturing.scad` rather than local sign
conventions.

Positive `fit_clearance` creates a looser joint. Material thickness, kerf, and
clearance are independent parameters and should be calibrated on the intended
machine and stock.

## Materials

Each manufactured part declares a stable ID, material class, nominal thickness,
and quantity. Different thicknesses require distinct sheets even when the base
material is the same. Veneer and bendable stock must also declare or document a
minimum bend radius.

## Operations

The standard operations are `cut`, `engrave`, `score`, and `reference`.
Reference geometry is never sent to the machine. Purchased hardware and motion
envelopes are references.

## Layout requirements

- Flat geometry lies in XY.
- Sheet size, margin, and part spacing are explicit.
- Part IDs remain visible in preview but are only engraved when requested.
- Declared bounds are validated for containment and pairwise overlap.
- Separate material thicknesses and operation exports are deterministic.

## Calibration

Projects with fitted connections should provide a coupon covering relevant slot,
tab, pin, and kerf values. Defaults are examples, not promises of fit or safety.
