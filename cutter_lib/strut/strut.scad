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

use <strut_2d.scad>

make_3d = false; // [false:true]

width = 100; //[10:10:200]
height = 20; //[5:5:100]
thickness = 10; //[1:1:20]

hole_radius=10;
hole_distance=100;
hole_length=5;

strut(width, height, thickness=thickness, type=["f", "f"],
        hole_radius=hole_radius, hole_distance=hole_distance, hole_length=hole_length,
        make_3d=make_3d);

module strut(width, height, thickness=10, type=["f", "f"], make_3d=false, hole_radius=2, hole_distance=10, hole_length=0)
{
    if (make_3d)
        linear_extrude(thickness)
            strut_2d(width, height, type=type, hole_radius=hole_radius, hole_distance=hole_distance, hole_length=hole_length);
    else
        strut_2d(width, height, type=type, hole_radius=hole_radius, hole_distance=hole_distance, hole_length=hole_length);
}
