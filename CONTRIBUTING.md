# Contributing

Thank you for improving OpenSCAD Cutter Lib. Start by reading
`docs/DESIGN_STANDARD.md` and use the closest template under `templates/`.

## Development baseline

- OpenSCAD 2021.01
- millimetres for documented dimensions
- SVG as the portable fabrication exchange format
- LightBurn as the primary downstream SVG workflow

Run the checks from the repository root:

```sh
tests/governance.sh
tests/render_examples.sh
tests/array_acceptance.sh
tests/lamp_acceptance.sh
tests/export_acceptance.sh
tests/bob_acceptance.sh
```

Generated test files are written below `${TMPDIR:-/tmp}` and must not be
committed.

## Adding a component

1. Copy `templates/component/` and select a unique family prefix.
2. Put authoritative cut geometry in a `_2d` module.
3. Build the 3D part by extruding that module.
4. Add the non-`_2d` entry file to `tests/public_files.txt`.
5. Document public modules and parameters in `docs/API.md`.
6. Test representative thickness, kerf, and clearance values.

Every governed entry file must open directly, show an `[Example]` section in
the Customizer, define `make_3d`, and render useful 2D and 3D defaults. Files
whose names end in `_2d.scad` are profile primitives and are exempt from that
entry-file interface.

## Pull-request checklist

- [ ] 3D manufactured parts use the canonical 2D profile.
- [ ] Cut, engrave, score, and reference geometry are classified correctly.
- [ ] Flat parts lie in the XY plane and do not overlap.
- [ ] New public files and declarations are documented.
- [ ] Parameters have assertions or documented valid ranges.
- [ ] OpenSCAD 2021.01 and all acceptance checks pass.
- [ ] An ADR is included when `GOVERNANCE.md` requires one.

Do not commit machine-specific LightBurn settings as universal defaults.
Calibration coupons and explicit material presets are preferred.
