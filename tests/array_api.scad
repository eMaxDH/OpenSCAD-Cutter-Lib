use <../cutter_lib/shapes/cshape_array.scad>

epsilon = 0.000001;

function approximately_equal(a, b, epsilon=epsilon) = abs(a-b) < epsilon;

automatic = get_cshape_array_element_size(
    100, 60, 6, 3, element_padding=2);
width_only = get_cshape_array_element_size(
    100, 60, 6, 3, element_padding=2, element_width=20);
height_only = get_cshape_array_element_size(
    100, 60, 6, 3, element_padding=2, element_height=15);
fixed = get_cshape_array_element_size(
    100, 60, 6, 3, element_padding=2,
    element_width=20, element_height=15);

assert(approximately_equal(automatic[0], 32)
       && approximately_equal(automatic[1], 29),
       str("automatic element size failed: ", automatic));
assert(approximately_equal(width_only[0], 18)
       && approximately_equal(width_only[1], 29),
       str("width-only element size failed: ", width_only));
assert(approximately_equal(height_only[0], 32)
       && approximately_equal(height_only[1], 13),
       str("height-only element size failed: ", height_only));
assert(approximately_equal(fixed[0], 18)
       && approximately_equal(fixed[1], 13),
       str("fixed element size failed: ", fixed));

square([1, 1]);
