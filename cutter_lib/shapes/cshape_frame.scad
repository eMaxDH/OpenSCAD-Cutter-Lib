use <../surfaces/cs_test_face.scad>


make_3d=false;

width= 150;
height= 120;
thickness = 4;

frame_width=5;
overlap=false;

size_struc = [[width,frame_width],
              [height-2*frame_width,frame_width],
              [height-2*frame_width,frame_width],
              [width,frame_width]];

cshape_frame_arrange(width, height, frame_width, thickness = thickness, overlap=overlap, make_3d=make_3d, spacing_2d=1)
{
    // 0: top
    cs_test_face(width=size_struc[0][0], height=size_struc[0][1], thickness=thickness, number=0, make_3d=make_3d);
    // 1: left
    cs_test_face(width=size_struc[1][0], height=size_struc[1][1], thickness=thickness, number=1, make_3d=make_3d);
    // 2: right
    cs_test_face(width=size_struc[2][0], height=size_struc[2][1], thickness=thickness, number=2, make_3d=make_3d);
    // 3: bottom
    cs_test_face(width=size_struc[3][0], height=size_struc[3][1], thickness=thickness, number=3, make_3d=make_3d);
}

//
//           0
//    ---------------   ^
//    |             |   |
//    |             |   |
//  1 |             | 2 |height
//    |             |   |
//    |             |   |
//    x--------------   v
//           3
//    <--- width --->
//  x: origin
//
//  ^ y 
//  |   
//  ---> x

module arrange_top_strut(width, height, frame_width, thickness, overlap=false, make_3d=false, spacing_2d=1)
{
    if (make_3d)
    {
        if (overlap)
            translate([0,height-frame_width,0])
                    children();
        else
            translate([0,height-frame_width,0])
                    children();
    }
    else
    {
        translate([spacing_2d, 3*frame_width + 3*spacing_2d, 0])
                children();
    }
}

module arrange_bottom_strut(width, height, frame_width, thickness, overlap=false, make_3d=false, spacing_2d=1)
{
    if (make_3d)
    {
        if (overlap)
            translate([width, frame_width, 0]) 
                rotate([0,0,180])
                    children();
        else
            translate([width, frame_width, 0]) 
                rotate([0,0,180])
                    children();
    }
    else
    {
        translate([spacing_2d,0,0])
            children();
    }
}

module arrange_left_strut(width, height, frame_width, thickness, overlap=false, make_3d=false, spacing_2d=1)
{
    if (make_3d)
    {
        if (overlap)
            translate([frame_width, 0, 0])
                rotate([0,0,90])
                    children();
        else
            translate([frame_width, frame_width, 0])
                rotate([0,0,90])
                    children();
    }
    else
    {
        translate([spacing_2d, 2*frame_width + 2*spacing_2d, 0])
                children();
    }
}

module arrange_right_strut(width, height, frame_width, thickness, overlap=false, make_3d=false, spacing_2d=1)
{
    if (make_3d)
    {
        if (overlap)
            translate([width-frame_width,height,0])
                rotate([0,0,-90])
                    children();
        else
            translate([width-frame_width,height-frame_width,0])
                rotate([0,0,-90])
                    children();
    }
    else
    {
        translate([spacing_2d, frame_width + spacing_2d, 0])
                children();
    }
}

//           0
//    ---------------
//    |             |
//    |             |
//  1 |             | 2
//    |             |
//    |             |
//    ---------------
//           3
module cshape_frame_arrange(width, height, frame_width, thickness = thickness, overlap=false,
                            make_3d=make_3d, spacing_2d=1)
{
    arrange_top_strut(width=width, height=height, frame_width=frame_width, thickness=thickness, overlap=overlap, make_3d=make_3d, spacing_2d=spacing_2d)
        children(0);
    arrange_left_strut(width=width, height=height, frame_width=frame_width, thickness=thickness, overlap=overlap, make_3d=make_3d, spacing_2d=spacing_2d)
        children(1);
    arrange_right_strut(width=width, height=height, frame_width=frame_width, thickness=thickness, overlap=overlap, make_3d=make_3d, spacing_2d=spacing_2d)
        children(2);
    arrange_bottom_strut(width=width, height=height, frame_width=frame_width, thickness=thickness, overlap=overlap, make_3d=make_3d, spacing_2d=spacing_2d)
        children(3);
}