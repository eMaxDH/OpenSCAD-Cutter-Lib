use <../materials/cm_manufacturing.scad>

/* [Output] */
make_3d = true; // [false:true]

/* [Dimensions] */
example_width = 14;
example_height = 25;
example_thickness = 4;
example_pin_diameter = 3;

/* [Example] */
example_pin_clearance = 0.2;

/* [Hidden] */
$fn = $preview ? 32 : 96;

if (make_3d) {
    linear_extrude(height=example_thickness)
        ch_pin_hinge_cheek_2d(
            width=example_width,
            height=example_height,
            pin_diameter=example_pin_diameter,
            pin_clearance=example_pin_clearance);
    ch_hinge_pin_preview(
        length=example_thickness,
        diameter=example_pin_diameter,
        axis_origin=[example_width/2,
                     example_height-example_width/2,
                     0]);
} else
    ch_pin_hinge_cheek_2d(
        width=example_width,
        height=example_height,
        pin_diameter=example_pin_diameter,
        pin_clearance=example_pin_clearance);

// Apply a rotation around an arbitrary hinge axis passing through
// `axis_origin`.
module ch_rotate_about_axis(axis_origin=[0,0,0], angle=0, axis=[1,0,0])
{
    translate(axis_origin)
        rotate(a=angle, v=axis)
            translate([-axis_origin[0], -axis_origin[1], -axis_origin[2]])
                children();
}

// A flat hinge cheek with a rounded end and laser-cut pin hole.
module ch_pin_hinge_cheek_2d(width, height,
                             pin_diameter,
                             pin_clearance=0,
                             kerf=0,
                             hole_center=undef,
                             edge_min=1)
{
    hc = is_undef(hole_center)
        ? [width/2, height-width/2]
        : hole_center;
    hole_d = effective_pin_hole_diameter(
        pin_diameter, pin_clearance, kerf);

    assert(width > 0 && height >= width,
           "ch_pin_hinge_cheek_2d: height must be at least width");
    assert(hc[0]-hole_d/2 >= edge_min &&
           width-hc[0]-hole_d/2 >= edge_min &&
           hc[1]-hole_d/2 >= edge_min &&
           height-hc[1]-hole_d/2 >= edge_min,
           "ch_pin_hinge_cheek_2d: pin hole is too close to an edge");

    difference() {
        union() {
            square([width, height-width/2]);
            translate([width/2, height-width/2])
                circle(d=width);
        }
        translate(hc)
            circle(d=hole_d);
    }
}

// Preview a purchased rod/wire/dowel along the X axis.
module ch_hinge_pin_preview(length, diameter, axis_origin=[0,0,0])
{
    assert(length > 0 && diameter > 0,
           "ch_hinge_pin_preview: pin dimensions must be positive");

    translate(axis_origin)
        rotate([0,90,0])
            cylinder(h=length, d=diameter);
}

// Sample a moving child between two angles. Preview-only geometry makes this
// suitable for checking a door motion envelope.
module ch_motion_sweep(angle_start=0, angle_end=90, samples=7,
                       axis_origin=[0,0,0], axis=[1,0,0])
{
    assert(samples >= 2, "ch_motion_sweep: samples must be at least two");

    for (i = [0:samples-1])
        let(a = angle_start + (angle_end-angle_start)*i/(samples-1))
            %ch_rotate_about_axis(axis_origin, a, axis)
                children();
}
