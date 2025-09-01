

module apply_cl_layer_visibility(layer=0, visibile_layers=[])
{
    if (len(visibile_layers) > 0)
    {
        id = search(layer, visibile_layers);
        if (len(id) > 0)
            children();
        else
            %children();
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