include <strut.scad>

// include <frame.scad>
// frame(100, 50, thickness=7, make_3d=true);

module arrange_bottom_strut(width, height, frame_width, thickness, make_3d, spacing_2d)
{
    if (make_3d)
    {
        translate([0,0,0])
            children();
    }
    else
    {
        translate([0,0,0])
            children();
    }
}

module arrange_top_strut(width, height, frame_width, thickness, make_3d, spacing_2d)
{
    if (make_3d)
    {
        translate([0,height,0])
            mirror([0,1,0])
                children();
    }
    else
    {
        translate([0, 2 * (frame_width + spacing_2d), 0])
                children();
    }
}

module arrange_left_strut(width, height, frame_width, thickness, make_3d, spacing_2d)
{
    if (make_3d)
    {
        translate([0,0,0])
            rotate([0,0,-90])
            mirror([1,0,0])
                children();
    }
    else
    {
        translate([0, 3 * (frame_width + spacing_2d), 0])
                children();
    }
}

module arrange_right_strut(width, height, frame_width, thickness, make_3d, spacing_2d)
{
    if (make_3d)
    {
        translate([width,0,0])
            rotate([0,0,90])
                children();
    }
    else
    {
        translate([0, 4 * (frame_width + spacing_2d), 0])
                children();
    }
}

module frame(width, height, frame_width=10, thickness = 0, hole_radius=2, hole_distance=[10,10],
                make_3d=false, spacing_2d=1)
{
    // Create bottom strut
    color("red")
    arrange_bottom_strut(width, height, frame_width, thickness, make_3d, spacing_2d)
        strut(width=width, height=frame_width, thickness=thickness, type=["f", "f"],
                hole_radius=hole_radius, hole_distance=hole_distance[0],
                make_3d=make_3d);

    translate([0,0,0])
        strut(width=width, height=frame_width, thickness=thickness, type=["f", "f"],
                hole_radius=hole_radius, hole_distance=hole_distance[0],
                make_3d=make_3d);

    // Create top strut
    color("orange")
    arrange_top_strut(width, height, frame_width, thickness, make_3d, spacing_2d)
    {
        strut(width=width, height=frame_width, thickness=thickness, type=["f", "f"],
                hole_radius=hole_radius, hole_distance=hole_distance[0],
                make_3d=make_3d);
    }

    // Create left strut
    color("green")
    arrange_left_strut(width, height, frame_width, thickness, make_3d, spacing_2d)
        strut(width=height, height=frame_width, thickness=thickness, type=["m", "m"],
                hole_radius=hole_radius, hole_distance=hole_distance[1],
                make_3d=make_3d);

    // Create right strut
    color("violet")
    arrange_right_strut(width, height, frame_width, thickness, make_3d, spacing_2d)
        strut(width=height, height=frame_width, thickness=thickness, type=["m", "m"],
                hole_radius=hole_radius, hole_distance=hole_distance[1],
                make_3d=make_3d);

}

module frame_base_floor(width, height, frame_width=10, thickness = 0, hole_radius=2, hole_distance=[10,10],
                             make_3d=false, spacing_2d=1)
{
    // Create bottom strut
    color("red")
    arrange_bottom_strut(width, height, frame_width, thickness, make_3d, spacing_2d)
        strut(width=width, height=frame_width, thickness=thickness, type=["f", "f"],
                hole_radius=hole_radius, hole_distance=hole_distance[0],
                make_3d=make_3d);

    translate([0,0,0])
        strut(width=width, height=frame_width, thickness=thickness, type=["f", "f"],
                hole_radius=hole_radius, hole_distance=hole_distance[0],
                make_3d=make_3d);

    // Create top strut
    color("orange")
    arrange_top_strut(width, height, frame_width, thickness, make_3d, spacing_2d)
    {
        strut(width=width, height=frame_width, thickness=thickness, type=["f", "f"],
                hole_radius=hole_radius, hole_distance=hole_distance[0],
                make_3d=make_3d);
        mirror([0,1,0])
            strut(width=width, height=frame_width, thickness=thickness, type=["f", "f"],
                hole_radius=hole_radius, hole_distance=hole_distance[0],
                make_3d=make_3d);
    }

    // Create left strut
    color("green")
    arrange_left_strut(width, height, frame_width, thickness, make_3d, spacing_2d)
        strut(width=height, height=frame_width, thickness=thickness, type=["m", "m"],
                hole_radius=hole_radius, hole_distance=hole_distance[1],
                make_3d=make_3d);

    // Create right strut
    color("violet")
    arrange_right_strut(width, height, frame_width, thickness, make_3d, spacing_2d)
        strut(width=height, height=frame_width, thickness=thickness, type=["m", "m"],
                hole_radius=hole_radius, hole_distance=hole_distance[1],
                make_3d=make_3d);

}

module frame_additional(width, height, frame_width=10, thickness = 0, hole_radius=2, hole_distance=[10,10],
        make_3d=false, spacing_2d=1)
{
    // // Create bottom strut
    // color("red")
    // arrange_bottom_strut(width, height, frame_width, thickness, make_3d, spacing_2d)
    //     strut(width=width, height=frame_width, thickness=thickness, type=["f", "f"], make_3d=make_3d);

    // translate([0,0,0])
    //     strut(width=width, height=frame_width, thickness=thickness, type=["f", "f"], make_3d=make_3d);

    // Create top strut
    color("orange")
    arrange_top_strut(width, height, frame_width, thickness, make_3d, spacing_2d)
    {
        strut(width=width, height=frame_width, thickness=thickness, type=["f", "f"],
                hole_radius=hole_radius, hole_distance=hole_distance[0],
                make_3d=make_3d);
        mirror([0,1,0])
            strut(width=width, height=frame_width, thickness=thickness, type=["f", "f"],
                hole_radius=hole_radius, hole_distance=hole_distance[0],
                make_3d=make_3d);
    }

    // Create left strut
    color("green")
    arrange_left_strut(width, height, frame_width, thickness, make_3d, spacing_2d)
        strut(width=height, height=frame_width, thickness=thickness, type=["m", "m"],
                hole_radius=hole_radius, hole_distance=hole_distance[1],
                make_3d=make_3d);

    // Create right strut
    color("violet")
    arrange_right_strut(width, height, frame_width, thickness, make_3d, spacing_2d)
        strut(width=height, height=frame_width, thickness=thickness, type=["m", "m"],
                hole_radius=hole_radius, hole_distance=hole_distance[1],
                make_3d=make_3d);

}

