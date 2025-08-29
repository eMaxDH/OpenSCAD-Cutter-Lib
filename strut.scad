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

include<strut_2d.scad>

module strut(width, height, thickness=10, type=["f", "f"], make_3d=false)
{
    if (make_3d)
        linear_extrude(thickness)
            strut_2d(width, height, type);
    else
        strut_2d(width, height, type);
}