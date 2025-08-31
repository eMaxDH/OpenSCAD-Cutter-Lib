use <../surfaces/cs_test_face.scad>

use <../shapes/cshape_box.scad>
use <../shapes/cshape_frame.scad>
use <../shapes/cshape_array.scad>

make_3d=true;

floor_size =  [200, 100, 50];

wall_thickness = 10;

no_floors = 0;


// ct_tower()
// {
//     ct_tower_basement(width=floor_size[0], height=floor_size[2], depth=floor_size[1], wall_thickness=wall_thickness, make_3d=make_3d);
// }

ct_tower_wall(width=width, height=height, wall_thickness=wall_thickness, make_3d=make_3d);

module ct_tower()
{
    no_floors = $children;
    // Basement
    children(0);
}

module ct_tower_basement(width, height, depth, wall_thickness=1, make_3d=false)
{
    thickness = wall_thickness;
    size_face_move = get_cshape_box_face_size_move(width, height, depth, thickness);
    echo(str("size_face_move: ",size_face_move));

    
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
        // cs_test_face(width=size_face_move[5][0], height=size_face_move[5][1], thickness=thickness, number=5, make_3d=make_3d);
        ct_tower_wall(width=size_face_move[5][0], height=size_face_move[5][1], wall_thickness=wall_thickness, make_3d=make_3d);
    }
}

function get_ct_tower_basement_2d_size(floor_size, thickness, spacing_2d=1) =
    get_cshape_box_2d_size_move(width=width, 
                height=height,
                depth=depth,
                thickness=thickness,
                spacing_2d=1);
