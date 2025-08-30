module floor_connector(width, height, depth, thickness=10, make_3d=false)
{
    if (make_3d)
        linear_extrude(height)
            difference(){
                square([width, depth]);

                translate([thickness/2, thickness/2, 0])
                    square([width - thickness, depth - thickness]);
            }
}