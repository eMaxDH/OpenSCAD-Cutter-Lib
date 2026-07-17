use <../../cutter_lib/trays/ctr_removable_tray.scad>
use <bob_chamber.scad>

function bob_rack_size(model_width, model_depth, plywood_thickness) =
    [bob_chamber_width(model_width, plywood_thickness)-
     2*plywood_thickness,
     bob_chamber_depth(model_depth, plywood_thickness)-
     4*plywood_thickness];

module bob_rack_assembly(model_width, model_height, model_depth,
                         plywood_thickness=4,
                         pullout=0,
                         removable=true,
                         exploded=0)
{
    chamber_w = bob_chamber_width(model_width, plywood_thickness);
    chamber_d = bob_chamber_depth(model_depth, plywood_thickness);
    rack = bob_rack_size(
        model_width, model_depth, plywood_thickness);
    x0 = (model_width-rack[0])/2;
    y0 = 2*plywood_thickness+2*plywood_thickness-pullout;
    z0 = 3*plywood_thickness+exploded;

    assert(rack[0] > 10 && rack[1] > 10,
           "bob_rack_assembly: rack is too small");
    assert(pullout >= 0,
           "bob_rack_assembly: pullout must be non-negative");
    if (!removable && pullout > 0)
        echo("[WARNING] bob_rack_assembly: pullout ignored conceptually when rack_removable=false");

    // Tray support ledges.
    color([0.60, 0.47, 0.28])
    for (x = [(model_width-chamber_w)/2,
              (model_width+chamber_w)/2-plywood_thickness])
        translate([x, 2*plywood_thickness,
                   z0-plywood_thickness])
            tray_runner(
                chamber_d,
                width=plywood_thickness,
                height=plywood_thickness/2,
                stop_height=plywood_thickness/2,
                make_3d=true);

    color([0.78, 0.62, 0.36])
        translate([x0, y0, z0])
            removable_tray(
                rack,
                thickness=plywood_thickness/2,
                corner_radius=2,
                grip_width=min(14, rack[0]/2),
                grip_depth=4,
                dish_slots=4,
                dish_slot_width=2,
                make_3d=true);

    // Low, robust side rails instead of fragile miniature wire tines.
    color([0.72, 0.54, 0.30])
    for (x = [x0, x0+rack[0]-plywood_thickness/2])
        translate([x, y0, z0+plywood_thickness/2])
            cube([plywood_thickness/2,
                  rack[1], plywood_thickness]);
}

