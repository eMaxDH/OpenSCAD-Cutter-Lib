use <../../cutter_lib/trays/ctr_removable_tray.scad>
use <bob_chamber.scad>

/* [Example] */

make_3d = true; // [false:true]
example_model_height = 80; // [70:1:160]
example_plywood_thickness = 4; // [1:0.5:8]
example_veneer_thickness = 0.6; // [0.1:0.1:2]
example_chamber_skeleton_gap = 0.5; // [0:0.1:2]
example_pullout = 0; // [0:1:80]

/* [Hidden] */

example_model_width = 340 * example_model_height / 490;
example_model_depth = example_model_height;
example_rack_size = bob_rack_size(
    example_model_width,
    example_model_depth,
    example_plywood_thickness,
    example_veneer_thickness,
    example_chamber_skeleton_gap);

if (make_3d)
    bob_rack_assembly(
        example_model_width,
        example_model_height,
        example_model_depth,
        example_plywood_thickness,
        example_pullout,
        veneer_thickness=example_veneer_thickness,
        chamber_skeleton_gap=example_chamber_skeleton_gap);
else
    bob_rack_base_2d(
        example_rack_size,
        corner_radius=bob_rack_corner_radius(),
        grip_width=min(14, example_rack_size[0]/2),
        grip_depth=4,
        dish_slots=4,
        dish_slot_width=2);

function bob_rack_size(model_width, model_depth, plywood_thickness,
                       veneer_thickness=0,
                       chamber_skeleton_gap=0) =
    [bob_chamber_width(
         model_width, plywood_thickness,
         veneer_thickness, chamber_skeleton_gap)-
     plywood_thickness,
     bob_chamber_depth(
         model_depth, plywood_thickness,
         veneer_thickness, chamber_skeleton_gap)-
     bob_rack_front_clearance(plywood_thickness)-
     bob_rack_rear_clearance(plywood_thickness)];
function bob_rack_front_clearance(plywood_thickness=4) =
    plywood_thickness;
function bob_rack_rear_clearance(plywood_thickness=4) =
    plywood_thickness/2;
function bob_rack_runner_span(
    model_width, plywood_thickness,
    veneer_thickness=0,
    chamber_skeleton_gap=0) =
    bob_chamber_width(
        model_width, plywood_thickness,
        veneer_thickness, chamber_skeleton_gap)-
    2*plywood_thickness;

function bob_rack_corner_radius() = 2;
function bob_rack_side_rail_length(
    rack_depth, front_corner_radius=2, rail_width=2) =
    rack_depth-front_corner_radius-rail_width;
function bob_rack_back_rail_length(rack_width) = rack_width;

module bob_rack_outline_2d(size, front_corner_radius=2)
{
    assert(size[0] > 2*front_corner_radius &&
           size[1] > front_corner_radius,
           "bob_rack_outline_2d: corner radius consumes rack");

    // The grip/front edge is rounded; the rear edge is deliberately square.
    union() {
        translate([front_corner_radius, 0])
            square([
                size[0]-2*front_corner_radius,
                size[1]
            ]);
        translate([0, front_corner_radius])
            square([
                size[0],
                size[1]-front_corner_radius
            ]);
        translate([
            front_corner_radius,
            front_corner_radius
        ])
            circle(r=front_corner_radius);
        translate([
            size[0]-front_corner_radius,
            front_corner_radius
        ])
            circle(r=front_corner_radius);
    }
}

module bob_rack_base_2d(size, corner_radius=2,
                        grip_width=14, grip_depth=4,
                        dish_slots=4, dish_slot_width=2)
{
    difference() {
        bob_rack_outline_2d(size, corner_radius);
        translate([size[0]/2, grip_depth/2])
            finger_grip_2d(grip_width, grip_depth);
        dish_slot_pattern_2d(
            [size[0], size[1]-2*grip_depth],
            dish_slot_width,
            size[1]/3,
            dish_slots,
            margin=4);
    }
}

module bob_rack_side_rail_2d(length, plywood_thickness=4)
{
    assert(length > 0 && plywood_thickness > 0,
           "bob_rack_side_rail_2d: dimensions must be positive");
    square([plywood_thickness/2, length]);
}

module bob_rack_back_rail_2d(length, plywood_thickness=4)
{
    assert(length > 0 && plywood_thickness > 0,
           "bob_rack_back_rail_2d: dimensions must be positive");
    square([length, plywood_thickness/2]);
}

module bob_rack_assembly(model_width, model_height, model_depth,
                         plywood_thickness=4,
                         pullout=0,
                         removable=true,
                         exploded=0,
                         veneer_thickness=0.6,
                         chamber_skeleton_gap=0.5)
{
    chamber_d = bob_chamber_depth(
        model_depth, plywood_thickness,
        veneer_thickness, chamber_skeleton_gap);
    rack = bob_rack_size(
        model_width, model_depth, plywood_thickness,
        veneer_thickness, chamber_skeleton_gap);
    corner_radius = bob_rack_corner_radius();
    rail_width = plywood_thickness/2;
    side_rail_length = bob_rack_side_rail_length(
        rack[1], corner_radius, rail_width);
    back_rail_length = bob_rack_back_rail_length(rack[0]);
    x0 = (model_width-rack[0])/2;
    runner_span = bob_rack_runner_span(
        model_width, plywood_thickness,
        veneer_thickness, chamber_skeleton_gap);
    runner_x0 = (model_width-runner_span)/2;
    y0 = 2*plywood_thickness+
         bob_rack_front_clearance(plywood_thickness)-
         pullout;
    chamber_floor_top = 3*plywood_thickness;
    runner_height = plywood_thickness/2;
    runner_z = chamber_floor_top+exploded;
    rack_z = runner_z+runner_height;

    assert(rack[0] > 10 && rack[1] > 10,
           "bob_rack_assembly: rack is too small");
    assert(pullout >= 0,
           "bob_rack_assembly: pullout must be non-negative");
    if (!removable && pullout > 0)
        echo("[WARNING] bob_rack_assembly: pullout ignored conceptually when rack_removable=false");

    // Tray support ledges.
    color([0.60, 0.47, 0.28])
    // Keep the established chamber-runner coordinates. The wider rack
    // overhangs these supports symmetrically.
    for (x = [
        runner_x0,
        runner_x0+runner_span-plywood_thickness
    ])
        translate([x, 2*plywood_thickness,
                   runner_z])
            tray_runner(
                chamber_d,
                width=plywood_thickness,
                height=runner_height,
                stop_height=runner_height,
                make_3d=true);

    color([0.78, 0.62, 0.36])
        translate([x0, y0, rack_z])
            linear_extrude(plywood_thickness/2)
                bob_rack_base_2d(
                    rack,
                    corner_radius=corner_radius,
                    grip_width=min(14, rack[0]/2),
                    grip_depth=4,
                    dish_slots=4,
                    dish_slot_width=2);

    // Low, robust side rails instead of fragile miniature wire tines.
    color([0.72, 0.54, 0.30])
    for (x = [x0, x0+rack[0]-rail_width])
        translate([x, y0+corner_radius,
                   rack_z+plywood_thickness/2])
            linear_extrude(plywood_thickness)
                bob_rack_side_rail_2d(
                    side_rail_length,
                    plywood_thickness);

    // Rear rail closes the rack between the two rounded back corners.
    color([0.72, 0.54, 0.30])
        translate([
            x0,
            y0+rack[1]-rail_width,
            rack_z+plywood_thickness/2
        ])
            linear_extrude(plywood_thickness)
                bob_rack_back_rail_2d(
                    back_rail_length,
                    plywood_thickness);
}
