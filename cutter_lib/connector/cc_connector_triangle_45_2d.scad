
size = 100;//[10:100]
type = "f"; //["f", "m"]
connector_factor = 0.4; //[0.1:0.1:1]

cc_connector_triangle_45_2d(size, type, connector_factor);

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
//       /|       ^
//     _/         |   
//    |   |       | size    
//   /            | 
//  /     |       |  
//  ---------...  v
// |<-  ->| size

function cc_connector_triangle_45_2d_shift(size, connector_factor=0.4) = 
    let (diagonal = size * sqrt(2))
    let (diagonal_connector = connector_factor * diagonal)
    let (shift_diagonal = diagonal/2 - diagonal_connector/2)
    shift_diagonal / sqrt(2);


module cc_connector_triangle_45_2d(size, type="f", connector_factor=0.3){
    connector_shift = cc_connector_triangle_45_2d_shift(size, connector_factor);
  
  
    if (type == "f")
    {
        difference() {
            polygon([[0,0],
                     [size, size],
                     [size, 0]]);
            translate([connector_shift, connector_shift, 0])
              scale([connector_factor, connector_factor ,1])
                    polygon([[0,0],
                             [size, size],
                             [size, 0]]);}
    }
    else if (type == "m")
    {
        union() {
            polygon([[0,0],
                     [size, size],
                     [size, 0]]);
            translate([connector_shift, connector_shift, 0])
              scale([connector_factor, connector_factor ,1])
                polygon([[0,0],
                         [size, size],
                         [0, size]]);}
    }
    else
    {
        echo("Unspecified type!");
    }
}