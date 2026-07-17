// Bob dishwasher reference envelope and manufacturing configuration.
// Dimensions are millimetres.

/* [Output] */

// Automatic uses this checkbox: checked = assembly, unchecked = cutting layout.
make_3d = true; // [false:true]

output_mode = "automatic"; // [automatic, assembly, cut_layout, exploded, single_part, debug, calibration]
layout_material = "all"; // [all, plywood_1, plywood_2, veneer]
layout_operation = "cut"; // [cut, engrave, preview]
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
hinge_pin_diameter = 2; // [0.5:0.1:5]
hinge_clearance = 0.2; // [0:0.05:1]
hinge_axis_offset = 2.5; // [0.5:0.1:10]
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

// When this configuration file is opened directly, show its derived envelope.
// bob_dishwasher.scad sets $bob_config_embedded before including this file.
if (is_undef($bob_config_embedded)) {
    echo(str("Bob configured envelope [W,D,H]: ",
             [model_width, model_depth, model_height]));
    color([0.72, 0.45, 0.20, 0.35])
        difference() {
            cube([model_width, model_depth, model_height]);
            translate([1, 1, 1])
                cube([model_width-2,
                      model_depth-2,
                      model_height-2]);
        }
}
