use <../../cutter_lib/layer/cl_layer.scad>
use <../../cutter_lib/surfaces/cs_test_surface.scad>

use <../../cutter_lib/shapes/cshape_array.scad>
use <../../cutter_lib/shapes/cshape_padding.scad>

use <../../cutter_lib/strut/cs_strut_triangle_45.scad>
use <../../cutter_lib/tower/ct_tower_wall.scad>

make_3d=true;

wall_width = 300;
wall_height = 200;
wall_depth=4;

wall_thickness = 10;

front_element_width = 15;
front_elements_ratio = 1.5;

back_element_width = 15;
back_elements_ratio = 1.5;

visibile_layers=[0,1,2];
use_construction_color=true;
cl_layer_info(visibile_layers);

only_front_back_layer=false;

if (only_front_back_layer)

{
    lamp_wall_front_level(width=wall_width, height=wall_height,
                        no_elements = 9,
                        element_width = front_element_width, element_hight = wall_height,
                        layer=0, visibile_layers=visibile_layers, make_3d=make_3d);

    translate([0,wall_height + 10, 0])
    lamp_wall_back_level(width=wall_width, height=wall_height,
                        no_elements = 7,
                        element_width = back_element_width, element_hight = wall_height,
                        layer=0, visibile_layers=visibile_layers, make_3d=make_3d);
}
else
{
    translate([-20,wall_height,0])
    linear_extrude(1)
        text("lamp_wall", halign="right", size = 8);
    lamp_wall(width=wall_width, height=wall_height,
                        wall_depth=wall_depth, wall_thickness=wall_thickness,
                        front_elements_ratio = front_elements_ratio, front_element_width = front_element_width,
                        back_elements_ratio = back_elements_ratio, back_element_width = back_element_width,
                        visibile_layers=visibile_layers, 
                        use_construction_color=use_construction_color, make_3d=make_3d);

    translate([0, wall_height * 1.2,0])
    {
        translate([-20,wall_height,0])
        linear_extrude(1)
            text("lamp_wall_middle_part", halign="right", size = 8);
        lamp_wall_middle_part(width=wall_width, height=wall_height,
                            wall_depth=wall_depth, wall_thickness=wall_thickness,
                            front_elements_ratio = front_elements_ratio, front_element_width = front_element_width,
                            back_elements_ratio = back_elements_ratio, back_element_width = back_element_width,
                            visibile_layers=visibile_layers, 
                            use_construction_color=use_construction_color, make_3d=make_3d);
    }

    translate([0, 2*wall_height * 1.2,0])
    {
        translate([-20,wall_height,0])
        linear_extrude(1)
            text("lamp_wall_top", halign="right", size = 8);
        lamp_wall_top(width=wall_width, height=wall_height,
                            wall_depth=wall_depth, wall_thickness=wall_thickness,
                            front_elements_ratio = front_elements_ratio, front_element_width = front_element_width,
                            back_elements_ratio = back_elements_ratio, back_element_width = back_element_width,
                            visibile_layers=visibile_layers, 
                            use_construction_color=use_construction_color, make_3d=make_3d);
    }
}


module lamp_wall(width, height, wall_thickness=wall_thickness, 
                 wall_depth=1, front_layer_overlap=5, back_layer_padding=5,
                 front_elements_ratio = 1.5, front_element_width = 15,
                 back_elements_ratio = 1.5, back_element_width = 15,
                 layer=[0,1,2], visibile_layers=[], 
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

    front_no_elements = get_lamp_wall_element_no(width, front_element_width, front_elements_ratio);
    back_no_elements = get_lamp_wall_element_no(width, back_element_width, back_elements_ratio);

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
                                layer=layer[0], visibile_layers=visibile_layers, make_3d=make_3d);
            // 1: left
            set_color_frame(use_construction_color, "green")
            translate([0,wall_thickness,0])
            mirror([0,1,0])
            cs_strut_triangle_45(width=strut_size[1][0], height=strut_size[1][1], thickness=wall_depth, type=["m", "m"],
                                hole_radius=hole_radius[1], hole_distance=hole_distance[1], hole_length=hole_length,
                                layer=layer[0], visibile_layers=visibile_layers, make_3d=make_3d);
            // 2: right
            set_color_frame(use_construction_color, "red")
            translate([0,wall_thickness,0])
            mirror([0,1,0])
            cs_strut_triangle_45(width=strut_size[2][0], height=strut_size[2][1], thickness=wall_depth, type=["m", "m"],
                                hole_radius=hole_radius[2], hole_distance=hole_distance[2], hole_length=hole_length,
                                layer=layer[0], visibile_layers=visibile_layers, make_3d=make_3d);
            // 3: bottom
            set_color_frame(use_construction_color, "violet")
            translate([0,wall_thickness,0])
            mirror([0,1,0])
            cs_strut_triangle_45(width=strut_size[3][0], height=strut_size[3][1], thickness=wall_depth, type=["f", "f"],
                                hole_radius=hole_radius[3], hole_distance=hole_distance[3], hole_length=hole_length,
                                layer=layer[0], visibile_layers=visibile_layers, make_3d=make_3d);

            // 4: front
            {
                translate([-front_layer_overlap,0,0])
                lamp_wall_front_level(width=width+2*front_layer_overlap, height=height,
                                      no_elements = front_no_elements, element_width = front_element_width,
                                      layer=layer[1], visibile_layers=visibile_layers, make_3d=make_3d);
            }
            // 5: back
            {
                padding_back=[back_layer_padding];
                new_size_back = get_cshape_padding_new_object_size(size=[width, height, 0], padding=padding_back);
                cshape_padding(padding=padding_back, new_size=new_size_back, show_placeholder=false)
                lamp_wall_back_level(width=new_size_back[0], height=new_size_back[1],
                                     no_elements = back_no_elements, element_width = back_element_width,
                                     layer=layer[2], visibile_layers=visibile_layers, make_3d=make_3d);
            }
        }
}

