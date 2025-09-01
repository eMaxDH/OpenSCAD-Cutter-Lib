use <../layer/cl_layer.scad>

use <../surfaces/cs_test_surface.scad>

make_3d=false;

width = 10; //[10:50]
height = 15; //[10:50]
thickness = 2; //[1:5]

number=1;

layer=0;
visibile_layers=[0];

cl_layer_info(visibile_layers);

// num example
margin_num = 5;
chsape_margin_tutorial(margin_num, str("margin: ", margin_num), layer, visibile_layers, make_3d);

// 1d example
margin_1d = [5];
translate([50, 0, 0])
chsape_margin_tutorial(margin_1d, str("margin: ", margin_1d), layer, visibile_layers, make_3d);

// 2d example
margin_2d = [5, 3];
translate([100, 0, 0])
chsape_margin_tutorial(margin_2d, str("margin: ", margin_2d), layer, visibile_layers, make_3d);

// 3d example
margin_3d = [5, 3, 2];
translate([150, 0, 0])
chsape_margin_tutorial(margin_3d, str("margin: ", margin_3d), layer, visibile_layers, make_3d);

module chsape_margin_tutorial(margin=0, text="chsape_margin_tutorial", 
                              layer=0, visibile_layers=[], make_3d=false)
{
    width = 10;
    height = 15;
    thickness = 2;

    linear_extrude(1)
        text(text, size=4);

    translate([0,10,0])
    {
        cshape_margin(margin, size=[width, height, thickness], show_placeholder=true)
        cs_test_surface(width=width, height=height, thickness=thickness, number=number,
                    layer=layer, visibile_layers=visibile_layers,
                    make_3d=make_3d);
    }
}


module cshape_margin(margin, size=undef, show_placeholder=false) {
    // --- placeholder  ---
    // if (is_undef(size) && show_placeholder==true)
    // {
    //     echo("[WARNING] The size must be given to visualise the placeholder.")
    // }
    if (show_placeholder && !is_undef(size))
    {
        color([0.8,0.8,1,0.8])
            if (is_num(margin))
            {
                difference()
                    {
                        cube([size[0] + 2*margin, size[1], 0.001]);
                        translate([0, 0, -margin/2])
                        {
                            translate([margin/2, (size[1])/2, 0])
                            rotate([0, 0, 90])
                            linear_extrude(margin, v=[0,0,1])
                                text("MARGIN", valign="center", halign="center", size=margin/3);

                            translate([size[0] + 3/2*margin, (size[1])/2, 0])
                            rotate([0, 0, -90])
                            linear_extrude(margin, v=[0,0,1])
                                text("MARGIN", valign="center", halign="center", size=margin/3);
                        }
                    }
            }
            else if (is_list(margin))
                if (len(margin) == 1)
                {
                    difference()
                    {
                        cube([size[0] + 2*margin[0], size[1], 0.001]);
                        translate([0, 0, -margin[0]/2])
                        {
                            translate([margin[0]/2, (size[1])/2, 0])
                            rotate([0, 0, 90])
                            linear_extrude(margin[0], v=[0,0,1])
                                text("MARGIN", valign="center", halign="center", size=margin[0]/3);

                            translate([size[0] + 3/2*margin[0], (size[1])/2, 0])
                            rotate([0, 0, -90])
                            linear_extrude(margin[0], v=[0,0,1])
                                text("MARGIN", valign="center", halign="center", size=margin[0]/3);
                        }
                    }
                }
                else if (len(margin) == 2)
                {
                    difference()
                    {
                        cube([size[0] + 2*margin[0], size[1] + 2*margin[1], 0.001]);
                        translate([0, 0, -margin[0]/2])
                        {
                            // left
                            translate([margin[0]/2, size[1]/2 + margin[1], 0])
                            rotate([0, 0, 90])
                            linear_extrude(margin[0], v=[0,0,1])
                                text("MARGIN", valign="center", halign="center", size=margin[0]/3);

                            // right
                            translate([size[0] + 3/2*margin[0], size[1]/2 + margin[1], 0])
                            rotate([0, 0, -90])
                            linear_extrude(margin[0], v=[0,0,1])
                                text("MARGIN", valign="center", halign="center", size=margin[0]/3);

                            // top
                            translate([size[0]/2 + margin[0], size[1] + 3/2*margin[1], 0])
                            linear_extrude(margin[0], v=[0,0,1])
                                text("MARGIN", valign="center", halign="center", size=margin[0]/3);

                            // bottom
                            translate([size[0]/2 + margin[0], margin[1]/2, 0])
                            linear_extrude(margin[0], v=[0,0,1])
                                text("MARGIN", valign="center", halign="center", size=margin[0]/3);
                        }
                    }
                }
                else if (len(margin) == 3)
                {
                    difference()
                    {
                        {
                            difference() {
                                cube([size[0] + 2*margin[0], size[1] + 2*margin[1], size[2] + 2*margin[2]]);
                                translate(margin_3d)
                                    cube([size[0], size[1], size[2] + 2*margin[2]]);
                            }
                        }
                        translate([0, 0, -margin[2]/2])
                        {
                            // left
                            translate([margin[0]/2, size[1]/2 + margin[1], -margin[2]])
                            rotate([0, 0, 90])
                            linear_extrude(4*margin[2] + size[2], v=[0,0,1])
                                text("MARGIN", valign="center", halign="center", size=margin[0]/3);

                            // right
                            translate([size[0] + 3/2*margin[0], size[1]/2 + margin[1], -margin[2]])
                            rotate([0, 0, -90])
                            linear_extrude(4*margin[2] + size[2], v=[0,0,1])
                                text("MARGIN", valign="center", halign="center", size=margin[0]/3);

                            // top
                            translate([size[0]/2 + margin[0], size[1] + 3/2*margin[1], -margin[2]])
                            linear_extrude(4*margin[2] + size[2], v=[0,0,1])
                                text("MARGIN", valign="center", halign="center", size=margin[0]/3);

                            // bottom
                            translate([size[0]/2 + margin[0], margin[1]/2, -margin[2]])
                            linear_extrude(4*margin[2] + size[2], v=[0,0,1])
                                text("MARGIN", valign="center", halign="center", size=margin[0]/3);
                        }
                    }
                }
                else
                    echo(str("[ERROR] margin: ", margin));
            else
                echo(str("[ERROR] margin: ", margin));
    }

    // ~~~ placeholder ~~~

    if (is_num(margin))
    {
        translate([margin, 0, 0])
            children();
    }
    else if (is_list(margin))
    {
        if (len(margin) == 1)
        {
            translate([margin[0], 0, 0])
                children();
        }
        else if (len(margin) == 2)
        {
            translate([margin[0], margin[1], 0])
                children();
        }
        else if (len(margin) == 3)
        {
            translate([margin[0], margin[1], margin[2]])
                    children();
        }
        else
            translate([0, -10, 0])
            color("red")
            linear_extrude(1)
                %text(str("[ERROR] cshape_margin: margin can only be a number or an array with a length of 1, 2, or 3. margin = ", margin),
                    size=8);
    }
}