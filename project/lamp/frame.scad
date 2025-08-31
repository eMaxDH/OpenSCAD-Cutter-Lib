use <../../cutter_lib/shapes/cshape_frame.scad>
use <../../cutter_lib/strut/cs_strut_triangle_45.scad>

make_3d=false;

width= 293;
height= 220;
thickness = 4;

frame_width=10;

frame_front(width, height, frame_width, thickness = thickness, make_3d=make_3d, spacing_2d=1);

module frame_front(width, height, frame_width, thickness = thickness, make_3d=make_3d, spacing_2d=1)
{
    hole_radius=[1.5,
                 0,
                 0,
                 1.5];
    hole_distance=[266,
                   0,
                   0,
                   266];
    hole_length=5;

    size_strut = [[width,frame_width],
              [height,frame_width],
              [height,frame_width],
              [width,frame_width]];

    cshape_frame_arrange(width=width, height=height, frame_width=frame_width, thickness = thickness, overlap=true, make_3d=make_3d, spacing_2d=1)
    {
        // 0: top
        color("yellow")
        translate([0,frame_width,0])
        mirror([0,1,0])
        cs_strut_triangle_45(width=size_strut[0][0], height=size_strut[0][1], thickness=thickness, type=["f", "f"],
                            hole_radius=hole_radius[0], hole_distance=hole_distance[0], hole_length=hole_length,
                            make_3d=make_3d);
        // 1: left
        color("green")
        translate([0,frame_width,0])
        mirror([0,1,0])
        cs_strut_triangle_45(width=size_strut[1][0], height=size_strut[1][1], thickness=thickness, type=["m", "m"],
                            hole_radius=hole_radius[1], hole_distance=hole_distance[1], hole_length=hole_length,
                            make_3d=make_3d);
        // 2: right
        color("red")
        translate([0,frame_width,0])
        mirror([0,1,0])
        cs_strut_triangle_45(width=size_strut[2][0], height=size_strut[2][1], thickness=thickness, type=["m", "m"],
                            hole_radius=hole_radius[2], hole_distance=hole_distance[2], hole_length=hole_length,
                            make_3d=make_3d);
        // 3: bottom
        color("violet")
        translate([0,frame_width,0])
        mirror([0,1,0])
        cs_strut_triangle_45(width=size_strut[3][0], height=size_strut[3][1], thickness=thickness, type=["f", "f"],
                            hole_radius=hole_radius[3], hole_distance=hole_distance[3], hole_length=hole_length,
                            make_3d=make_3d);
    }
}

module frame_back(width, height, frame_width, thickness = thickness, make_3d=make_3d, spacing_2d=1)
{
    hole_radius=[1.5,
                 0,
                 0,
                 1.5];
    hole_distance=[266,
                   0,
                   0,
                   266];
    hole_length=5;

    size_strut = [[width,frame_width],
              [height,frame_width],
              [height,frame_width],
              [width,frame_width]];

    cshape_frame_arrange(width=width, height=height, frame_width=frame_width, thickness = thickness, overlap=true, make_3d=make_3d, spacing_2d=1)
    {
        // 0: top
        color("yellow")
        translate([0,frame_width,0])
        mirror([0,1,0])
        cs_strut_triangle_45(width=size_strut[0][0], height=size_strut[0][1], thickness=thickness, type=["f", "f"],
                            hole_radius=hole_radius[0], hole_distance=hole_distance[0], hole_length=hole_length,
                            make_3d=make_3d);
        // 1: left
        color("green")
        translate([0,frame_width,0])
        mirror([0,1,0])
        cs_strut_triangle_45(width=size_strut[1][0], height=size_strut[1][1], thickness=thickness, type=["m", "m"],
                            hole_radius=hole_radius[1], hole_distance=hole_distance[1], hole_length=hole_length,
                            make_3d=make_3d);
        // 2: right
        color("red")
        translate([0,frame_width,0])
        mirror([0,1,0])
        cs_strut_triangle_45(width=size_strut[2][0], height=size_strut[2][1], thickness=thickness, type=["m", "m"],
                            hole_radius=hole_radius[2], hole_distance=hole_distance[2], hole_length=hole_length,
                            make_3d=make_3d);
        // 3: bottom
        color("violet")
        translate([0,frame_width,0])
        mirror([0,1,0])
        cs_strut_triangle_45(width=size_strut[3][0], height=size_strut[3][1], thickness=thickness, type=["f", "f"],
                            hole_radius=hole_radius[3], hole_distance=hole_distance[3], hole_length=hole_length,
                            make_3d=make_3d);
    }
}

