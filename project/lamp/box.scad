use <../../cutter_lib/strut/cs_strut_triangle_45.scad>
use <../../cutter_lib/shapes/cshape_box.scad>
use <../../cutter_lib/surfaces/cs_test_face.scad>

use <frame_basement.scad>
use <frame_additional_level.scad>

make_3d=false;

width= 293;
height= 220;
depth=240;
thickness = 4;
frame_width = 10;

no_level = 2;//[1:1:4]

size_unfold = get_cshape_box_2d_size_move(width=width, 
                height=height,
                depth=depth,
                thickness=thickness,
                spacing_2d=1);

size_face_move = get_cshape_box_face_size_move(width, height, depth, thickness);
echo(str("size_face_move: ",size_face_move));

box_basement(width, height, depth, thickness = thickness, make_3d=make_3d, spacing_2d=1);

for (i = [2 : no_level])
{
    if (make_3d)
        translate([0, 0, (i-1)*height])
            box_additional_level(width, height, depth, thickness = thickness, make_3d=make_3d, spacing_2d=1);
    else
        translate([(i-1)*size_unfold[0], 0, 0])
            box_additional_level(width, height, depth, thickness = thickness, make_3d=make_3d, spacing_2d=1);
}

module box_basement(width, height, depth, thickness = thickness, make_3d=make_3d, spacing_2d=1)
{
    cshape_box_arrange_move(width, height, depth, thickness = thickness, make_3d=make_3d, spacing_2d=1)
    {
        // 0: top
        text("");
        // 1: back
        frame_back_basement(width=size_face_move[1][0], height=size_face_move[1][1], frame_width=frame_width, thickness=thickness, make_3d=make_3d, spacing_2d=1);
        // 2: left
        frame_left_basement(width=size_face_move[2][0], height=size_face_move[2][1], frame_width=frame_width, thickness=thickness, make_3d=make_3d, spacing_2d=1);
        // 3: bottom
        text("");
        // 4: right
        frame_right_basement(width=size_face_move[4][0], height=size_face_move[4][1], frame_width=frame_width, thickness=thickness, make_3d=make_3d, spacing_2d=1);
        // 5: front
        frame_front_basement(width=size_face_move[5][0], height=size_face_move[5][1], frame_width=frame_width, thickness=thickness, make_3d=make_3d, spacing_2d=1);
    }
}

module box_additional_level(width, height, depth, thickness = thickness, make_3d=make_3d, spacing_2d=1)
{
    cshape_box_arrange_move(width, height, depth, thickness = thickness, make_3d=make_3d, spacing_2d=1)
    {
        // 0: top
        text("");
        // 1: back
        frame_back_additional_level(width=size_face_move[1][0], height=size_face_move[1][1], frame_width=frame_width, thickness=thickness, make_3d=make_3d, spacing_2d=1);
        // 2: left
        frame_left_additional_level(width=size_face_move[2][0], height=size_face_move[2][1], frame_width=frame_width, thickness=thickness, make_3d=make_3d, spacing_2d=1);
        // 3: bottom
        text("");
        // 4: right
        frame_right_additional_level(width=size_face_move[4][0], height=size_face_move[4][1], frame_width=frame_width, thickness=thickness, make_3d=make_3d, spacing_2d=1);
        // 5: front
        frame_front_additional_level(width=size_face_move[5][0], height=size_face_move[5][1], frame_width=frame_width, thickness=thickness, make_3d=make_3d, spacing_2d=1);
    }
}