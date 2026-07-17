# API reference

This reference describes the reusable declarations under `cutter_lib/`.
Demonstration modules and file-scope examples are omitted unless they are
useful as entry points.

All defaults shown here come from the current source. Import files with `use`,
not `include`.

## Manufacturing and fabrication

The miniature-appliance helpers are grouped by reusable mechanism:

| Import | Purpose |
| --- | --- |
| `materials/cm_manufacturing.scad` | Kerf-aware slot, tab, and hole dimensions |
| `joints/cj_hidden_tabs.scad` | Repeated hidden tabs and matching slots |
| `hinges/ch_pin_hinge.scad` | Pin cheeks, pins, rotation, and motion sweeps |
| `shells/csh_ribbed_veneer.scad` | Rounded ribs and flattenable veneer wraps |
| `trays/ctr_removable_tray.scad` | Tray, grip, dish slots, and runners |
| `layout/cl_cut_layout.scad` | Sheets, placement, and overlap checks |
| `calibration/ccal_laser_coupon.scad` | Slot-fit, kerf, and pin-hole coupon |
| `validation/cv_validation.scad` | Shared assertions and warnings |

### Compensation

```scad
cut_compensation(kerf);
slot_width(material_thickness, fit_clearance=0, kerf=0);
tab_width(material_thickness, fit_clearance=0, kerf=0);
compensated_dimension(target, kerf=0, internal=false);
effective_pin_hole_diameter(pin_diameter, pin_clearance=0, kerf=0);
```

These return drawn dimensions for a centre-line laser path. Internal features
subtract one full kerf; external features add one full kerf. Verify that
convention against the export/CAM workflow using the coupon.

### Hidden joints

```scad
cj_edge_pattern(edge_length, count=3, edge_margin=4) children();
cj_hidden_tabs_2d(
    edge_length, tab_depth, feature_width,
    count=3, edge_margin=4, fit_clearance=0, kerf=0
);
cj_hidden_slots_2d(
    edge_length, material_thickness, feature_width,
    count=3, edge_margin=4, fit_clearance=0, kerf=0
);
cj_hidden_tabbed_panel_2d(
    size, edge="bottom", tab_depth=4, feature_width=8,
    count=3, edge_margin=4, fit_clearance=0, kerf=0
);
```

The modules assert that margins, pitch, and feature widths are feasible.
Slots are intended for `difference()` operations.

### Pin hinges

```scad
ch_rotate_about_axis(
    axis_origin=[0,0,0], angle=0, axis=[1,0,0]
) children();
ch_pin_hinge_cheek_2d(
    width, height, pin_diameter,
    pin_clearance=0, kerf=0,
    hole_center=undef, edge_min=1
);
ch_hinge_pin_preview(length, diameter, axis_origin=[0,0,0]);
ch_motion_sweep(
    angle_start=0, angle_end=90, samples=7,
    axis_origin=[0,0,0], axis=[1,0,0]
) children();
```

Cheek validation rejects pin holes that violate the minimum edge distance.
The motion sweep is preview-only background geometry.

### Ribbed veneer shells

```scad
csh_wrap_length(width, height, corner_radius);
csh_rounded_rect_2d(size, radius);
shell_rib(width, height, rib_width=4, corner_radius=6) children();
veneer_registration_slot(size=[8,4]);
veneer_skin_layout(
    width, height, depth, corner_radius=6,
    front_termination_offset=4, rear_termination_offset=4,
    min_bend_radius=5
);
ribbed_veneer_shell(
    width, height, depth,
    rib_count=4, rib_thickness=4, rib_width=4,
    veneer_thickness=0.6, corner_radius=6,
    front_termination_offset=4, rear_termination_offset=4,
    show_ribs=true, show_skin=true, min_bend_radius=5
);
```

The shell is a constant rounded cross-section extruded along depth. Its veneer
development bends in one direction and is not a compound-surface flattening.

### Removable trays

```scad
finger_grip_2d(width=16, depth=5);
dish_slot_pattern_2d(
    area=[30,30], slot_width=2,
    slot_length=20, count=4, margin=3
);
removable_tray_2d(...);
removable_tray(..., make_3d=false);
tray_runner(length, width=4, height=4, stop_height=0, make_3d=true);
```

The tray uses broad cut slots and a grip opening rather than fragile tines.

### Sheet layouts

