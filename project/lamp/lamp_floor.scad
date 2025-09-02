use <../../cutter_lib/layer/cl_layer.scad>
use <../../cutter_lib/surfaces/cs_test_surface.scad>

use <../../cutter_lib/shapes/cshape_box.scad>
// use <../shapes/cshape_array.scad>

use <../../cutter_lib/tower/ct_tower_floor.scad>

use <lamp_wall.scad>


make_3d=true;

floor_size = [200,300,100];

wall_depth=10; // frame thinkness
wall_thickness = 10; 

visibile_layers=[0,1,2];
cl_layer_info(visibile_layers);

spacing_2d=1;

use_construction_color=true;

lamp_floor(floor_size[0], floor_size[2], floor_size[1],
                          wall_thickness=wall_thickness,
                          use_construction_color=use_construction_color,
                          make_3d=make_3d);

module lamp_floor_example(width, height, depth, wall_thickness=1,
                              use_construction_color=use_construction_color,
                              visibile_layers=visibile_layers, make_3d=false, spacing_2d=1)
{
    size_face_move = get_cshape_box_face_size_move(width=width, height=height, depth=depth, 
                                                   thickness=wall_thickness);

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
                    number=4, layer=1, visibile_layers=visibile_layers, make_3d=make_3d);
        // 5: front
        cs_test_surface(width=size_face_move[5][0], height=size_face_move[5][1], thickness=wall_thickness,
                    number=5, layer=2, visibile_layers=visibile_layers, make_3d=make_3d);
    }
}

module lamp_floor(width, height, depth, wall_thickness=1,
                  use_construction_color=use_construction_color,
                  visibile_layers=visibile_layers, make_3d=false, spacing_2d=1)
{
    size_face_move = get_cshape_box_face_size_move(width=width, height=height, depth=depth, 
                                                   thickness=wall_thickness);

    ct_tower_floor_arrange(width=width, height=height, depth=depth, 
                            wall_thickness=wall_thickness,
                            make_3d=make_3d, spacing_2d=spacing_2d)
    {
        // 0: top
        linear_extrude(0)
            text("");
        // 1: back
        lamp_wall(width=size_face_move[1][0], height=size_face_move[1][1],
                    wall_depth=wall_depth, wall_thickness=wall_thickness,
                    front_layer_overlap=0, back_layer_padding=wall_thickness,
                    front_elements_ratio = 1.618, front_element_width = 15,
                    back_elements_ratio = 1.618, back_element_width = 15,
                    layer=[0,1,2], visibile_layers=visibile_layers, 
                    use_construction_color=use_construction_color,
                    make_3d=make_3d);
        // 2: left
        lamp_wall(width=size_face_move[2][0], height=size_face_move[2][1],
                    wall_depth=wall_depth, wall_thickness=wall_thickness,
                    front_layer_overlap=wall_depth, back_layer_padding=0,
                    front_elements_ratio = 1.618, front_element_width = 15,
                    back_elements_ratio = 1.618, back_element_width = 15,
                    layer=[0,1,2], visibile_layers=visibile_layers, 
                    use_construction_color=use_construction_color,
                    make_3d=make_3d);
        // 3: bottom
        linear_extrude(0)
            text("");
        // 4: right
        lamp_wall(width=size_face_move[4][0], height=size_face_move[4][1],
                    wall_depth=wall_depth, wall_thickness=wall_thickness,
                    front_layer_overlap=wall_depth, back_layer_padding=0,
                    front_elements_ratio = 1.618, front_element_width = 15,
                    back_elements_ratio = 1.618, back_element_width = 15,
                    layer=[0,1,2], visibile_layers=visibile_layers, 
                    use_construction_color=use_construction_color,
                    make_3d=make_3d);
        // 5: front
        lamp_wall(width=size_face_move[5][0], height=size_face_move[5][1],
                    wall_depth=wall_depth, wall_thickness=wall_thickness,
                    front_layer_overlap=0, back_layer_padding=wall_thickness,
                    front_elements_ratio = 1.618, front_element_width = 15,
                    back_elements_ratio = 1.618, back_element_width = 15,
                    layer=[0,1,2], visibile_layers=visibile_layers, 
                    use_construction_color=use_construction_color,
                    make_3d=make_3d);
    }
}

