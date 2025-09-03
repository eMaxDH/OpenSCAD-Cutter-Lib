use <../layer/cl_layer.scad>
use <../surfaces/cs_test_surface.scad>

use <../shapes/cshape_box.scad>
// use <../shapes/cshape_array.scad>

use <ct_tower_wall.scad>


make_3d=true;

floor_size = [200,100,50];

wall_depth=4;
frame_width = 15; 

frame_overlap = false;

visibile_layers = [0];
cl_layer_info(visibile_layers);

spacing_2d=1;

test_faces=true;

ct_tower_floor_example(floor_size[0], floor_size[2], floor_size[1],
                          wall_depth=wall_depth,
                          frame_width = frame_width,
                          frame_overlap=frame_overlap,
                          test_faces=test_faces,
                          make_3d=make_3d);

module ct_tower_floor_example(width, height, depth, wall_depth=1, frame_width=10, frame_overlap=false,
                              test_faces=true,
                              visibile_layers=visibile_layers, make_3d=false, spacing_2d=1)
{
    size_face_move = get_cshape_box_face_size_move(width=width, height=height, depth=depth, 
                                                   thickness=wall_depth);

    if (test_faces == true)
    {
        ct_tower_floor_arrange(width=width, height=height, depth=depth, 
                                wall_depth=wall_depth,
                                make_3d=make_3d, spacing_2d=spacing_2d)
        {
            // 0: top
            cs_test_surface(width=size_face_move[0][0], height=size_face_move[0][1], thickness=wall_depth,
                        number=0, layer=0, visibile_layers=visibile_layers, make_3d=make_3d);
            // 1: back
            cs_test_surface(width=size_face_move[1][0], height=size_face_move[1][1], thickness=wall_depth,
                        number=1, layer=0, visibile_layers=visibile_layers, make_3d=make_3d);
            // 2: left
            cs_test_surface(width=size_face_move[2][0], height=size_face_move[2][1], thickness=wall_depth,
                        number=2, layer=0, visibile_layers=visibile_layers, make_3d=make_3d);
            // 3: bottom
            cs_test_surface(width=size_face_move[3][0], height=size_face_move[3][1], thickness=wall_depth,
                        number=3, layer=0, visibile_layers=visibile_layers, make_3d=make_3d);
            // 4: right
            cs_test_surface(width=size_face_move[4][0], height=size_face_move[4][1], thickness=wall_depth,
                        number=4, layer=0, visibile_layers=visibile_layers, make_3d=make_3d);
            // 5: front
            cs_test_surface(width=size_face_move[5][0], height=size_face_move[5][1], thickness=wall_depth,
                        number=5, layer=0, visibile_layers=visibile_layers, make_3d=make_3d);
        }
    }
    else
    {
        ct_tower_floor_arrange(width=width, height=height, depth=depth, 
                                wall_depth=wall_depth,
                                make_3d=make_3d, spacing_2d=spacing_2d)
        {
            // 0: top
            ct_tower_wall_example(width=size_face_move[0][0], height=size_face_move[0][1],
                                wall_depth=wall_depth, frame_width=frame_width,
                                frame_overlap=frame_overlap,
                                visibile_layers=visibile_layers, make_3d=make_3d);
            // 1: back
            ct_tower_wall_example(width=size_face_move[1][0], height=size_face_move[1][1],
                                wall_depth=wall_depth, frame_width=frame_width,
                                frame_overlap=frame_overlap,
                                visibile_layers=visibile_layers, make_3d=make_3d);
            // 2: left
            ct_tower_wall_example(width=size_face_move[2][0], height=size_face_move[2][1],
                                wall_depth=wall_depth, frame_width=frame_width,
                                frame_overlap=frame_overlap,
                                visibile_layers=visibile_layers, make_3d=make_3d);
            // 3: bottom
            ct_tower_wall_example(width=size_face_move[3][0], height=size_face_move[3][1],
                                wall_depth=wall_depth, frame_width=frame_width,
                                frame_overlap=frame_overlap,
                                visibile_layers=visibile_layers, make_3d=make_3d);
            // 4: right
            ct_tower_wall_example(width=size_face_move[4][0], height=size_face_move[4][1],
                                wall_depth=wall_depth, frame_width=frame_width,
                                frame_overlap=frame_overlap,
                                visibile_layers=visibile_layers, make_3d=make_3d);
            // 5: front
            ct_tower_wall_example(width=size_face_move[5][0], height=size_face_move[5][1],
                                wall_depth=wall_depth, frame_width=frame_width,
                                frame_overlap=frame_overlap,
                                visibile_layers=visibile_layers, make_3d=make_3d);
        }
    }
}

module ct_tower_floor_arrange(width, height, depth, wall_depth=1,
                                 make_3d=false, spacing_2d=1)
{
    cshape_box_arrange_move(width=width, height=height, depth=depth, thickness = wall_depth,
                            make_3d=make_3d, spacing_2d=1)
    {
        // 0: top
        children(0);
        // 1: back
        children(1);
        // 2: left
        children(2);
        // 3: bottom
        children(3);
        // 4: right
        children(4);
        // 5: front
        children(5);
    }
}



function get_ct_tower_floor_2d_size(width, height, depth, wall_depth, spacing_2d=1) =
    get_cshape_box_2d_size_move(width=width, 
                                height=height,
                                depth=depth,
                                thickness=wall_depth,
                                spacing_2d=spacing_2d);


