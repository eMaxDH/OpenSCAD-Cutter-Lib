/* [Output] */
make_3d = true; // [false:true]

/* [Dimensions] */
example_width = 80;             // [40:5:160]
example_depth = 50;             // [30:5:120]
example_height = 45;            // [20:5:100]
example_material_thickness = 3; // [1:0.5:8]

/* [Example] */
show_dimension_blocks = true;

/* [Hidden] */

if (show_dimension_blocks)
    tpl_config_example(
        width=example_width,
        depth=example_depth,
        height=example_height,
        thickness=example_material_thickness,
        make_3d=make_3d);

function tpl_default_size() = [80, 50, 45];
function tpl_default_thickness() = 3;
function tpl_default_sheet_size() = [300, 200];

// A configuration file still supplies a useful standalone scale example.
module tpl_config_example(width=80, depth=50, height=45, thickness=3,
                          make_3d=false)
{
    sizes = [[width, thickness], [depth, thickness], [height, thickness]];
    for (i = [0:2])
        translate([0, i*(thickness+4)])
            if (make_3d)
                linear_extrude(height=thickness)
                    square(sizes[i]);
            else
                square(sizes[i]);
}
