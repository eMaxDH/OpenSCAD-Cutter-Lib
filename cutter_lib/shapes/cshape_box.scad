use <../surfaces/cs_test_face.scad>

make_3d=false;

width= 10;
height= 10;
depth= 10;
thickness = 1;

cshape_box_arrange(width, height, depth, thickness = thickness, make_3d=make_3d, spacing_2d=1)
{
    // 0: top
    cs_test_face(width=width-2*thickness, height=height-2*thickness, thickness=thickness, number=0, make_3d=make_3d);
    // 1: back
    cs_test_face(width=width, height=height, thickness=thickness, number=1, make_3d=make_3d);
    // 2: left
    cs_test_face(width=width, height=height-2*thickness, thickness=thickness, number=2, make_3d=make_3d);
    // 3: bottom
    cs_test_face(width=width-2*thickness, height=height-2*thickness, thickness=thickness, number=3, make_3d=make_3d);
    // 4: right
    cs_test_face(width=width, height=height-2*thickness, thickness=thickness, number=4, make_3d=make_3d);
    // 5: front
    cs_test_face(width=width, height=height, thickness=thickness, number=5, make_3d=make_3d);
}

echo(str("get_cshape_box_2d_size: ",get_cshape_box_2d_size(width=width, 
                height=height,
                depth=depth,
                thickness=thickness,
                spacing_2d=1)));

//        ---
//       |   |    
//        ---     
//       |   |    
//    --- --- --- 
//   |   | 3 |   |
//    ---o--- --- 
//       |   |    
//   x    ---     
//
//  x: 2d-origin
//  o: 3d-origin
module cshape_box_arrange_bottom_frame(width, height, depth, thickness = 0, make_3d=false, spacing_2d=1)
{
    if (make_3d)
    {
        echo("cshape_box_arrange_bottom_frame::thickness = ", thickness);
        translate([thickness, thickness, 0])
            children();
    }
    else
    {
        translate([height + 2*spacing_2d,
                   height + 2*spacing_2d,
                   0])
            children();
    }
}

//        ---
//       | 0 |    
//        ---     
//       |   |    
//    --- --- --- 
//   |   |   |   |
//    ---o--- --- 
//       |   |    
//   x    ---     
//
//  x: 2d-origin
//  o: 3d-origin
module cshape_box_arrange_top_frame(width, height, depth, thickness = 0, make_3d=false, spacing_2d=1)
{
    if (make_3d)
    {
        translate([thickness, depth-thickness, height])
            rotate([180,0,0])
            // mirror([0, 0, 1])
                children();
    }
    else
    {
        translate([height + 2*spacing_2d,
                   depth + 2*height + 4*spacing_2d,
                   0])
                children();
    }
}

//        ---
//       |   |    
//        ---     
//       |   |    
//    --- --- --- 
//   |   |   |   |
//    ---o--- --- 
//       | 5 |    
//   x    ---     
//
//  x: 2d-origin
//  o: 3d-origin
module cshape_box_arrange_front_frame(width, height, depth, thickness = 0, make_3d=false, spacing_2d=1)
{
    if (make_3d)
    {
        translate([0, 0, height])
            rotate([-90, 0, 0])
                children();
    }
    else
    {
        translate([height + 2*spacing_2d,
                   spacing_2d,
                   0])
                children();
    }
}

//        ---
//       |   |    
//        ---     
//       | 1 |    
//    --- --- --- 
//   |   |   |   |
//    ---o--- --- 
//       |   |    
//   x    ---     
//
//  x: 2d-origin
//  o: 3d-origin
module cshape_box_arrange_back_frame(width, height, depth, thickness = 0, make_3d=false, spacing_2d=1)
{
    if (make_3d)
    {
        translate([0, depth, 0])
            rotate([90,0,0])
                children();
    }
    else
    {
        translate([height + 2*spacing_2d,
                   3*spacing_2d + height + depth,
                   0])
                children();
    }
}

//        ---
//       |   |    
//        ---     
//       |   |    
//    --- --- --- 
//   | 2 |   |   |
//    ---o--- --- 
//       |   |    
//   x    ---     
//
//  x: 2d-origin
//  o: 3d-origin
module cshape_box_arrange_left_frame(width, height, depth, thickness = 0, make_3d=false, spacing_2d=1)
{
    if (make_3d)
    {
        translate([0,thickness,height])
                rotate([0,90,0])
                children();
    }
    else
    {
        translate([spacing_2d,
                   height + 2*spacing_2d,
                   0])
                children();
    }
}

//        ---
//       |   |    
//        ---     
//       |   |    
//    --- --- --- 
//   |   |   | 4 |
//    --- --- --- 
//       |   |    
//   x    ---     
//
module cshape_box_arrange_right_frame(width, height, depth, thickness = 0, make_3d=false, spacing_2d=1)
{
    if (make_3d)
    {
        translate([width,thickness,0])
                rotate([0,-90,0])
                children();
    }
    else
    {
        translate([height + width + 3*spacing_2d,
                   height + 2*spacing_2d,
                   0])
                children();
    }
    
}

//  This is what the 2D unfolding of the cube looks like,
//  including the numbering of the sides.
//        ---
//       | 0 |
//        ---
//       | 1 |
//    --- --- ---  ^
//   | 2 | 3 | 4 | | depth
//    --- --- ---  v
//       | 5 |<-> height
//        ---
//        <-> width
// 
//  thickness: thickness of the plate
// 
// 
//  The origin of a face is defind in the corner of a face,
//  e.g. marked with an 'o' for face 1.
//        ---
//       |   |
//        ---
//       | 1 |
//    ---o--- ---  
//   |   |   |   |
//    --- --- ---  
//       |   |
//        ---
//
//  the folded box with origin x 
//
//       -----      
//     /  0   /
//    /----- / |
//    |  5  | 4|    ^y
//    |     | /    /
//    x----- /    --> x
module cshape_box_arrange(width, height, depth, thickness = 0, make_3d=false, spacing_2d=1)
{
    cshape_box_arrange_top_frame(width=width, height=height, depth=depth, thickness=thickness, make_3d=make_3d, spacing_2d=spacing_2d)
        children(0);
    cshape_box_arrange_back_frame(width=width, height=height, depth=depth, thickness=thickness, make_3d=make_3d, spacing_2d=spacing_2d)
        children(1);
    cshape_box_arrange_left_frame(width=width, height=height, depth=depth, thickness=thickness, make_3d=make_3d, spacing_2d=spacing_2d)
        children(2);
    cshape_box_arrange_bottom_frame(width=width, height=height, depth=depth, thickness=thickness, make_3d=make_3d, spacing_2d=spacing_2d)
        children(3);
    cshape_box_arrange_right_frame(width=width, height=height, depth=depth, thickness=thickness, make_3d=make_3d, spacing_2d=spacing_2d)
        children(4);
    cshape_box_arrange_front_frame(width=width, height=height, depth=depth, thickness=thickness, make_3d=make_3d, spacing_2d=spacing_2d)
        children(5);
}

//        ---
//       |   |     ^
//        ---      |
//       |   |     |
//    --- --- ---  |
//   |   |   |   | | size[1]
//    --- --- ---  |
//       |   |     |
//   x    ---      v
//   <--size[0]-->
// 
//  x: origin
function get_cshape_box_2d_size(width, height, depth, thickness = 0, spacing_2d=1) =
    [width + 2*height + 2*spacing_2d, 2*depth + 2*height + 3*spacing_2d];
    