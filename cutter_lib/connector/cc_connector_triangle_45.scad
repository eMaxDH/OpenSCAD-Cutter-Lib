use <../layer/cl_layer.scad>
use <cc_connector_triangle_45_2d.scad>

make_3d=false;

size = 100;//[10:100]
type = "f"; //["f", "m"]
connector_factor = 0.4; //[0.1:0.1:1]
thickness = 4;//[1:20]

cc_connector_triangle_45(size, type, connector_factor, thickness, make_3d);

// connector 1
// type f
//        ____...
//       /
//      /    
//    _|  <- in the middle of the diagnoal
//   /       the factor specifies the connector size in comparrision to the diagonal
//  /  45°
//  ---------...

// connector 1
// type m
//        ____...
//       /
//     _/    
//    |     
//   /
//  /   
//  ---------...


module cc_connector_triangle_45(size, type="f", connector_factor=0.3, thickness=1,
                                layer=0, visibile_layers=[], make_3d=false)
{
    apply_cl_layer_visibility(layer=layer, visibile_layers=visibile_layers)
    {
        if (make_3d)
        {
            linear_extrude(thickness)
                cc_connector_triangle_45_2d(size=size, type=type, connector_factor=connector_factor);
            
        }
        else
        {
            cc_connector_triangle_45_2d(size=size, type=type, connector_factor=connector_factor);
        }
    }
}