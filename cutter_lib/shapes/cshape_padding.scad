use <../layer/cl_layer.scad>

use <../surfaces/cs_test_surface.scad>

make_3d=true;

width = 20; //[10:40]
height = 30; //[10:40]
thickness = 5; //[3:10]

number=1;

layer=0;
visibile_layers=[0];

cl_layer_info(visibile_layers);

padding_x = 2;//[0:5]
padding_y = 2;//[0:5]
padding_z = 2;//[0:5]

// num example
padding_num = padding_x;
cshape_padding_tutorial(padding_num, str("padding: ", padding_num), layer, visibile_layers, make_3d);

// 1d example
padding_1d = [padding_x];
translate([50, 0, 0])
cshape_padding_tutorial(padding_1d, str("padding: ", padding_1d), layer, visibile_layers, make_3d);

// 2d example
padding_2d = [padding_x, padding_y];
translate([50, 50, 0])
cshape_padding_tutorial(padding_2d, str("padding: ", padding_2d), layer, visibile_layers, make_3d);

// 3d example
padding_3d = [padding_x, padding_y, padding_z];
translate([0, 50, 0])
cshape_padding_tutorial(padding_3d, str("padding: ", padding_3d), layer, visibile_layers, make_3d);

module cshape_padding_tutorial(padding=0, text="cshape_padding_tutorial", 
                              layer=0, visibile_layers=[], make_3d=false)
{
    // width = 10;
    // height = 15;
    // thickness = 2;

    linear_extrude(1)
        text(text, size=4);

    translate([0,10,0])
    {
        new_size = get_cshape_padding_new_object_size(size=[width, height, thickness],
                                                 padding=padding);
        echo(str("[cshape_padding_tutorial] ", text, " new_size = ", new_size));
        cshape_padding(padding, new_size=new_size, show_placeholder=true)
        cs_test_surface(width=new_size[0], height=new_size[1], thickness=new_size[2], number=number,
                    layer=layer, visibile_layers=visibile_layers,
                    make_3d=make_3d);
    }
}


