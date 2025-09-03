use <../../cutter_lib/layer/cl_layer.scad>
use <../../cutter_lib/surfaces/cs_test_surface.scad>

use <../../cutter_lib/shapes/cshape_box.scad>
// use <../shapes/cshape_array.scad>

use <../../cutter_lib/tower/ct_tower_floor.scad>

use <lamp_wall.scad>


make_3d=true;

floor_size = [300,250,230];

//wall_depth=10; // frame thinkness
frame_width = 10; 
wall_depth=5;
visibile_layers=[0,1,2];
cl_layer_info(visibile_layers);

spacing_2d=1;

use_construction_color=true;

lamp_floor(floor_size[0], floor_size[2], floor_size[1],
                          frame_width=frame_width, wall_depth=wall_depth,
                          use_construction_color=use_construction_color,
                          make_3d=make_3d);

module lamp_floor_example(width, height, depth, frame_width=1,wall_depth=5,
                              use_construction_color=use_construction_color,
                              visibile_layers=visibile_layers, make_3d=false, spacing_2d=1)
{
    size_face_move = get_cshape_box_face_size_move(width=width, height=height, depth=depth, 
                                                   thickness=wall_depth);

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
                    number=4, layer=1, visibile_layers=visibile_layers, make_3d=make_3d);
        // 5: front
        cs_test_surface(width=size_face_move[5][0], height=size_face_move[5][1], thickness=wall_depth,
                    number=5, layer=2, visibile_layers=visibile_layers, make_3d=make_3d);
    }
}

module lamp_floor(width, height, depth, frame_width=1,wall_depth=5,
                  use_construction_color=use_construction_color,
                  front_elements_ratio = 1.618, front_element_width = 15,
                  back_elements_ratio = 1.618, back_element_width = 15,
                  visibile_layers=visibile_layers, make_3d=false, spacing_2d=1)
{
    size_face_move = get_cshape_box_face_size_move(width=width, height=height, depth=depth, 
                                                   thickness=wall_depth);

    ct_tower_floor_arrange(width=width, height=height, depth=depth, 
                            wall_depth=wall_depth,
                            make_3d=make_3d, spacing_2d=spacing_2d)
    {
        // 0: top
        linear_extrude(0)
            text("");
        // 1: back
        lamp_wall(width=size_face_move[1][0], height=size_face_move[1][1],
                    wall_depth=wall_depth, frame_width=frame_width,
                    front_layer_overlap=0, back_layer_padding=wall_depth,
                    front_elements_ratio = front_elements_ratio, front_element_width = front_element_width,
                    back_elements_ratio = back_elements_ratio, back_element_width = back_element_width,
                    hole_radius=[1.5, 0, 0, 1.5],
                    hole_distance=[267, 0, 0, 267],
                    hole_length=5,
                    layer=[0,1,2], visibile_layers=visibile_layers, 
                    use_construction_color=use_construction_color,
                    make_3d=make_3d);
        // 2: left
        lamp_wall(width=size_face_move[2][0], height=size_face_move[2][1],
                    wall_depth=wall_depth, frame_width=frame_width,
                    front_layer_overlap=wall_depth, back_layer_padding=0,
                    front_elements_ratio = front_elements_ratio, front_element_width = front_element_width,
                    back_elements_ratio = back_elements_ratio, back_element_width = back_element_width,
                    hole_radius=[1.5, 0, 0, 1.5],
                    hole_distance=[217, 0, 0, 217],
                    hole_length=5,
                    layer=[0,1,2], visibile_layers=visibile_layers, 
                    use_construction_color=use_construction_color,
                    make_3d=make_3d);
        // 3: bottom
        linear_extrude(0)
            text("");
        // 4: right
        lamp_wall(width=size_face_move[4][0], height=size_face_move[4][1],
                    wall_depth=wall_depth, frame_width=frame_width,
                    front_layer_overlap=wall_depth, back_layer_padding=0,
                    front_elements_ratio = front_elements_ratio, front_element_width = front_element_width,
                    back_elements_ratio = back_elements_ratio, back_element_width = back_element_width,
                    hole_radius=[1.5, 0, 0, 1.5],
                    hole_distance=[217, 0, 0, 217],
                    hole_length=5,
                    layer=[0,1,2], visibile_layers=visibile_layers, 
                    use_construction_color=use_construction_color,
                    make_3d=make_3d);
        // 5: front
        lamp_wall(width=size_face_move[5][0], height=size_face_move[5][1],
                    wall_depth=wall_depth, frame_width=frame_width,
                    front_layer_overlap=0, back_layer_padding=wall_depth,
                    front_elements_ratio = front_elements_ratio, front_element_width = front_element_width,
                    back_elements_ratio = back_elements_ratio, back_element_width = back_element_width,
                    hole_radius=[1.5, 0, 0, 1.5],
                    hole_distance=[267, 0, 0, 267],
                    hole_length=5,
                    layer=[0,1,2], visibile_layers=visibile_layers, 
                    use_construction_color=use_construction_color,
                    make_3d=make_3d);
    }
}

