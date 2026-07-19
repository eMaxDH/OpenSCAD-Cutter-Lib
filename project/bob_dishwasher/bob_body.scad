use <../../cutter_lib/materials/cm_manufacturing.scad>
use <../../cutter_lib/shells/csh_ribbed_veneer.scad>
use <../../cutter_lib/connector/cc_connector_triangle_45_2d.scad>

/* [Example] */

make_3d = true; // [false:true]
example_model_height = 80; // [70:1:160]
example_plywood_thickness = 4; // [1:0.5:8]
example_veneer_thickness = 0.6; // [0.1:0.1:2]
example_rib_count = 4; // [1:1:10]
example_show_veneer = true; // [false:true]
example_show_skeleton = true; // [false:true]

/* [Hidden] */

example_model_width = 340 * example_model_height / 490;
example_model_depth = example_model_height;
example_corner_radius = example_model_height * 0.10;

if (make_3d)
    bob_body_structure(
        example_model_width,
        example_model_height,
        example_model_depth,
        example_plywood_thickness,
        example_veneer_thickness,
        example_rib_count,
        example_corner_radius,
        example_plywood_thickness,
        example_plywood_thickness,
        0.15, 0.5,
        example_show_skeleton,
        example_show_veneer,
        5, 0.58);
else
    bob_segmented_rib_compact_2d(
        bob_structural_width(
            example_model_width, example_veneer_thickness),
        bob_structural_height(
            example_model_height, example_veneer_thickness),
        example_plywood_thickness,
        bob_structural_corner_radius(
            example_corner_radius, example_veneer_thickness),
        0.15, 0.5);

function bob_inner_width(model_width, plywood_thickness) =
    model_width - 2*plywood_thickness;
function bob_front_face_y(veneer_thickness) =
    -veneer_thickness;
function bob_front_plywood_y() = 0;
function bob_front_stack_thickness(
    plywood_thickness, veneer_thickness) =
    plywood_thickness+veneer_thickness;
function bob_structural_width(model_width, veneer_thickness) =
    model_width-2*veneer_thickness;
function bob_structural_height(model_height, veneer_thickness) =
    model_height-2*veneer_thickness;
function bob_structural_corner_radius(corner_radius, veneer_thickness) =
    corner_radius-veneer_thickness;

module bob_base_2d(model_width, model_depth, plywood_thickness=4)
{
    square([
        bob_inner_width(model_width, plywood_thickness),
        model_depth-2*plywood_thickness
    ]);
}

function bob_base_front_bridge_depth(
    plywood_thickness=4,
    base_overlap=undef) =
    plywood_thickness+
    (is_undef(base_overlap)
     ? plywood_thickness
     : base_overlap);

function bob_base_front_bridge_width(
    model_width, corner_radius) =
    model_width-2*corner_radius;

// Radius-to-radius cleat between the rear face of the front rib and the
// underside of the inset base. Its second plywood-thickness overlaps beneath
// the base.
module bob_base_front_bridge_2d(
    model_width,
    corner_radius=8,
    plywood_thickness=4,
    base_overlap=undef)
{
    assert(model_width > 2*corner_radius,
           "bob_base_front_bridge_2d: rib radii consume the bridge");
    square([
        bob_base_front_bridge_width(
            model_width,
            corner_radius),
        bob_base_front_bridge_depth(
            plywood_thickness,
            base_overlap)
    ]);
}

module bob_stringer_2d(stringer_length, plywood_thickness=4)
{
    square([
        plywood_thickness,
        stringer_length
    ]);
}

// Bob-specific canonical rounded shell silhouette.
module bob_shell_rib_2d(model_width, model_height,
                        plywood_thickness=4,
                        corner_radius=8,
                        fit_clearance=0.15,
                        kerf=0.5)
{
    shell_rib(model_width, model_height,
              rib_width=plywood_thickness,
              corner_radius=corner_radius);
}

function bob_rib_cap_height(corner_radius, plywood_thickness) =
    corner_radius+plywood_thickness;
function bob_rib_cap_piece_height(corner_radius, plywood_thickness) =
    bob_rib_cap_height(corner_radius, plywood_thickness);
function bob_rib_side_length(model_height, corner_radius,
                             plywood_thickness) =
    model_height-2*corner_radius;

// The library's stepped 45-degree pair partitions a full material-width
// square. It is deliberately only an alignment guide for a broad glued scarf,
// not a narrow structural tab.
module bob_rib_triangle_joint_2d(
    plywood_thickness=4,
    half="cap",
    connector_factor=0.4)
{
    assert(half == "cap" || half == "side",
           "bob_rib_triangle_joint_2d: unsupported half");

    if (half == "cap")
        cc_connector_triangle_45_2d(
            plywood_thickness, "f", connector_factor);
    else
        translate([plywood_thickness, plywood_thickness])
            rotate([0,0,180])
                cc_connector_triangle_45_2d(
                    plywood_thickness, "m",
                    connector_factor);
}

