use <../../cutter_lib/hinges/ch_pin_hinge.scad>
use <../../cutter_lib/shells/csh_ribbed_veneer.scad>
use <bob_body.scad>

/* [Example] */

make_3d = true; // [false:true]
example_model_height = 80; // [70:1:160]
example_plywood_thickness = 4; // [1:0.5:8]
example_veneer_thickness = 0.6; // [0.1:0.1:2]
example_cradle_side_gap = 0.6; // [0:0.1:3]
example_cradle_bottom_gap = 1.0; // [0:0.1:2]
example_cradle_top_gap = 0.5; // [0:0.1:3]
example_pin_vertical_offset = 0; // [-1.3:0.1:2]
example_pin_front_back_offset = 0; // [-0.4:0.1:0.4]
example_door_angle = 45; // [0:1:90]
example_show_sweep = false; // [false:true]
example_window_mode = "open"; // [open, transparent_insert]

/* [Hidden] */

example_model_width = 340 * example_model_height / 490;
example_body_corner_radius = example_model_height*0.10;
example_hinge_corner_radius =
    bob_hinge_cradle_inner_radius(
        example_body_corner_radius,
        example_plywood_thickness,
        example_veneer_thickness);
example_door_width = bob_door_width(
    example_model_width);
example_door_height = bob_door_height(
    example_model_height, example_plywood_thickness,
    example_veneer_thickness,
    example_cradle_bottom_gap);
example_tongue_width = bob_door_tongue_width(
    example_model_width, example_plywood_thickness,
    example_veneer_thickness,
    example_cradle_side_gap);

if (make_3d)
    bob_door_assembly(
        example_model_width,
        example_model_height,
        example_plywood_thickness,
        example_veneer_thickness,
        example_door_angle,
        2, 0.2,
        example_window_mode,
        true, true,
        example_show_sweep,
        cradle_side_gap=example_cradle_side_gap,
        cradle_bottom_gap=example_cradle_bottom_gap,
        cradle_top_gap=example_cradle_top_gap,
        pin_vertical_offset=example_pin_vertical_offset,
        pin_front_back_offset=example_pin_front_back_offset);
else {
    bob_door_frame_2d(
        example_door_width,
        example_door_height,
        max(5, example_plywood_thickness),
        example_body_corner_radius,
        example_window_mode,
        example_plywood_thickness,
        example_tongue_width,
        example_hinge_corner_radius);
    translate([example_door_width+5, 0])
        bob_door_fascia_2d(
            example_door_width,
            example_door_height,
            example_body_corner_radius,
            example_window_mode,
            example_plywood_thickness,
            example_tongue_width,
            example_hinge_corner_radius);
    translate([example_door_width+5, 0])
        bob_door_engraving_2d(
            example_door_width,
            example_door_height);
}

// The overlay follows the finished front envelope. Clearances belong to the
// lower tongue/cradle joint, rather than shrinking the complete door.
function bob_door_width(model_width) = model_width;
function bob_door_height(model_height, plywood_thickness=4,
                         veneer_thickness=0.6,
                         cradle_bottom_gap=1.0) =
    model_height-
    bob_door_bottom(
        plywood_thickness, veneer_thickness,
        cradle_bottom_gap);
function bob_door_bottom(plywood_thickness=4,
                         veneer_thickness=0.6,
                         cradle_bottom_gap=1.0) =
    veneer_thickness+plywood_thickness+
    cradle_bottom_gap;
function bob_door_tongue_width(model_width,
                               plywood_thickness=4,
                               veneer_thickness=0.6,
                               cradle_side_gap=0.6) =
    model_width-
    2*(veneer_thickness+plywood_thickness+
       cradle_side_gap);
function bob_door_tongue_height(
    plywood_thickness=4,
    tongue_corner_radius=undef) =
    max(
        2.5*plywood_thickness,
        is_undef(tongue_corner_radius)
        ? 0
        : 2*tongue_corner_radius);
function bob_hinge_cradle_height(
    plywood_thickness=4,
    veneer_thickness=0.6,
    cradle_bottom_gap=1.0,
    cradle_top_gap=0.5,
    tongue_corner_radius=undef) =
    bob_door_bottom(
        plywood_thickness, veneer_thickness,
        cradle_bottom_gap)+
    bob_door_tongue_height(
        plywood_thickness,
        tongue_corner_radius)-
    cradle_top_gap;
function bob_hinge_axis_z(plywood_thickness=4,
                          pin_vertical_offset=0) =
    2.4*plywood_thickness+pin_vertical_offset;