module lamp_floor_basement(width, height, depth, wall_thickness=1,
                  use_construction_color=use_construction_color,
                  visibile_layers=visibile_layers, make_3d=false, spacing_2d=1)
{
    size_face_move = get_cshape_box_face_size_move(width=width, height=height, depth=depth, 
                                                   thickness=wall_thickness);

    ct_tower_floor_arrange(width=width, height=height, depth=depth, 
                            wall_thickness=wall_thickness,
                            make_3d=make_3d, spacing_2d=spacing_2d)
    {
        // 0: top
        linear_extrude(0)
            text("");
        // 1: back
        lamp_wall_basement(width=size_face_move[1][0], height=size_face_move[1][1],
                    wall_depth=wall_depth, wall_thickness=wall_thickness,
                    front_layer_overlap=0, back_layer_padding=wall_thickness,
                    front_elements_ratio = 1.618, front_element_width = 15,
                    back_elements_ratio = 1.618, back_element_width = 15,
                    layer=[0,1,2], visibile_layers=visibile_layers, 
                    use_construction_color=use_construction_color,
                    make_3d=make_3d);
        // 2: left
        lamp_wall_basement(width=size_face_move[2][0], height=size_face_move[2][1],
                    wall_depth=wall_depth, wall_thickness=wall_thickness,
                    front_layer_overlap=wall_depth, back_layer_padding=0,
                    front_elements_ratio = 1.618, front_element_width = 15,
                    back_elements_ratio = 1.618, back_element_width = 15,
                    layer=[0,1,2], visibile_layers=visibile_layers, 
                    use_construction_color=use_construction_color,
                    make_3d=make_3d);
        // 3: bottom
        linear_extrude(0)
            text("");
        // 4: right
        lamp_wall_basement(width=size_face_move[4][0], height=size_face_move[4][1],
                    wall_depth=wall_depth, wall_thickness=wall_thickness,
                    front_layer_overlap=wall_depth, back_layer_padding=0,
                    front_elements_ratio = 1.618, front_element_width = 15,
                    back_elements_ratio = 1.618, back_element_width = 15,
                    layer=[0,1,2], visibile_layers=visibile_layers, 
                    use_construction_color=use_construction_color,
                    make_3d=make_3d);
        // 5: front
        lamp_wall_basement(width=size_face_move[5][0], height=size_face_move[5][1],
                    wall_depth=wall_depth, wall_thickness=wall_thickness,
                    front_layer_overlap=0, back_layer_padding=wall_thickness,
                    front_elements_ratio = 1.618, front_element_width = 15,
                    back_elements_ratio = 1.618, back_element_width = 15,
                    layer=[0,1,2], visibile_layers=visibile_layers, 
                    use_construction_color=use_construction_color,
                    make_3d=make_3d);
    }
    frame_thickness=6;
    frame_width=2;
    translate([-frame_width,
               -frame_width, 
               height - frame_thickness/2])
        lamp_silver_ring(width=width + 2*frame_width,
                         height=depth + 2*frame_width,
                         thickness=frame_thickness,
                         frame_width=frame_width,
                         make_3d=make_3d);
}