module lamp_wall_basement(width, height, wall_thickness=wall_thickness, 
                            wall_depth=1, front_layer_overlap=5, back_layer_padding=5,
                            front_elements_ratio = 1.5, front_element_width = 15,
                            back_elements_ratio = 1.5, back_element_width = 15,
                            layer=[0,1,2], visibile_layers=[], 
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

    front_no_elements = get_lamp_wall_element_no(width, front_element_width, front_elements_ratio);
    back_no_elements = get_lamp_wall_element_no(width, back_element_width, back_elements_ratio);

    ct_tower_wall_arrange(width=width, height=height, 
                          wall_depth=wall_depth, wall_thickness=wall_thickness,
                          frame_overlap=frame_overlap,
                          make_3d=make_3d)
        {
            // 0: top
            {
                set_color_frame(use_construction_color, "orange")
                translate([0,wall_thickness,0])
                {
                    mirror([0,1,0])
                    cs_strut_triangle_45(width=strut_size[0][0], height=strut_size[0][1], thickness=wall_depth, type=["f", "f"],
                                        hole_radius=hole_radius[0], hole_distance=hole_distance[0], hole_length=hole_length,
                                        layer=layer[0], visibile_layers=visibile_layers, make_3d=make_3d);

                    translate([0,0,0])
                    cs_strut_triangle_45(width=strut_size[0][0], height=strut_size[0][1], thickness=wall_depth, type=["f", "f"],
                                        hole_radius=hole_radius[0], hole_distance=hole_distance[0], hole_length=hole_length,
                                        layer=layer[0], visibile_layers=visibile_layers, make_3d=make_3d);
                }
            }
            // 1: left
            set_color_frame(use_construction_color, "green")
            translate([0,wall_thickness,0])
            mirror([0,1,0])
            cs_strut_triangle_45(width=strut_size[1][0], height=strut_size[1][1], thickness=wall_depth, type=["m", "m"],
                                hole_radius=hole_radius[1], hole_distance=hole_distance[1], hole_length=hole_length,
                                layer=layer[0], visibile_layers=visibile_layers, make_3d=make_3d);
            // 2: right
            set_color_frame(use_construction_color, "red")
            translate([0,wall_thickness,0])
            mirror([0,1,0])
            cs_strut_triangle_45(width=strut_size[2][0], height=strut_size[2][1], thickness=wall_depth, type=["m", "m"],
                                hole_radius=hole_radius[2], hole_distance=hole_distance[2], hole_length=hole_length,
                                layer=layer[0], visibile_layers=visibile_layers, make_3d=make_3d);
            // 3: bottom
            set_color_frame(use_construction_color, "violet")
            translate([0,wall_thickness,0])
            mirror([0,1,0])
            cs_strut_triangle_45(width=strut_size[3][0], height=strut_size[3][1], thickness=wall_depth, type=["f", "f"],
                                hole_radius=hole_radius[3], hole_distance=hole_distance[3], hole_length=hole_length,
                                layer=layer[0], visibile_layers=visibile_layers, make_3d=make_3d);

            // 4: front
            {
                translate([-front_layer_overlap,0,0])
                lamp_wall_front_level(width=width+2*front_layer_overlap, height=height,
                                      no_elements = front_no_elements, element_width = front_element_width,
                                      layer=layer[1], visibile_layers=visibile_layers, make_3d=make_3d);
            }
            // 5: back
            {
                padding_back=[back_layer_padding];
                new_size_back = get_cshape_padding_new_object_size(size=[width, height, 0], padding=padding_back);
                cshape_padding(padding=padding_back, new_size=new_size_back, show_placeholder=false)
                lamp_wall_back_level(width=new_size_back[0], height=new_size_back[1],
                                     no_elements = back_no_elements, element_width = back_element_width,
                                     layer=layer[2], visibile_layers=visibile_layers, make_3d=make_3d);
            }
        }
}

