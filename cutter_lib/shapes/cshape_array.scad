use <../surfaces/cs_test_face.scad>


make_3d=false;

width= 150;
height= 120;
thickness = 4;

element_width = 10;
element_hight = 15;

no_elements_x = 3;
no_elements_y = 2;

size_struc = [[20,20],
              [25,20],
              [30,20],
              [35,20],
              [40,20]];

cshape_array_arrange(width, height, element_width, element_hight,
                     no_elements_x=3,
                     thickness=thickness,
                     make_3d=make_3d, spacing_2d=1)
{
    cs_test_face(width=size_struc[0][0], height=size_struc[0][1], thickness=thickness, number=0, make_3d=make_3d);
    cs_test_face(width=size_struc[1][0], height=size_struc[1][1], thickness=thickness, number=1, make_3d=make_3d);
    cs_test_face(width=size_struc[2][0], height=size_struc[2][1], thickness=thickness, number=2, make_3d=make_3d);
    cs_test_face(width=size_struc[3][0], height=size_struc[3][1], thickness=thickness, number=3, make_3d=make_3d);
    cs_test_face(width=size_struc[3][0], height=size_struc[3][1], thickness=thickness, number=4, make_3d=make_3d);
    cs_test_face(width=size_struc[3][0], height=size_struc[3][1], thickness=thickness, number=5, make_3d=make_3d);
    cs_test_face(width=size_struc[3][0], height=size_struc[3][1], thickness=thickness, number=6, make_3d=make_3d);
}

//
//    ----------------------   ^
//    |  4   | 5    | 6    |   |
//    |      |      |      |   |
//    |--------------------|   |height
//    |  0   | 1    | 2    |   |
//    |      |      |      |   |
//    x---------------------   v
//           
//    <--- width --->
//  x: origin
//
//  ^ y 
//  |   
//  ---> x
module cshape_array_arrange(width, height, element_width, element_hight,
                            no_elements_x=1,
                            thickness=thickness,
                            make_3d=make_3d, spacing_2d=1)
{   
    no_elements = $children;
    echo("no_elements: ", no_elements);
    no_x = (no_elements > no_elements_x) ? no_elements_x : 0;
    no_y = ceil(no_elements / no_elements_x);
    no_x_2 = ceil(sqrt(no_elements));
    no_y_2 = ceil(sqrt(no_elements));

    echo("no_x: ", no_x);
    echo("no_y: ", no_y);
    echo("no_x_2: ", no_x_2);
    echo("no_y_2: ", no_y_2);

    array_size = (no_elements >= no_elements_x) ? [no_x, no_y] : [no_x_2, no_y_2];
    echo("array_size: ", array_size);

    d_x = width / array_size[0];
    d_y = width / array_size[1];

    for (i_x = [0:(array_size[0]-1)])
    {
        for (i_y = [0:(array_size[0]-1)])
        {
            // i = i_x * array_size[0] + i_y;
            i = i_y * array_size[0] + i_x;
            if (i < no_elements)
                // translate([i_x*d_x, i_y*d_y, 0])
                translate([i_x*d_x, i_y*d_y, 0])
                    children(i);
        }
    }
}
