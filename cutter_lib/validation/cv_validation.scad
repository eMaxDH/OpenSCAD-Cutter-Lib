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

