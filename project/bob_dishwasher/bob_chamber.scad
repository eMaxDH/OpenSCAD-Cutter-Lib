use <../../cutter_lib/materials/cm_manufacturing.scad>
use <../../cutter_lib/joints/cj_hidden_tabs.scad>

/* [Example] */

make_3d = true; // [false:true]
example_model_height = 80; // [70:1:160]
example_plywood_thickness = 4; // [1:0.5:8]
example_veneer_thickness = 0.6; // [0.1:0.1:2]
example_skeleton_gap = 0.5; // [0:0.1:2]
example_exploded = 0; // [0:0.5:10]

/* [Hidden] */

example_model_width = 340 * example_model_height / 490;
example_model_depth = example_model_height;
example_chamber_width =
    bob_chamber_width(example_model_width,
                      example_plywood_thickness,
                      example_veneer_thickness,
                      example_skeleton_gap);
example_chamber_height =
    bob_chamber_height(example_model_height,
                       example_plywood_thickness,
                       example_veneer_thickness,
                       example_skeleton_gap);
example_chamber_depth =
    bob_chamber_depth(example_model_depth,
                      example_plywood_thickness,
                      example_veneer_thickness,
                      example_skeleton_gap);

if (make_3d)
    bob_chamber_assembly(
        example_model_width,
        example_model_height,
        example_model_depth,
        example_plywood_thickness,
        example_exploded,
        example_veneer_thickness,
        example_skeleton_gap);
else {
    bob_chamber_floor_2d(
        example_chamber_width,
        example_chamber_depth,
        example_plywood_thickness);
    translate([
        example_chamber_width+
        2*example_plywood_thickness+5, 0])
        bob_chamber_side_2d(
            example_chamber_depth,
            example_chamber_height,
            example_plywood_thickness);
    translate([
        example_chamber_width+
        2*example_plywood_thickness+5,
        example_chamber_height+5
    ])
        bob_chamber_rear_2d(
            bob_chamber_rear_width(
                example_chamber_width,
                example_plywood_thickness),
            example_chamber_height);
}

function bob_chamber_width(model_width, plywood_thickness,
                           veneer_thickness=0,
                           skeleton_gap=0) =
    model_width - 4*plywood_thickness -
    2*(veneer_thickness+skeleton_gap);
// Leave two material thicknesses below and above the chamber: the lower
// allowance contains the base/floor stack, and the upper allowance contains
// the top longitudinal stringers.
function bob_chamber_height(model_height, plywood_thickness,
                            veneer_thickness=0,
                            skeleton_gap=0) =
    model_height - 4*plywood_thickness -
    veneer_thickness-skeleton_gap;
function bob_chamber_depth(model_depth, plywood_thickness,
                           veneer_thickness=0,
                           skeleton_gap=0) =
    model_depth - 4*plywood_thickness -
    veneer_thickness-skeleton_gap;
function bob_chamber_rear_width(chamber_width, plywood_thickness=4) =
    chamber_width+2*plywood_thickness;

module bob_chamber_rear_2d(width, height)
{
    assert(width > 0 && height > 0,
           "bob_chamber_rear_2d: dimensions must be positive");
    square([width, height]);
}

module bob_chamber_spray_arm_2d(width, line_width=1.2)
{
    assert(width > 0 && line_width > 0,
           "bob_chamber_spray_arm_2d: dimensions must be positive");

    union() {
        circle(d=3);
        square([width*0.55, line_width], center=true);
    }
}

module bob_chamber_floor_2d(width, depth,
                            plywood_thickness=4,
                            fit_clearance=0.15,
                            kerf=0.5,
                            tab_count=3)
{
    feature_width = max(7, 2*plywood_thickness);

    union() {
        square([width, depth]);

        // Tabs enter the side supports and remain inside the shell.
        rotate([0,0,90])
            cj_hidden_tabs_2d(
                depth, plywood_thickness, feature_width,
                tab_count, edge_margin=plywood_thickness,
                fit_clearance=fit_clearance, kerf=kerf);
        translate([width, depth])
            rotate([0,0,-90])
                cj_hidden_tabs_2d(
                    depth, plywood_thickness, feature_width,
                    tab_count, edge_margin=plywood_thickness,
                    fit_clearance=fit_clearance, kerf=kerf);
    }
}