function bob_hinge_cradle_inner_radius(
    body_corner_radius,
    plywood_thickness=4,
    veneer_thickness=0.6) =
    body_corner_radius-
    veneer_thickness-
    plywood_thickness;
function bob_window_diameter(door_width, door_height) =
    min(door_width*0.42, door_height*0.32);
function bob_window_center_z(door_height) = door_height*0.43;

module bob_door_window_2d(door_width, door_height)
{
    translate([
        door_width/2,
        bob_window_center_z(door_height)
    ])
        circle(d=bob_window_diameter(
            door_width, door_height));
}

module bob_top_rounded_rect_2d(size, radius)
{
    assert(size[0] > 2*radius &&
           size[1] > radius,
           "bob_top_rounded_rect_2d: radius consumes panel");

    union() {
        square([size[0], size[1]-radius]);
        translate([radius, size[1]-radius])
            square([size[0]-2*radius, radius]);
        for (x = [radius, size[0]-radius])
            translate([x, size[1]-radius])
                circle(r=radius);
    }
}

module bob_bottom_rounded_rect_2d(size, radius)
{
    assert(size[0] > 2*radius &&
           size[1] > radius,
           "bob_bottom_rounded_rect_2d: radius consumes panel");

    union() {
        translate([0, radius])
            square([size[0], size[1]-radius]);
        translate([radius, 0])
            square([size[0]-2*radius, radius]);
        for (x = [radius, size[0]-radius])
            translate([x, radius])
                circle(r=radius);
    }
}

// Broad upper panel plus the narrower centered hinge tongue used by the
// original Bob mechanism. The broad-panel shoulders remain square; the
// latest front reference rounds the outer top and tongue-bottom corners.
module bob_door_outline_2d(door_width, door_height,
                           plywood_thickness=4,
                           corner_radius=5,
                           tongue_width=undef,
                           tongue_corner_radius=undef)
{
    resolved_tongue_width = is_undef(tongue_width)
        ? 0.80*door_width
        : tongue_width;
    resolved_tongue_corner_radius =
        is_undef(tongue_corner_radius)
        ? min(corner_radius,
              1.25*plywood_thickness)
        : tongue_corner_radius;
    tongue_height =
        bob_door_tongue_height(
            plywood_thickness,
            resolved_tongue_corner_radius);
    tongue_x = (door_width-resolved_tongue_width)/2;

    assert(door_height >
           tongue_height+2*corner_radius,
           "bob_door_outline_2d: hinge tongue consumes door height");
    assert(resolved_tongue_width > 2*plywood_thickness,
           "bob_door_outline_2d: hinge tongue is too narrow");
    assert(resolved_tongue_corner_radius > 0 &&
           resolved_tongue_corner_radius <=
           tongue_height/2,
           "bob_door_outline_2d: invalid hinge corner radius");

    union() {
        translate([0, tongue_height])
            bob_top_rounded_rect_2d(
                [door_width,
                 door_height-tongue_height],
                corner_radius);

        translate([tongue_x, 0])
            bob_bottom_rounded_rect_2d(
                [resolved_tongue_width, tongue_height],
                resolved_tongue_corner_radius);
    }
}

module bob_hinge_cradle_2d(width, height,
                           plywood_thickness=4,
                           corner_radius=8,
                           cradle_height=14)
{
    assert(cradle_height > plywood_thickness &&
           cradle_height < height,
           "bob_hinge_cradle_2d: invalid cradle height");

    intersection() {
        shell_rib(
            width, height,
            rib_width=plywood_thickness,
            corner_radius=corner_radius);
        square([width, cradle_height]);
    }
}

// Finished front outline: the inner edge matches the plywood cradle while
// the outer edge reaches the veneer-covered body silhouette.
module bob_hinge_cradle_finished_2d(
    model_width, model_height,
    plywood_thickness=4,
    veneer_thickness=0.6,
    corner_radius=8,
    cradle_height=14)
{
    bob_hinge_cradle_2d(
        model_width, model_height,
        plywood_thickness+veneer_thickness,
        corner_radius,
        cradle_height);
}

