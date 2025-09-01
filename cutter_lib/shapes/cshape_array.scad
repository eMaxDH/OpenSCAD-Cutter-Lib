use <../surfaces/cs_test_surface.scad>


make_3d=true;

width= 100;
height= 200;
thickness = 4;

element_width = 10;
element_hight = 15;

no_elements_x = 2;

no_elements = 7;

element_padding = 10;

array_plane = "xy"; //["xy", "xz", "yz"]


cshape_array_arange_example(width=width, height=height,
                            no_elements=no_elements, no_elements_x=no_elements_x,
                            element_padding=element_padding);

rotate([0,-180,0])
cshape_array_repeat_example(width=width, height=height,
                            no_elements=no_elements, no_elements_x=no_elements_x,
                            element_padding=element_padding);

module cshape_array_arange_example(width, height, no_elements,
                            no_elements_x=0, element_padding=0)
{
    element_size = get_cshape_array_element_size(width=width, height=height,
                                                no_elements=no_elements, no_elements_x=no_elements_x,
                                                element_padding=element_padding);


    cshape_array_arrange(width, height,
                        no_elements_x=no_elements_x,
                        element_padding=element_padding,
                        array_plane=array_plane,
                        make_3d=make_3d, spacing_2d=1)
    {
        // 0
        cs_test_surface(width=element_size[0], height=element_size[1], thickness=thickness, number=0, make_3d=make_3d);
        // 1
        cs_test_surface(width=element_size[0], height=element_size[1], thickness=thickness, number=1, make_3d=make_3d);
        // 2
        cs_test_surface(width=element_size[0], height=element_size[1], thickness=thickness, number=2, make_3d=make_3d);
        // 3
        cs_test_surface(width=element_size[0], height=element_size[1], thickness=thickness, number=3, make_3d=make_3d);
        // 4
        cs_test_surface(width=element_size[0], height=element_size[1], thickness=thickness, number=4, make_3d=make_3d);
        // 5
        cs_test_surface(width=element_size[0], height=element_size[1], thickness=thickness, number=5, make_3d=make_3d);
        // 6
        cs_test_surface(width=element_size[0], height=element_size[1], thickness=thickness, number=6, make_3d=make_3d);
    }
}

module cshape_array_repeat_example(width, height, no_elements,
                            no_elements_x=0, element_padding=0)
{
    element_size = get_cshape_array_element_size(width=width, height=height,
                                                no_elements=no_elements, no_elements_x=no_elements_x,
                                                element_padding=element_padding);


    cshape_array_repeat(width, height,
                        no_elements=no_elements,
                        no_elements_x=no_elements_x,
                        element_padding=element_padding,
                        array_plane=array_plane,
                        make_3d=make_3d, spacing_2d=1)
    {
        // 0
        cs_test_surface(width=element_size[0], height=element_size[1], thickness=thickness, number=0, make_3d=make_3d);
    }
}

//
//     --------------------    ^
//    |  3   | 4    | 5    |   |
//    |      |      |      |   |
//    |--------------------|   |height
//    |  0   | 1    | 2    |   |
//    |      |      |      |   |
//    x--------------------    v
//           
//    <---    width    --->
//  x: origin
//
//  ^ y 
//  |   
//  ---> x
//
//  element_padding
//  
//  ------------------------------|
//  |  4       |   |   |  5       |
//  |          |   |   |          |
//  |          |   |   |          |
//  |          |   |   |          |
//  |-----------   |   -----------|
//  |              |              | 
//  |-----------------------------|
//  |              |              | 
//  |-----------   |   -----------|
//  |  2       |   |   |  3       |
//  |          |   |   |          |
//  |          |   |   |          |
//  |-----------   |   -----------|
//  |              |              |
//  |-----------------------------|
//  |              |              |
//  |-----------   |   ---------- |
//  |  0       |   |   |  1       |
//  |          |   |   |          |
//  |          |   |   |          |
//  |          |   |   |          |
//   -----------------------------|
module cshape_array_arrange(width, height,
                            no_elements_x=0,
                            element_padding=0,
                            array_plane="xy",
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
                    if (array_plane == "xy")
                    {
                        translate([x, y, 0])
                            children(i);
                    }
                    else if (array_plane == "xz")
                    {
                        rotate([90,0,0])
                        translate([x, y, 0])
                            children(i);
                    }
                    else if (array_plane == "yz")
                    {
                        rotate([90,0,90])
                        translate([x, y, 0])
                            children(i);
                    }
                    else
                    {
                        color("red")
                        text(str("[ERROR] cshape_array_arrange: undefined array_plane: ", array_plane));
                    }
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

//
//     --------------------    ^
//    |  3   | 4    | 5    |   |
//    |      |      |      |   |
//    |--------------------|   |height
//    |  0   | 1    | 2    |   |
//    |      |      |      |   |
//    x--------------------    v
//           
//    <---    width    --->
//  x: origin
//
//  ^ y 
//  |   
//  ---> x
//
//  element_padding
//  
//  ------------------------------|
//  |  4       |   |   |  5       |
//  |          |   |   |          |
//  |          |   |   |          |
//  |          |   |   |          |
//  |-----------   |   -----------|
//  |              |              | 
//  |-----------------------------|
//  |              |              | 
//  |-----------   |   -----------|
//  |  2       |   |   |  3       |
//  |          |   |   |          |
//  |          |   |   |          |
//  |-----------   |   -----------|
//  |              |              |
//  |-----------------------------|
//  |              |              |
//  |-----------   |   ---------- |
//  |  0       |   |   |  1       |
//  |          |   |   |          |
//  |          |   |   |          |
//  |          |   |   |          |
//   -----------------------------|
module cshape_array_repeat(width, height,
                           no_elements,
                           no_elements_x=0,
                           element_padding=0,
                           array_plane="xy",
                           make_3d=false, spacing_2d=1)
{   
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
                    if (array_plane == "xy")
                    {
                        translate([x, y, 0])
                            children();
                    }
                    else if (array_plane == "xz")
                    {
                        rotate([90,0,0])
                        translate([x, y, 0])
                            children();
                    }
                    else if (array_plane == "yz")
                    {
                        rotate([90,0,90])
                        translate([x, y, 0])
                            children();
                    }
                    else
                    {
                        color("red")
                        text(str("[ERROR] cshape_array_arrange: undefined array_plane: ", array_plane));
                    }
                }
            }
            else
            {
                if (i < no_elements)
                {
                    x = i_x*(element_size[0] + spacing_2d); 
                    y = i_y*(element_size[1] + spacing_2d);
                    translate([x, y, 0])
                        children();
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