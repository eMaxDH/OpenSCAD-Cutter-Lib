// Rib-supported shell primitives for veneer that bends in one direction.

function csh_wrap_length(width, height, corner_radius) =
    assert(width > 2*corner_radius,
           "csh_wrap_length: width must exceed twice the corner radius")
    assert(height > corner_radius,
           "csh_wrap_length: height must exceed the corner radius")
    (width - 2*corner_radius) +
    2*(height - corner_radius) +
    PI*corner_radius;

module csh_rounded_rect_2d(size, radius)
{
    assert(size[0] > 0 && size[1] > 0,
           "csh_rounded_rect_2d: size must be positive");
    assert(radius >= 0 && 2*radius <= min(size[0], size[1]),
           "csh_rounded_rect_2d: invalid radius");

    if (radius == 0)
        square(size);
    else
        translate([radius, radius])
            offset(r=radius)
                square([size[0]-2*radius, size[1]-2*radius]);
}

// Cross-section rib. Optional children are subtracted as registration slots.
module shell_rib(width, height, rib_width=4, corner_radius=6)
{
    assert(rib_width > 0, "shell_rib: rib_width must be positive");
    assert(width > 2*rib_width && height > 2*rib_width,
           "shell_rib: rib width consumes the silhouette");
    assert(corner_radius >= rib_width,
           "shell_rib: corner radius must be at least rib_width");

    difference() {
        csh_rounded_rect_2d([width, height], corner_radius);
        translate([rib_width, rib_width])
            csh_rounded_rect_2d(
                [width-2*rib_width, height-2*rib_width],
                max(0, corner_radius-rib_width));
        children();
    }
}

module veneer_registration_slot(size=[8,4])
{
    assert(size[0] > 0 && size[1] > 0,
           "veneer_registration_slot: size must be positive");
    square(size, center=true);
}

// Flat single-direction veneer development. It represents a wrap over both
// sides and the rounded top; the front and rear remain separate faces.
module veneer_skin_layout(width, height, depth,
                          corner_radius=6,
                          front_termination_offset=4,
                          rear_termination_offset=4,
                          min_bend_radius=5)
{
    skin_depth = depth-front_termination_offset-rear_termination_offset;
    wrap = csh_wrap_length(width, height, corner_radius);

    assert(skin_depth > 0,
           "veneer_skin_layout: termination offsets consume the depth");
    if (corner_radius < min_bend_radius)
        echo(str("[WARNING] veneer_skin_layout: bend radius ",
                 corner_radius, " is below recommended ", min_bend_radius));

    square([wrap, skin_depth]);
}

// 3D preview of ribs and an optional idealised veneer skin. The skin is an
// extrusion of a constant rounded cross-section, so its flat development is
// valid as a one-direction wrap approximation.
module ribbed_veneer_shell(width, height, depth,
                           rib_count=4,
                           rib_thickness=4,
                           rib_width=4,
                           veneer_thickness=0.6,
                           corner_radius=6,
                           front_termination_offset=4,
                           rear_termination_offset=4,
                           show_ribs=true,
                           show_skin=true,
                           min_bend_radius=5)
{
    usable_depth = depth-front_termination_offset-rear_termination_offset;

    assert(width > 0 && height > 0 && depth > 0,
           "ribbed_veneer_shell: dimensions must be positive");
    assert(rib_count >= 1 && floor(rib_count) == rib_count,
           "ribbed_veneer_shell: rib_count must be a positive integer");
    assert(usable_depth >= rib_thickness,
           "ribbed_veneer_shell: no room remains for ribs");

    if (corner_radius < min_bend_radius)
        echo(str("[WARNING] ribbed_veneer_shell: bend radius ",
                 corner_radius, " is below recommended ", min_bend_radius));

    if (show_ribs)
        for (i = [0:rib_count-1])
            let(y = rib_count == 1
                ? front_termination_offset
                : front_termination_offset +
                  (usable_depth-rib_thickness)*i/(rib_count-1))
                translate([0, y+rib_thickness, 0])
                    rotate([90,0,0])
                        linear_extrude(rib_thickness)
                            shell_rib(width, height,
                                      rib_width, corner_radius);

    if (show_skin)
        color([0.72, 0.45, 0.2, 0.90])
            translate([0, front_termination_offset+usable_depth, 0])
                rotate([90,0,0])
                    linear_extrude(usable_depth)
                        difference() {
                            csh_rounded_rect_2d(
                                [width, height], corner_radius);
                            translate([veneer_thickness,
                                       veneer_thickness])
                                csh_rounded_rect_2d(
                                    [width-2*veneer_thickness,
                                     height-2*veneer_thickness],
                                    max(0, corner_radius-
                                           veneer_thickness));
                        }
}
