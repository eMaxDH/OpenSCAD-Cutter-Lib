use <../../cutter_lib/materials/cm_manufacturing.scad>
use <../../cutter_lib/shells/csh_ribbed_veneer.scad>
use <../../cutter_lib/joints/cj_hidden_tabs.scad>

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
        example_model_width,
        example_model_height,
        example_plywood_thickness,
        example_corner_radius,
        0.15, 0.5);

function bob_inner_width(model_width, plywood_thickness) =
    model_width - 2*plywood_thickness;

function bob_inner_depth(model_depth, plywood_thickness) =
    model_depth - 2*plywood_thickness;

module bob_base_2d(model_width, model_depth, plywood_thickness=4)
{
    square([
        bob_inner_width(model_width, plywood_thickness),
        bob_inner_depth(model_depth, plywood_thickness)
    ]);
}

module bob_stringer_2d(model_depth, plywood_thickness=4)
{
    square([
        plywood_thickness,
        bob_inner_depth(model_depth, plywood_thickness)
    ]);
}

// Bob-specific rib: generic rounded shell silhouette plus hidden stringer
// registration slots. The slots remain behind the veneer.
module bob_shell_rib_2d(model_width, model_height,
                        plywood_thickness=4,
                        corner_radius=8,
                        fit_clearance=0.15,
                        kerf=0.5)
{
    sw = slot_width(plywood_thickness, fit_clearance, kerf);
    slot_length = 2*plywood_thickness;
    x_inset = plywood_thickness + slot_length/2;
    z_inset = plywood_thickness + slot_length/2;

    shell_rib(model_width, model_height,
              rib_width=plywood_thickness,
              corner_radius=corner_radius) {
        translate([x_inset, z_inset])
            square([slot_length, sw], center=true);
        translate([model_width-x_inset, z_inset])
            square([slot_length, sw], center=true);
        translate([x_inset, model_height-z_inset])
            square([slot_length, sw], center=true);
        translate([model_width-x_inset, model_height-z_inset])
            square([slot_length, sw], center=true);
    }
}

function bob_rib_cap_height(corner_radius, plywood_thickness) =
    corner_radius+plywood_thickness;
function bob_rib_cap_piece_height(corner_radius, plywood_thickness) =
    bob_rib_cap_height(corner_radius, plywood_thickness)+
    plywood_thickness;
function bob_rib_side_length(model_height, corner_radius,
                             plywood_thickness) =
    model_height-
    2*bob_rib_cap_height(corner_radius, plywood_thickness);

module bob_rib_cap_2d(model_width, model_height,
                      plywood_thickness=4,
                      corner_radius=8,
                      top=false,
                      fit_clearance=0.15,
                      kerf=0.5)
{
    cap_h = bob_rib_cap_height(
        corner_radius, plywood_thickness);
    tab_feature = plywood_thickness/2;

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
                square([model_width, cap_h]);
            }
            for (x = [0, model_width-plywood_thickness])
                translate([x, cap_h])
                    cj_hidden_tabs_2d(
                        plywood_thickness,
                        plywood_thickness,
                        tab_feature,
                        count=1, edge_margin=0,
                        fit_clearance=fit_clearance,
                        kerf=kerf);
        }
    else
        translate([0, plywood_thickness])
            union() {
                translate([0, -(model_height-cap_h)])
                    intersection() {
                        bob_shell_rib_2d(
                            model_width, model_height,
                            plywood_thickness, corner_radius,
                            fit_clearance, kerf);
                        translate([0, model_height-cap_h])
                            square([model_width, cap_h]);
                    }
                for (x = [0, model_width-plywood_thickness])
                    translate([x, 0])
                        mirror([0,1])
                            cj_hidden_tabs_2d(
                                plywood_thickness,
                                plywood_thickness,
                                tab_feature,
                                count=1, edge_margin=0,
                                fit_clearance=fit_clearance,
                                kerf=kerf);
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
    slot_depth = slot_width(
        plywood_thickness, fit_clearance, kerf);

    difference() {
        square([plywood_thickness, side_length]);
        for (y = [
            slot_depth/2,
            side_length-slot_depth/2
        ])
            translate([0, y])
                cj_hidden_slots_2d(
                    plywood_thickness,
                    plywood_thickness,
                    plywood_thickness/2,
                    count=1, edge_margin=0,
                    fit_clearance=fit_clearance,
                    kerf=kerf);
    }
}

