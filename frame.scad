include<strut.scad>

// frame(100, 50, thickness=thickness, make_3d=true);


module frame(width, height, frame_width=10, thickness = 0, make_3d=false, spacing_2d=1)
{
    t = make_3d ? thickness : 0;
    // Create bottom strut
    color("red")
    if (make_3d)
    {
        translate([0,0,0])
            strut(width=width, height=frame_width, thickness=t, type=["f", "f"]);
    }
    else
    {
        translate([0,0,0])
            strut(width=width, height=frame_width, thickness=t, type=["f", "f"]);
    }

    // Create top strut
    color("orange")
    if (make_3d)
    {
        translate([0,height,0])
            mirror([0,1,0])
                strut(width=width, height=frame_width, thickness=t, type=["f", "f"]);
    }
    else
    {
        translate([0, frame_width + spacing_2d, 0])
                strut(width=width, height=frame_width, thickness=t, type=["f", "f"]);
    }

    // Create left strut
    color("green")
    if (make_3d)
    {
        translate([0,0,0])
            rotate([0,0,-90])
                mirror([1,0,0])
                    strut(width=height, height=frame_width, thickness=t, type=["m", "m"]);
    }
    else
    {
        translate([0, 2 * (frame_width + spacing_2d), 0])
                strut(width=height, height=frame_width, thickness=t, type=["m", "m"]);
    }

    // Create right strut
    color("violet")
    if (make_3d)
    {
        translate([width,0,0])
            rotate([0,0,90])
                strut(width=height, height=frame_width, thickness=t, type=["m", "m"]);
    }
    else
    {
        translate([0, 3 * (frame_width + spacing_2d), 0])
                strut(width=height, height=frame_width, thickness=t, type=["m", "m"]);
    }

}

