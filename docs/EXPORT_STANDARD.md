# SVG and LightBurn export standard

SVG is the portable manufacturing exchange format. LightBurn is the primary
downstream workflow, but generated geometry must not depend on a LightBurn-only
source file.

## Operation colours

The composite representation uses:

| Operation | RGB | Hex |
| --- | --- | --- |
| Cut | 255, 0, 0 | `#ff0000` |
| Engrave | 0, 0, 255 | `#0000ff` |
| Score | 0, 128, 0 | `#008000` |
| Reference | 128, 128, 128 | `#808080` |

## Authoritative exports

Separate operation files are authoritative:

```text
<project>_<material>_cut.svg
<project>_<material>_engrave.svg
<project>_<material>_score.svg
```

A convenience composite file may also be generated:

```text
<project>_<material>_all.svg
```

OpenSCAD 2021.01 does not provide a reliable portable SVG layer contract.
Therefore operation selection is represented in the model and separate exports
remain normative. A tested deterministic postprocessor may assign composite
SVG colours/groups; colour in the OpenSCAD preview alone is not sufficient.

## File requirements

- SVGs use millimetre-scale geometry and a deterministic origin.
- Sheet boundaries and reference labels are excluded from machine operations.
- File names include material and operation.
- Export scripts fail on empty output.
- Generated machine settings are not treated as universal defaults.
