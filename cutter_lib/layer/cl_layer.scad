
use <../surfaces/cs_test_surface.scad>

make_3d=true;

width = 20; //[10:40]
height = 30; //[10:40]
thickness = 5; //[3:10]

number=1;

visibile_layers=[0,1,2];

cl_layer_info(visibile_layers);

translate([0, -10, 0])
linear_extrude(1)
     text("layer = 0", size=4);
cs_test_surface(width=width, height=height, thickness=thickness, number=number,
                    layer=0, visibile_layers=visibile_layers,
                    make_3d=make_3d);

translate([50, 0, 0])
{
    translate([0, -10, 0])
    linear_extrude(1)
     text("layer = 1", size=4);
    cs_test_surface(width=width, height=height, thickness=thickness, number=number,
                        layer=1, visibile_layers=visibile_layers,
                        make_3d=make_3d);
}

translate([100, 0, 0])
{
    translate([0, -10, 0])
    linear_extrude(1)
     text("layer = 2", size=4);
    cs_test_surface(width=width, height=height, thickness=thickness, number=number,
                    layer=2, visibile_layers=visibile_layers,
                    make_3d=make_3d);
}

module apply_cl_layer_visibility(layer=0, visibile_layers=[])
{
    if (len(visibile_layers) > 0)
    {
        id = search(layer, visibile_layers);
        // echo(str("lvisibile_layers = ", visibile_layers));
        // echo(str("layer = ", layer));
        // echo(str("id = ", id));
        if (len(id) > 0)
        {
            // echo("render");
            children();
        }
        else
        {
            // echo("NOT render");
            %children();
        }
    }
    else
    {
        children();
    }
}

module cl_layer_info(visibile_layers=[], name ="obeject", size=10)
{
    color("gold")
    translate([0,-2*size,0])
    {
        %text(str("rendered layers: ", visibile_layers), size=size*0.8);
    }
}