```scad
cl_boxes_overlap(a, b, spacing=0);
cl_validate_layout(
    boxes, sheet_size=[300,300],
    margin=5, spacing=3, name="sheet"
);
cl_sheet_boundary(sheet_size=[300,300], label="", line_width=0.3);
cl_layout_part(
    position, size, id="", quantity=1,
    sheet_size=[300,300], margin=5, label_size=2
) children();
cl_cut_geometry() children();
cl_engrave_geometry() children();
cl_reference_geometry() children();
cl_operation_geometry(kind="cut", output="preview") children();
```

Parts use explicit placement because OpenSCAD cannot reliably query arbitrary
child bounds. `cl_validate_layout` asserts sheet containment and pairwise
non-overlap using declared bounding boxes. `cl_operation_geometry` provides
explicit cut/engrave selection because SVG export does not reliably preserve
OpenSCAD preview colours.

### Calibration

```scad
ccal_laser_coupon(
    material_thickness=4, kerf=0.5, pin_diameter=2,
    clearances=[-0.2,-0.1,0,0.1,0.2,0.3],
    size=[85,42], label_size=2
);
```

Cut the coupon with the intended material and process before selecting fit and
pin clearances.

## Shared conventions

- `make_3d=false` selects flat XY output; `true` selects assembled or extruded
  output.
- `spacing_2d=1` controls separation between parts in a flat layout.
- Dimensions are unitless.
- Child order is positional and significant.
- `visibile_layers` and `element_hight` are intentional documentation
  spellings because they match the current source API.

## Shapes

### Box

Import:

```scad
use <cutter_lib/shapes/cshape_box.scad>
```

Primary modules:

```scad
cshape_box_arrange_fold(
    width, height, depth,
    thickness=0, make_3d=false, spacing_2d=1
) { /* six children */ }

cshape_box_arrange_move(
    width, height, depth,
    thickness=0, make_3d=false, spacing_2d=1
) { /* six children */ }
```

Both modules expect the same child order:

| Index | Face |
| ---: | --- |
| 0 | Top |
| 1 | Back |
| 2 | Left |
| 3 | Bottom |
| 4 | Right |
| 5 | Front |

`fold` creates a traditional cross-shaped net. `move` uses an alternative
orientation whose left and right child geometry is defined as
`[depth, height]`; this is the arrangement used by the tower modules.

Sizing functions:

```scad
get_cshape_box_face_size_fold(width, height, depth, thickness)
get_cshape_box_face_size_move(width, height, depth, thickness)
```

Each returns six `[x, y]` pairs in child order. Thickness is subtracted from
the top, bottom, left, and right panels so they fit between the full-size
front and back panels.

```scad
get_cshape_box_2d_size_fold(
    width, height, depth, thickness=0, spacing_2d=1
)

get_cshape_box_2d_size_move(
    width, height, depth, thickness=0, spacing_2d=1
)
```

These return the `[width, height]` footprint of the corresponding flat
arrangement.

The file also exposes one lower-level `cshape_box_arrange_*_frame_fold` and
`cshape_box_arrange_*_frame_move` module for each face. Use those only when a
single face transform is needed.

Constraints:

- `width > 2 * thickness`
- `depth > 2 * thickness`
- child panels must use the dimensions returned by the matching size function
- use matching `fold` sizing and arrangement functions, or matching `move`
  functions

### Frame

Import:

```scad
use <cutter_lib/shapes/cshape_frame.scad>
```

```scad
cshape_frame_arrange(
    width, height, frame_width,
    thickness,
    overlap=false,
    make_3d=false,
    spacing_2d=1
) { /* four children */ }
```

Child order:

| Index | Strut |
| ---: | --- |
| 0 | Top |
| 1 | Left |
| 2 | Right |
| 3 | Bottom |

Use the sizing function before creating the children:

```scad
get_cshape_frame_strut_size(width, height, frame_width, overlap=false)
```

It returns four `[length, width]` pairs. With `overlap=false`, side struts are
shortened by `2 * frame_width` and fit between the top and bottom. With
`overlap=true`, side struts retain the full height.

### Array

Import:

```scad
use <cutter_lib/shapes/cshape_array.scad>
```

```scad
cshape_array_arrange(
    width, height,
    no_elements_x=0,
    element_width=0,
    element_hight=0,
    element_padding=0,
    array_plane="xy",
    make_3d=false,
    spacing_2d=1
) { /* one child per cell */ }
```

