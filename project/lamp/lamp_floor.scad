use <../../cutter_lib/layer/cl_layer.scad>
use <../../cutter_lib/surfaces/cs_test_surface.scad>

use <../../cutter_lib/shapes/cshape_box.scad>
// use <../shapes/cshape_array.scad>

use <../../cutter_lib/tower/ct_tower_floor.scad>

use <lamp_wall.scad>


make_3d=true;

floor_size = [200,100,50];

wall_depth=10; // frame thinkness
wall_thickness = 10; 

visibile_layers = [0];
cl_layer_info(visibile_layers);

spacing_2d=1;

test_faces=true;

use_construction_color=true;

lamp_floor_example(floor_size[0], floor_size[2], floor_size[1],
                          wall_thickness=wall_thickness,
                          test_faces=test_faces,
                          use_construction_color=use_construction_color,
                          make_3d=make_3d);

module lamp_floor_example(width, height, depth, wall_thickness=1,
                              test_faces=true, use_construction_color=use_construction_color,
                              visibile_layers=visibile_layers, make_3d=false, spacing_2d=1)
{
    size_face_move = get_cshape_box_face_size_move(width=width, height=height, depth=depth, 
                                                   thickness=wall_thickness);

    if (test_faces == true)
    {
        ct_tower_floor_arrange(width=width, height=height, depth=depth, 
                                wall_thickness=wall_thickness,
                                make_3d=make_3d, spacing_2d=spacing_2d)
        {
            // 0: top
            cs_test_surface(width=size_face_move[0][0], height=size_face_move[0][1], thickness=wall_thickness,
                        number=0, layer=0, visibile_layers=visibile_layers, make_3d=make_3d);
            // 1: back
            cs_test_surface(width=size_face_move[1][0], height=size_face_move[1][1], thickness=wall_thickness,
                        number=1, layer=0, visibile_layers=visibile_layers, make_3d=make_3d);
            // 2: left
            cs_test_surface(width=size_face_move[2][0], height=size_face_move[2][1], thickness=wall_thickness,
                        number=2, layer=0, visibile_layers=visibile_layers, make_3d=make_3d);
            // 3: bottom
            cs_test_surface(width=size_face_move[3][0], height=size_face_move[3][1], thickness=wall_thickness,
                        number=3, layer=0, visibile_layers=visibile_layers, make_3d=make_3d);
            // 4: right
            cs_test_surface(width=size_face_move[4][0], height=size_face_move[4][1], thickness=wall_thickness,
                        number=4, layer=0, visibile_layers=visibile_layers, make_3d=make_3d);
            // 5: front
            cs_test_surface(width=size_face_move[5][0], height=size_face_move[5][1], thickness=wall_thickness,
                        number=5, layer=0, visibile_layers=visibile_layers, make_3d=make_3d);
        }
    }
    else
    {
        ct_tower_floor_arrange(width=width, height=height, depth=depth, 
                                wall_thickness=wall_thickness,
                                make_3d=make_3d, spacing_2d=spacing_2d)
        {
            // 0: top
            text("");
            // 1: back
            lamp_wall_example(width=size_face_move[1][0], height=size_face_move[1][1],
                      wall_depth=wall_depth, wall_thickness=wall_thickness,
                      visibile_layers=visibile_layers, 
                      use_construction_color=use_construction_color,
                      make_3d=make_3d);
            // 2: left
            lamp_wall_example(width=size_face_move[2][0], height=size_face_move[2][1],
                      wall_depth=wall_depth, wall_thickness=wall_thickness,
                      visibile_layers=visibile_layers, 
                      use_construction_color=use_construction_color,
                      make_3d=make_3d);
            // 3: bottom
            text("");
            // 4: right
            lamp_wall_example(width=size_face_move[4][0], height=size_face_move[4][1],
                      wall_depth=wall_depth, wall_thickness=wall_thickness,
                      visibile_layers=visibile_layers, 
                      use_construction_color=use_construction_color,
                      make_3d=make_3d);
            // 5: front
            lamp_wall_example(width=size_face_move[5][0], height=size_face_move[5][1],
                      wall_depth=wall_depth, wall_thickness=wall_thickness,
                      visibile_layers=visibile_layers, 
                      use_construction_color=use_construction_color,
                      make_3d=make_3d);
        }
    }
}