module bob_rib_cap_2d(model_width, model_height,
                      plywood_thickness=4,
                      corner_radius=8,
                      top=false,
                      fit_clearance=0.15,
                      kerf=0.5)
{
    cap_h = bob_rib_cap_height(
        corner_radius, plywood_thickness);
    curve_h = corner_radius;

    assert(bob_rib_side_length(
               model_height, corner_radius,
               plywood_thickness) > 2*plywood_thickness,
           "bob_rib_cap_2d: no straight side remains");

    if (!top)
        union() {
            intersection() {
                bob_shell_rib_2d(
                    model_width, model_height,
                    plywood_thickness, corner_radius,
                    fit_clearance, kerf);
                square([model_width, curve_h]);
            }
            for (x = [0, model_width-plywood_thickness])
                translate([x, curve_h])
                    bob_rib_triangle_joint_2d(
                        plywood_thickness, "cap");
        }
    else
        union() {
            translate([0, cap_h-model_height])
                intersection() {
                    bob_shell_rib_2d(
                        model_width, model_height,
                        plywood_thickness, corner_radius,
                        fit_clearance, kerf);
                    translate([0, model_height-curve_h])
                        square([model_width, curve_h]);
                }
            for (x = [0, model_width-plywood_thickness])
                translate([x, plywood_thickness])
                    mirror([0,1])
                        bob_rib_triangle_joint_2d(
                            plywood_thickness, "cap");
            }
}

module bob_rib_side_2d(model_height,
                       plywood_thickness=4,
                       corner_radius=8,
                       fit_clearance=0.15,
                       kerf=0.5)
{
    side_length = bob_rib_side_length(
        model_height, corner_radius, plywood_thickness);

    union() {
        bob_rib_triangle_joint_2d(
            plywood_thickness, "side");
        translate([0, plywood_thickness])
            square([
                plywood_thickness,
                side_length-2*plywood_thickness
            ]);
        translate([0, side_length])
            mirror([0,1])
                bob_rib_triangle_joint_2d(
                    plywood_thickness, "side");
    }
}

module bob_segmented_shell_rib_2d(
    model_width, model_height,
    plywood_thickness=4,
    corner_radius=8,
    fit_clearance=0.15,
    kerf=0)
{
    bob_rib_cap_2d(
        model_width, model_height,
        plywood_thickness, corner_radius,
        false, fit_clearance, kerf);
    translate([
        0,
        model_height-bob_rib_cap_piece_height(
            corner_radius, plywood_thickness)
    ])
        bob_rib_cap_2d(
            model_width, model_height,
            plywood_thickness, corner_radius,
            true, fit_clearance, kerf);
    for (x = [0, model_width-plywood_thickness])
        translate([x, corner_radius])
            bob_rib_side_2d(
                model_height, plywood_thickness,
                corner_radius, fit_clearance, kerf);
}

module bob_segmented_rib_compact_2d(
    model_width, model_height,
    plywood_thickness=4,
    corner_radius=8,
    fit_clearance=0.15,
    kerf=0.5,
    spacing=3)
{
    cap_piece_h = bob_rib_cap_piece_height(
        corner_radius, plywood_thickness);
    side_length = bob_rib_side_length(
        model_height, corner_radius, plywood_thickness);

    bob_rib_cap_2d(
        model_width, model_height,
        plywood_thickness, corner_radius,
        false, fit_clearance, kerf);
    translate([0, cap_piece_h+spacing])
        bob_rib_cap_2d(
            model_width, model_height,
            plywood_thickness, corner_radius,
            true, fit_clearance, kerf);
    for (i = [0:1])
        translate([
            model_width+spacing+
            i*(plywood_thickness+spacing),
            0
        ])
            bob_rib_side_2d(
                model_height, plywood_thickness,
                corner_radius, fit_clearance, kerf);
}

module bob_rib_at_y(y, model_width, model_height,
                    plywood_thickness=4,
                    corner_radius=8,
                    fit_clearance=0.15,
                    kerf=0.5)
{
    translate([0, y+plywood_thickness, 0])
        rotate([90,0,0])
            linear_extrude(plywood_thickness)
                bob_segmented_shell_rib_2d(
                    model_width, model_height,
                    plywood_thickness, corner_radius,
                    fit_clearance, kerf=0);
}

module bob_stringer_cage(model_width, model_height, model_depth,
                         plywood_thickness=4,
                         veneer_thickness=0.6)
{
    x_positions = [
        veneer_thickness+2*plywood_thickness,
        model_width-veneer_thickness-3*plywood_thickness
    ];
    stringer_length =
        model_depth-veneer_thickness;

    assert(stringer_length > 0,
           "bob_stringer_cage: model is too shallow");

    // The hidden base supplies the lower longitudinal structure behind the
    // front door-sweep clearance.
    // The upper stringers reach the front face of the front rib and end
    // against the inner face of the rear veneer.
    for (x = x_positions)
        translate([
            x,
            0,
            model_height-veneer_thickness-
            2*plywood_thickness
        ])
            linear_extrude(plywood_thickness)
                bob_stringer_2d(
                    stringer_length, plywood_thickness);
}