// Cross-section of the veneer wrapped over the U's outer left side, bottom,
// rounded corners, and right side. Extruding this profile through the cradle
// depth produces the edge covering shown in the assembly.
module bob_hinge_cradle_edge_veneer_2d(
    model_width, model_height,
    plywood_thickness=4,
    veneer_thickness=0.6,
    corner_radius=8,
    cradle_height=14)
{
    difference() {
        bob_hinge_cradle_finished_2d(
            model_width, model_height,
            plywood_thickness,
            veneer_thickness,
            corner_radius,
            cradle_height);

        translate([
            veneer_thickness,
            veneer_thickness
        ])
            bob_hinge_cradle_2d(
                bob_structural_width(
                    model_width,
                    veneer_thickness),
                bob_structural_height(
                    model_height,
                    veneer_thickness),
                plywood_thickness,
                bob_structural_corner_radius(
                    corner_radius,
                    veneer_thickness),
                cradle_height-veneer_thickness);
    }
}

function bob_hinge_cradle_outer_edge_length(
    model_width, corner_radius, cradle_height) =
    model_width-2*corner_radius+
    PI*corner_radius+
    2*(cradle_height-corner_radius);

module bob_hinge_cradle_edge_strip_2d(
    model_width, plywood_thickness=4,
    corner_radius=8, cradle_height=14)
{
    assert(cradle_height >= corner_radius,
           "bob_hinge_cradle_edge_strip_2d: cradle is below its corner radius");
    square([
        bob_hinge_cradle_outer_edge_length(
            model_width,
            corner_radius,
            cradle_height),
        plywood_thickness
    ]);
}

module bob_door_frame_2d(door_width, door_height,
                         frame_width=5, corner_radius=5,
                         window_mode="open",
                         plywood_thickness=4,
                         tongue_width=undef,
                         tongue_corner_radius=undef)
{
    assert(window_mode == "open" ||
           window_mode == "transparent_insert",
           "bob_door_frame_2d: unsupported window_mode");
    assert(door_width > 2*frame_width &&
           door_height > 2*frame_width,
           "bob_door_frame_2d: frame consumes door");

    difference() {
        bob_door_outline_2d(
            door_width, door_height,
            plywood_thickness, corner_radius,
            tongue_width, tongue_corner_radius);
        bob_door_window_2d(
            door_width, door_height);
    }
}

module bob_door_fascia_2d(door_width, door_height,
                          corner_radius=5,
                          window_mode="open",
                          plywood_thickness=4,
                          tongue_width=undef,
                          tongue_corner_radius=undef)
{
    difference() {
        bob_door_outline_2d(
            door_width, door_height,
            plywood_thickness, corner_radius,
            tongue_width, tongue_corner_radius);
        if (window_mode == "open" ||
            window_mode == "transparent_insert")
            bob_door_window_2d(
                door_width, door_height);
    }
}

// Remove precisely any fascia region hidden by the plywood cradle while
// retaining veneer on the visible center of the door tongue. The front-rib
// veneer is trimmed separately by bob_front_veneer_frame_2d().
module bob_door_trimmed_fascia_2d(
    door_width, door_height,
    plywood_thickness=4,
    veneer_thickness=0.6,
    corner_radius=5,
    window_mode="open",
    tongue_width=undef,
    tongue_corner_radius=undef,
    body_corner_radius=8,
    cradle_height=14,
    door_bottom=5)
{
    structural_width =
        bob_structural_width(
            door_width, veneer_thickness);
    structural_height =
        bob_structural_height(
            door_height+door_bottom,
            veneer_thickness);
    structural_radius =
        bob_structural_corner_radius(
            body_corner_radius, veneer_thickness);
    difference() {
        bob_door_fascia_2d(
            door_width, door_height,
            corner_radius, window_mode,
            plywood_thickness, tongue_width,
            tongue_corner_radius);

        translate([
            veneer_thickness,
            veneer_thickness-door_bottom
        ])
            bob_hinge_cradle_2d(
                structural_width,
                structural_height,
                plywood_thickness,
                structural_radius,
                cradle_height-veneer_thickness);
    }
}

module bob_door_engraving_2d(door_width, door_height,
                             line_width=0.35)
{
    display = [door_width*0.28, door_height*0.07];
    display_z = door_height*0.79;
    button_z = door_height*0.735;
    window_d = bob_window_diameter(
        door_width, door_height);
    window_z = bob_window_center_z(door_height);

    // Circular viewing-port border.
    difference() {
        translate([door_width/2, window_z])
            circle(d=window_d+2);
        translate([door_width/2, window_z])
            circle(d=window_d+2-2*line_width);
    }

    // Upper display.
    translate([(door_width-display[0])/2, display_z])
        difference() {
            csh_rounded_rect_2d(display, 1);
            translate([line_width, line_width])
                csh_rounded_rect_2d(
                    [display[0]-2*line_width,
                     display[1]-2*line_width],
                    max(0, 1-line_width));
        }

    // Three controls below the display, matching the Bob front arrangement.
    button_x = [
        door_width/2-door_width*0.09,
        door_width/2,
        door_width/2+door_width*0.09
    ];
    button_d = [2.0, 2.6, 2.0];
    for (i = [0:2])
        translate([button_x[i], button_z])
            circle(d=button_d[i]);

    // Lower brand mark.
    translate([door_width/2, door_height*0.08])
        text("Bob.", size=max(2.5, door_width*0.09),
             halign="center");
}