Arranges each supplied child once, in row-major order. `no_elements_x=0`
chooses an approximately square grid. In assembled mode, `array_plane` may be
`"xy"`, `"xz"`, or `"yz"`.

```scad
cshape_array_repeat(
    width, height, repeat,
    element_width=0,
    element_hight=0,
    no_elements_x=0,
    element_padding=0,
    array_plane="xy",
    make_3d=false,
    spacing_2d=1
) { /* one repeated child */ }
```

Repeats the same child `repeat` times.

Sizing functions:

```scad
get_cshape_no_elements(width, height, no_elements, no_elements_x)
```

Returns `[columns, rows]`. The `width` and `height` arguments are currently
accepted but do not affect the result.

```scad
get_cshape_array_element_size(
    width, height, no_elements_sum, no_elements_x,
    element_padding=0,
    element_width=0,
    element_hight=0
)
```

Returns `[element_width, element_height]`. If both dimensions are zero, the
available area determines the result. If both are supplied, padding is
subtracted from each.

```scad
get_cshape_array_dx(width, no_elements_x, element_size)
```

Returns the distance from one element origin to the next. When a non-zero
element size is supplied, at least two elements are required.

Known constraint: the helper's branch for supplying only `element_hight`
references misspelled internal variables. Supply both explicit dimensions or
leave both at zero.

### Padding

Import:

```scad
use <cutter_lib/shapes/cshape_padding.scad>
```

```scad
cshape_padding(padding, new_size=undef, show_placeholder=false)
    children();
```

Moves child geometry inward by the requested padding. Accepted forms are:

| Value | Applied axes |
| --- | --- |
| `p` | X |
| `[px]` | X |
| `[px, py]` | X and Y |
| `[px, py, pz]` | X, Y, and Z |

`show_placeholder=true` displays the padded region as OpenSCAD background
geometry when `new_size` is supplied.

```scad
get_cshape_padding_new_object_size(size, padding)
```

Returns the child size remaining after padding both sides of each selected
axis. For example:

```scad
get_cshape_padding_new_object_size([100, 60, 4], [5, 3]);
// [90, 54, 4]
```

Padding must not reduce any dimension to zero or below.

## Layer helpers

Import:

```scad
use <cutter_lib/layer/cl_layer.scad>
```

```scad
apply_cl_layer_visibility(layer=0, visibile_layers=[])
    children();
```

With an empty list, children render normally. With a non-empty list, children
whose `layer` is present render normally; all others are marked as background
geometry with `%`. This is a preview control, not a boolean geometry filter.

```scad
cl_layer_info(visibile_layers=[], name="obeject", size=10);
```

Displays preview-only text listing the rendered layers. The `name` parameter
is currently unused.

## Diagnostic surfaces

Imports:

```scad
use <cutter_lib/surfaces/cs_test_surface.scad>
use <cutter_lib/surfaces/cs_test_surface_2d.scad>
```

```scad
cs_test_surface(
    width, height,
    thickness=1,
    number=0,
    face_color="",
    layer=0,
    visibile_layers=[],
    make_3d=false
);
```

Creates a numbered panel for verifying face order and orientation. In 3D,
the top label is red and the bottom label is green.

```scad
cs_test_surface_2d(width, height, number=0, face_color="");
cs_test_surface_2d_top(width=15, height=10, number=0);
cs_test_surface_2d_middle(width=15, height=10, number=0);
cs_test_surface_2d_bottom(width=15, height=10, number=0);
cs_testface_get_color(number);
get_cs_test_surface_2d_text_size(width, height);
```

These are intended for development and orientation checks rather than final
cutter output.

## Connectors, struts, and slots

### 45-degree connector

Imports:

```scad
use <cutter_lib/connector/cc_connector_triangle_45_2d.scad>
use <cutter_lib/connector/cc_connector_triangle_45.scad>
```

```scad
cc_connector_triangle_45_2d(size, type="f", connector_factor=0.3);

cc_connector_triangle_45(
    size,
    type="f",
    connector_factor=0.3,
    thickness=1,
    layer=0,
    visibile_layers=[],
    make_3d=false
);
```

`type` is `"f"` for the recessed profile or `"m"` for the projecting profile.
`connector_factor` sets the connector segment as a fraction of the 45-degree
diagonal. Use the same size and factor for a matching pair.

```scad
cc_connector_triangle_45_2d_shift(size, connector_factor=0.4)
```

