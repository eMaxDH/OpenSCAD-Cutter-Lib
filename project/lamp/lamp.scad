use <../../cutter_lib/layer/cl_layer.scad>

use <../../cutter_lib/tower/ct_tower_floor.scad>
use <../../cutter_lib/tower/ct_tower.scad>



use <lamp_floor.scad>

$fn = $preview ? 32 : 128;

make_3d=true;

floor_size = [290,221,243];

wall_thickness = 10; 

visibile_layers = [0,1,2];
cl_layer_info(visibile_layers);

spacing_2d=1;

use_construction_color=true;

lamp(width=floor_size[0], height=floor_size[2], depth=floor_size[1],
                 wall_thickness=wall_thickness, use_construction_color=use_construction_color,
                 visibile_layers=visibile_layers, make_3d=make_3d, spacing_2d=spacing_2d);

module lamp(width, height, depth, wall_thickness, use_construction_color=true,
                        visibile_layers=[], make_3d=false, spacing_2d=1)
{
    ct_tower_arrange(width=width, height=height, depth=depth, wall_thickness=wall_thickness,
                     make_3d=make_3d, spacing_2d=spacing_2d)
    {
        // basement
        lamp_floor_basement(width=width, height=height, depth=depth,
                               wall_thickness=wall_thickness,
                               use_construction_color=use_construction_color,
                               visibile_layers=visibile_layers, make_3d=make_3d);
        // first floor
        lamp_floor_middle_part(width=width, height=height, depth=depth,
                               wall_thickness=wall_thickness,
                               use_construction_color=use_construction_color,
                               visibile_layers=visibile_layers, make_3d=make_3d);
        // second floor
        lamp_floor_middle_part(width=width, height=height, depth=depth,
                               wall_thickness=wall_thickness,
                               use_construction_color=use_construction_color,
                               visibile_layers=visibile_layers, make_3d=make_3d);
        // roof
        lamp_floor_top(width=width, height=height, depth=depth,
                               wall_thickness=wall_thickness,
                               use_construction_color=use_construction_color,
                               visibile_layers=visibile_layers, make_3d=make_3d);
    }
}