module bob_door_local(door_width, door_height,
                      plywood_thickness=4,
                      veneer_thickness=0.6,
                      window_mode="open",
                      show_engraving=true,
                      exploded=0,
                      tongue_width=undef,
                      body_corner_radius=8,
                      cradle_height=14,
                      door_bottom=5)
{
    corner = body_corner_radius;
    hinge_corner =
        bob_hinge_cradle_inner_radius(
            body_corner_radius,
            plywood_thickness,
            veneer_thickness);
    plywood_front_y = bob_front_plywood_y();
    finished_front_y =
        bob_front_face_y(veneer_thickness);
    finished_depth = bob_front_stack_thickness(
        plywood_thickness, veneer_thickness);

    assert(plywood_front_y+plywood_thickness-
           finished_front_y == finished_depth,
           "bob_door_local: door must equal veneer plus rib thickness");

    color([0.72, 0.56, 0.33])
        translate([
            0,
            plywood_front_y+
            plywood_thickness+exploded,
            0
        ])
            rotate([90,0,0])
                linear_extrude(plywood_thickness)
                    bob_door_frame_2d(
                        door_width, door_height,
                        frame_width=max(plywood_thickness, 5),
                        corner_radius=corner,
                        window_mode=window_mode,
                        plywood_thickness=plywood_thickness,
                        tongue_width=tongue_width,
                        tongue_corner_radius=
                            hinge_corner);

    color([0.55, 0.28, 0.12])
        translate([
            0,
            plywood_front_y-exploded,
            0
        ])
            rotate([90,0,0])
                linear_extrude(veneer_thickness)
                    bob_door_trimmed_fascia_2d(
                        door_width, door_height,
                        plywood_thickness,
                        veneer_thickness,
                        corner, window_mode,
                        tongue_width,
                        hinge_corner,
                        body_corner_radius,
                        cradle_height,
                        door_bottom);

    if (window_mode == "transparent_insert")
        color([0.35, 0.65, 0.8, 0.25])
            translate([
                0,
                plywood_front_y+
                plywood_thickness/2+exploded,
                0
            ])
                rotate([90,0,0])
                    linear_extrude(veneer_thickness)
                        bob_door_window_2d(
                            door_width, door_height);

    if (show_engraving)
        color([0.12, 0.08, 0.05])
            translate([0,
                       finished_front_y-exploded,
                       0])
                rotate([90,0,0])
                    linear_extrude(0.08)
                        bob_door_engraving_2d(
                            door_width, door_height);
}