module lamp_floor_middle_part(width, height, depth, wall_thickness=1,
                  use_construction_color=use_construction_color,
                  visibile_layers=visibile_layers, make_3d=false, spacing_2d=1)
{
    size_face_move = get_cshape_box_face_size_move(width=width, height=height, depth=depth, 
                                                   thickness=wall_thickness);

    ct_tower_floor_arrange(width=width, height=height, depth=depth, 
                            wall_thickness=wall_thickness,
                            make_3d=make_3d, spacing_2d=spacing_2d)
    {
        // 0: top
        linear_extrude(0)
            text("");
        // 1: back
        lamp_wall_middle_part(width=size_face_move[1][0], height=size_face_move[1][1],
                    wall_depth=wall_depth, wall_thickness=wall_thickness,
                    front_layer_overlap=0, back_layer_padding=wall_thickness,
                    front_elements_ratio = 1.618, front_element_width = 15,
                    back_elements_ratio = 1.618, back_element_width = 15,
                    layer=[0,1,2], visibile_layers=visibile_layers, 
                    use_construction_color=use_construction_color,
                    make_3d=make_3d);
        // 2: left
        lamp_wall_middle_part(width=size_face_move[2][0], height=size_face_move[2][1],
                    wall_depth=wall_depth, wall_thickness=wall_thickness,
                    front_layer_overlap=wall_depth, back_layer_padding=0,
                    front_elements_ratio = 1.618, front_element_width = 15,
                    back_elements_ratio = 1.618, back_element_width = 15,
                    layer=[0,1,2], visibile_layers=visibile_layers, 
                    use_construction_color=use_construction_color,
                    make_3d=make_3d);
        // 3: bottom
        linear_extrude(0)
            text("");
        // 4: right
        lamp_wall_middle_part(width=size_face_move[4][0], height=size_face_move[4][1],
                    wall_depth=wall_depth, wall_thickness=wall_thickness,
                    front_layer_overlap=wall_depth, back_layer_padding=0,
                    front_elements_ratio = 1.618, front_element_width = 15,
                    back_elements_ratio = 1.618, back_element_width = 15,
                    layer=[0,1,2], visibile_layers=visibile_layers, 
                    use_construction_color=use_construction_color,
                    make_3d=make_3d);
        // 5: front
        lamp_wall_middle_part(width=size_face_move[5][0], height=size_face_move[5][1],
                    wall_depth=wall_depth, wall_thickness=wall_thickness,
                    front_layer_overlap=0, back_layer_padding=wall_thickness,
                    front_elements_ratio = 1.618, front_element_width = 15,
                    back_elements_ratio = 1.618, back_element_width = 15,
                    layer=[0,1,2], visibile_layers=visibile_layers, 
                    use_construction_color=use_construction_color,
                    make_3d=make_3d);
    }
    frame_thickness=6;
    frame_width=2;
    translate([-frame_width,
               -frame_width, 
               height - frame_thickness/2])
        lamp_silver_ring(width=width + 2*frame_width,
                         height=depth + 2*frame_width,
                         thickness=frame_thickness,
                         frame_width=frame_width,
                         make_3d=make_3d);
}

module lamp_floor_top(width, height, depth, wall_thickness=1,
                  use_construction_color=use_construction_color,
                  visibile_layers=visibile_layers, make_3d=false, spacing_2d=1)
{
    size_face_move = get_cshape_box_face_size_move(width=width, height=height, depth=depth, 
                                                   thickness=wall_thickness);

    ct_tower_floor_arrange(width=width, height=height, depth=depth, 
                            wall_thickness=wall_thickness,
                            make_3d=make_3d, spacing_2d=spacing_2d)
    {
        // 0: top
        linear_extrude(0)
            text("");
        // 1: back
        lamp_wall_top(width=size_face_move[1][0], height=size_face_move[1][1],
                    wall_depth=wall_depth, wall_thickness=wall_thickness,
                    front_layer_overlap=0, back_layer_padding=wall_thickness,
                    front_elements_ratio = 1.618, front_element_width = 15,
                    back_elements_ratio = 1.618, back_element_width = 15,
                    layer=[0,1,2], visibile_layers=visibile_layers, 
                    use_construction_color=use_construction_color,
                    make_3d=make_3d);
        // 2: left
        lamp_wall_top(width=size_face_move[2][0], height=size_face_move[2][1],
                    wall_depth=wall_depth, wall_thickness=wall_thickness,
                    front_layer_overlap=wall_depth, back_layer_padding=0,
                    front_elements_ratio = 1.618, front_element_width = 15,
                    back_elements_ratio = 1.618, back_element_width = 15,
                    layer=[0,1,2], visibile_layers=visibile_layers, 
                    use_construction_color=use_construction_color,
                    make_3d=make_3d);
        // 3: bottom
        linear_extrude(0)
            text("");
        // 4: right
        lamp_wall_top(width=size_face_move[4][0], height=size_face_move[4][1],
                    wall_depth=wall_depth, wall_thickness=wall_thickness,
                    front_layer_overlap=wall_depth, back_layer_padding=0,
                    front_elements_ratio = 1.618, front_element_width = 15,
                    back_elements_ratio = 1.618, back_element_width = 15,
                    layer=[0,1,2], visibile_layers=visibile_layers, 
                    use_construction_color=use_construction_color,
                    make_3d=make_3d);
        // 5: front
        lamp_wall_top(width=size_face_move[5][0], height=size_face_move[5][1],
                    wall_depth=wall_depth, wall_thickness=wall_thickness,
                    front_layer_overlap=0, back_layer_padding=wall_thickness,
                    front_elements_ratio = 1.618, front_element_width = 15,
                    back_elements_ratio = 1.618, back_element_width = 15,
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