use <../materials/cm_manufacturing.scad>
use <../hinges/ch_pin_hinge.scad>

/* [Output] */
make_3d = true; // [false:true]

/* [Material] */
material_thickness = 4; // [1:0.1:10]
kerf = 0.15;            // [0:0.01:1]

/* [Example] */
pin_diameter = 2; // [0.5:0.1:8]

/* [Hidden] */
$fn = $preview ? 32 : 96;

if (make_3d)
    linear_extrude(height=material_thickness)
        ccal_laser_coupon(material_thickness=material_thickness,
                          kerf=kerf, pin_diameter=pin_diameter);
else
    ccal_laser_coupon(material_thickness=material_thickness,
                      kerf=kerf, pin_diameter=pin_diameter);

// Combined slot-fit, kerf-line, and pin-hole calibration coupon.
// Clearance values describe the desired finished fit around the nominal
// material or pin. Cut and label this before committing the model sheets.
module ccal_laser_coupon(material_thickness=4,
                         kerf=0.5,
                         pin_diameter=2,
                         clearances=[-0.2,-0.1,0,0.1,0.2,0.3],
                         size=[85,42],
                         label_size=2)
{
    assert(material_thickness > 0 && pin_diameter > 0,
           "ccal_laser_coupon: material and pin dimensions must be positive");
    assert(len(clearances) > 0,
           "ccal_laser_coupon: provide at least one clearance");
    assert(size[0] > 0 && size[1] > 0,
           "ccal_laser_coupon: size must be positive");

    cell = (size[0]-8)/len(clearances);
    assert(cell > material_thickness+2,
           "ccal_laser_coupon: coupon is too narrow for clearance samples");

    difference() {
        square(size);

        for (i = [0:len(clearances)-1]) {
            clearance = clearances[i];
            sw = slot_width(material_thickness, clearance, kerf);
            hole_d = effective_pin_hole_diameter(
                pin_diameter, clearance, kerf);
            x = 4 + cell*(i+0.5);

            translate([x-sw/2, 4])
                square([sw, 12]);
            translate([x, 27])
                circle(d=hole_d);
        }

        // Kerf comparison lines with progressively wider nominal gaps.
        for (i = [0:4])
            translate([5+i*2, size[1]-6])
                square([0.15+i*0.1, 4]);
    }

    for (i = [0:len(clearances)-1])
        translate([4+(size[0]-8)/len(clearances)*(i+0.5), 18])
            text(str(clearances[i]), size=label_size,
                 halign="center");
}
