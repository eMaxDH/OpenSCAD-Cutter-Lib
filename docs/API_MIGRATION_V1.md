# API migration toward version 1.0

The project is in a pre-1.0 cleanup period. This document records intentional
breaking changes before the stable public API is declared.

## Planned naming corrections

| Historical name | Version 1.0 name |
| --- | --- |
| `visibile_layers` | `visible_layers` |
| `element_hight` | `element_height` |
| `cshape_array_arange_example` | `cshape_array_arrange_example` |

Migration should update library declarations, examples, projects, and API
documentation together. Temporary aliases may be provided when they do not
make named-argument behaviour ambiguous.

## Stable conventions being introduced

- every governed entry file has a standalone 2D/3D example;
- every manufactured part has a canonical `_2d` profile;
- `make_3d=false` means flat XY manufacturing geometry;
- operation names are `cut`, `engrave`, `score`, and `reference`;
- OpenSCAD 2021.01 is the compatibility baseline;
- SVG is the portable export source for LightBurn.

The final 1.0 release must remove this document's unresolved items from the
public API reference and record their final disposition in the changelog.
