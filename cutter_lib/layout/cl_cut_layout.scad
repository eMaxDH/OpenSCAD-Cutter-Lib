// Deterministic sheet-layout helpers. Placement remains explicit because
// OpenSCAD cannot query arbitrary child bounds reliably.

/* [Output] */
make_3d = true; // [false:true]

/* [2D Layout] */
example_sheet_size = [120, 70];
example_margin = 5;
example_spacing = 5;

/* [Example] */
example_part_size = [45, 25];
example_thickness = 3;

/* [Hidden] */

cl_cut_layout_example(
    sheet_size=example_sheet_size,
    margin=example_margin,
    spacing=example_spacing,
    part_size=example_part_size,
    thickness=example_thickness,
    make_3d=make_3d);

module cl_cut_layout_example(sheet_size=[120, 70], margin=5, spacing=5,
                             part_size=[45, 25], thickness=3,
                             make_3d=false)
{
    positions = [[margin, margin],
                 [margin+part_size[0]+spacing, margin]];
    boxes = [[positions[0][0], positions[0][1],
              part_size[0], part_size[1]],
             [positions[1][0], positions[1][1],
              part_size[0], part_size[1]]];
    cl_validate_layout(boxes, sheet_size, margin, spacing, "example sheet");

    if (!make_3d)
        cl_sheet_boundary(sheet_size, "LAYOUT EXAMPLE");

    for (p = positions)
        translate([p[0], p[1], 0])
            if (make_3d)
                linear_extrude(height=thickness)
                    square(part_size);
            else
                square(part_size);
}

function cl_boxes_overlap(a, b, spacing=0) =
    !(a[0]+a[2]+spacing <= b[0] ||
      b[0]+b[2]+spacing <= a[0] ||
      a[1]+a[3]+spacing <= b[1] ||
      b[1]+b[3]+spacing <= a[1]);

module cl_validate_layout(boxes, sheet_size=[300,300],
                          margin=5, spacing=3, name="sheet")
{
    assert(sheet_size[0] > 2*margin && sheet_size[1] > 2*margin,
           str("cl_validate_layout: invalid ", name, " dimensions/margin"));

    for (i = [0:len(boxes)-1]) {
        b = boxes[i];
        assert(b[0] >= margin && b[1] >= margin &&
               b[0]+b[2] <= sheet_size[0]-margin &&
               b[1]+b[3] <= sheet_size[1]-margin,
               str("cl_validate_layout: part ", i,
                   " is outside ", name));

        if (i < len(boxes)-1)
            for (j = [i+1:len(boxes)-1])
                assert(!cl_boxes_overlap(b, boxes[j], spacing),
                       str("cl_validate_layout: parts ", i,
                           " and ", j, " overlap on ", name));
    }
}

module cl_sheet_boundary(sheet_size=[300,300], label="",
                         line_width=0.3)
{
    assert(sheet_size[0] > 0 && sheet_size[1] > 0,
           "cl_sheet_boundary: sheet size must be positive");

    %difference() {
        square(sheet_size);
        translate([line_width, line_width])
            square([sheet_size[0]-2*line_width,
                    sheet_size[1]-2*line_width]);
    }

    if (label != "")
        %translate([2, sheet_size[1]-5])
            text(label, size=3);
}

// Place a known-size part and optionally add a preview-only identifier.
module cl_layout_part(position, size, id="", quantity=1,
                      sheet_size=[300,300], margin=5,
                      label_size=2)
{
    assert(size[0] > 0 && size[1] > 0,
           str("cl_layout_part: ", id, " has non-positive size"));
    assert(position[0] >= margin && position[1] >= margin &&
           position[0]+size[0] <= sheet_size[0]-margin &&
           position[1]+size[1] <= sheet_size[1]-margin,
           str("cl_layout_part: ", id, " does not fit the sheet"));

    translate(position)
        children();

    if (id != "")
        %translate([position[0],
                    max(0.5, position[1]-label_size-0.5)])
            text(str(id, quantity > 1 ? str(" x", quantity) : ""),
                 size=label_size);
}

// Preview conventions for separating operations. Geometry is not altered.
module cl_cut_geometry()
{
    color("red")
        children();
}

module cl_engrave_geometry()
{
    color("blue")
        children();
}

module cl_reference_geometry()
{
    %color("gray")
        children();
}

// Select a manufacturing operation explicitly. Preview mode keeps both
// operations visible with conventional colours; exported cut/engrave modes
// contain only the requested geometry.
module cl_operation_geometry(kind="cut", output="preview")
{
    assert(kind == "cut" || kind == "engrave",
           "cl_operation_geometry: kind must be cut or engrave");
    assert(output == "cut" || output == "engrave" ||
           output == "preview",
           "cl_operation_geometry: unsupported output");

    if (output == kind)
        children();
    else if (output == "preview") {
        if (kind == "cut")
            cl_cut_geometry()
                children();
        else
            cl_engrave_geometry()
                children();
    }
}
