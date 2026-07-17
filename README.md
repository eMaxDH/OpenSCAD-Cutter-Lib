# OpenSCAD Cutter Lib

Parametric OpenSCAD helpers for designing assemblies that can be viewed in 3D
and laid out as 2D parts for cutting.

The library supplies layout and assembly logic for boxes, frames, arrays,
layered walls, repeated floors, connectors, struts, slots, and reference
surfaces. A complete four-level lamp in [`project/lamp`](project/lamp) shows
how the pieces fit together.

![Four-level lamp example](project/lamp/img/lamp.png)

## What the library does

The central idea is to define a part once and pass it to an arrangement module
as a child. The arrangement module then either:

- positions and rotates the parts into an assembled model when `make_3d=true`;
- places the same parts flat when `make_3d=false`.

This is useful for checking an assembly in OpenSCAD before exporting its
individual panels to SVG or DXF.

The repository currently provides:

| Area | Capabilities |
| --- | --- |
| Shapes | Six-face box layouts, four-part frames, repeated arrays, padding |
| Construction | Layer visibility, test surfaces, 45-degree connectors and struts |
| Towers | Layered walls, six-sided floors, vertically repeated floors |
| Marking | Repeated ruler ticks |
| Example project | A configurable, multi-level wooden lamp |

See the [API reference](docs/API.md) for module signatures, child ordering,
return values, and constraints.

## Requirements

- OpenSCAD
- Git, if cloning the repository

There are no external OpenSCAD library dependencies. A minimum OpenSCAD
version has not yet been established by automated testing.

## Getting started

Clone the project:

```sh
git clone https://github.com/eMaxDH/OpenSCAD-Cutter-Lib.git
cd OpenSCAD-Cutter-Lib
```

Open `project/lamp/lamp.scad` in OpenSCAD to inspect the example. Change
`make_3d` near the top of that file:

```scad
make_3d = true;  // assembled preview
// make_3d = false; // flat cutter layout
```

From a terminal, the equivalent exports are:

```sh
openscad -o lamp.stl -D 'make_3d=true' project/lamp/lamp.scad
openscad -o lamp.svg -D 'make_3d=false' project/lamp/lamp.scad
```

OpenSCAD's `-D` option overrides the values in the source file. Use a 3D
output format for assembled geometry and a 2D output format for flat geometry.

## Minimal example

The following model uses the same six panels for an assembled box and a flat
layout. Save it in the repository root so the import paths resolve:

```scad
use <cutter_lib/shapes/cshape_box.scad>

make_3d = true;

width = 80;
height = 50;
depth = 40;
thickness = 3;
spacing_2d = 2;

face_sizes =
    get_cshape_box_face_size_move(width, height, depth, thickness);

module panel(size, thickness, make_3d) {
    if (make_3d)
        cube([size[0], size[1], thickness]);
    else
        square(size);
}

cshape_box_arrange_move(
    width,
    height,
    depth,
    thickness=thickness,
    make_3d=make_3d,
    spacing_2d=spacing_2d
) {
    panel(face_sizes[0], thickness, make_3d); // top
    panel(face_sizes[1], thickness, make_3d); // back
    panel(face_sizes[2], thickness, make_3d); // left
    panel(face_sizes[3], thickness, make_3d); // bottom
    panel(face_sizes[4], thickness, make_3d); // right
    panel(face_sizes[5], thickness, make_3d); // front
}
```

Child order is part of the API. Box layouts always expect:

```text
0 top, 1 back, 2 left, 3 bottom, 4 right, 5 front
```

The layout modules transform their children but do not generate joinery,
kerf compensation, or tool paths automatically. Put those details into the
child panel geometry.

## Importing the library

Use OpenSCAD's `use` directive:

```scad
use <cutter_lib/shapes/cshape_frame.scad>
use <cutter_lib/strut/cs_strut_triangle_45.scad>
```

Do not use `include` for normal library consumption. Most source files contain
an executable demonstration at file scope; `use` imports only modules and
functions and prevents those demonstrations from appearing in your model.

Paths are resolved relative to the file containing the import. If the library
is installed in an OpenSCAD library directory, the shorter installed-library
path may be used instead.

## Core conventions

### Dimensions

Dimensions are unitless, as in all OpenSCAD models. Use one unit consistently;
the example project is designed as if values are millimetres.

`width` maps to X, `depth` to Y, and assembled `height` to Z. Flat layouts lie
in the XY plane.

### 2D and 3D modes

Most public modules accept `make_3d=false`. When it is false, children should
produce 2D geometry. When it is true, children should produce geometry whose
material thickness extends along local Z.

`spacing_2d` separates flat parts. It is layout spacing, not laser kerf.

### Layers

Layer-aware modules accept a layer number and a list named
`visibile_layers`. If the list is empty, all layers render. If it is non-empty,
listed layers render normally and other layers become OpenSCAD background
geometry (`%`).

The misspelling `visibile_layers` is part of the current API and must be used
exactly as written.

### Naming

Prefixes indicate the component family:

- `cshape_*`: shape and layout utilities
- `ct_tower_*`: tower, floor, and wall utilities
- `cs_*`: surfaces, struts, and slots
- `cc_*`: connectors
- `cl_*`: layer helpers
- `cm_*`: markers

The array API also uses the existing parameter name `element_hight`. Keep this
spelling in named arguments.

## Repository layout

```text
cutter_lib/
  connector/   45-degree male/female connector geometry
  layer/       layer visibility helpers
  marker/      ruler/tick markers
  shapes/      arrays, boxes, frames, and padding
  slot/        elongated 2D holes
  strut/       connector-ended struts with optional holes
  surfaces/    numbered diagnostic surfaces
  tower/       walls, floors, and vertical stacking
project/
  lamp/        complete example and exported images/models
docs/
  API.md       module and function reference
  LAMP.md      example-project walkthrough
```

## Example project

The lamp composes the library at three levels:

1. struts and repeated slats form a layered wall;
2. six wall positions form a floor;
3. four floors are stacked into the lamp.

Read the [lamp walkthrough](docs/LAMP.md) before modifying its dimensions or
exporting individual layers.

## Current limitations

- There is no automated test or continuous-integration setup.
- There is no tagged package or central include file; import the required
  `.scad` files directly.
- Some names contain historical spelling errors retained for compatibility.
- The array size helper has an unresolved branch when only
  `element_hight` is supplied; provide both element dimensions or neither.
- Cutter kerf, tolerances, nesting optimization, and material checks remain
  the caller's responsibility.
- The checked-in OpenSCAD parameter-set JSON files contain older parameter
  names. Treat the `.scad` defaults as authoritative.

## License

No license file is currently included. Until the repository owner adds one,
do not assume permission to copy, modify, or redistribute the project beyond
what applicable law permits.