Returns the XY shift used to centre the connector on the diagonal.

### Connector-ended strut

Imports:

```scad
use <cutter_lib/strut/cs_strut_triangle_45_2d.scad>
use <cutter_lib/strut/cs_strut_triangle_45.scad>
```

```scad
cs_strut_triangle_45_2d(
    width, height,
    type=["f", "f"],
    hole_radius=2,
    hole_distance=10,
    hole_length=0
);

cs_strut_triangle_45(
    width, height,
    thickness=10,
    type=["f", "f"],
    hole_radius=2,
    hole_distance=10,
    hole_length=0,
    layer=0,
    visibile_layers=[],
    make_3d=false
);
```

`type` selects the left and right connector profiles. Two holes are centred
around the strut midpoint and separated by `hole_distance`. A
`hole_length > 2 * hole_radius` creates elongated holes; otherwise the holes
are circular.

The strut requires `width >= 2 * height`. Hole positions and lengths must also
stay within the strut.

Lower-level helpers:

```scad
cs_strut_triangle_45_2d_base(width, height, type=["f", "f"]);
cs_strut_triangle_45_2d_make_holes(
    strut_width, hole_radius, hole_distance, hole_length=0
) children();
```

### Elongated hole

Import:

```scad
use <cutter_lib/slot/cs_elongated_hole_2d.scad>
```

```scad
cs_elongated_hole_2d(width, height, spacing=0.001);
```

Creates a centred capsule-shaped 2D hole. `width` must be at least `height`.
`spacing` is a small construction value used by the Minkowski operation; it
is not placement spacing or kerf.

## Marker

Import:

```scad
use <cutter_lib/marker/cm_marker.scad>
```

```scad
cm_marker_ruler(
    width, height, ticks,
    tick_width=0.1,
    tick_height=10,
    layer=0,
    layer_visibility=[],
    make_3d=false
);
```

Creates `ticks` evenly spaced tick marks across `width`. The current
implementation refers to a file-scope `visibile_layers` variable rather than
the `layer_visibility` parameter, so layer filtering should be treated as
experimental.

## Tower composition

### Wall

Import:

```scad
use <cutter_lib/tower/ct_tower_wall.scad>
```

```scad
ct_tower_wall_arrange(
    width, height,
    wall_depth=0.1,
    frame_width=1,
    frame_overlap=false,
    make_3d=false,
    spacing_2d=1
) { /* up to six children */ }
```

Child order:

| Index | Part | Conventional layer |
| ---: | --- | ---: |
| 0 | Top frame strut | 0 |
| 1 | Left frame strut | 0 |
| 2 | Right frame strut | 0 |
| 3 | Bottom frame strut | 0 |
| 4 | Front surface | 1 |
| 5 | Back surface | 2 |

The first four children are passed through `cshape_frame_arrange`. In 3D, the
front surface is shifted by `wall_depth` along Z and the back remains at Z=0.

```scad
get_ct_tower_wall_strut_size(width, height, thickness, overlap);
get_ct_tower_wall_2d_size(width, height, spacing_2d=1);
```

`ct_tower_wall_example(...)` builds the same structure from diagnostic
surfaces and is useful for learning or debugging.

### Floor

Import:

```scad
use <cutter_lib/tower/ct_tower_floor.scad>
```

```scad
ct_tower_floor_arrange(
    width, height, depth,
    wall_depth=1,
    make_3d=false,
    spacing_2d=1
) { /* six children */ }
```

This is a box `move` arrangement with the standard box child order:
top, back, left, bottom, right, front.

```scad
get_ct_tower_floor_2d_size(
    width, height, depth, wall_depth, spacing_2d=1
);
```

Returns the flat footprint. `ct_tower_floor_example(...)` can populate the
floor with test faces or example tower walls.

### Tower

Import:

```scad
use <cutter_lib/tower/ct_tower.scad>
```

```scad
ct_tower_arrange(
    width, height, depth, wall_depth,
    make_3d=false,
    spacing_2d=1
) { /* one child per floor */ }
```

In 3D, numeric `height` stacks children at multiples of that height. In 2D,
each floor is placed on the next row using its calculated flat footprint.

The implementation also accepts a height list whose length equals the number
of children. Its current placement formula is `i * height[i]`, which is not a
cumulative stack for unequal heights; use a single numeric height unless that
behaviour is specifically desired.

`ct_tower_example(...)` supplies two demonstration floors.