module lamp_floor_basement(width, height, depth, frame_width=1,wall_depth=5,
                  use_construction_color=use_construction_color,
                  front_elements_ratio = 1.618, front_element_width = 15,
                  back_elements_ratio = 1.618, back_element_width = 15,
                  visibile_layers=visibile_layers, make_3d=false, spacing_2d=1)
{
    size_face_move = get_cshape_box_face_size_move(width=width, height=height, depth=depth, 
                                                   thickness=wall_depth);

    ct_tower_floor_arrange(width=width, height=height, depth=depth, 
                            wall_depth=wall_depth,
                            make_3d=make_3d, spacing_2d=spacing_2d)
    {
        // 0: top
        linear_extrude(0)
            text("");
        // 1: back
        lamp_wall_basement(width=size_face_move[1][0], height=size_face_move[1][1],
                    wall_depth=wall_depth, frame_width=frame_width,
                    front_layer_overlap=0, back_layer_padding=wall_depth,
                    front_elements_ratio = front_elements_ratio, front_element_width = front_element_width,
                    back_elements_ratio = back_elements_ratio, back_element_width = back_element_width,
                    hole_radius=[1.5, 0, 0, 1.5],
                    hole_distance=[267, 0, 0, 267],
                    hole_length=5,
                    layer=[0,1,2], visibile_layers=visibile_layers, 
                    use_construction_color=use_construction_color,
                    make_3d=make_3d);
        // 2: left
        lamp_wall_basement(width=size_face_move[2][0], height=size_face_move[2][1],
                    wall_depth=wall_depth, frame_width=frame_width,
                    front_layer_overlap=wall_depth, back_layer_padding=0,
                    front_elements_ratio = front_elements_ratio, front_element_width = front_element_width,
                    back_elements_ratio = back_elements_ratio, back_element_width = back_element_width,
                    hole_radius=[1.5, 0, 0, 1.5],
                    hole_distance=[217, 0, 0, 217],
                    hole_length=5,
                    layer=[0,1,2], visibile_layers=visibile_layers, 
                    use_construction_color=use_construction_color,
                    make_3d=make_3d);
        // 3: bottom
        linear_extrude(0)
            text("");
        // lamp_wall(width=size_face_move[3][0], height=size_face_move[3][1],
        //             wall_depth=wall_depth, frame_width=frame_width,
        //             front_layer_overlap=wall_depth, back_layer_padding=0,
        //             front_elements_ratio = front_elements_ratio, front_element_width = front_element_width,
        //             back_elements_ratio = back_elements_ratio, back_element_width = back_element_width,
        //             hole_radius=[0, 0, 0, 0],
        //             hole_distance=[217, 0, 0, 217],
        //             hole_length=5,
        //             layer=[3,1,2], visibile_layers=visibile_layers, 
        //             use_construction_color=use_construction_color,
        //             make_3d=make_3d);
        // 4: right
        lamp_wall_basement(width=size_face_move[4][0], height=size_face_move[4][1],
                    wall_depth=wall_depth, frame_width=frame_width,
                    front_layer_overlap=wall_depth, back_layer_padding=0,
                    front_elements_ratio = front_elements_ratio, front_element_width = front_element_width,
                    back_elements_ratio = back_elements_ratio, back_element_width = back_element_width,
                    hole_radius=[1.5, 0, 0, 1.5],
                    hole_distance=[217, 0, 0, 217],
                    hole_length=5,
                    layer=[0,1,2], visibile_layers=visibile_layers, 
                    use_construction_color=use_construction_color,
                    make_3d=make_3d);
        // 5: front
        lamp_wall_basement(width=size_face_move[5][0], height=size_face_move[5][1],
                    wall_depth=wall_depth, frame_width=frame_width,
                    front_layer_overlap=0, back_layer_padding=wall_depth,
                    front_elements_ratio = front_elements_ratio, front_element_width = front_element_width,
                    back_elements_ratio = back_elements_ratio, back_element_width = back_element_width,
                    hole_radius=[1.5, 0, 0, 1.5],
                    hole_distance=[267, 0, 0, 267],
                    hole_length=5,
                    layer=[0,1,2], visibile_layers=visibile_layers, 
                    use_construction_color=use_construction_color,
                    make_3d=make_3d);
    }
    silver_ring_frame_thickness=6;
    silver_ring_frame_width=2;
    translate([-silver_ring_frame_width,
               -silver_ring_frame_width, 
               height - silver_ring_frame_thickness/2])
        lamp_silver_ring(width=width + 2*silver_ring_frame_width,
                         height=depth + 2*silver_ring_frame_width,
                         thickness=silver_ring_frame_thickness,
                         frame_width=silver_ring_frame_width,
                         make_3d=make_3d);
}

