use <../../cutter_lib/layer/cl_layer.scad>

use <../../cutter_lib/tower/ct_tower_floor.scad>
use <../../cutter_lib/tower/ct_tower.scad>



use <lamp_floor.scad>

$fn = $preview ? 32 : 128;

make_3d=true;

floor_size = [294,244,228];

frame_width = 10;
wall_depth = 4;

visibile_layers = [0,1,2];
cl_layer_info(visibile_layers);

spacing_2d=1;

use_construction_color=true;

lamp(width=floor_size[0], height=floor_size[2], depth=floor_size[1],
                 frame_width=frame_width, wall_depth=wall_depth, 
                 use_construction_color=use_construction_color,
                 visibile_layers=visibile_layers, make_3d=make_3d, spacing_2d=spacing_2d);

module lamp(width, height, depth, wall_depth=4, frame_width=15, use_construction_color=true,
                        visibile_layers=[], make_3d=false, spacing_2d=1)
{
    ct_tower_arrange(width=width, height=height, depth=depth, 
                     wall_depth=wall_depth,
                     make_3d=make_3d, spacing_2d=spacing_2d)
    {
        // basement
        lamp_floor_basement(width=width, height=height, depth=depth,
                               frame_width=frame_width, wall_depth=wall_depth,
                               front_elements_ratio = 1.618, front_element_width = 15,
                               back_elements_ratio = 1.618, back_element_width = 15,
                               use_construction_color=use_construction_color,
                               visibile_layers=visibile_layers, make_3d=make_3d);
        // first floor
        lamp_floor_middle_part(width=width, height=height, depth=depth,
                               frame_width=frame_width, wall_depth=wall_depth,
                               front_elements_ratio = 1.618, front_element_width = 15,
                               back_elements_ratio = 1.618, back_element_width = 15,
                               use_construction_color=use_construction_color,
                               visibile_layers=visibile_layers, make_3d=make_3d);
        // second floor
        lamp_floor_middle_part(width=width, height=height, depth=depth,
                               frame_width=frame_width, wall_depth=wall_depth,
                               front_elements_ratio = 1.618, front_element_width = 15,
                               back_elements_ratio = 1.618, back_element_width = 15,
                               use_construction_color=use_construction_color,
                               visibile_layers=visibile_layers, make_3d=make_3d);
        // roof
        lamp_floor_top(width=width, height=height, depth=depth,
                               frame_width=frame_width, wall_depth=wall_depth,
                               front_elements_ratio = 1.618, front_element_width = 15,
                               back_elements_ratio = 1.618, back_element_width = 15,
                               use_construction_color=use_construction_color,
                               visibile_layers=visibile_layers, make_3d=make_3d);
    }
}