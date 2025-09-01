use <../../cutter_lib/layer/cl_layer.scad>
use <../../cutter_lib/surfaces/cs_test_surface.scad>

use <../../cutter_lib/shapes/cshape_array.scad>
use <../../cutter_lib/shapes/cshape_padding.scad>

use <../../cutter_lib/strut/cs_strut_triangle_45.scad>
use <../../cutter_lib/tower/ct_tower_wall.scad>

use <facing.scad>

make_3d=true;

wall_width = 300;
wall_height = 200;
wall_depth=4;

wall_thickness = 10;


layer=0;
visibile_layers=[0];
use_construction_color=true;
cl_layer_info(visibile_layers);

lamp_wall_example(width=wall_width, height=wall_height,
                      wall_depth=wall_depth, wall_thickness=wall_thickness,
                      visibile_layers=visibile_layers, 
                      use_construction_color=use_construction_color, make_3d=make_3d);

module lamp_wall_example(width, height, wall_thickness=wall_thickness, 
                             wall_depth=1, visibile_layers=[], 
                             use_construction_color=true, make_3d=make_3d)
{
    hole_radius=[1.5,
                 0,
                 0,
                 1.5];
    hole_distance=[266,
                   0,
                   0,
                   266];
    hole_length=5;

    frame_overlap = true;

    strut_size = get_ct_tower_wall_strut_size(width=width, height=height,
                                              thickness=wall_thickness,
                                              overlap=frame_overlap);

    ct_tower_wall_arrange(width=width, height=height, 
                          wall_depth=wall_depth, wall_thickness=wall_thickness,
                          frame_overlap=frame_overlap,
                          make_3d=make_3d)
        {
            // 0: top
            set_color_frame(use_construction_color, "orange")
            translate([0,wall_thickness,0])
            mirror([0,1,0])
            cs_strut_triangle_45(width=strut_size[0][0], height=strut_size[0][1], thickness=wall_depth, type=["f", "f"],
                                hole_radius=hole_radius[0], hole_distance=hole_distance[0], hole_length=hole_length,
                                layer=0, visibile_layers=visibile_layers, make_3d=make_3d);
            // 1: left
            set_color_frame(use_construction_color, "green")
            translate([0,wall_thickness,0])
            mirror([0,1,0])
            cs_strut_triangle_45(width=strut_size[1][0], height=strut_size[1][1], thickness=wall_depth, type=["m", "m"],
                                hole_radius=hole_radius[1], hole_distance=hole_distance[1], hole_length=hole_length,
                                layer=0, visibile_layers=visibile_layers, make_3d=make_3d);
            // 2: right
            set_color_frame(use_construction_color, "red")
            translate([0,wall_thickness,0])
            mirror([0,1,0])
            cs_strut_triangle_45(width=strut_size[2][0], height=strut_size[2][1], thickness=wall_depth, type=["m", "m"],
                                hole_radius=hole_radius[2], hole_distance=hole_distance[2], hole_length=hole_length,
                                layer=0, visibile_layers=visibile_layers, make_3d=make_3d);
            // 3: bottom
            set_color_frame(use_construction_color, "violet")
            translate([0,wall_thickness,0])
            mirror([0,1,0])
            cs_strut_triangle_45(width=strut_size[3][0], height=strut_size[3][1], thickness=wall_depth, type=["f", "f"],
                                hole_radius=hole_radius[3], hole_distance=hole_distance[3], hole_length=hole_length,
                                layer=0, visibile_layers=visibile_layers, make_3d=make_3d);

            // 4: front
            lamp_wall_front(width=width, height=height,
                        layer=1, visibile_layers=visibile_layers, make_3d=make_3d);
            // 5: back
            {
                padding=[wall_depth];
                new_size = get_cshape_padding_new_object_size(size=[width, height, 0], padding=padding);
                cshape_padding(padding=padding, new_size=new_size, show_placeholder=true)
                lamp_wall_back(width=new_size[0], height=new_size[1],
                            layer=2, visibile_layers=visibile_layers, make_3d=make_3d);
            }
        }
}

module lamp_wall_front(width, height, thickness=1,
                        layer=0, visibile_layers=[],
                        make_3d=false, spacing_2d=1)
{
    no_elements = 10;
    no_elements_x = 10;
    element_padding = 15;
    array_plane="xy";


    element_size = get_cshape_array_element_size(width=width, height=height,
                                                no_elements=no_elements, no_elements_x=no_elements_x,
                                                element_padding=element_padding);
    
    set_color_facing_front()
    apply_cl_layer_visibility(layer, visibile_layers)
    cshape_array_repeat(width, height,
                        no_elements=no_elements,
                        no_elements_x=no_elements_x,
                        element_padding=element_padding,
                        array_plane=array_plane,
                        make_3d=make_3d, spacing_2d=1)
    {
        // cs_test_surface(width=element_size[0], height=element_size[1], thickness=1, number=0, make_3d=make_3d);
        square(element_size);
    }
}

module lamp_wall_back(width, height, thickness=1,
                        layer=0, visibile_layers=[],
                        make_3d=false, spacing_2d=1)
{
    no_elements = 9;
    no_elements_x = no_elements;
    element_padding = 15;
    array_plane="xy";


    element_size = get_cshape_array_element_size(width=width, height=height,
                                                no_elements=no_elements, no_elements_x=no_elements_x,
                                                element_padding=element_padding);
    
    set_color_facing_back()
    apply_cl_layer_visibility(layer, visibile_layers)
    cshape_array_repeat(width, height,
                        no_elements=no_elements,
                        no_elements_x=no_elements_x,
                        element_padding=element_padding,
                        array_plane=array_plane,
                        make_3d=make_3d, spacing_2d=1)
    {
        // cs_test_surface(width=element_size[0], height=element_size[1], thickness=1, number=0, make_3d=make_3d);
        square(element_size);
    }
}

module set_color_facing_front()
{
    color("SaddleBrown")
        children();
}

module set_color_facing_back()
{
    color("Cornsilk")
        children();
}

module set_color_frame(use_construction_color, construction_color)
{
    if (use_construction_color)
        color(construction_color)
            children();
    else
        color("Wheat")
            children();
}
