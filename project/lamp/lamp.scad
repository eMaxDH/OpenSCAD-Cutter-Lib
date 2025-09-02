use <../../cutter_lib/layer/cl_layer.scad>

use <../../cutter_lib/tower/ct_tower_floor.scad>
use <../../cutter_lib/tower/ct_tower.scad>



use <lamp_floor.scad>

make_3d=true;

floor_size = [290,221,243];

wall_thickness = 10; 

visibile_layers = [0,1,2];
cl_layer_info(visibile_layers);

spacing_2d=1;

use_construction_color=true;

lamp_example(width=floor_size[0], height=floor_size[2], depth=floor_size[1],
                 wall_thickness=wall_thickness, use_construction_color=use_construction_color,
                 visibile_layers=visibile_layers, make_3d=make_3d, spacing_2d=spacing_2d);

module lamp_example(width, height, depth, wall_thickness, use_construction_color=true,
                        visibile_layers=[], make_3d=false, spacing_2d=1)
{
    ct_tower_arrange(width=width, height=height, depth=depth, wall_thickness=wall_thickness,
                     make_3d=make_3d, spacing_2d=spacing_2d)
    {
        // basement
        lamp_floor_example(width=width, height=height, depth=depth,
                               wall_thickness=wall_thickness,
                               test_faces=false,
                               use_construction_color=use_construction_color,
                               visibile_layers=visibile_layers, make_3d=make_3d);
        // first floor
        lamp_floor_example(width=width, height=height, depth=depth,
                               wall_thickness=wall_thickness,
                               test_faces=false,
                               use_construction_color=use_construction_color,
                               visibile_layers=visibile_layers, make_3d=make_3d);
    }
}