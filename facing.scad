include <facing_2d.scad>

module facing(width, height, element_width, no_of_elements, thickness=1, make_3d=false)
{
    if (make_3d)
        linear_extrude(thickness)
            facing_2d(width, height, element_width, no_of_elements);
    else
        facing_2d(width, height, element_width, no_of_elements);
}