module bob_segmented_shell_rib_2d(
    model_width, model_height,
    plywood_thickness=4,
    corner_radius=8,
    fit_clearance=0.15,
    kerf=0)
{
    cap_h = bob_rib_cap_height(
        corner_radius, plywood_thickness);
    side_length = bob_rib_side_length(
        model_height, corner_radius, plywood_thickness);

    bob_rib_cap_2d(
        model_width, model_height,
        plywood_thickness, corner_radius,
        false, fit_clearance, kerf);
    translate([
        0,
        model_height-
        bob_rib_cap_piece_height(
            corner_radius, plywood_thickness)
    ])
        bob_rib_cap_2d(
            model_width, model_height,
            plywood_thickness, corner_radius,
            true, fit_clearance, kerf);
    for (x = [0, model_width-plywood_thickness])
        translate([x, cap_h])
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
                         plywood_thickness=4)
{
    length = model_depth-2*plywood_thickness;
    x_positions = [
        2*plywood_thickness,
        model_width-3*plywood_thickness
    ];
    z_positions = [
        plywood_thickness,
        model_height-2*plywood_thickness
    ];

    assert(length > 0, "bob_stringer_cage: model is too shallow");

    for (x = x_positions)
        for (z = z_positions)
            translate([x, plywood_thickness, z])
                linear_extrude(plywood_thickness)
                    bob_stringer_2d(
                        model_depth, plywood_thickness);
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
                          veneer_opacity=0.58)
{
    usable_depth = model_depth-front_offset-rear_offset;
    assert(rib_count >= 1, "bob_body_structure: at least one rib is required");

    color([0.72, 0.56, 0.33])
    if (show_ribs) {
        // Front and rear termination frames.
        bob_rib_at_y(0, model_width, model_height,
                     plywood_thickness, corner_radius,
                     fit_clearance, kerf);
        bob_rib_at_y(model_depth-plywood_thickness,
                     model_width, model_height,
                     plywood_thickness, corner_radius,
                     fit_clearance, kerf);

        // Internal silhouette ribs.
        for (i = [0:rib_count-1])
            let(y = front_offset +
                    (usable_depth-plywood_thickness)*(i+1)/(rib_count+1))
                bob_rib_at_y(y, model_width, model_height,
                             plywood_thickness, corner_radius,
                             fit_clearance, kerf);

        bob_stringer_cage(
            model_width, model_height, model_depth,
            plywood_thickness);

        // Hidden structural base.
        translate([plywood_thickness, plywood_thickness,
                   plywood_thickness])
            linear_extrude(plywood_thickness)
                bob_base_2d(
                    model_width, model_depth,
                    plywood_thickness);
    }

    if (show_skin)
        ribbed_veneer_shell(
            model_width, model_height, model_depth,
            rib_count=1,
            rib_thickness=plywood_thickness,
            rib_width=plywood_thickness,
            veneer_thickness=veneer_thickness,
            corner_radius=corner_radius,
            front_termination_offset=front_offset,
            rear_termination_offset=rear_offset,
            show_ribs=false,
            show_skin=true,
            min_bend_radius=min_bend_radius,
            skin_opacity=veneer_opacity);

    if (show_skin) {
        // Front cosmetic termination ring and rear cosmetic face.
        color([0.55, 0.28, 0.12])
            translate([0, 0, 0])
                rotate([90,0,0])
                    linear_extrude(veneer_thickness)
                        shell_rib(
                            model_width, model_height,
                            rib_width=plywood_thickness,
                            corner_radius=corner_radius);

        color([0.55, 0.28, 0.12])
            translate([0, model_depth, 0])
                rotate([90,0,0])
                    linear_extrude(veneer_thickness)
                        csh_rounded_rect_2d(
                            [model_width, model_height],
                            corner_radius);
    }
}
