use <../surfaces/cs_test_face.scad>

make_3d=false;

width= 15;
height= 12;
depth= 10;
thickness = 1;

size_unfold = get_cshape_box_2d_size_fold(width=width, 
                height=height,
                depth=depth,
                thickness=thickness,
                spacing_2d=1);

echo(str("size_unfold: ",size_unfold));

translate([0, -depth*1.1, 0]) {
    text("fold", size=depth);
}

size_face_fold = get_cshape_box_face_size_fold(width, height, depth, thickness);
echo(str("size_face_fold: ",size_face_fold));

cshape_box_arrange_fold(width, height, depth, thickness = thickness, make_3d=make_3d, spacing_2d=1)
{
    // 0: top
    cs_test_face(width=size_face_fold[0][0], height=size_face_fold[0][1], thickness=thickness, number=0, make_3d=make_3d);
    // 1: back
    cs_test_face(width=size_face_fold[1][0], height=size_face_fold[1][1], thickness=thickness, number=1, make_3d=make_3d);
    // 2: left
    cs_test_face(width=size_face_fold[2][0], height=size_face_fold[2][1], thickness=thickness, number=2, make_3d=make_3d);
    // 3: bottom
    cs_test_face(width=size_face_fold[3][0], height=size_face_fold[3][1], thickness=thickness, number=3, make_3d=make_3d);
    // 4: right
    cs_test_face(width=size_face_fold[4][0], height=size_face_fold[4][1], thickness=thickness, number=4, make_3d=make_3d);
    // 5: front
    cs_test_face(width=size_face_fold[5][0], height=size_face_fold[5][1], thickness=thickness, number=5, make_3d=make_3d);
}

translate([size_unfold[0], -depth*1.1, 0]) {
    text("move", size=depth);
}

size_face_move = get_cshape_box_face_size_move(width, height, depth, thickness);
echo(str("size_face_move: ",size_face_move));

translate([size_unfold[0], 0, 0])
cshape_box_arrange_move(width, height, depth, thickness = thickness, make_3d=make_3d, spacing_2d=1)
{
    // 0: top
    cs_test_face(width=size_face_move[0][0], height=size_face_move[0][1], thickness=thickness, number=0, make_3d=make_3d);
    // 1: back
    cs_test_face(width=size_face_move[1][0], height=size_face_move[1][1], thickness=thickness, number=1, make_3d=make_3d);
    // 2: left
    cs_test_face(width=size_face_move[2][0], height=size_face_move[2][1], thickness=thickness, number=2, make_3d=make_3d);
    // 3: bottom
    cs_test_face(width=size_face_move[3][0], height=size_face_move[3][1], thickness=thickness, number=3, make_3d=make_3d);
    // 4: right
    cs_test_face(width=size_face_move[4][0], height=size_face_move[4][1], thickness=thickness, number=4, make_3d=make_3d);
    // 5: front
    cs_test_face(width=size_face_move[5][0], height=size_face_move[5][1], thickness=thickness, number=5, make_3d=make_3d);
}



// ----------------------
// ---- Section FOLD ----
// ----------------------

function get_cshape_box_face_size_fold(width, height, depth, thickness) =
    [
        [width-2*thickness, depth-2*thickness],
        [width, height],
        [height, depth-2*thickness],
        [width-2*thickness, depth-2*thickness],
        [height, depth-2*thickness],
        [width, height]
    ];

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
function get_cshape_box_2d_size_fold(width, height, depth, thickness = 0, spacing_2d=1) =
    [width + 2*height + 4*spacing_2d, 2*depth + 2*height + 5*spacing_2d];

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
module cshape_box_arrange_bottom_frame_fold(width, height, depth, thickness = 0, make_3d=false, spacing_2d=1)
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
module cshape_box_arrange_top_frame_fold(width, height, depth, thickness = 0, make_3d=false, spacing_2d=1)
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
module cshape_box_arrange_front_frame_fold(width, height, depth, thickness = 0, make_3d=false, spacing_2d=1)
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
module cshape_box_arrange_back_frame_fold(width, height, depth, thickness = 0, make_3d=false, spacing_2d=1)
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
module cshape_box_arrange_left_frame_fold(width, height, depth, thickness = 0, make_3d=false, spacing_2d=1)
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
module cshape_box_arrange_right_frame_fold(width, height, depth, thickness = 0, make_3d=false, spacing_2d=1)
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
module cshape_box_arrange_fold(width, height, depth, thickness = 0, make_3d=false, spacing_2d=1)
{
    cshape_box_arrange_top_frame_fold(width=width, height=height, depth=depth, thickness=thickness, make_3d=make_3d, spacing_2d=spacing_2d)
        children(0);
    cshape_box_arrange_back_frame_fold(width=width, height=height, depth=depth, thickness=thickness, make_3d=make_3d, spacing_2d=spacing_2d)
        children(1);
    cshape_box_arrange_left_frame_fold(width=width, height=height, depth=depth, thickness=thickness, make_3d=make_3d, spacing_2d=spacing_2d)
        children(2);
    cshape_box_arrange_bottom_frame_fold(width=width, height=height, depth=depth, thickness=thickness, make_3d=make_3d, spacing_2d=spacing_2d)
        children(3);
    cshape_box_arrange_right_frame_fold(width=width, height=height, depth=depth, thickness=thickness, make_3d=make_3d, spacing_2d=spacing_2d)
        children(4);
    cshape_box_arrange_front_frame_fold(width=width, height=height, depth=depth, thickness=thickness, make_3d=make_3d, spacing_2d=spacing_2d)
        children(5);
}

