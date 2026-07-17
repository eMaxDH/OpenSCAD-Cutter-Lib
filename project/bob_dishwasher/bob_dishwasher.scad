// OpenSCAD's Customizer reads annotated assignments from the file opened in
// the editor, but not from included files. Keep the entry-point parameters
// here so opening bob_dishwasher.scad exposes the complete control panel.

/* [Output] */

// Automatic uses this checkbox: checked = assembly, unchecked = cutting layout.
make_3d = true; // [false:true]

output_mode = "automatic"; // [automatic, assembly, cut_layout, exploded, single_part, debug, calibration]

/* [2D layout layers] */

// "preview" shows cutting and engraving together in OpenSCAD.
layout_material = "all"; // [all, plywood_1, plywood_2, veneer]
layout_operation = "preview"; // [preview, cut, engrave]

/* [Output part selection] */

single_part_id = "BOB-DOOR-FRAME"; // [BOB-DOOR-FRAME, BOB-RIB-01, BOB-CAL-01]

/* [Scale] */

model_height = 80; // [70:1:160]

source_width = 340; // [1:1:1000]
source_height = 490; // [1:1:1000]
source_depth = 490; // [1:1:1000]

/* [Materials and cutting] */

plywood_thickness = 4; // [1:0.1:10]
veneer_thickness = 0.6; // [0.1:0.1:3]
kerf = 0.5; // [0:0.05:1]
fit_clearance = 0.15; // [0:0.05:1]

sheet_size = [300, 300];
sheet_margin = 5; // [0:1:25]
part_spacing = 3; // [0.5:0.5:10]

/* [Door and hinge] */

door_angle = 90; // [0:1:90]
door_perimeter_gap = 0.4; // [0:0.1:2]
hinge_pin_diameter = 2; // [0.5:0.1:5]
hinge_clearance = 0.2; // [0:0.05:1]
// Distance from the cheek's rear edge to its hinge-hole centre.
hinge_axis_offset = 2.5; // [1.5:0.1:8]
show_hinge = true; // [false:true]
show_door_sweep = false; // [false:true]
window_mode = "open"; // [open, transparent_insert]

/* [Veneer shell and skeleton] */

shell_rib_count = 4; // [1:1:10]
shell_mode = "ribbed_veneer"; // [ribbed_veneer]
shell_corner_radius = model_height * 0.10;
shell_front_offset = plywood_thickness;
shell_rear_offset = plywood_thickness;
minimum_veneer_bend_radius = 5; // [1:0.5:20]

show_veneer = true; // [false:true]
show_rib_cage = true; // [false:true]
veneer_opacity = 0.58; // [0.1:0.05:1]

/* [Interior and details] */

rack_enabled = true; // [false:true]
rack_removable = true; // [false:true]
rack_pullout = 0; // [0:1:80]

show_engraving = true; // [false:true]
show_chamber = true; // [false:true]

/* [Hidden] */

scale_factor = model_height / source_height;
model_width = source_width * scale_factor;
model_depth = source_depth * scale_factor;

minimum_supported_height = 70;
maximum_supported_height = 160;

$fn = $preview ? 48 : 128;

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
    assert(door_perimeter_gap >= 0,
           "Door perimeter gap must be non-negative");

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
        exploded,
        door_perimeter_gap);

    if (debug) {
        // Nominal envelope and hinge-axis clearance references.
        %cube([model_width, model_depth, model_height]);
        %translate([-plywood_thickness, 0,
                    bob_door_bottom(
                        plywood_thickness,
                        door_perimeter_gap)])
            rotate([0,90,0])
                cylinder(h=model_width+
                           2*plywood_thickness,
                         d=hinge_pin_diameter+
                           2*hinge_clearance);
    }
}

// Like the lamp entry module, this keeps one make_3d switch at the top level:
// true assembles the parts; false places every manufactured part on XY sheets.
module bob_dishwasher(make_3d=true, output_mode="automatic")
{
    selected_output_mode =
        output_mode == "automatic"
        ? (make_3d ? "assembly" : "cut_layout")
        : output_mode;

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
            hinge_axis_offset, door_perimeter_gap,
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
                bob_door_width(
                    model_width, plywood_thickness,
                    door_perimeter_gap),
                bob_door_height(
                    model_height, plywood_thickness,
                    door_perimeter_gap),
                max(5, plywood_thickness),
                min(6, bob_door_width(
                    model_width, plywood_thickness,
                    door_perimeter_gap)*0.12));
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
}

bob_validate_configuration();

echo(str("Bob scale factor: ", scale_factor,
         " (approximately 1:", 1/scale_factor, ")"));
echo(str("Bob envelope [W,D,H]: ",
         [model_width, model_depth, model_height]));

bob_dishwasher(make_3d, output_mode);