module lamp_wall_middle_part(width, height, wall_thickness=wall_thickness, 
                            wall_depth=1, front_layer_overlap=5, back_layer_padding=5,
                            front_elements_ratio = 1.5, front_element_width = 15,
                            back_elements_ratio = 1.5, back_element_width = 15,
                            layer=[0,1,2], visibile_layers=[], 
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

    front_no_elements = get_lamp_wall_element_no(width, front_element_width, front_elements_ratio);
    back_no_elements = get_lamp_wall_element_no(width, back_element_width, back_elements_ratio);

    ct_tower_wall_arrange(width=width, height=height, 
                          wall_depth=wall_depth, wall_thickness=wall_thickness,
                          frame_overlap=frame_overlap,
                          make_3d=make_3d)
        {
            // 0: top
            {
                set_color_frame(use_construction_color, "orange")
                translate([0,wall_thickness,0])
                {
                    mirror([0,1,0])
                    cs_strut_triangle_45(width=strut_size[0][0], height=strut_size[0][1], thickness=wall_depth, type=["f", "f"],
                                        hole_radius=hole_radius[0], hole_distance=hole_distance[0], hole_length=hole_length,
                                        layer=layer[0], visibile_layers=visibile_layers, make_3d=make_3d);

                    translate([0,0,0])
                    cs_strut_triangle_45(width=strut_size[0][0], height=strut_size[0][1], thickness=wall_depth, type=["f", "f"],
                                        hole_radius=hole_radius[0], hole_distance=hole_distance[0], hole_length=hole_length,
                                        layer=layer[0], visibile_layers=visibile_layers, make_3d=make_3d);
                }
            }
            // 1: left
            set_color_frame(use_construction_color, "green")
            translate([0,wall_thickness,0])
            mirror([0,1,0])
            cs_strut_triangle_45(width=strut_size[1][0], height=strut_size[1][1], thickness=wall_depth, type=["m", "m"],
                                hole_radius=hole_radius[1], hole_distance=hole_distance[1], hole_length=hole_length,
                                layer=layer[0], visibile_layers=visibile_layers, make_3d=make_3d);
            // 2: right
            set_color_frame(use_construction_color, "red")
            translate([0,wall_thickness,0])
            mirror([0,1,0])
            cs_strut_triangle_45(width=strut_size[2][0], height=strut_size[2][1], thickness=wall_depth, type=["m", "m"],
                                hole_radius=hole_radius[2], hole_distance=hole_distance[2], hole_length=hole_length,
                                layer=layer[0], visibile_layers=visibile_layers, make_3d=make_3d);
            // 3: bottom
            linear_extrude(1)
                text("");

            // 4: front
            {
                translate([-front_layer_overlap,0,0])
                lamp_wall_front_level(width=width+2*front_layer_overlap, height=height,
                                      no_elements = front_no_elements, element_width = front_element_width,
                                      layer=layer[1], visibile_layers=visibile_layers, make_3d=make_3d);
            }
            // 5: back
            {
                padding_back=[back_layer_padding];
                new_size_back = get_cshape_padding_new_object_size(size=[width, height, 0], padding=padding_back);
                cshape_padding(padding=padding_back, new_size=new_size_back, show_placeholder=false)
                lamp_wall_back_level(width=new_size_back[0], height=new_size_back[1],
                                     no_elements = back_no_elements, element_width = back_element_width,
                                     layer=layer[2], visibile_layers=visibile_layers, make_3d=make_3d);
            }
        }
}

