use <../layer/cl_layer.scad>

use <cs_test_face.scad>
use <cs_test_face_2d.scad>

make_3d=false;

width = 10; //[10:100]
height = 15; //[10:100]
thickness = 2; //[1:5]

number=10;

layer=0;
visibile_layers=[0];

cl_layer_info(visibile_layers);

cs_test_face(width=width, height=height, thickness=thickness, number=number,
             layer=layer, visibile_layers=visibile_layers,
             make_3d=make_3d);

module cs_test_face(width, height, thickness=1, number=0, face_color="",
                    layer=0, visibile_layers=[], make_3d=false) {
    apply_cl_layer_visibility(layer, visibile_layers)
    {
        if (make_3d)
        {
            color("red")
            translate([0, 0, thickness])
            linear_extrude(thickness/10)
                cs_test_face_2d_top(width=width, height=height, number=number);

            if (face_color == "")
                color(cs_testface_get_color(number))
                linear_extrude(thickness)
                    cs_test_face_2d_middle(width=width, height=height, number=number);
            else
                color(face_color)
                linear_extrude(thickness)
                    cs_test_face_2d_middle(width=width, height=height, number=number);

            color("green")
            translate([0, 0, -thickness/10])
            linear_extrude(thickness/10)
                cs_test_face_2d_bottom(width=width, height=height, number=number);
        }
        else
            cs_test_face_2d(width=width, height=height, number=number, face_color=face_color);
    }
}

