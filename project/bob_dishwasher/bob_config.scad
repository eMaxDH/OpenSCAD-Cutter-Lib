// Bob dishwasher reference envelope and manufacturing configuration.
// Dimensions are millimetres.

model_height = 80;

source_width = 340;
source_height = 490;
source_depth = 490;

scale_factor = model_height / source_height;
model_width = source_width * scale_factor;
model_depth = source_depth * scale_factor;

plywood_thickness = 4;
veneer_thickness = 0.6;
kerf = 0.5;                 // Provisional: calibrate for material and machine.
fit_clearance = 0.15;

sheet_size = [300, 300];
sheet_margin = 5;
part_spacing = 3;

door_angle = 90;
hinge_pin_diameter = 2;
hinge_clearance = 0.2;
hinge_axis_offset = 2.5;
show_door_sweep = false;

shell_rib_count = 4;        // Internal ribs; front/rear frames are additional.
shell_mode = "ribbed_veneer";
shell_corner_radius = model_height * 0.10;
shell_front_offset = plywood_thickness;
shell_rear_offset = plywood_thickness;
minimum_veneer_bend_radius = 5;

window_mode = "open";       // Future/preview option: "transparent_insert".
rack_enabled = true;
rack_removable = true;
rack_pullout = 0;           // Increase to slide rack out through the front.

show_engraving = true;
show_veneer = true;
show_rib_cage = false;
show_chamber = true;
show_hinge = true;

output_mode = "assembly";
// "assembly", "cut_layout", "exploded", "single_part", "debug", "calibration"
layout_material = "all";
// "all", "plywood_1", "plywood_2", "veneer"
layout_operation = "cut";
// "cut", "engrave", "preview"
single_part_id = "BOB-DOOR-FRAME";

minimum_supported_height = 70;
maximum_supported_height = 160;

$fn = $preview ? 48 : 128;
