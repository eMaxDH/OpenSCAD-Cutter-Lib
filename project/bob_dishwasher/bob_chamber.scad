use <../../cutter_lib/materials/cm_manufacturing.scad>
use <../../cutter_lib/joints/cj_hidden_tabs.scad>

function bob_chamber_width(model_width, plywood_thickness) =
    model_width - 4*plywood_thickness;
function bob_chamber_height(model_height, plywood_thickness) =
    model_height - 6*plywood_thickness;
function bob_chamber_depth(model_depth, plywood_thickness) =
    model_depth - 4*plywood_thickness;

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
        translate([0, plywood_thickness/2])
            cj_hidden_slots_2d(
                depth, plywood_thickness, feature_width,
                tab_count, edge_margin=plywood_thickness,
                fit_clearance=fit_clearance, kerf=kerf);
        translate([0, height-plywood_thickness/2])
            cj_hidden_slots_2d(
                depth, plywood_thickness, feature_width,
                tab_count, edge_margin=plywood_thickness,
                fit_clearance=fit_clearance, kerf=kerf);
    }
}

module bob_chamber_assembly(model_width, model_height, model_depth,
                            plywood_thickness=4,
                            exploded=0)
{
    cw = bob_chamber_width(model_width, plywood_thickness);
    ch = bob_chamber_height(model_height, plywood_thickness);
    cd = bob_chamber_depth(model_depth, plywood_thickness);
    x0 = (model_width-cw)/2;
    y0 = 2*plywood_thickness;
    z0 = 2*plywood_thickness;

    assert(cw > 2*plywood_thickness &&
           ch > 2*plywood_thickness &&
           cd > 2*plywood_thickness,
           "bob_chamber_assembly: model is too small for chamber");

    color([0.72, 0.74, 0.72]) {
        // Floor and upper boundary.
        translate([x0, y0, z0-exploded])
            cube([cw, cd, plywood_thickness]);
        translate([x0, y0, z0+ch-plywood_thickness+exploded])
            cube([cw, cd, plywood_thickness]);

        // Rear wall.
        translate([x0, y0+cd-plywood_thickness+exploded,
                   z0])
            cube([cw, plywood_thickness, ch]);

        // Narrow side supports leave the chamber visually open.
        for (x = [x0, x0+cw-plywood_thickness])
            translate([x, y0, z0])
                cube([plywood_thickness, cd, ch]);
    }

    // Simplified spray-arm engraving/preview on the chamber floor.
    color([0.35, 0.38, 0.36])
        translate([model_width/2, y0+cd*0.55,
                   z0+plywood_thickness+0.1])
            linear_extrude(0.4)
                union() {
                    circle(d=3);
                    square([cw*0.55, 1.2], center=true);
                }
}
