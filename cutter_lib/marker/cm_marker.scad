use <../layer/cl_layer.scad>
use <../surfaces/cs_test_surface.scad>
use <../shapes/cshape_array.scad>

make_3d=true;

width = 100; //[10:100]
height = 10; //[5:30]
ticks = 11; //[2:20]

number=1;

visibile_layers=[0,1,2];

cl_layer_info(visibile_layers);

apply_cl_layer_visibility(layer=-1, visibile_layers=visibile_layers)
translate([0,0,-1])
square([width,height*1.2]);

cm_marker_ruler(width=width, height=height,  ticks=ticks, make_3d=make_3d);

module cm_marker_ruler(width, height, ticks, tick_width=0.1, tick_height=10,
                        layer=0, layer_visibility=[],
                        make_3d=false)
{
    element_size = get_cshape_array_element_size(width=width, height=height,
                                                no_elements_sum=ticks-1, no_elements_x=ticks-1);
    color("green")
    apply_cl_layer_visibility(layer=layer, visibile_layers=visibile_layers)
    cshape_array_repeat(width+element_size[0], height,
                        repeat=ticks,
                        no_elements_x=ticks,
                        array_plane="xy",
                        make_3d=make_3d, spacing_2d=0)
    {
        if (make_3d)
        {
            linear_extrude(1)
            square([tick_width,tick_height]);
        }
        else
        {
            square([tick_width,tick_height]);
        }
    }
}