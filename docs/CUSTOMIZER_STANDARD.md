# OpenSCAD Customizer standard

Governed entry files expose a predictable UI in this order:

```scad
/* [Output] */
make_3d = true; // [false:true]
output_mode = "automatic";

/* [Dimensions] */

/* [Material] */
material_thickness = 3; // [0.1:0.1:20]
kerf = 0.15;            // [0:0.01:1]
fit_clearance = 0.1;    // [-0.5:0.05:1]

/* [Connections] */

/* [2D Layout] */
spacing_2d = 3;         // [0:0.5:20]

/* [Appearance] */

/* [Example] */

/* [Hidden] */
```

Only applicable sections need to be visible, but `Output` and `Example` are
required. Project entry points may add part selection and material-sheet
sections.

## Shared controls

- `make_3d`: direct 2D/3D switch in every governed file.
- `output_mode`: richer project routing; `automatic` resolves from `make_3d`.
- `spacing_2d`: display/layout spacing, never laser kerf.
- `kerf`: full measured cut width.
- `fit_clearance`: positive values loosen a joint.

Command-line `-D` overrides must remain effective. Do not reassign a public
Customizer variable after its declaration, and do not let a saved preset
silently replace a live override.

Use `[Hidden]` for derived values and example dispatch. Avoid presenting
parameters that do not affect the selected component.
