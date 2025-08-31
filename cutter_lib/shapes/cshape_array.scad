use <../surfaces/cs_test_face.scad>


make_3d=true;

width= 100;
height= 200;
thickness = 4;

element_width = 10;
element_hight = 15;

no_elements_x = 2;

no_elements = 7;

element_padding = 10;

element_size = get_cshape_array_element_size(width, height,
                                             no_elements=no_elements, no_elements_x=no_elements_x,
                                             element_padding=element_padding);
echo("element_size: ", element_size);

size_strut = [element_size,
              element_size,
              element_size,
              element_size,
              element_size];


cshape_array_arrange(width, height,
                     no_elements_x=no_elements_x,
                     element_padding=element_padding,
                     thickness=thickness,
                     make_3d=make_3d, spacing_2d=1)
{
    // 0
    cs_test_face(width=size_strut[0][0], height=size_strut[0][1], thickness=thickness, number=0, make_3d=make_3d);
    // 1
    cs_test_face(width=size_strut[1][0], height=size_strut[1][1], thickness=thickness, number=1, make_3d=make_3d);
    // 2
    cs_test_face(width=size_strut[2][0], height=size_strut[2][1], thickness=thickness, number=2, make_3d=make_3d);
    // 3
    cs_test_face(width=size_strut[3][0], height=size_strut[3][1], thickness=thickness, number=3, make_3d=make_3d);
    // 4
    cs_test_face(width=size_strut[3][0], height=size_strut[3][1], thickness=thickness, number=4, make_3d=make_3d);
    // 5
    cs_test_face(width=size_strut[3][0], height=size_strut[3][1], thickness=thickness, number=5, make_3d=make_3d);
    // 6
    cs_test_face(width=size_strut[3][0], height=size_strut[3][1], thickness=thickness, number=6, make_3d=make_3d);
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
module cshape_array_arrange(width, height,
                            no_elements_x=0,
                            element_padding=0,
                            thickness=1,
                            make_3d=false, spacing_2d=1)
{   
    no_elements = $children;
    array_size = get_cshape_array_size(width, height, no_elements, no_elements_x);
    echo("array_size: ", array_size);
    d_x = width / array_size[0];
    d_y = height / array_size[1];
    echo("d_x: ", d_x);
    echo("d_y: ", d_y);

    element_size = get_cshape_array_element_size(width=width, height=height,
                        no_elements=no_elements, no_elements_x=no_elements_x,
                        element_padding=element_padding);

    for (i_x = [0:(array_size[0]-1)])
    {
        for (i_y = [0:(array_size[1]-1)])
        {
            i = i_y * array_size[0] + i_x;
            if (make_3d)
            {
                if (i < no_elements)
                {
                    x = i_x*(d_x + element_padding / array_size[0]);
                    y = i_y*(d_y + element_padding / array_size[1]);
                    translate([x, y, 0])
                    children(i);
                }
            }
            else
            {
                if (i < no_elements)
                {
                    x = i_x*(element_size[0] + spacing_2d); 
                    y = i_y*(element_size[1] + spacing_2d);
                    translate([x, y, 0])
                    children(i);
                }
            }
        }
    }
}

function get_cshape_array_size(width, height, no_elements, no_elements_x) =
    let (no_x = (no_elements < no_elements_x) ? no_elements : no_elements_x)
    (no_x > 0)
    ? [no_x, ceil(no_elements / no_x)]
    : [ceil(sqrt(no_elements)), ceil(sqrt(no_elements))];

function get_cshape_array_element_size(width, height, no_elements, no_elements_x, element_padding=0) =
    let (array_size = get_cshape_array_size(width, height, no_elements, no_elements_x))
    [width / array_size[0] - element_padding * (array_size[0]-1)/array_size[0],
         height / array_size[1] - element_padding * (array_size[1]-1)/array_size[1]];