module lamp_wall_top(width, height, wall_thickness=wall_thickness, 
                            wall_depth=1, front_layer_overlap=5, back_layer_padding=5,
                            front_elements_ratio = 1.5, front_element_width = 15,
                            back_elements_ratio = 1.5, back_element_width = 15,
                            layer=[0,1,2], visibile_layers=[], 
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

    front_no_elements = get_lamp_wall_element_no(width, front_element_width, front_elements_ratio);
    back_no_elements = get_lamp_wall_element_no(width, back_element_width, back_elements_ratio);

    ct_tower_wall_arrange(width=width, height=height, 
                          wall_depth=wall_depth, wall_thickness=wall_thickness,
                          frame_overlap=frame_overlap,
                          make_3d=make_3d)
        {
            // 0: top
            {
                set_color_frame(use_construction_color, "orange")
                translate([0,wall_thickness,0])
                {
                    mirror([0,1,0])
                    cs_strut_triangle_45(width=strut_size[0][0], height=strut_size[0][1], thickness=wall_depth, type=["f", "f"],
                                        hole_radius=hole_radius[0], hole_distance=hole_distance[0], hole_length=hole_length,
                                        layer=layer[0], visibile_layers=visibile_layers, make_3d=make_3d);
                }
            }
            // 1: left
            set_color_frame(use_construction_color, "green")
            translate([0,wall_thickness,0])
            mirror([0,1,0])
            cs_strut_triangle_45(width=strut_size[1][0], height=strut_size[1][1], thickness=wall_depth, type=["m", "m"],
                                hole_radius=hole_radius[1], hole_distance=hole_distance[1], hole_length=hole_length,
                                layer=layer[0], visibile_layers=visibile_layers, make_3d=make_3d);
            // 2: right
            set_color_frame(use_construction_color, "red")
            translate([0,wall_thickness,0])
            mirror([0,1,0])
            cs_strut_triangle_45(width=strut_size[2][0], height=strut_size[2][1], thickness=wall_depth, type=["m", "m"],
                                hole_radius=hole_radius[2], hole_distance=hole_distance[2], hole_length=hole_length,
                                layer=layer[0], visibile_layers=visibile_layers, make_3d=make_3d);
            // 3: bottom
            linear_extrude(1)
                text("");

            // 4: front
            {
                translate([-front_layer_overlap,0,0])
                lamp_wall_front_level(width=width+2*front_layer_overlap, height=height,
                                      no_elements = front_no_elements, element_width = front_element_width,
                                      layer=layer[1], visibile_layers=visibile_layers, make_3d=make_3d);
            }
            // 5: back
            {
                padding_back=[back_layer_padding];
                new_size_back = get_cshape_padding_new_object_size(size=[width, height, 0], padding=padding_back);
                cshape_padding(padding=padding_back, new_size=new_size_back, show_placeholder=false)
                lamp_wall_back_level(width=new_size_back[0], height=new_size_back[1],
                                     no_elements = back_no_elements, element_width = back_element_width,
                                     layer=layer[2], visibile_layers=visibile_layers, make_3d=make_3d);
            }
        }
}

module lamp_wall_front_level(width, height, thickness=1,
                        no_elements = 9,
                        element_width = 15, element_hight = 15,
                        layer=0, visibile_layers=[],
                        make_3d=false, spacing_2d=1)
{
    array_plane="xy";
    element_size = get_cshape_array_element_size(width=width, height=height,
                                                no_elements_sum=no_elements, no_elements_x=no_elements,
                                                element_width=element_width);
    
    echo(str("element_size", element_size));

    set_color_facing_front()
    apply_cl_layer_visibility(layer, visibile_layers)
    cshape_array_repeat(width, height,
                        repeat=no_elements,
                        no_elements_x=no_elements,
                        element_width=element_width,
                        array_plane=array_plane,
                        make_3d=make_3d, spacing_2d=1)
    {
        if (make_3d)
        {
            cube([element_size[0], height, thickness]);
        }
        else
        {
            square(size=[element_size[0], height]);
        }
    }
}

module lamp_wall_back_level(width, height, thickness=1,
                        no_elements = 9,
                        element_width = 15, element_hight = 15,
                        layer=0, visibile_layers=[],
                        make_3d=false, spacing_2d=1)
{
    array_plane="xy";
    element_size = get_cshape_array_element_size(width=width, height=height,
                                                no_elements_sum=no_elements, no_elements_x=no_elements,
                                                element_width=element_width);
    
    set_color_facing_back()
    apply_cl_layer_visibility(layer, visibile_layers)
    cshape_array_repeat(width, height,
                        repeat=no_elements,
                        no_elements_x=no_elements,
                        element_width=element_width,
                        array_plane=array_plane,
                        make_3d=make_3d, spacing_2d=1)
    {
        if (make_3d)
        {
            cube([element_size[0], height, thickness]);
        }
        else
        {
            square(size=[element_size[0], height]);
        }
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
function get_lamp_wall_element_no(width, element_width, ratio) = 
    floor(width / (ratio*element_width));
