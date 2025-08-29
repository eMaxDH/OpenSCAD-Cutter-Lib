//
// Create a strut with connectors
//
// Example
// -------
//     strut(100, 10, type=["f", "m"]);  
//         __________________________
//  ^     /                          \_
// 10   _|                             |
//  v  /                                \
//    ------------------------------------
//    <---             100             -->

//strut_2d(100, 10, type=["f", "f"]);


function calc_connector_shift(size, connector_factor=0.4) = 
    let (diagonal = size * sqrt(2))
    let (diagonal_connector = connector_factor * diagonal)
    let (shift_diagonal = diagonal/2 - diagonal_connector/2)
    shift_diagonal * sqrt(2);

module strut_connector(size, type="f", connector_factor=0.3){
    connector_shift = calc_connector_shift(size, connector_factor);
  
  
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


module strut_2d(width, height, type=["f", "f"]){
    strut_connector(height, type=type[0]);
    translate([height, 0, 0])
        square([width-2*height, height]);
    translate([width, 0, 0])
        mirror([1,0,0])
            strut_connector(height, type=type[1]);
}
