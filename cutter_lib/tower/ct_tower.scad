use <../layer/cl_layer.scad>
use <../surfaces/cs_test_face.scad>

use <../shapes/cshape_box.scad>
use <../shapes/cshape_frame.scad>
use <../shapes/cshape_array.scad>

use <ct_tower_wall.scad>

make_3d=true;

floor_size = [200,100,50];

wall_width = 200;
wall_height = 50;
wall_depth=1;

wall_thickness = 10;

frame_overlap = true;

tower_wall_2d_size = get_ct_tower_wall_2d_size(wall_width, wall_height);

strut_size = get_cshape_frame_strut_size(width=wall_width, height=wall_height, frame_width=wall_thickness, overlap=frame_overlap);

visibile_layers = [0];
cl_layer_info(visibile_layers);

spacing_2d=1;

ct_tower(make_3d=make_3d, spacing_2d=spacing_2d)
{
    ct_tower_basement(width=floor_size[0], height=floor_size[2], depth=floor_size[1], wall_thickness=wall_thickness,
                      visibile_layers=visibile_layers, make_3d=make_3d);
}

module ct_tower(make_3d=false, spacing_2d=1)
{
    no_floors = $children;
    // Basement
    children(0);
}

module ct_tower_basement(width, height, depth, wall_thickness=1,
        visibile_layers=[], make_3d=false, spacing_2d=1)
{
    thickness = wall_depth;
    size_face_move = get_cshape_box_face_size_move(width, height, depth, wall_depth);
    echo(str("size_face_move: ",size_face_move));

    cshape_box_arrange_move(width, height, depth, thickness = thickness,
                            make_3d=make_3d, spacing_2d=1)
    {
        // 0: top
        cs_test_face(width=size_face_move[0][0], height=size_face_move[0][1], thickness=thickness, number=0, 
                     layer=0, visibile_layers=visibile_layers, make_3d=make_3d);
        // 1: back
        cs_test_face(width=size_face_move[1][0], height=size_face_move[1][1], thickness=thickness, number=1, 
                     layer=0, visibile_layers=visibile_layers, make_3d=make_3d);
        // 2: left
        cs_test_face(width=size_face_move[2][0], height=size_face_move[2][1], thickness=thickness, number=2, 
                     layer=0, visibile_layers=visibile_layers, make_3d=make_3d);
        // 3: bottom
        cs_test_face(width=size_face_move[3][0], height=size_face_move[3][1], thickness=thickness, number=3, 
                     layer=0, visibile_layers=visibile_layers, make_3d=make_3d);
        // 4: right
        cs_test_face(width=size_face_move[4][0], height=size_face_move[4][1], thickness=thickness, number=4, 
                     layer=0, visibile_layers=visibile_layers, make_3d=make_3d);
        // 5: front
        // cs_test_face(width=size_face_move[5][0], height=size_face_move[5][1], thickness=thickness, number=5, make_3d=make_3d);
        ct_tower_wall(width=size_face_move[5][0], height=size_face_move[5][1], 
                      wall_depth=1, wall_thickness=wall_thickness,
                      frame_overlap=frame_overlap,
                      make_3d=make_3d)
        {
            // 0: top frame strut
            cs_test_face(width=strut_size[0][0], height=strut_size[0][1], thickness=wall_depth, number=0, 
                         layer=0, visibile_layers=visibile_layers, make_3d=make_3d);
            // 1: left frame strut
            cs_test_face(width=strut_size[1][0], height=strut_size[1][1], thickness=wall_depth, number=1, 
                         layer=0, visibile_layers=visibile_layers, make_3d=make_3d);
            // 2: right frame strut
            cs_test_face(width=strut_size[2][0], height=strut_size[2][1], thickness=wall_depth, number=2, 
                         layer=0, visibile_layers=visibile_layers, make_3d=make_3d);
            // 3: bottom frame strut
            cs_test_face(width=strut_size[3][0], height=strut_size[3][1], thickness=wall_depth, number=3, 
                         layer=0, visibile_layers=visibile_layers, make_3d=make_3d);

            // 4: front
            cs_test_face(width=wall_width, height=wall_height, thickness=wall_depth, number=4, face_color=[1,0,0,0.1], 
                         layer=1, visibile_layers=visibile_layers, make_3d=make_3d);
            // 5: back
            cs_test_face(width=wall_width, height=wall_height, thickness=wall_depth, number=5, face_color=[0,1,0,0.1], 
                         layer=2, visibile_layers=visibile_layers, make_3d=make_3d);
            
        }
    }
}

function get_ct_tower_basement_2d_size(floor_size, thickness, spacing_2d=1) =
    get_cshape_box_2d_size_move(width=width, 
                height=height,
                depth=depth,
                thickness=thickness,
                spacing_2d=1);


