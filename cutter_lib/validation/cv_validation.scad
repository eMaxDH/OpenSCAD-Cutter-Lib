/* [Output] */
make_3d = true; // [false:true]

/* [Dimensions] */
example_size = [40, 25];
example_thickness = 3;

/* [Example] */
validated_value = 10; // [1:1:30]

/* [Hidden] */

cv_require_positive([validated_value, example_thickness],
                    ["validated_value", "example_thickness"],
                    "validation example")
    if (make_3d)
        linear_extrude(height=example_thickness)
            square(example_size);
    else
        square(example_size);

module cv_require_positive(values, names=[], context="geometry")
{
    for (i = [0:len(values)-1])
        assert(values[i] > 0,
               str(context, ": ",
                   len(names) > i ? names[i] : str("value ", i),
                   " must be positive"));
    children();
}

module cv_warn_range(value, minimum, maximum, name="value")
{
    if (value < minimum || value > maximum)
        echo(str("[WARNING] ", name, "=", value,
                 " is outside validated range [",
                 minimum, ", ", maximum, "]"));
    children();
}

module cv_warn_veneer_bend(radius, recommended_minimum)
{
    if (radius < recommended_minimum)
        echo(str("[WARNING] veneer bend radius ", radius,
                 " is below recommended ", recommended_minimum));
    children();
}
