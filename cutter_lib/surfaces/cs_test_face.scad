use <cs_test_face.scad>
use <cs_test_face_2d.scad>

make_3d=false;

width = 10; //[10:100]
height = 15; //[10:100]
thickness = 2; //[1:5]

number=10;


cs_test_face(width=width, height=height, thickness=thickness, number=number, make_3d=make_3d);

module cs_test_face(width, height, thickness=1, number=0, make_3d=false) {
    if (make_3d)
    {
        color("red")
        translate([0, 0, thickness])
        linear_extrude(thickness/10)
            cs_test_face_2d_top(width=width, height=height, number=number);

        color(cs_testface_get_color(number))
        linear_extrude(thickness)
            cs_test_face_2d_middle(width=width, height=height, number=number);

        color("green")
        translate([0, 0, -thickness/10])
        linear_extrude(thickness/10)
            cs_test_face_2d_bottom(width=width, height=height, number=number);
    }
    else
        cs_test_face_2d(width=width, height=height, number=number);
}

