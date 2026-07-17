$bob_config_embedded = true;
include <bob_config.scad>

use <../../cutter_lib/calibration/ccal_laser_coupon.scad>
use <../../cutter_lib/validation/cv_validation.scad>

use <bob_body.scad>
use <bob_door.scad>
use <bob_chamber.scad>
use <bob_rack.scad>
use <bob_layout.scad>

module bob_validate_configuration()
{
    assert(model_height > 0 && model_width > 0 && model_depth > 0,
           "Bob envelope dimensions must be positive");
    assert(plywood_thickness > 0 && veneer_thickness > 0,
           "Material thicknesses must be positive");
    assert(kerf >= 0 && fit_clearance >= 0,
           "Kerf and fit clearance must be non-negative");
    assert(sheet_size[0] > 2*sheet_margin &&
           sheet_size[1] > 2*sheet_margin,
           "Sheet margin consumes the sheet");
    assert(part_spacing >= kerf,
           "Part spacing should be at least one kerf");
    assert(shell_mode == "ribbed_veneer",
           "Only shell_mode=\"ribbed_veneer\" is implemented");
    assert(window_mode == "open" ||
           window_mode == "transparent_insert",
           "Unsupported window_mode");
    assert(layout_material == "all" ||
           layout_material == "plywood_1" ||
           layout_material == "plywood_2" ||
           layout_material == "veneer",
           "Unsupported layout_material");
    assert(layout_operation == "cut" ||
           layout_operation == "engrave" ||
           layout_operation == "preview",
           "Unsupported layout_operation");
    assert(door_angle >= 0 && door_angle <= 90,
           "door_angle must be between 0 and 90 degrees");
    assert(bob_door_bottom(model_height) >= plywood_thickness,
           "Door hinge is too close to the base");

    if (model_height < minimum_supported_height ||
        model_height > maximum_supported_height)
        echo(str("[WARNING] model_height=", model_height,
                 " is outside validated range [",
                 minimum_supported_height, ", ",
                 maximum_supported_height, "]"));
    if (shell_corner_radius < minimum_veneer_bend_radius)
        echo(str("[WARNING] shell bend radius ",
                 shell_corner_radius,
                 " is below recommended ",
                 minimum_veneer_bend_radius));
    if (kerf == 0.5)
        echo("[WARNING] kerf=0.5 is provisional; cut the calibration coupon first");
}

module bob_assembly(exploded=0, debug=false)
{
    bob_body_structure(
        model_width, model_height, model_depth,
        plywood_thickness, veneer_thickness,
        shell_rib_count, shell_corner_radius,
        shell_front_offset, shell_rear_offset,
        fit_clearance, kerf,
        show_rib_cage, show_veneer,
        minimum_veneer_bend_radius,
        veneer_opacity);

    if (show_chamber)
        bob_chamber_assembly(
            model_width, model_height, model_depth,
            plywood_thickness, exploded);

    if (rack_enabled)
        bob_rack_assembly(
            model_width, model_height, model_depth,
            plywood_thickness,
            rack_removable ? rack_pullout : 0,
            rack_removable,
            exploded);

    bob_door_assembly(
        model_width, model_height,
        plywood_thickness, veneer_thickness,
        door_angle,
        hinge_pin_diameter, hinge_clearance,
        hinge_axis_offset,
        window_mode, show_engraving,
        show_hinge,
        show_door_sweep || debug,
        exploded);

    if (debug) {
        // Nominal envelope and hinge-axis clearance references.
        %cube([model_width, model_depth, model_height]);
        %translate([0, -hinge_axis_offset,
                    bob_door_bottom(model_height)])
            rotate([0,90,0])
                cylinder(h=model_width,
                         d=hinge_pin_diameter+
                           2*hinge_clearance);
    }
}

selected_output_mode =
    output_mode == "automatic"
    ? (make_3d ? "assembly" : "cut_layout")
    : output_mode;

bob_validate_configuration();

echo(str("Bob scale factor: ", scale_factor,
         " (approximately 1:", 1/scale_factor, ")"));
echo(str("Bob envelope [W,D,H]: ",
         [model_width, model_depth, model_height]));

if (selected_output_mode == "assembly")
    bob_assembly();
else if (selected_output_mode == "exploded")
    bob_assembly(exploded=2);
else if (selected_output_mode == "debug")
    bob_assembly(debug=true);
else if (selected_output_mode == "cut_layout")
    bob_cut_layout(
        model_width, model_height, model_depth,
        plywood_thickness, veneer_thickness,
        kerf, fit_clearance,
        shell_rib_count, shell_corner_radius,
        shell_front_offset, shell_rear_offset,
        hinge_pin_diameter, hinge_clearance,
        sheet_size, sheet_margin, part_spacing,
        window_mode, layout_material,
        layout_operation);
else if (selected_output_mode == "calibration")
    ccal_laser_coupon(
        plywood_thickness, kerf,
        hinge_pin_diameter);
else if (selected_output_mode == "single_part") {
    if (single_part_id == "BOB-DOOR-FRAME")
        bob_door_frame_2d(
            bob_door_width(model_width),
            bob_door_height(model_height),
            max(5, plywood_thickness),
            min(6, bob_door_width(model_width)*0.12));
    else if (single_part_id == "BOB-RIB-01")
        bob_shell_rib_2d(
            model_width, model_height,
            plywood_thickness,
            shell_corner_radius,
            fit_clearance, kerf);
    else if (single_part_id == "BOB-CAL-01")
        ccal_laser_coupon(
            plywood_thickness, kerf,
            hinge_pin_diameter);
    else
        assert(false, str("Unknown single_part_id: ",
                          single_part_id));
}
else
    assert(false, str("Unknown output_mode: ",
                      selected_output_mode));
