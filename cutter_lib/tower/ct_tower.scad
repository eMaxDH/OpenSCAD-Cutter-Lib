use <../layer/cl_layer.scad>
use <../surfaces/cs_test_surface.scad>

use <../shapes/cshape_box.scad>
use <../shapes/cshape_frame.scad>
use <../shapes/cshape_array.scad>

use <ct_tower_wall.scad>

make_3d=true;

floor_size = [200,100,50];

wall_width = 200;
wall_height = 50;
wall_depth=1;

wall_thickness = 10;

frame_overlap = true;

tower_wall_2d_size = get_ct_tower_wall_2d_size(wall_width, wall_height);

strut_size = get_cshape_frame_strut_size(width=wall_width, height=wall_height, frame_width=wall_thickness, overlap=frame_overlap);

visibile_layers = [0];
cl_layer_info(visibile_layers);

spacing_2d=1;

ct_tower(make_3d=make_3d, spacing_2d=spacing_2d)
{
    ct_tower_floor(width=floor_size[0], height=floor_size[2], depth=floor_size[1], wall_thickness=wall_thickness,
                      visibile_layers=visibile_layers, make_3d=make_3d);
}

module ct_tower(make_3d=false, spacing_2d=1)
{
    no_floors = $children;
    // Basement
    children(0);
}

