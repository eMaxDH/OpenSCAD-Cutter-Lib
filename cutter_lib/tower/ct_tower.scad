use <../layer/cl_layer.scad>

use <ct_tower_floor.scad>

make_3d=true;

floor_size = [200,100,50];

wall_depth = 4; 
frame_width = 15;

frame_overlap = false;

visibile_layers = [0];
cl_layer_info(visibile_layers);

spacing_2d=1;

ct_tower_example(width=floor_size[0], height=floor_size[2], depth=floor_size[1],
                 wall_depth=wall_depth,
                frame_width = frame_width,
                 visibile_layers=visibile_layers, make_3d=make_3d, spacing_2d=spacing_2d);

module ct_tower_example(width, height, depth, wall_depth=wall_depth,
                          frame_width = frame_width,
                        visibile_layers=[], make_3d=false, spacing_2d=1)
{
    ct_tower_arrange(width=width, height=height, depth=depth, wall_depth=wall_depth,
                     make_3d=make_3d, spacing_2d=spacing_2d)
    {
        // basement
        ct_tower_floor_example(width=width, height=height, depth=depth,
                               wall_depth=wall_depth,
                               frame_width = frame_width,
                               frame_overlap=frame_overlap,
                               test_faces=true,
                               visibile_layers=visibile_layers, make_3d=make_3d);
        // first floor
        ct_tower_floor_example(width=width, height=height, depth=depth,
                               wall_depth=wall_depth,
                               frame_width = frame_width,
                               frame_overlap=frame_overlap,
                               test_faces=false,
                               visibile_layers=visibile_layers, make_3d=make_3d);
    }
}

module ct_tower_arrange(width, height, depth, wall_depth,
                make_3d=false, spacing_2d=1)
{
    no_floors = $children;

    if (make_3d)
    {
        for (i = [0:no_floors-1])
        {
            if (is_list(height) && len(height) == no_floors)
            {
                translate([0, 0, i * height[i]])
                    children(i);
            }
            else if (is_num(height))
            {
                translate([0, 0, i * height])
                    children(i);
            }
        }
    }
    else
    {
        size = get_ct_tower_floor_2d_size(width=width, height=height, 
                                          depth=depth, wall_depth=wall_depth);
        for (i = [0:no_floors-1])
        {
            translate([0, i*size[1], 0])
                children(i);
        }
    }
}

