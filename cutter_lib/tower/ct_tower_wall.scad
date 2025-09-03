use <../layer/cl_layer.scad>
use <../surfaces/cs_test_surface.scad>

use <../shapes/cshape_box.scad>
use <../shapes/cshape_frame.scad>
use <../shapes/cshape_array.scad>
use <../shapes/cshape_padding.scad>

make_3d=true;

wall_width = 200;
wall_height = 50;
wall_depth=1;

frame_width = 10;

frame_overlap = true;

front_padding = [0, 0];

layer=0;
visibile_layers=[0];

cl_layer_info(visibile_layers);

ct_tower_wall_example(width=wall_width, height=wall_height,
                      wall_depth=wall_depth, frame_width=frame_width,
                      visibile_layers=visibile_layers, make_3d=make_3d);

module ct_tower_wall_example(width, height, frame_width=frame_width, 
                             wall_depth=1, frame_overlap=false,
                             visibile_layers=[], make_3d=make_3d)
{
    strut_size = get_ct_tower_wall_strut_size(width=width, height=height, thickness=frame_width,
                                              overlap=frame_overlap);

    ct_tower_wall_arrange(width=width, height=height, 
                          wall_depth=wall_depth, frame_width=frame_width,
                          frame_overlap=frame_overlap,
                          make_3d=make_3d)
        {
            // 0: top frame strut
            cs_test_surface(width=strut_size[0][0], height=strut_size[0][1], thickness=wall_depth, number=0,
                        layer=0, visibile_layers=visibile_layers, make_3d=make_3d);
            // 1: left frame strut
            cs_test_surface(width=strut_size[1][0], height=strut_size[1][1], thickness=wall_depth, number=1,
                        layer=0, visibile_layers=visibile_layers, make_3d=make_3d);
            // 2: right frame strut
            cs_test_surface(width=strut_size[2][0], height=strut_size[2][1], thickness=wall_depth, number=2, 
                        layer=0, visibile_layers=visibile_layers, make_3d=make_3d);
            // 3: bottom frame strut
            cs_test_surface(width=strut_size[3][0], height=strut_size[3][1], thickness=wall_depth, number=3, 
                        layer=0, visibile_layers=visibile_layers, make_3d=make_3d);

            // 4: front
            {
                
                new_size = get_cshape_padding_new_object_size(size=[width, height, wall_depth], padding=front_padding);
                cshape_padding(padding=front_padding, new_size=new_size, show_placeholder=true)
                // new_size=[width, height, wall_depth];
                cs_test_surface(width=new_size[0], height=new_size[1], thickness=new_size[2], number=4, face_color=[1,0,0,0.1], 
                            layer=1, visibile_layers=visibile_layers, make_3d=make_3d);
            }
            // 5: back
            cs_test_surface(width=width, height=height, thickness=wall_depth, number=5, face_color=[0,1,0,0.1], 
                        layer=2, visibile_layers=visibile_layers, make_3d=make_3d);
        }
}

// ct_tower_wall_arrange(width=wall_width, height=wall_height, 
//               wall_depth=1, frame_width=frame_width,
//               frame_overlap=frame_overlap,
//               make_3d=make_3d)
// {
//     // 0: top frame strut
//     cs_test_surface(width=strut_size[0][0], height=strut_size[0][1], thickness=wall_depth, number=0,
//                  layer=0, visibile_layers=visibile_layers, make_3d=make_3d);
//     // 1: left frame strut
//     cs_test_surface(width=strut_size[1][0], height=strut_size[1][1], thickness=wall_depth, number=1,
//                  layer=0, visibile_layers=visibile_layers, make_3d=make_3d);
//     // 2: right frame strut
//     cs_test_surface(width=strut_size[2][0], height=strut_size[2][1], thickness=wall_depth, number=2, 
//                  layer=0, visibile_layers=visibile_layers, make_3d=make_3d);
//     // 3: bottom frame strut
//     cs_test_surface(width=strut_size[3][0], height=strut_size[3][1], thickness=wall_depth, number=3, 
//                  layer=0, visibile_layers=visibile_layers, make_3d=make_3d);

//     // 4: front
//     cs_test_surface(width=wall_width, height=wall_height, thickness=wall_depth, number=4, face_color=[1,0,0,0.1], 
//                  layer=1, visibile_layers=visibile_layers, make_3d=make_3d);
//     // 5: back
//     cs_test_surface(width=wall_width, height=wall_height, thickness=wall_depth, number=5, face_color=[0,1,0,0.1], 
//                  layer=2, visibile_layers=visibile_layers, make_3d=make_3d);
// }

//  A tower wall is made out of 3 parts, the front, frame, and back layer.
//
//  Layers
//  ----
//                ^ surface normal 
//          ----------------------     <- front
//  ^ z    |                      |    <- frame
//  |       ----------------------     <- back
//                v surface normal
//
//   INFO: The back layer is arranged so that the surface normal (z-axis) points in the -z direction of the wall coordinatesystem.
//
//  Dimensions
//  ---- 
//
//         <--       width      --> 
//          ----------------------  ^                <- front
//  ^ z    |                      | |  wall_depth    <- frame
//  |       ----------------------  v                <- back
//  --> x
//
//
//         <--        width       --> 
//          ------------------------    ^    
//         |     frame              |   |
//         |    ----------------    |   |
//         | wt |              |    |   |height 
//         |<-->|              |    |   | 
//         |    |              |    |   |
//         |    ----------------    |   | 
//  ^ y    |                      t |   | 
//  |       ------------------------    v
//  --> x
//               wt: frame_width  aka frame_width (chsape_frame)
//                t: wall_depth      aka thickness (chshape_frame)
//
//
module ct_tower_wall_arrange(width, height, wall_depth = 0.1, frame_width=1, frame_overlap=false,
                     make_3d=false, spacing_2d=1)
{
    no_children = $children;
    frame_layer = [0,3];
    front_layer = 4;
    back_layer = 5;
    if (make_3d)
    {
        cshape_frame_arrange(width=width, height=height, frame_width = frame_width, thickness = wall_depth, overlap=frame_overlap, make_3d=make_3d, spacing_2d=1)
        {
            // 0: top
            children(0);
            // 1: left
            children(1);
            // 2: right
            children(2);
            // 3: bottom
            children(3);
        }
        if (no_children >= front_layer)
            translate([0, 0, wall_depth])
                children(4);
        if (no_children >= back_layer)
            // translate([width, 0, 0])
            // rotate([0,180,0])
                children(5);
    }
    else
    {
        cshape_frame_arrange(width=width, height=height, frame_width = frame_width, thickness = wall_depth, overlap=frame_overlap, make_3d=make_3d, spacing_2d=1)
        {
            // 0: top
            children(0);
            // 1: left
            children(1);
            // 2: right
            children(2);
            // 3: bottom
            children(3);
        }
        if (no_children >= front_layer)
            translate([0, 0, wall_depth*1.5])
                children(4);
        if (no_children >= back_layer)
            translate([0, 0, -wall_depth*1.5])
                children(5);
    }
}

function get_ct_tower_wall_2d_size(width, height, spacing_2d=1) =
    [width + spacing_2d, height + spacing_2d, 0];

function get_ct_tower_wall_strut_size(width, height, thickness, overlap) =
    get_cshape_frame_strut_size(width=width, height=height,
                                frame_width=thickness, 
                                overlap=overlap);