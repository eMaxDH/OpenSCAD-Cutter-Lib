//
// Create a strut with connectors
//
// Example
// -------
//     strut(100, 10, type=["f", "m"]);  
//         __________________________
//  ^     /                          \_
// 10   _|                             |
//  v  /                    t=thickness \
//    ------------------------------------
//    <---             100             -->
use <../layer/cl_layer.scad>
use <cs_strut_triangle_45_2d.scad>

make_3d = false; // [false:true]

width = 293; //[10:10:300]
height = 5; //[5:5:100]
thickness = 4; //[1:1:20]

hole_radius=3;
hole_distance=236;
hole_length=8;

layer=0;
visibile_layers=[0];

cl_layer_info(visibile_layers);

cs_strut_triangle_45(width, height, thickness=thickness, type=["f", "f"],
        hole_radius=hole_radius, hole_distance=hole_distance, hole_length=hole_length,
        layer=0, visibile_layers=[], make_3d=make_3d);

module cs_strut_triangle_45(width, height, thickness=10, type=["f", "f"],
                            hole_radius=2, hole_distance=10, hole_length=0,
                            layer=0, visibile_layers=[], make_3d=false,)
{
    apply_cl_layer_visibility(layer, visibile_layers)
    if (make_3d)
        linear_extrude(thickness)
            cs_strut_triangle_45_2d(width=width, height=height, type=type, hole_radius=hole_radius, hole_distance=hole_distance, hole_length=hole_length);
    else
        cs_strut_triangle_45_2d(width=width, height=height, type=type, hole_radius=hole_radius, hole_distance=hole_distance, hole_length=hole_length);
}
