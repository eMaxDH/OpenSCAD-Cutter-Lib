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

//use <strut_2d.scad>
//strut_2d(100, 10, type=["f", "f"]);

use <../slot/cs_elongated_hole_2d.scad>

function calc_connector_shift(size, connector_factor=0.4) = 
    let (diagonal = size * sqrt(2))
    let (diagonal_connector = connector_factor * diagonal)
    let (shift_diagonal = diagonal/2 - diagonal_connector/2)
    shift_diagonal / sqrt(2);

module make_holes(strut_width, hole_radius, hole_distance, thickness)
{
    function calculate_hole_positions(strut_width, hole_distance) =
        let (left_hole = (strut_width - hole_distance) / 2)
        let (right_hole = left_hole + hole_distance)
        [[left_hole, 0, 0], [right_hole, 0, 0]];
    
    positions = calculate_hole_positions(strut_width, hole_distance);
    difference()
    {
        children();
        union()
        {
            translate(positions[0])
                circle(hole_radius);

            translate(positions[1])
                circle(hole_radius);
        }
    }
}

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

module make_holes(strut_width, hole_radius, hole_distance, hole_length=0)
{
    function calculate_hole_positions(strut_width, hole_distance) =
        let (left_hole = (strut_width - hole_distance) / 2)
        let (right_hole = left_hole + hole_distance)
        [[left_hole, 0, 0], [right_hole, 0, 0]];
    
    positions = calculate_hole_positions(strut_width, hole_distance);
    difference()
    {
        children();
        union()
        {
            translate(positions[0])
                if (hole_length > 0)
                    cs_elongated_hole_2d(hole_length, hole_radius);
                else
                    circle(hole_radius);

            translate(positions[1])
                if (hole_length > 0)
                    cs_elongated_hole_2d(hole_length, hole_radius);
                else
                    circle(hole_radius);
        }
    }
}

module strut_2d_base(width, height, type=["f", "f"]){
    strut_connector(height, type=type[0]);
    translate([height, 0, 0])
        square([width-2*height, height]);
    translate([width, 0, 0])
        mirror([1,0,0])
            strut_connector(height, type=type[1]);
}

module strut_2d(width, height, type=["f", "f"], hole_radius=2, hole_distance=10, hole_length=0){
    make_holes(width, hole_radius, hole_distance, hole_length)
        strut_2d_base(width, height, type=type);
}