module bob_chamber_side_2d(depth, height,
                           plywood_thickness=4,
                           fit_clearance=0.15,
                           kerf=0.5,
                           tab_count=3)
{
    feature_width = max(7, 2*plywood_thickness);

    difference() {
        square([depth, height]);
        cj_hidden_edge_notches_2d(
            depth, plywood_thickness, feature_width,
            tab_count, edge_margin=plywood_thickness,
            fit_clearance=fit_clearance, kerf=kerf);
        translate([0, height])
            mirror([0,1])
            cj_hidden_edge_notches_2d(
                depth, plywood_thickness, feature_width,
                tab_count, edge_margin=plywood_thickness,
                fit_clearance=fit_clearance, kerf=kerf);
    }
}

module bob_chamber_assembly(model_width, model_height, model_depth,
                            plywood_thickness=4,
                            exploded=0,
                            veneer_thickness=0.6,
                            skeleton_gap=0.5)
{
    cw = bob_chamber_width(
        model_width, plywood_thickness,
        veneer_thickness, skeleton_gap);
    ch = bob_chamber_height(
        model_height, plywood_thickness,
        veneer_thickness, skeleton_gap);
    cd = bob_chamber_depth(
        model_depth, plywood_thickness,
        veneer_thickness, skeleton_gap);
    rear_width = bob_chamber_rear_width(
        cw, plywood_thickness);
    x0 = (model_width-cw)/2;
    y0 = 2*plywood_thickness;
    z0 = 2*plywood_thickness;

    assert(cw > 2*plywood_thickness &&
           ch > 2*plywood_thickness &&
           cd > 2*plywood_thickness,
           "bob_chamber_assembly: model is too small for chamber");
    assert(skeleton_gap >= 0,
           "bob_chamber_assembly: skeleton_gap must be non-negative");

    color([0.72, 0.74, 0.72]) {
        // Use the actual tabbed profiles. The main floor/top panels sit
        // between the side walls; only their tabs enter the matching slots.
        translate([x0, y0, z0-exploded])
            linear_extrude(plywood_thickness)
                bob_chamber_floor_2d(
                    cw, cd, plywood_thickness,
                    fit_clearance=0.15, kerf=0);
        translate([x0, y0, z0+ch-plywood_thickness+exploded])
            linear_extrude(plywood_thickness)
                bob_chamber_floor_2d(
                    cw, cd, plywood_thickness,
                    fit_clearance=0.15, kerf=0);

        // The rear closes the outside of the chamber and spans across both
        // side-wall ends instead of fitting only between their inner faces.
        translate([x0-plywood_thickness,
                   y0+cd+plywood_thickness+exploded,
                   z0])
            rotate([90,0,0])
                linear_extrude(plywood_thickness)
                    bob_chamber_rear_2d(rear_width, ch);

        // Side walls lie outside the clear chamber width. Their real slot
        // profiles receive the floor and top tabs without solid collisions.
        for (x = [x0-plywood_thickness, x0+cw])
            translate([x, y0, z0])
                rotate([90,0,90])
                    linear_extrude(plywood_thickness)
                        bob_chamber_side_2d(
                            cd, ch, plywood_thickness,
                            fit_clearance=0.15, kerf=0);
    }

    // Simplified spray-arm engraving/preview on the chamber floor.
    color([0.35, 0.38, 0.36])
        translate([model_width/2, y0+cd*0.55,
                   z0+plywood_thickness+0.1])
            linear_extrude(0.4)
                bob_chamber_spray_arm_2d(cw);
}
