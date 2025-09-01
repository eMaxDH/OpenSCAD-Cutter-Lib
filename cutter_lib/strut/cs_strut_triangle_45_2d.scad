//
// Create a strut with connectors
//
// Example
// -------
//     strut(100, 10, type=["f", "m"]);  
//         __________________________
//  ^     /                          \_
// 10   _|                             |
//  v  /                                \
//    ------------------------------------
//    <---             100             -->

//use <strut_2d.scad>
//strut_2d(100, 10, type=["f", "f"]);

use <../slot/cs_elongated_hole_2d.scad>
use <../connector/cc_connector_triangle_45.scad>

module cs_strut_triangle_45_2d_make_holes(strut_width, hole_radius, hole_distance, hole_length=0)
{
    function calculate_hole_positions(strut_width, hole_distance) =
        let (left_hole = (strut_width - hole_distance) / 2)
        let (right_hole = left_hole + hole_distance)
        [[left_hole, 0, 0], [right_hole, 0, 0]];
    
    positions = calculate_hole_positions(strut_width, hole_distance);
    difference()
    {
        children();
        union()
        {
            translate(positions[0])
                if (hole_length > 2*hole_radius)
                    cs_elongated_hole_2d(width=hole_length, height=hole_radius*2);
                else
                    circle(hole_radius);

            translate(positions[1])
                if (hole_length > 2*hole_radius)
                    cs_elongated_hole_2d(width=hole_length, height=hole_radius*2);
                else
                    circle(hole_radius);
        }
    }
}

module cs_strut_triangle_45_2d_base(width, height, type=["f", "f"]){
    if (width>=2*height)
    {
        cc_connector_triangle_45(height, type=type[0]);
        translate([height, 0, 0])
            square([width-2*height, height]);
        translate([width, 0, 0])
            mirror([1,0,0])
                cc_connector_triangle_45(height, type=type[1]);
    }
    else
    {
        color("red")
        text("[ERROR] cs_strut_triangle_45_2d_base: width<2*height");
    }
}

module cs_strut_triangle_45_2d(width, height, type=["f", "f"], hole_radius=2, hole_distance=10, hole_length=0){
    cs_strut_triangle_45_2d_make_holes(width, hole_radius, hole_distance, hole_length)
        cs_strut_triangle_45_2d_base(width, height, type=type);
}