module cshape_padding(padding, new_size=undef, show_placeholder=false) {
    // --- placeholder  ---
    // if (is_undef(size) && show_placeholder==true)
    // {
    //     echo("[WARNING] The size must be given to visualise the placeholder.")
    // }
    if (show_placeholder && !is_undef(new_size))
    {
        %color([0.8,0.8,1,0.8])
            if (is_num(padding))
            {
                difference()
                    {
                        cube([new_size[0] + 2*padding, new_size[1], 0.001]);
                        translate([0, 0, -padding/2])
                        {
                            translate([padding/2, (new_size[1])/2, 0])
                            rotate([0, 0, 90])
                            linear_extrude(padding, v=[0,0,1])
                                text("padding", valign="center", halign="center", size=padding/3);

                            translate([new_size[0] + 3/2*padding, (new_size[1])/2, 0])
                            rotate([0, 0, -90])
                            linear_extrude(padding, v=[0,0,1])
                                text("padding", valign="center", halign="center", size=padding/3);
                        }
                    }
            }
            else if (is_list(padding))
                if (len(padding) == 1)
                {
                    difference()
                    {
                        cube([new_size[0] + 2*padding[0], new_size[1], 0.001]);
                        translate([0, 0, -padding[0]/2])
                        {
                            translate([padding[0]/2, (new_size[1])/2, 0])
                            rotate([0, 0, 90])
                            linear_extrude(padding[0], v=[0,0,1])
                                text("padding", valign="center", halign="center", size=padding[0]/3);

                            translate([new_size[0] + 3/2*padding[0], (new_size[1])/2, 0])
                            rotate([0, 0, -90])
                            linear_extrude(padding[0], v=[0,0,1])
                                text("padding", valign="center", halign="center", size=padding[0]/3);
                        }
                    }
                }
                else if (len(padding) == 2)
                {
                    echo(str("2d padding new_size: ", new_size));
                    difference()
                    {
                        cube([new_size[0] + 2*padding[0], new_size[1] + 2*padding[1], 0.001]);
                        translate([0, 0, -padding[0]/2])
                        {
                            // left
                            translate([padding[0]/2, new_size[1]/2 + padding[1], 0])
                            rotate([0, 0, 90])
                            linear_extrude(padding[0], v=[0,0,1])
                                text("padding", valign="center", halign="center", size=padding[0]/3);

                            // right
                            translate([new_size[0] + 3/2*padding[0], new_size[1]/2 + padding[1], 0])
                            rotate([0, 0, -90])
                            linear_extrude(padding[0], v=[0,0,1])
                                text("padding", valign="center", halign="center", size=padding[0]/3);

                            // top
                            translate([new_size[0]/2 + padding[0], new_size[1] + 3/2*padding[1], 0])
                            linear_extrude(padding[0], v=[0,0,1])
                                text("padding", valign="center", halign="center", size=padding[0]/3);

                            // bottom
                            translate([new_size[0]/2 + padding[0], padding[1]/2, 0])
                            linear_extrude(padding[0], v=[0,0,1])
                                text("padding", valign="center", halign="center", size=padding[0]/3);
                        }
                    }
                }
                else if (len(padding) == 3)
                {
                    difference()
                    {
                        {
                            difference() {
                                cube([new_size[0] + 2*padding[0], new_size[1] + 2*padding[1], new_size[2] + 2*padding[2]]);
                                translate([padding[0], padding[1], -padding[2]/2])
                                    cube([new_size[0], new_size[1], new_size[2] + 4*padding[2]]);
                            }
                        }
                        translate([0, 0, -padding[2]/2])
                        {
                            // left
                            translate([padding[0]/2, new_size[1]/2 + padding[1], -padding[2]])
                            rotate([0, 0, 90])
                            linear_extrude(4*padding[2] + new_size[2], v=[0,0,1])
                                text("padding", valign="center", halign="center", size=padding[0]/3);

                            // right
                            translate([new_size[0] + 3/2*padding[0], new_size[1]/2 + padding[1], -padding[2]])
                            rotate([0, 0, -90])
                            linear_extrude(4*padding[2] + new_size[2], v=[0,0,1])
                                text("padding", valign="center", halign="center", size=padding[0]/3);

                            // top
                            translate([new_size[0]/2 + padding[0], new_size[1] + 3/2*padding[1], -padding[2]])
                            linear_extrude(4*padding[2] + new_size[2], v=[0,0,1])
                                text("padding", valign="center", halign="center", size=padding[0]/3);

                            // bottom
                            translate([new_size[0]/2 + padding[0], padding[1]/2, -padding[2]])
                            linear_extrude(4*padding[2] + new_size[2], v=[0,0,1])
                                text("padding", valign="center", halign="center", size=padding[0]/3);
                        }
                    }
                }
                else
                    echo(str("[ERROR] padding: ", padding));
            else
                echo(str("[ERROR] padding: ", padding));
    }

    // ~~~ placeholder ~~~

    if (is_num(padding))
    {
        translate([padding, 0, 0])
            children();
    }
    else if (is_list(padding))
    {
        if (len(padding) == 1)
        {
            translate([padding[0], 0, 0])
                children();
        }
        else if (len(padding) == 2)
        {
            translate([padding[0], padding[1], 0])
                children();
        }
        else if (len(padding) == 3)
        {
            translate([padding[0], padding[1], padding[2]])
                    children();
        }
        else
            translate([0, -10, 0])
            color("red")
            linear_extrude(1)
                %text(str("[ERROR] cshape_padding: padding can only be a number or an array with a length of 1, 2, or 3. padding = ", padding),
                    size=8);
    }
}

function get_cshape_padding_new_object_size(size, padding) =
    is_num(padding) == true 
    ?   [size[0]-2*padding, size[1], size[2]]
    :   is_list(padding) == true
        ?   len(padding) == 1
            ?   [size[0]-2*padding[0], size[1], size[2]]
            :   len(padding) == 2
                ?   [size[0]-2*padding[0], size[1]-2*padding[1], size[2]]
                :   len(padding) == 3
                    ?   [size[0]-2*padding[0], size[1]-2*padding[1], size[2]-2*padding[2]]
                        : undef
        : undef;
