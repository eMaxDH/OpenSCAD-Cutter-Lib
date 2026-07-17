use <../shells/csh_ribbed_veneer.scad>

module finger_grip_2d(width=16, depth=5)
{
    assert(width > depth && depth > 0,
           "finger_grip_2d: width must exceed positive depth");
    scale([1, 2*depth/width])
        circle(d=width);
}

module dish_slot_pattern_2d(area=[30,30], slot_width=2,
                            slot_length=20, count=4, margin=3)
{
    assert(area[0] > 0 && area[1] > 0,
           "dish_slot_pattern_2d: area must be positive");
    assert(count >= 1 && floor(count) == count,
           "dish_slot_pattern_2d: count must be a positive integer");
    assert(slot_width > 0 && slot_length > 0 &&
           slot_length <= area[1]-2*margin,
           "dish_slot_pattern_2d: slots do not fit the area");

    pitch = (area[0]-2*margin)/count;
    assert(slot_width < pitch,
           "dish_slot_pattern_2d: slot width exceeds pitch");

    for (i = [0:count-1])
        translate([margin+pitch*(i+0.5)-slot_width/2,
                   (area[1]-slot_length)/2])
            square([slot_width, slot_length]);
}

module removable_tray_2d(size=[40,50], corner_radius=2,
                         grip_width=14, grip_depth=5,
                         dish_slots=4, dish_slot_width=2)
{
    assert(size[0] > grip_width && size[1] > 2*grip_depth,
           "removable_tray_2d: grip does not fit tray");

    difference() {
        csh_rounded_rect_2d(size, corner_radius);
        translate([size[0]/2, grip_depth/2])
            finger_grip_2d(grip_width, grip_depth);
        dish_slot_pattern_2d(
            [size[0], size[1]-2*grip_depth],
            dish_slot_width,
            size[1]/3,
            dish_slots,
            margin=4);
    }
}

module removable_tray(size=[40,50], thickness=2,
                      corner_radius=2, grip_width=14,
                      grip_depth=5, dish_slots=4,
                      dish_slot_width=2, make_3d=false)
{
    assert(thickness > 0, "removable_tray: thickness must be positive");

    if (make_3d)
        linear_extrude(thickness)
            removable_tray_2d(size, corner_radius, grip_width,
                              grip_depth, dish_slots, dish_slot_width);
    else
        removable_tray_2d(size, corner_radius, grip_width,
                          grip_depth, dish_slots, dish_slot_width);
}

// Side profile of a runner cut from sheet stock. The optional raised stop is
// part of this same outline, so it cannot diverge between 2D and 3D.
module tray_runner_2d(length, height=4, stop_height=0, stop_length=4)
{
    assert(length > 0 && height > 0 && stop_length > 0,
           "tray_runner: dimensions must be positive");
    assert(stop_height >= 0,
           "tray_runner: stop_height must be non-negative");
    assert(stop_length <= length,
           "tray_runner: stop length exceeds runner length");

    union() {
        square([length, height]);
        if (stop_height > 0)
            translate([length-stop_length, height])
                square([stop_length, stop_height]);
    }
}

module tray_runner(length, width=4, height=4, stop_height=0,
                   make_3d=true)
{
    assert(width > 0, "tray_runner: width must be positive");

    if (make_3d)
        rotate([90,0,90])
            linear_extrude(width)
                tray_runner_2d(
                    length, height, stop_height, width);
    else
        tray_runner_2d(
            length, height, stop_height, width);
}
