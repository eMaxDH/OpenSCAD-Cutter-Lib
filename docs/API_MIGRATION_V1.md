# API migration toward version 1.0

The project is in a pre-1.0 cleanup period. This document records intentional
breaking changes made before the stable public API is declared.

## Completed naming corrections

| Historical name | Version 1.0 name |
| --- | --- |
| `visibile_layers` | `visible_layers` |
| `element_hight` | `element_height` |
| `cshape_array_arange_example` | `cshape_array_arrange_example` |

The repository source, reference projects, templates, and documentation now use
the version 1.0 names. No compatibility aliases are provided: callers using
named arguments must update them. The `element_height`-only sizing branch was
also repaired as part of this change.

## Stable conventions being introduced

- every governed entry file has a standalone 2D/3D example;
- every manufactured part has a canonical `_2d` profile;
- `make_3d=false` means flat XY manufacturing geometry;
- operation names are `cut`, `engrave`, `score`, and `reference`;
- OpenSCAD 2021.01 is the compatibility baseline;
- SVG is the portable export source for LightBurn.

The final 1.0 release should retain this file as the migration record and verify
that no historical spelling remains outside the changelog and this table.
