use <../../cutter_lib/materials/cm_manufacturing.scad>
use <../../cutter_lib/shells/csh_ribbed_veneer.scad>

function bob_inner_width(model_width, plywood_thickness) =
    model_width - 2*plywood_thickness;

function bob_inner_depth(model_depth, plywood_thickness) =
    model_depth - 2*plywood_thickness;

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

module bob_rib_at_y(y, model_width, model_height,
                    plywood_thickness=4,
                    corner_radius=8,
                    fit_clearance=0.15,
                    kerf=0.5)
{
    translate([0, y+plywood_thickness, 0])
        rotate([90,0,0])
            linear_extrude(plywood_thickness)
                bob_shell_rib_2d(
                    model_width, model_height,
                    plywood_thickness, corner_radius,
                    fit_clearance, kerf);
}

module bob_stringer_cage(model_width, model_height, model_depth,
                         plywood_thickness=4)
{
    length = model_depth-2*plywood_thickness;
    inset = 1.5*plywood_thickness;

    assert(length > 0, "bob_stringer_cage: model is too shallow");

    for (x = [inset, model_width-inset-plywood_thickness])
        for (z = [inset, model_height-inset-plywood_thickness])
            translate([x, plywood_thickness, z])
                cube([plywood_thickness, length, plywood_thickness]);
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
                          min_bend_radius=5)
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
            cube([bob_inner_width(model_width, plywood_thickness),
                  bob_inner_depth(model_depth, plywood_thickness),
                  plywood_thickness]);
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
            min_bend_radius=min_bend_radius);

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
