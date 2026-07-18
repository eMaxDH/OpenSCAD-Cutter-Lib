use <../../cutter_lib/hinges/ch_pin_hinge.scad>
use <../../cutter_lib/shells/csh_ribbed_veneer.scad>

/* [Example] */

make_3d = true; // [false:true]
example_model_height = 80; // [70:1:160]
example_plywood_thickness = 4; // [1:0.5:8]
example_veneer_thickness = 0.6; // [0.1:0.1:2]
example_door_side_gap = 0.4; // [0:0.1:2]
example_door_top_gap = 0.5; // [0:0.1:2]
example_door_bottom_gap = 1.0; // [0:0.1:2]
example_door_angle = 45; // [0:1:90]
example_show_sweep = false; // [false:true]
example_window_mode = "open"; // [open, transparent_insert]

/* [Hidden] */

example_model_width = 340 * example_model_height / 490;
example_door_width = bob_door_width(
    example_model_width, example_plywood_thickness,
    example_door_side_gap);
example_door_height = bob_door_height(
    example_model_height, example_plywood_thickness,
    example_door_top_gap,
    example_door_bottom_gap);

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
        door_side_gap=example_door_side_gap,
        door_top_gap=example_door_top_gap,
        door_bottom_gap=example_door_bottom_gap);
else {
    bob_door_frame_2d(
        example_door_width,
        example_door_height,
        max(5, example_plywood_thickness),
        min(6, example_door_width*0.12),
        example_window_mode);
    translate([example_door_width+5, 0])
        bob_door_fascia_2d(
            example_door_width,
            example_door_height,
            min(6, example_door_width*0.12),
            example_window_mode);
    translate([example_door_width+5, 0])
        bob_door_engraving_2d(
            example_door_width,
            example_door_height);
}

// Leave one plywood thickness at each side for the front-rib knuckles.
function bob_door_width(model_width, plywood_thickness=4,
                        side_gap=0.4) =
    model_width-2*(plywood_thickness+side_gap);
function bob_door_height(model_height, plywood_thickness=4,
                         top_gap=0.4, bottom_gap=0.4) =
    model_height-2*plywood_thickness-top_gap-bottom_gap;
function bob_door_bottom(plywood_thickness=4, bottom_gap=0.4) =
    plywood_thickness+bottom_gap;
function bob_hinge_axis_z(plywood_thickness=4) =
    2.4*plywood_thickness;
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

module bob_door_frame_2d(door_width, door_height,
                         frame_width=5, corner_radius=5,
                         window_mode="open")
{
    assert(window_mode == "open" ||
           window_mode == "transparent_insert",
           "bob_door_frame_2d: unsupported window_mode");
    assert(door_width > 2*frame_width &&
           door_height > 2*frame_width,
           "bob_door_frame_2d: frame consumes door");

    difference() {
        csh_rounded_rect_2d(
            [door_width, door_height], corner_radius);
        bob_door_window_2d(
            door_width, door_height);
    }
}

module bob_door_fascia_2d(door_width, door_height,
                          corner_radius=5,
                          window_mode="open")
{
    difference() {
        csh_rounded_rect_2d(
            [door_width, door_height], corner_radius);
        if (window_mode == "open" ||
            window_mode == "transparent_insert")
            bob_door_window_2d(
                door_width, door_height);
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
                      exploded=0)
{
    corner = min(6, door_width*0.12);

    color([0.72, 0.56, 0.33])
        translate([0, plywood_thickness+exploded, 0])
            rotate([90,0,0])
                linear_extrude(plywood_thickness)
                    bob_door_frame_2d(
                        door_width, door_height,
                        frame_width=max(plywood_thickness, 5),
                        corner_radius=corner,
                        window_mode=window_mode);

    color([0.55, 0.28, 0.12])
        translate([0, -exploded, 0])
            rotate([90,0,0])
                linear_extrude(veneer_thickness)
                    bob_door_fascia_2d(
                        door_width, door_height,
                        corner, window_mode);

    if (window_mode == "transparent_insert")
        color([0.35, 0.65, 0.8, 0.25])
            translate([
                0,
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
                       -veneer_thickness-exploded,
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
                         door_side_gap=0.4,
                         door_top_gap=0.5,
                         door_bottom_gap=1.0)
{
    dw = bob_door_width(
        model_width, plywood_thickness,
        door_side_gap);
    dh = bob_door_height(
        model_height, plywood_thickness,
        door_top_gap, door_bottom_gap);
    dx = (model_width-dw)/2;
    axis = [
        0, plywood_thickness/2,
        bob_hinge_axis_z(plywood_thickness)
    ];
    axis_local_z =
        axis[2]-bob_door_bottom(
            plywood_thickness, door_bottom_gap);

    assert(door_angle >= 0 && door_angle <= 90,
           "bob_door_assembly: door_angle must be between 0 and 90 degrees");
    assert(hinge_pin_diameter+hinge_clearance+
           1.5 <= plywood_thickness,
           "bob_door_assembly: chassis knuckle has insufficient material around the pin");
    assert(door_side_gap >= 0 &&
           door_top_gap >= 0 &&
           door_bottom_gap >= 0,
           "bob_door_assembly: door gaps must be non-negative");

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
            translate([0, -axis[1], -axis_local_z])
                bob_door_local(
                    dw, dh,
                    plywood_thickness,
                    veneer_thickness,
                    window_mode,
                    show_engraving,
                    exploded);

    if (show_sweep)
        translate([dx, axis[1], axis[2]])
            for (a = [0:15:90])
                %rotate([a,0,0])
                    translate([
                        0, -axis[1], -axis_local_z
                    ])
                        bob_door_local(
                            dw, dh,
                            plywood_thickness,
                            veneer_thickness,
                            window_mode,
                            false);
}