module bob_body_structure(model_width, model_height, model_depth,
                          plywood_thickness=4,
                          veneer_thickness=0.6,
                          rib_count=4,
                          corner_radius=8,
                          front_offset=4,
                          rear_offset=4,
                          fit_clearance=0.15,
                          kerf=0.5,
                          show_ribs=true,
                          show_skin=true,
                          min_bend_radius=5,
                          veneer_opacity=0.58,
                          hinge_pin_diameter=2,
                          hinge_clearance=0.2,
                          show_hinge_bores=true)
{
    usable_depth = model_depth-front_offset-rear_offset;
    front_plywood_y = bob_front_plywood_y();
    front_face_y = bob_front_face_y(
        veneer_thickness);
    front_stack_depth = bob_front_stack_thickness(
        plywood_thickness, veneer_thickness);
    structural_width =
        bob_structural_width(model_width, veneer_thickness);
    structural_height =
        bob_structural_height(model_height, veneer_thickness);
    structural_radius =
        bob_structural_corner_radius(
            corner_radius, veneer_thickness);

    assert(rib_count >= 1, "bob_body_structure: at least one rib is required");
    assert(structural_width > 2*plywood_thickness &&
           structural_height > 2*plywood_thickness,
           "bob_body_structure: veneer leaves no room for the ribs");
    assert(structural_radius >= plywood_thickness,
           "bob_body_structure: veneer leaves too little rib corner radius");
    assert(front_plywood_y+plywood_thickness-
           front_face_y == front_stack_depth,
           "bob_body_structure: invalid front veneer/rib stack");

    color([0.72, 0.56, 0.33])
    if (show_ribs) {
        // The two side rails of the front termination frame are the fixed
        // chassis knuckles. Their coaxial bore is drilled along X after the
        // four frame segments have been glued.
        difference() {
            translate([
                veneer_thickness,
                front_plywood_y,
                veneer_thickness
            ])
                bob_rib_at_y(
                    0, structural_width, structural_height,
                    plywood_thickness, structural_radius,
                    fit_clearance, kerf);
            if (show_hinge_bores)
                translate([
                    -0.01,
                    plywood_thickness/2,
                    2.4*plywood_thickness
                ])
                    rotate([0,90,0])
                        cylinder(
                            h=model_width+0.02,
                            d=hinge_pin_diameter+
                              hinge_clearance);
        }

        // Rear termination frame.
        translate([veneer_thickness, 0, veneer_thickness])
            bob_rib_at_y(
                model_depth-plywood_thickness-veneer_thickness,
                structural_width, structural_height,
                plywood_thickness, structural_radius,
                fit_clearance, kerf);

        // Internal silhouette ribs.
        for (i = [0:rib_count-1])
            let(y = front_offset +
                    (usable_depth-plywood_thickness)*(i+1)/(rib_count+1))
                translate([
                    veneer_thickness, 0, veneer_thickness
                ])
                    bob_rib_at_y(
                        y, structural_width, structural_height,
                        plywood_thickness, structural_radius,
                        fit_clearance, kerf);

        bob_stringer_cage(
            model_width, model_height, model_depth,
            plywood_thickness, veneer_thickness);

        // Hidden structural base starts behind the front rib so the part of
        // the raised-hinge door below the pin has a clear opening sweep.
        // Lift it above the bottom veneer so the bridge can laminate to its
        // underside without intersecting the finished skin.
        translate([veneer_thickness+plywood_thickness,
                   2*plywood_thickness,
                   veneer_thickness+plywood_thickness])
            linear_extrude(plywood_thickness)
                bob_base_2d(
                    structural_width,
                    model_depth-veneer_thickness,
                    plywood_thickness);

        // The bridge remains entirely below the base/sweep plane. It butts
        // against the rear face of the front rib, spans the one-thickness
        // gap, and overlaps one thickness beneath the base.
        translate([
            corner_radius,
            plywood_thickness,
            veneer_thickness
        ])
            linear_extrude(plywood_thickness)
                bob_base_front_bridge_2d(
                    model_width,
                    corner_radius,
                    plywood_thickness);
    }

    if (show_skin)
        // The wrap starts at the front frame and ends where the rear face
        // veneer begins. The rib-spacing offsets must not expose either
        // termination rib.
        ribbed_veneer_shell(
            model_width, model_height, model_depth,
            rib_count=1,
            rib_thickness=plywood_thickness,
            rib_width=plywood_thickness,
            veneer_thickness=veneer_thickness,
            corner_radius=corner_radius,
            front_termination_offset=0,
            rear_termination_offset=veneer_thickness,
            show_ribs=false,
            show_skin=true,
            min_bend_radius=min_bend_radius,
            skin_opacity=veneer_opacity);

    if (show_skin) {
        // Rear cosmetic face.
        color([0.55, 0.28, 0.12])
            translate([0, model_depth, 0])
                rotate([90,0,0])
                    linear_extrude(veneer_thickness)
                        csh_rounded_rect_2d(
                            [model_width, model_height],
                            corner_radius);
    }
}
