use <assembly_config.scad>
use <assembly_layout.scad>
use <../component/component.scad>

/* [Output] */
make_3d = true; // [false:true]
output_mode = "automatic"; // [automatic,assembly,cut_layout,single_part,calibration,debug]

/* [Dimensions] */
assembly_size = [80, 50, 45];
material_thickness = 3; // [1:0.5:8]

/* [Material] */
kerf = 0.15;         // [0:0.01:1]
fit_clearance = 0.1; // [-0.5:0.05:1]

/* [2D Layout] */
sheet_size = [300, 200];
sheet_margin = 5;
part_spacing = 5;
layout_operation = "cut"; // [cut,engrave,score,reference,all]

/* [Example] */
single_part_id = "TPL-SIDE-A"; // [TPL-SIDE-A,TPL-SIDE-B]

/* [Hidden] */
$fn = $preview ? 32 : 96;
resolved_output_mode = output_mode == "automatic"
    ? (make_3d ? "assembly" : "cut_layout")
    : output_mode;

tpl_assembly_entry(
    output_mode=resolved_output_mode,
    size=assembly_size,
    thickness=material_thickness,
    sheet_size=sheet_size,
    margin=sheet_margin,
    spacing=part_spacing,
    operation=layout_operation,
    single_part_id=single_part_id);

module tpl_assembly_entry(output_mode="assembly", size=[80, 50, 45],
                          thickness=3, sheet_size=[300, 200], margin=5,
                          spacing=5, operation="cut",
                          single_part_id="TPL-SIDE-A")
{
    assert(thickness > 0, "template assembly: thickness must be positive");

    if (output_mode == "assembly")
        tpl_assembly(size=size, thickness=thickness);
    else if (output_mode == "cut_layout")
        tpl_assembly_layout(sheet_size=sheet_size, margin=margin,
                            spacing=spacing, thickness=thickness,
                            operation=operation, make_3d=false);
    else if (output_mode == "single_part")
        tpl_component_plate(thickness=thickness, make_3d=false);
    else if (output_mode == "calibration")
        tpl_component_plate(size=[40, 20], thickness=thickness,
                            hole_diameter=thickness+0.1, make_3d=false);
    else if (output_mode == "debug")
        tpl_assembly(size=size, thickness=thickness);
    else
        assert(false, str("template assembly: unsupported output_mode ",
                          output_mode));
}

module tpl_assembly(size=[80, 50, 45], thickness=3)
{
    plate_size = [60, 30];
    translate([0, 0, 0])
        rotate([90, 0, 0])
            tpl_component_plate(size=plate_size, thickness=thickness,
                                make_3d=true);
    translate([0, size[1], 0])
        rotate([90, 0, 0])
            tpl_component_plate(size=plate_size, thickness=thickness,
                                make_3d=true, part_color="peru");
}
