use <../../cutter_lib/layout/cl_cut_layout.scad>
use <../component/component.scad>

/* [Output] */
make_3d = false; // [false:true]

/* [2D Layout] */
sheet_size = [300, 200];
sheet_margin = 5; // [0:1:20]
part_spacing = 5; // [0:1:20]
layout_operation = "cut"; // [cut,engrave,score,reference,all]

/* [Example] */
material_thickness = 3; // [1:0.5:8]

/* [Hidden] */

tpl_assembly_layout(
    sheet_size=sheet_size,
    margin=sheet_margin,
    spacing=part_spacing,
    thickness=material_thickness,
    operation=layout_operation,
    make_3d=make_3d);

module tpl_assembly_layout(sheet_size=[300, 200], margin=5, spacing=5,
                           thickness=3, operation="cut", make_3d=false)
{
    part_size = [60, 30];
    positions = [[margin, margin],
                 [margin+part_size[0]+spacing, margin]];
    boxes = [[positions[0][0], positions[0][1], part_size[0], part_size[1]],
             [positions[1][0], positions[1][1], part_size[0], part_size[1]]];

    cl_validate_layout(boxes, sheet_size, margin, spacing,
                       "template assembly sheet");

    if (!make_3d)
        cl_sheet_boundary(sheet_size, "TEMPLATE");

    for (i = [0:1])
        translate([positions[i][0], positions[i][1], 0])
            tpl_component_plate(
                size=part_size,
                thickness=thickness,
                make_3d=make_3d,
                part_color=i == 0 ? "burlywood" : "peru");
}
