use <../layer/cl_layer.scad>
use <../surfaces/cs_test_face.scad>

use <../shapes/cshape_box.scad>
// use <../shapes/cshape_array.scad>

use <ct_tower_wall.scad>


make_3d=true;

floor_size = [200,100,50];

wall_width = 200;
wall_height = 50;
wall_depth=1;

wall_thickness = 10;

frame_overlap = true;

visibile_layers = [0];
cl_layer_info(visibile_layers);

spacing_2d=1;


ct_tower_basement_arrange(width=floor_size[0], height=floor_size[2], depth=floor_size[1], wall_thickness=wall_thickness,
                      visibile_layers=visibile_layers, make_3d=make_3d);
                      

module ct_tower_basement_arrange(width, height, depth, wall_thickness=1,
        visibile_layers=[], make_3d=false, spacing_2d=1)
{
    thickness = wall_depth;
    size_face_move = get_cshape_box_face_size_move(width, height, depth, wall_depth);

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
        ct_tower_wall_test(size_face_move[4][0], size_face_move[4][1], thickness, wall_depth=wall_depth,
                           frame_overlap=frame_overlap,
                           visibile_layers=visibile_layers, make_3d=make_3d);
        // 5: front
        ct_tower_wall_test(size_face_move[5][0], size_face_move[5][1], thickness, wall_depth=wall_depth,
                           frame_overlap=frame_overlap,
                           visibile_layers=visibile_layers, make_3d=make_3d);
    }
}

module ct_tower_wall_test(wall_width, wall_height, wall_thickness, wall_depth=1,frame_overlap=false,
                          layer=[0,1,2], visibile_layers=[], make_3d=false)
{
    strut_size = get_ct_tower_wall_strut_size(wall_width=wall_width, wall_height=wall_height, wall_thickness=wall_thickness,
                                              overlap=frame_overlap);

    ct_tower_wall_arrange(width=wall_width, height=wall_height, 
                          wall_depth=wall_depth, wall_thickness=wall_thickness,
                          frame_overlap=frame_overlap,
                          make_3d=make_3d)
        {
            // 0: top frame strut
            cs_test_face(width=strut_size[0][0], height=strut_size[0][1], thickness=wall_depth, number=0, 
                         layer=layer[0], visibile_layers=visibile_layers, make_3d=make_3d);
            // 1: left frame strut
            cs_test_face(width=strut_size[1][0], height=strut_size[1][1], thickness=wall_depth, number=1, 
                         layer=layer[0], visibile_layers=visibile_layers, make_3d=make_3d);
            // 2: right frame strut
            cs_test_face(width=strut_size[2][0], height=strut_size[2][1], thickness=wall_depth, number=2, 
                         layer=layer[0], visibile_layers=visibile_layers, make_3d=make_3d);
            // 3: bottom frame strut
            cs_test_face(width=strut_size[3][0], height=strut_size[3][1], thickness=wall_depth, number=3, 
                         layer=layer[0], visibile_layers=visibile_layers, make_3d=make_3d);

            // 4: front
            cs_test_face(width=wall_width, height=wall_height, thickness=wall_depth, number=4, face_color=[1,0,0,0.1], 
                         layer=layer[1], visibile_layers=visibile_layers, make_3d=make_3d);
            // 5: back
            cs_test_face(width=wall_width, height=wall_height, thickness=wall_depth, number=5, face_color=[0,1,0,0.1], 
                         layer=layer[2], visibile_layers=visibile_layers, make_3d=make_3d);
            
        }
}

function get_ct_tower_basement_2d_size(basement_width, basement_height, basement_depth, wall_depth, spacing_2d=1) =
    get_cshape_box_2d_size_move(width=basement_width, 
                height=basement_height,
                depth=basement_depth,
                thickness=wall_depth,
                spacing_2d=spacing_2d);