module lamp_floor_middle_part(width, height, depth, frame_width=1,wall_depth=5,
                  use_construction_color=use_construction_color,
                  front_elements_ratio = 1.618, front_element_width = 15,
                  back_elements_ratio = 1.618, back_element_width = 15,
                  visibile_layers=visibile_layers, make_3d=false, spacing_2d=1)
{
    size_face_move = get_cshape_box_face_size_move(width=width, height=height, depth=depth, 
                                                   thickness=wall_depth);

    ct_tower_floor_arrange(width=width, height=height, depth=depth, 
                            wall_depth=wall_depth,
                            make_3d=make_3d, spacing_2d=spacing_2d)
    {
        // 0: top
        linear_extrude(0)
            text("");
        // 1: back
        lamp_wall_middle_part(width=size_face_move[1][0], height=size_face_move[1][1],
                    wall_depth=wall_depth, frame_width=frame_width,
                    front_layer_overlap=0, back_layer_padding=wall_depth,
                    front_elements_ratio = front_elements_ratio, front_element_width = front_element_width,
                    back_elements_ratio = back_elements_ratio, back_element_width = back_element_width,
                    hole_radius=[1.5, 0, 0, 1.5],
                    hole_distance=[267, 0, 0, 267],
                    hole_length=5,
                    layer=[0,1,2], visibile_layers=visibile_layers, 
                    use_construction_color=use_construction_color,
                    make_3d=make_3d);
        // 2: left
        lamp_wall_middle_part(width=size_face_move[2][0], height=size_face_move[2][1],
                    wall_depth=wall_depth, frame_width=frame_width,
                    front_layer_overlap=wall_depth, back_layer_padding=0,
                    front_elements_ratio = front_elements_ratio, front_element_width = front_element_width,
                    back_elements_ratio = back_elements_ratio, back_element_width = back_element_width,
                    hole_radius=[1.5, 0, 0, 1.5],
                    hole_distance=[217, 0, 0, 217],
                    hole_length=5,
                    layer=[0,1,2], visibile_layers=visibile_layers, 
                    use_construction_color=use_construction_color,
                    make_3d=make_3d);
        // 3: bottom
        linear_extrude(0)
            text("");
        // 4: right
        lamp_wall_middle_part(width=size_face_move[4][0], height=size_face_move[4][1],
                    wall_depth=wall_depth, frame_width=frame_width,
                    front_layer_overlap=wall_depth, back_layer_padding=0,
                    front_elements_ratio = front_elements_ratio, front_element_width = front_element_width,
                    back_elements_ratio = back_elements_ratio, back_element_width = back_element_width,
                    hole_radius=[1.5, 0, 0, 1.5],
                    hole_distance=[217, 0, 0, 217],
                    hole_length=5,
                    layer=[0,1,2], visibile_layers=visibile_layers, 
                    use_construction_color=use_construction_color,
                    make_3d=make_3d);
        // 5: front
        lamp_wall_middle_part(width=size_face_move[5][0], height=size_face_move[5][1],
                    wall_depth=wall_depth, frame_width=frame_width,
                    front_layer_overlap=0, back_layer_padding=wall_depth,
                    front_elements_ratio = front_elements_ratio, front_element_width = front_element_width,
                    back_elements_ratio = back_elements_ratio, back_element_width = back_element_width,
                    hole_radius=[1.5, 0, 0, 1.5],
                    hole_distance=[267, 0, 0, 267],
                    hole_length=5,
                    layer=[0,1,2], visibile_layers=visibile_layers, 
                    use_construction_color=use_construction_color,
                    make_3d=make_3d);
    }
    silver_ring_frame_thickness=6;
    silver_ring_frame_width=2;
    translate([-silver_ring_frame_width,
               -silver_ring_frame_width, 
               height - silver_ring_frame_thickness/2])
        lamp_silver_ring(width=width + 2*silver_ring_frame_width,
                         height=depth + 2*silver_ring_frame_width,
                         thickness=silver_ring_frame_thickness,
                         frame_width=silver_ring_frame_width,
                         make_3d=make_3d);
}