module frame_left(width, height, frame_width, thickness = thickness, make_3d=make_3d, spacing_2d=1)
{
    hole_radius=[1.5,
                 0,
                 0,
                 1.5];
    hole_distance=[216,
                   0,
                   0,
                   216];
    hole_length=5;

    size_strut = [[width,frame_width],
              [height,frame_width],
              [height,frame_width],
              [width,frame_width]];

    cshape_frame_arrange(width=width, height=height, frame_width=frame_width, thickness = thickness, overlap=true, make_3d=make_3d, spacing_2d=1)
    {
        // 0: top
        color("yellow")
        translate([0,frame_width,0])
        mirror([0,1,0])
        cs_strut_triangle_45(width=size_strut[0][0], height=size_strut[0][1], thickness=thickness, type=["f", "f"],
                            hole_radius=hole_radius[0], hole_distance=hole_distance[0], hole_length=hole_length,
                            make_3d=make_3d);
        // 1: left
        color("green")
        translate([0,frame_width,0])
        mirror([0,1,0])
        cs_strut_triangle_45(width=size_strut[1][0], height=size_strut[1][1], thickness=thickness, type=["m", "m"],
                            hole_radius=hole_radius[1], hole_distance=hole_distance[1], hole_length=hole_length,
                            make_3d=make_3d);
        // 2: right
        color("red")
        translate([0,frame_width,0])
        mirror([0,1,0])
        cs_strut_triangle_45(width=size_strut[2][0], height=size_strut[2][1], thickness=thickness, type=["m", "m"],
                            hole_radius=hole_radius[2], hole_distance=hole_distance[2], hole_length=hole_length,
                            make_3d=make_3d);
        // 3: bottom
        color("violet")
        translate([0,frame_width,0])
        mirror([0,1,0])
        cs_strut_triangle_45(width=size_strut[3][0], height=size_strut[3][1], thickness=thickness, type=["f", "f"],
                            hole_radius=hole_radius[3], hole_distance=hole_distance[3], hole_length=hole_length,
                            make_3d=make_3d);
    }
}

module frame_right(width, height, frame_width, thickness = thickness, make_3d=make_3d, spacing_2d=1)
{
    hole_radius=[1.5,
                 0,
                 0,
                 1.5];
    hole_distance=[216,
                   0,
                   0,
                   216];
    hole_length=5;

    size_strut = [[width,frame_width],
              [height,frame_width],
              [height,frame_width],
              [width,frame_width]];

    cshape_frame_arrange(width=width, height=height, frame_width=frame_width, thickness = thickness, overlap=true, make_3d=make_3d, spacing_2d=1)
    {
        // 0: top
        color("yellow")
        translate([0,frame_width,0])
        mirror([0,1,0])
        cs_strut_triangle_45(width=size_strut[0][0], height=size_strut[0][1], thickness=thickness, type=["f", "f"],
                            hole_radius=hole_radius[0], hole_distance=hole_distance[0], hole_length=hole_length,
                            make_3d=make_3d);
        // 1: left
        color("green")
        translate([0,frame_width,0])
        mirror([0,1,0])
        cs_strut_triangle_45(width=size_strut[1][0], height=size_strut[1][1], thickness=thickness, type=["m", "m"],
                            hole_radius=hole_radius[1], hole_distance=hole_distance[1], hole_length=hole_length,
                            make_3d=make_3d);
        // 2: right
        color("red")
        translate([0,frame_width,0])
        mirror([0,1,0])
        cs_strut_triangle_45(width=size_strut[2][0], height=size_strut[2][1], thickness=thickness, type=["m", "m"],
                            hole_radius=hole_radius[2], hole_distance=hole_distance[2], hole_length=hole_length,
                            make_3d=make_3d);
        // 3: bottom
        color("violet")
        translate([0,frame_width,0])
        mirror([0,1,0])
        cs_strut_triangle_45(width=size_strut[3][0], height=size_strut[3][1], thickness=thickness, type=["f", "f"],
                            hole_radius=hole_radius[3], hole_distance=hole_distance[3], hole_length=hole_length,
                            make_3d=make_3d);
    }
}
