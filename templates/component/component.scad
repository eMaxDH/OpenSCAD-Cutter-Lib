use <component_2d.scad>

/* [Output] */
make_3d = true; // [false:true]

/* [Dimensions] */
plate_size = [60, 30];
material_thickness = 3; // [0.5:0.5:12]
hole_diameter = 5;      // [1:0.5:20]
corner_radius = 3;      // [0:0.5:12]

/* [Example] */
example_color = "burlywood";

/* [Hidden] */
$fn = $preview ? 32 : 96;

tpl_component_plate(
    size=plate_size,
    thickness=material_thickness,
    hole_diameter=hole_diameter,
    corner_radius=corner_radius,
    make_3d=make_3d,
    part_color=example_color
);

// Public wrapper. The 3D branch only extrudes the canonical 2D profile.
module tpl_component_plate(size=[60, 30], thickness=3,
                           hole_diameter=5, corner_radius=3,
                           make_3d=false, part_color="burlywood")
{
    assert(thickness > 0,
           "tpl_component_plate: thickness must be positive");

    color(part_color)
        if (make_3d)
            linear_extrude(height=thickness)
                tpl_component_plate_2d(
                    size=size,
                    hole_diameter=hole_diameter,
                    corner_radius=corner_radius);
        else
            tpl_component_plate_2d(
                size=size,
                hole_diameter=hole_diameter,
                corner_radius=corner_radius);
}
