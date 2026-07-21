
use <../surfaces/cs_test_surface.scad>

/* [Output] */
make_3d=true;

/* [Example] */
width = 20; //[10:40]
height = 30; //[10:40]
thickness = 5; //[3:10]

number=1;

visible_layers=[0,1,2];

cl_layer_info(visible_layers);

translate([0, -10, 0])
cl_layer_example_label("layer = 0", make_3d);
cs_test_surface(width=width, height=height, thickness=thickness, number=number,
                    layer=0, visible_layers=visible_layers,
                    make_3d=make_3d);

translate([50, 0, 0])
{
    translate([0, -10, 0])
    cl_layer_example_label("layer = 1", make_3d);
    cs_test_surface(width=width, height=height, thickness=thickness, number=number,
                        layer=1, visible_layers=visible_layers,
                        make_3d=make_3d);
}

translate([100, 0, 0])
{
    translate([0, -10, 0])
    cl_layer_example_label("layer = 2", make_3d);
    cs_test_surface(width=width, height=height, thickness=thickness, number=number,
                    layer=2, visible_layers=visible_layers,
                    make_3d=make_3d);
}

module cl_layer_example_label(label, make_3d=false)
{
    if (make_3d)
        linear_extrude(height=1)
            text(label, size=4);
    else
        text(label, size=4);
}

module apply_cl_layer_visibility(layer=0, visible_layers=[])
{
    if (len(visible_layers) > 0)
    {
        id = search(layer, visible_layers);
        // echo(str("visible_layers = ", visible_layers));
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

module cl_layer_info(visible_layers=[], name ="object", size=10)
{
    color("gold")
    translate([0,-2*size,0])
    {
        %text(str("rendered layers: ", visible_layers), size=size*0.8);
    }
}
