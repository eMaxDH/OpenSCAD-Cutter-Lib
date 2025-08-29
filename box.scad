include <frame.scad>

module arrange_bottom_frame(width, height, depth, thickness = 0, make_3d=false, spacing_2d=1)
{
    if (make_3d)
    {
        translate([thickness, thickness, 0])
            children();
    }
    else
    {
        translate([0, 0, 0])
            children();
    }
    
}

module arrange_top_frame(width, height, depth, thickness = 0, make_3d=false, spacing_2d=1)
{
    if (make_3d)
    {
        translate([thickness, thickness, height])
            mirror([0, 0, 1])
                children();
    }
    else
    {
        translate([0, depth + height + 2*spacing_2d, 0])
                children();
    }
}

module arrange_front_frame(width, height, depth, thickness = 0, make_3d=false, spacing_2d=1)
{
    if (make_3d)
    {
        translate([0, 0, 0])
            mirror([0, 1, 0])
            rotate([90, 0, 0])
                children();
    }
    else
    {
        translate([0, -height - spacing_2d, 0])
                children();
    }
}

module arrange_back_frame(width, height, depth, thickness = 0, make_3d=false, spacing_2d=1)
{
    if (make_3d)
    {
        translate([0,depth,0])
            rotate([90,0,0])
                children();
    }
    else
    {
        translate([0,depth + spacing_2d,0])
                children();
    }
}

module arrange_left_frame(width, height, depth, thickness = 0, make_3d=false, spacing_2d=1)
{
    if (make_3d)
    {
        translate([0,thickness,0])
            mirror([1,0,0])
            rotate([0,270,0])
                children();
    }
    else
    {
        translate([-max(height, width) - spacing_2d,0,0])
                children();
    }
}

module arrange_right_frame(width, height, depth, thickness = 0, make_3d=false, spacing_2d=1)
{
    if (make_3d)
    {
        translate([width, thickness, 0])
            rotate([0,270,0])
                children();
    }
    else
    {
        translate([max(height, width) + spacing_2d, 0, 0])
                children();
    }
    
}


module box(width, height, depth, frame_width=10, thickness = 0, make_3d=false,
            top=true, bottom=true, left=true, right=true, front=true, back=true,
            spacing_2d=1)
{
    t = make_3d ? thickness : 0;

    //bottom
    if (bottom)
    arrange_bottom_frame(width, height, depth, thickness, make_3d, spacing_2d)
    {
        new_width = width - 2*thickness;
        new_depth = depth - 2*thickness;
        frame(new_width, new_depth, frame_width, thickness, make_3d, spacing_2d=spacing_2d);
    }

    //top
    if (top)
    arrange_top_frame(width, height, depth, thickness, make_3d, spacing_2d)
    {
        new_width = width - 2*thickness;
        new_depth = depth - 2*thickness;
        frame(new_width, new_depth, frame_width, thickness, make_3d, spacing_2d=spacing_2d);
    }

    // front
    if (front)
    arrange_front_frame(width, height, depth, thickness, make_3d, spacing_2d)
    {   
        new_height = height;
        new_width = width;
        frame(new_width, new_height, frame_width, thickness, make_3d, spacing_2d=spacing_2d);
    }

    // back
    if (back)
    arrange_back_frame(width, height, depth, thickness, make_3d, spacing_2d)
    {   
        new_height = height;
        new_width = width;
        frame(new_width, new_height, frame_width, thickness, make_3d, spacing_2d=spacing_2d);
    }

    // left
    if (left)
    arrange_left_frame(width, height, depth, thickness, make_3d, spacing_2d)
    {
        new_height = height;
        new_depth = depth - 2*thickness;
        frame(new_height, new_depth, frame_width, thickness, make_3d, spacing_2d=spacing_2d);
    }

    // right
    if (right)
    arrange_right_frame(width, height, depth, thickness, make_3d, spacing_2d)
    {
        new_height = height;
        new_depth = depth - 2*thickness;
        frame(new_height, new_depth, frame_width, thickness, make_3d, spacing_2d=spacing_2d);
    }
}