// ----------------------
// ---- Section MOVE ----
// ----------------------

function get_cshape_box_face_size_move(width, height, depth, thickness) =
    [
        [width-2*thickness, depth-2*thickness],
        [width, height],
        [depth-2*thickness, height],
        [width-2*thickness, depth-2*thickness],
        [depth-2*thickness, height],
        [width, height]
    ];

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
function get_cshape_box_2d_size_move(width, height, depth, thickness = 0, spacing_2d=1) =
    [width + 2*depth + 4*spacing_2d, 2*depth + 2*height + 5*spacing_2d];

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
module cshape_box_arrange_bottom_frame_move(width, height, depth, thickness = 0, make_3d=false, spacing_2d=1)
{
    if (make_3d)
    {
        echo("cshape_box_arrange_bottom_frame_move::thickness = ", thickness);
        translate([thickness, depth-thickness, thickness])
        rotate([180,0,0])
            children();
    }
    else
    {
        translate([depth + 2*spacing_2d,
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
module cshape_box_arrange_top_frame_move(width, height, depth, thickness = 0, make_3d=false, spacing_2d=1)
{
    if (make_3d)
    {
        translate([thickness, thickness, height-thickness])
            // mirror([0, 0, 1])
                children();
    }
    else
    {
        translate([depth + 2*spacing_2d,
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
module cshape_box_arrange_front_frame_move(width, height, depth, thickness = 0, make_3d=false, spacing_2d=1)
{
    if (make_3d)
    {
        translate([0, thickness, 0])
            rotate([90, 0, 0])
                children();
    }
    else
    {
        translate([depth + 2*spacing_2d,
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
module cshape_box_arrange_back_frame_move(width, height, depth, thickness = 0, make_3d=false, spacing_2d=1)
{
    if (make_3d)
    {
        translate([width, depth-thickness, 0])
            rotate([-90,180,0])
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
module cshape_box_arrange_left_frame_move(width, height, depth, thickness = 0, make_3d=false, spacing_2d=1)
{
    if (make_3d)
    {
        translate([thickness,depth-thickness,0])
                rotate([90,0,-90])
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
module cshape_box_arrange_right_frame_move(width, height, depth, thickness = 0, make_3d=false, spacing_2d=1)
{
    if (make_3d)
    {
        translate([width-thickness,thickness,0])
                rotate([90,0,90])
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

module cshape_box_arrange_move(width, height, depth, thickness = 0, make_3d=false, spacing_2d=1)
{
    cshape_box_arrange_top_frame_move(width=width, height=height, depth=depth, thickness=thickness, make_3d=make_3d, spacing_2d=spacing_2d)
        children(0);
    cshape_box_arrange_back_frame_move(width=width, height=height, depth=depth, thickness=thickness, make_3d=make_3d, spacing_2d=spacing_2d)
        children(1);
    cshape_box_arrange_left_frame_move(width=width, height=height, depth=depth, thickness=thickness, make_3d=make_3d, spacing_2d=spacing_2d)
        children(2);
    cshape_box_arrange_bottom_frame_move(width=width, height=height, depth=depth, thickness=thickness, make_3d=make_3d, spacing_2d=spacing_2d)
        children(3);
    cshape_box_arrange_right_frame_move(width=width, height=height, depth=depth, thickness=thickness, make_3d=make_3d, spacing_2d=spacing_2d)
        children(4);
    cshape_box_arrange_front_frame_move(width=width, height=height, depth=depth, thickness=thickness, make_3d=make_3d, spacing_2d=spacing_2d)
        children(5);
}