module lamp_floor_top(width, height, depth, frame_width=1,wall_depth=5,
                  use_construction_color=use_construction_color,
                  front_elements_ratio = 1.618, front_element_width = 15,
                  back_elements_ratio = 1.618, back_element_width = 15,
                  visibile_layers=visibile_layers, make_3d=false, spacing_2d=1)
{
    size_face_move = get_cshape_box_face_size_move(width=width, height=height, depth=depth, 
                                                   thickness=wall_depth);

    ct_tower_floor_arrange(width=width, height=height, depth=depth, 
                            wall_depth=wall_depth,
                            make_3d=make_3d, spacing_2d=spacing_2d)
    {
        // 0: top
        linear_extrude(0)
            text("");
        // 1: back
        lamp_wall_top(width=size_face_move[1][0], height=size_face_move[1][1],
                    wall_depth=wall_depth, frame_width=frame_width,
                    front_layer_overlap=0, back_layer_padding=wall_depth,
                    front_elements_ratio = front_elements_ratio, front_element_width = front_element_width,
                    back_elements_ratio = back_elements_ratio, back_element_width = back_element_width,
                    hole_radius=[1.5, 0, 0, 1.5],
                    hole_distance=[267, 0, 0, 267],
                    hole_length=5,
                    layer=[0,1,2], visibile_layers=visibile_layers, 
                    use_construction_color=use_construction_color,
                    make_3d=make_3d);
        // 2: left
        lamp_wall_top(width=size_face_move[2][0], height=size_face_move[2][1],
                    wall_depth=wall_depth, frame_width=frame_width,
                    front_layer_overlap=wall_depth, back_layer_padding=0,
                    front_elements_ratio = front_elements_ratio, front_element_width = front_element_width,
                    back_elements_ratio = back_elements_ratio, back_element_width = back_element_width,
                    hole_radius=[1.5, 0, 0, 1.5],
                    hole_distance=[217, 0, 0, 217],
                    hole_length=5,
                    layer=[0,1,2], visibile_layers=visibile_layers, 
                    use_construction_color=use_construction_color,
                    make_3d=make_3d);
        // 3: bottom
        linear_extrude(0)
            text("");
        // 4: right
        lamp_wall_top(width=size_face_move[4][0], height=size_face_move[4][1],
                    wall_depth=wall_depth, frame_width=frame_width,
                    front_layer_overlap=wall_depth, back_layer_padding=0,
                    front_elements_ratio = front_elements_ratio, front_element_width = front_element_width,
                    back_elements_ratio = back_elements_ratio, back_element_width = back_element_width,
                    hole_radius=[1.5, 0, 0, 1.5],
                    hole_distance=[217, 0, 0, 217],
                    hole_length=5,
                    layer=[0,1,2], visibile_layers=visibile_layers, 
                    use_construction_color=use_construction_color,
                    make_3d=make_3d);
        // 5: front
        lamp_wall_top(width=size_face_move[5][0], height=size_face_move[5][1],
                    wall_depth=wall_depth, frame_width=frame_width,
                    front_layer_overlap=0, back_layer_padding=wall_depth,
                    front_elements_ratio = front_elements_ratio, front_element_width = front_element_width,
                    back_elements_ratio = back_elements_ratio, back_element_width = back_element_width,
                    hole_radius=[1.5, 0, 0, 1.5],
                    hole_distance=[267, 0, 0, 267],
                    hole_length=5,
                    layer=[0,1,2], visibile_layers=visibile_layers, 
                    use_construction_color=use_construction_color,
                    make_3d=make_3d);
    }
}

module lamp_silver_ring(width, height, thickness, frame_width, make_3d=false)
{
    if (make_3d)
    {
        color("silver")
        difference()
        {
            cube([width, height, thickness]);
            translate([frame_width, frame_width, -frame_width/2])
                cube([width - 2*frame_width,
                    height - 2*frame_width,
                    thickness + 2*frame_width]);
        }
    }
}