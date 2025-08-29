include <frame.scad>

module box_bottom(width, height, depth, frame_width=10, thickness = 0, make_3d=false)
{
    frame(width-2*thickness, depth-2*thickness, frame_width, thickness, make_3d);
}

module box_top(width, height, depth, frame_width=10, thickness = 0, make_3d=false)
{
    frame(width-2*thickness, depth-2*thickness, frame_width, thickness, make_3d);
}

module box_front(width, height, depth, frame_width=10, thickness = 0, make_3d=false)
{
    frame(width, height, frame_width, thickness, make_3d);
}

module box_back(width, height, depth, frame_width=10, thickness = 0, make_3d=false)
{
    frame(width, height, frame_width, thickness, make_3d);
}

module box_left(width, height, depth, frame_width=10, thickness = 0, make_3d=false)
{
    frame(height, depth-2*thickness, frame_width, thickness, make_3d);
}

module box_right(width, height, depth, frame_width=10, thickness = 0, make_3d=false)
{
    frame(height, depth-2*thickness, frame_width, thickness, make_3d);
}


module box(width, height, depth, frame_width=10, thickness = 0, make_3d=false,
            top=true, bottom=true, left=true, right=true, front=true, back=true,
            spacing_2d=1)
{
    t = make_3d ? thickness : 0;

    //bottom
    if (bottom)
    if (make_3d)
    {
        translate([thickness, thickness, 0])
            box_bottom(width, height, depth, frame_width, thickness, make_3d);
    }
    else
    {
        translate([0, 0, 0])
            box_bottom(width, height, depth, frame_width, thickness, make_3d);
    }

    //top
    if (top)
    if (make_3d)
    {
        translate([thickness, thickness, height])
            mirror([0, 0, 1])
                box_top(width, height, depth, frame_width, thickness, make_3d);
    }
    else
    {
        translate([0, depth + height + 2*spacing_2d, 0])
                box_top(width, height, depth, frame_width, thickness, make_3d);
    }

    // front
    if (front)
    if (make_3d)
    {
        translate([0, 0, 0])
            mirror([0, 1, 0])
            rotate([90, 0, 0])
                box_front(width, height, depth, frame_width, thickness, make_3d);
    }
    else
    {
        translate([0, -height - spacing_2d, 0])
                box_front(width, height, depth, frame_width, thickness, make_3d);
    }

    // back
    if (back)
    if (make_3d)
    {
        translate([0,depth,0])
            rotate([90,0,0])
                box_back(width, height, depth, frame_width, thickness, make_3d);
    }
    else
    {
        translate([0,depth + spacing_2d,0])
                box_back(width, height, depth, frame_width, thickness, make_3d);
    }

    // left
    if (left)
    if (make_3d)
    {
        translate([0,thickness,0])
            mirror([1,0,0])
            rotate([0,270,0])
                box_left(width, height, depth, frame_width, thickness, make_3d);
    }
    else
    {
        translate([-max(height, width) - spacing_2d,0,0])
                box_left(width, height, depth, frame_width, thickness, make_3d);
    }
    // right
    if (right)
    if (make_3d)
    {
        translate([width, thickness, 0])
            rotate([0,270,0])
                box_right(width, height, depth, frame_width, thickness, make_3d);
    }
    else
    {
        translate([max(height, width) + spacing_2d, 0, 0])
                box_right(width, height, depth, frame_width, thickness, make_3d);
    }
}