module bob_door_assembly(model_width, model_height,
                         plywood_thickness=4,
                         veneer_thickness=0.6,
                         door_angle=90,
                         hinge_pin_diameter=2,
                         hinge_clearance=0.2,
                         window_mode="open",
                         show_engraving=true,
                         show_hinge=true,
                         show_sweep=false,
                         exploded=0,
                         cradle_side_gap=0.6,
                         cradle_bottom_gap=1.0,
                         cradle_top_gap=0.5,
                         pin_vertical_offset=0,
                         pin_front_back_offset=0,
                         body_corner_radius=undef)
{
    dw = bob_door_width(model_width);
    door_bottom = bob_door_bottom(
        plywood_thickness, veneer_thickness,
        cradle_bottom_gap);
    dh = bob_door_height(
        model_height, plywood_thickness,
        veneer_thickness,
        cradle_bottom_gap);
    dx = (model_width-dw)/2;
    corner_radius = is_undef(body_corner_radius)
        ? model_height*0.10
        : body_corner_radius;
    structural_width =
        bob_structural_width(
            model_width, veneer_thickness);
    structural_height =
        bob_structural_height(
            model_height, veneer_thickness);
    structural_radius =
        bob_structural_corner_radius(
            corner_radius, veneer_thickness);
    hinge_corner_radius =
        bob_hinge_cradle_inner_radius(
            corner_radius,
            plywood_thickness,
            veneer_thickness);
    cradle_height = bob_hinge_cradle_height(
        plywood_thickness,
        veneer_thickness,
        cradle_bottom_gap,
        cradle_top_gap,
        hinge_corner_radius);
    tongue_width = bob_door_tongue_width(
        model_width, plywood_thickness,
        veneer_thickness, cradle_side_gap);
    local_axis_y =
        bob_front_plywood_y()+
        plywood_thickness/2+
        pin_front_back_offset;
    world_axis_y =
        -plywood_thickness/2+
        pin_front_back_offset;
    axis = [
        0, world_axis_y,
        bob_hinge_axis_z(
            plywood_thickness,
            pin_vertical_offset)
    ];
    axis_local_z =
        axis[2]-door_bottom;
    tongue_height =
        bob_door_tongue_height(
            plywood_thickness,
            hinge_corner_radius);
    pin_radius =
        (hinge_pin_diameter+hinge_clearance)/2;

    assert(door_angle >= 0 && door_angle <= 90,
           "bob_door_assembly: door_angle must be between 0 and 90 degrees");
    assert(hinge_pin_diameter+hinge_clearance+
           1.5 <= plywood_thickness,
           "bob_door_assembly: chassis knuckle has insufficient material around the pin");
    assert(axis_local_z-pin_radius >= 1.5 &&
           tongue_height-axis_local_z-pin_radius >= 1.5,
           "bob_door_assembly: hinge pin lacks material inside the door tongue");
    assert(cradle_side_gap >= 0 &&
           cradle_bottom_gap >= 0 &&
           cradle_top_gap >= 0,
           "bob_door_assembly: cradle gaps must be non-negative");
    assert(cradle_height > plywood_thickness,
           "bob_door_assembly: cradle top gap consumes the cradle");
    assert(hinge_corner_radius > 0,
           "bob_door_assembly: body radius leaves no hinge corner radius");
    assert(abs(pin_front_back_offset)+pin_radius+0.5 <=
           plywood_thickness/2,
           "bob_door_assembly: front/back pin offset leaves insufficient plywood");

    // A forward copy of the rib's lower U-profile forms the two chassis
    // knuckles around the door tongue. The complete front rib remains
    // directly behind the door/cradle stack.
    color([0.72, 0.56, 0.33])
        translate([
            veneer_thickness,
            0,
            veneer_thickness
        ])
            rotate([90,0,0])
                linear_extrude(plywood_thickness)
                    bob_hinge_cradle_2d(
                        structural_width,
                        structural_height,
                        plywood_thickness,
                        structural_radius,
                        cradle_height-veneer_thickness);

    // The edge strip bends continuously around the outer left side, bottom,
    // and right side, meeting the body's main veneer at the front-rib plane.
    color([0.55, 0.28, 0.12])
        rotate([90,0,0])
            linear_extrude(plywood_thickness)
                bob_hinge_cradle_edge_veneer_2d(
                    model_width,
                    model_height,
                    plywood_thickness,
                    veneer_thickness,
                    corner_radius,
                    cradle_height);

    // The enlarged front face reaches the finished body outline and covers
    // the front edge of the side/bottom strip. Its rear surface bonds to the
    // cradle; the cradle's opposite face remains bare for the rib glue joint.
    color([0.55, 0.28, 0.12])
        translate([
            0,
            -plywood_thickness,
            0
        ])
            rotate([90,0,0])
                linear_extrude(veneer_thickness)
                    bob_hinge_cradle_finished_2d(
                        model_width,
                        model_height,
                        plywood_thickness,
                        veneer_thickness,
                        corner_radius,
                        cradle_height);

    if (show_hinge) {
        color("silver")
            ch_hinge_pin_preview(
                model_width,
                hinge_pin_diameter,
                [0,
                 axis[1], axis[2]]);
    }

    translate([dx, axis[1], axis[2]])
        rotate([door_angle,0,0])
            translate([
                0, -local_axis_y,
                -axis_local_z
            ])
                bob_door_local(
                    dw, dh,
                    plywood_thickness,
                    veneer_thickness,
                    window_mode,
                    show_engraving,
                    exploded,
                    tongue_width,
                    corner_radius,
                    cradle_height,
                    door_bottom);

    if (show_sweep)
        translate([dx, axis[1], axis[2]])
            for (a = [0:15:90])
                %rotate([a,0,0])
                    translate([
                        0, -local_axis_y,
                        -axis_local_z
                    ])
                        bob_door_local(
                            dw, dh,
                            plywood_thickness,
                            veneer_thickness,
                            window_mode,
                            false,
                            0,
                            tongue_width,
                            corner_radius,
                            cradle_height,
                            door_bottom);
}
