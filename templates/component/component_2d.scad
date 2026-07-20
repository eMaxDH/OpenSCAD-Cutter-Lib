// Canonical manufacturing profile for the component template.
module tpl_component_plate_2d(size=[60, 30], hole_diameter=5,
                              corner_radius=3)
{
    assert(size[0] > 2*corner_radius && size[1] > 2*corner_radius,
           "tpl_component_plate_2d: radius consumes the plate");
    assert(hole_diameter > 0 && hole_diameter < min(size),
           "tpl_component_plate_2d: invalid hole diameter");

    difference() {
        translate([corner_radius, corner_radius])
            offset(r=corner_radius)
                square([size[0]-2*corner_radius,
                        size[1]-2*corner_radius]);
        translate(size/2)
            circle(d=hole_diameter);
    }
}
