use <../surfaces/cs_test_surface.scad>


make_3d=true;

width= 50;
height= 100;
thickness = 4;//[1:10]

element_width = 10;//[10:20]
element_hight = 15;//[10:20]

no_elements_x = 2;//[1:10]

repeat = 7;//[0:100]

element_padding = 2;//[0:5]

array_plane = "xy"; //["xy", "xz", "yz"]

only_padding = false;

if (only_padding)
{
    cshape_array_arange_example(width=width, height=height,
                            no_elements_sum=7,
                            no_elements_x=no_elements_x,
                            element_padding=element_padding);
    rotate([0,-180,0])
    cshape_array_repeat_example(width=width, height=height,
                                repeat=repeat, no_elements_x=no_elements_x,
                                element_padding=element_padding);
}
else
{
    cshape_array_arange_example(width=width, height=height,
                                no_elements_sum=7,
                                no_elements_x=no_elements_x,
                                element_padding=element_padding,
                                element_width=element_width, element_hight=element_hight);
    rotate([0,-180,0])
    cshape_array_repeat_example(width=width, height=height,
                                repeat=repeat, no_elements_x=no_elements_x,
                                element_padding=element_padding,
                                element_width=element_width, element_hight=element_hight);
}

module cshape_array_arange_example(width, height, no_elements_sum,
                            no_elements_x=0, element_padding=0,
                            element_width=0, element_hight=0)
{
    element_size = get_cshape_array_element_size(width=width, height=height,
                                                no_elements_sum=no_elements_sum, no_elements_x=no_elements_x,
                                                element_padding=element_padding,
                                                element_width=element_width, element_hight=element_hight);

    // element_size = [element_width-element_padding, element_hight-element_padding];

    cshape_array_arrange(width, height,
                        no_elements_x=no_elements_x,
                        element_width=element_size[0], element_hight=element_size[1],
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

module cshape_array_repeat_example(width, height, repeat,
                                  no_elements_x=0, element_padding=0,
                                  element_width=0, element_hight=0)
{
    element_size = get_cshape_array_element_size(width=width, height=height,
                                                no_elements_sum=repeat, no_elements_x=no_elements_x,
                                                element_padding=element_padding,
                                                element_width=element_width, element_hight=element_hight);

    // element_size = [element_width-element_padding, element_hight-element_padding];

    echo(str("repeat: element_size: ", element_size));

    cshape_array_repeat(width, height,
                        repeat=repeat,
                        no_elements_x=no_elements_x,
                        element_width=element_size[0], element_hight=element_size[1],
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
// Definitions
// ----
//        width
//        <---------------------------->
//        array element size
//        <------------->
//         element size
//        <---------->
//        |-----------   |   ---------- |
//        | ppppppppp|   |   |ppppppppp |
//        |---------p|   |   |p-------- |
//        |   0    |p|   |   |p| 1      |
//        |        |p|   |   |p|        |
//         ----------------------------- 
//        <----------------->
//                dx
//
//        < first element|second element>
//        --> no_elements_x = 2
//
//
// only element_padding (symbol: p)
// -----
//  
//        ------------------------------|
//        |  4       | p | p |  5       |
//        |          | p | p |          |
//        |          | p | p |          |
//        |          | p | p |          |
//        |----------- p | p -----------|
//        | pppppppppppp | pppppppppppp | 
//        |-----------------------------|
//        | pppppppppppp | pppppppppppp | 
//        |----------- p | p -----------|
//        |  2       | p | p |  3       |
//        |          | p | p |          |
//        |          | p | p |          |
//        |----------- p | p -----------|
//        | pppppppppppp | pppppppppppp |
//        |-----------------------------|
//        | pppppppppppp | pppppppppppp |
//        |----------- p | p ---------- |
//        |  0       | p | p |  1       |
//        |          | p | p |          |
//        |          | p | p |          |
//        |          | p | p |          |
//         -----------------------------|
module cshape_array_arrange(width, height,
                            no_elements_x=0,
                            element_width=0, element_hight=0,
                            element_padding=0,
                            array_plane="xy",
                            make_3d=false, spacing_2d=1)
{   
    no_childen = $children;
    no_elements = get_cshape_no_elements(width, height, no_childen, no_elements_x);
    // echo("no_elements: ", no_elements);
    d_x = get_cshape_array_dx(width=width,
                              no_elements_x=no_elements[0],
                              element_size=element_width);
    d_y = get_cshape_array_dx(width=height, 
                              no_elements_x=no_elements[1],
                              element_size=element_hight);
    // echo("d_x: ", d_x);
    // echo("d_y: ", d_y);
    // echo("element_padding: ", element_padding);

    element_size = get_cshape_array_element_size(width=width, height=height,
                        no_elements_sum=no_childen, no_elements_x=no_elements_x,
                        element_padding=element_padding,
                        element_width=element_width, element_hight=element_hight);

    for (i_y = [0:(no_elements[1]-1)])
    {
        for (i_x = [0:(no_elements[0]-1)])
        {
            i = i_y * no_elements[0] + i_x;
            if (make_3d)
            {
                if (i < no_childen)
                {
                    x = i_x*(d_x + element_padding / no_elements[0]);
                    y = i_y*(d_y + element_padding / no_elements[1]);
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
                if (i < no_childen)
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
module cshape_array_repeat(width, height, repeat,
                           element_width=0, element_hight=0,
                           no_elements_x=0,
                           element_padding=0,
                           array_plane="xy",
                           make_3d=false, spacing_2d=1)
{   
    no_childen = $children;
    no_elements = get_cshape_no_elements(width, height, repeat, no_elements_x);
    d_x = get_cshape_array_dx(width=width,
                              no_elements_x=no_elements[0],
                              element_size=element_width);
    d_y = get_cshape_array_dx(width=height, 
                              no_elements_x=no_elements[1],
                              element_size=element_hight);

    element_size = get_cshape_array_element_size(width=width, height=height,
                        no_elements_sum=no_childen, no_elements_x=no_elements_x,
                        element_padding=element_padding,
                        element_width=element_width, element_hight=element_hight);
    // echo("no_elements: ", no_elements);
    // echo("d_x: ", d_x);
    // echo("d_y: ", d_y);
    // echo("element_padding: ", element_padding);
    // echo("element_width, element_hight", element_width, element_hight);
    // echo(str("element_size: ", element_size));

    for (i_y = [0:(no_elements[1]-1)])
    {
        for (i_x = [0:(no_elements[0]-1)])
        {
            i = i_y * no_elements[0] + i_x;
            if (make_3d)
            {
                if (i < repeat)
                {
                    x = i_x*(d_x + element_padding / no_elements[0]);
                    y = i_y*(d_y + element_padding / no_elements[1]);
                    echo("x,y: ", x, y);
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
                if (i < repeat)
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

function get_cshape_no_elements(width, height, no_elements, no_elements_x) =
    let (no_x = (no_elements < no_elements_x) ? no_elements : no_elements_x)
    (no_x > 0)
    ? [no_x, ceil(no_elements / no_x)]
    : [ceil(sqrt(no_elements)), ceil(sqrt(no_elements))];

function get_cshape_array_element_size(width, height, no_elements_sum, no_elements_x,
                                       element_padding=0,
                                       element_width=0, element_hight=0) =
    let (array_size = get_cshape_no_elements(width, height, no_elements_sum, no_elements_x))
    let (dx_no_element_width = width / array_size[0] - element_padding * (array_size[0]-1)/array_size[0])
    let (dx_no_element_height = height / array_size[1] - element_padding * (array_size[1]-1)/array_size[1])
    let (dx_elment_width = element_width-element_padding)
    let (dx_elment_height = element_hight-element_padding)
    (element_width > 0)
    ?   (element_hight > 0)
        ?   [dx_elment_width, dx_elment_height]
        :   [dx_no_element_width, dx_elment_height]
    :   [dx_no_element_width, dx_no_element_height];


// get_cshape_array_dx
// ----
// 
// If the size of an element is not defined, only padding can be applied.
// Therefore, dx is equal to the size of the array element.
// 
// Arguments
// -----
//  width
//      size of the complete array in one dimension
// 
//  no_elements_x
//      number of elements
//
//  element_size
//      size of the element which should be plased in the array
//      (including the padding distance)
//
// Returns
// -----
//   dx: distance in x where the next element shoulde be placed
// 
//
// Definition
// -----
//
//        array size
//        <---------------------------->
//        array element size
//        <------------->
//         element size
//        <---------->
//        |-----------   |   ---------- |
//        | ppppppppp|   |   |ppppppppp |
//        |---------p|   |   |p-------- |
//        |   0    |p|   |   |p| 1      |
//        |        |p|   |   |p|        |
//         ----------------------------- 
//        <----------------->
//                dx
//
//        < first element|second element>
//        --> no_elements_x = 2
//
function get_cshape_array_dx(width, no_elements_x, element_size) = 
    (element_size > 0)
    ?   (no_elements_x > 1)
        ?   (width - (no_elements_x * element_size))/(no_elements_x-1) + element_size
        :   0
    :   width / no_elements_x;