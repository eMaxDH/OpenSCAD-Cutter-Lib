include <frame.scad>
include <facing.scad>

facing_element_width = 15; //[5:1:100]
facing_element_no = 11; //[1:1:20]
facing_thickness = 0.5; //[0.1:0.1:2.0]

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
        translate([0,depth-thickness,0])
            mirror([1,0,0])
                rotate([0,-90,0])
                rotate([0,0,-90])
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
        translate([width,depth-thickness,0])
                rotate([0,-90,0])
                rotate([0,0,-90])
                children();
    }
    else
    {
        translate([max(height, width) + spacing_2d, 0, 0])
                children();
    }
    
}

module arrange_facing_back_front(width, height, depth, thickness = 0, make_3d=false, spacing_2d=1)
{
    if (make_3d)
    {
        arrange_front_frame(width, height, depth, thickness, make_3d, spacing_2d)
        translate([thickness + facing_thickness, 0, thickness])
            children();
    }
    else
    {
        translate([3*width+spacing_2d, 0, 0])
        arrange_front_frame(width, height, depth, thickness, make_3d, spacing_2d)
            children();
    }
}

module arrange_facing_front_front(width, height, depth, thickness = 0, make_3d=false, spacing_2d=1)
{
    if (make_3d)
    {
        arrange_front_frame(width, height, depth, thickness, make_3d, spacing_2d)
        translate([0, 0, -facing_thickness])
            children();
    }
    else
    {
        translate([-3*width-spacing_2d, 0, 0])
        arrange_front_frame(width, height, depth, thickness, make_3d, spacing_2d)
            children();
    }
}

module arrange_facing_back_back(width, height, depth, thickness = 0, make_3d=false, spacing_2d=1)
{
    if (make_3d)
    {
        arrange_back_frame(width, height, depth, thickness, make_3d, spacing_2d)
        translate([thickness+facing_thickness, 0, thickness])
            children();
    }
    else
    {
        translate([3*width+spacing_2d, 0, 0])
        arrange_back_frame(width, height, depth, thickness, make_3d, spacing_2d)
            children();
    }
}

module arrange_facing_front_back(width, height, depth, thickness = 0, make_3d=false, spacing_2d=1)
{
    if (make_3d)
    {
        arrange_back_frame(width, height, depth, thickness, make_3d, spacing_2d)
        translate([0, 0, -facing_thickness])
            children();
    }
    else
    {
        translate([-3*width-spacing_2d, 0, 0])
        arrange_back_frame(width, height, depth, thickness, make_3d, spacing_2d)
            children();
    }
}

module arrange_facing_back_left(width, height, depth, thickness = 0, make_3d=false, spacing_2d=1)
{
    if (make_3d)
    {
        arrange_left_frame(width, height, depth, thickness, make_3d, spacing_2d)
        translate([facing_thickness, 0, thickness])
            children();
    }
    else
    {
        translate([3*width+spacing_2d, 0, 0])
        arrange_left_frame(width, height, depth, thickness, make_3d, spacing_2d)
            children();
    }
}

module arrange_facing_front_left(width, height, depth, thickness = 0, make_3d=false, spacing_2d=1)
{
    if (make_3d)
    {
        arrange_left_frame(width, height, depth, thickness, make_3d, spacing_2d)
        translate([-thickness, 0, -facing_thickness])
            children();
    }
    else
    {
        translate([-3*width-spacing_2d, 0, 0])
        arrange_left_frame(width, height, depth, thickness, make_3d, spacing_2d)
            children();
    }
}

module arrange_facing_back_right(width, height, depth, thickness = 0, make_3d=false, spacing_2d=1)
{
    if (make_3d)
    {
        arrange_right_frame(width, height, depth, thickness, make_3d, spacing_2d)
        translate([facing_thickness, 0, thickness])
            children();
    }
    else
    {
        translate([3*width+spacing_2d, 0, 0])
        arrange_right_frame(width, height, depth, thickness, make_3d, spacing_2d)
            children();
    }
}

module arrange_facing_front_right(width, height, depth, thickness = 0, make_3d=false, spacing_2d=1)
{
    if (make_3d)
    {
        arrange_right_frame(width, height, depth, thickness, make_3d, spacing_2d)
        translate([-thickness, 0, -facing_thickness])
            children();
    }
    else
    {
        translate([-3*width-spacing_2d, 0, 0])
        arrange_right_frame(width, height, depth, thickness, make_3d, spacing_2d)
            children();
    }
}

module set_color_box()
{
    color("Wheat")
        children();
}

module set_color_facing_front()
{
    color("SaddleBrown")
        children();
}

module set_color_facing_back()
{
    color("Cornsilk")
        children();
}

module box(width, height, depth, frame_width=10, thickness = 0, make_3d=false,
            top=true, bottom=true, left=true, right=true, front=true, back=true,
            spacing_2d=1)
{
    //bottom
    if (bottom)
    arrange_bottom_frame(width, height, depth, thickness, make_3d, spacing_2d)
    {
        new_width = width - 2*thickness;
        new_depth = depth - 2*thickness;
        set_color_box()
            frame(new_width, new_depth, frame_width, thickness, make_3d, spacing_2d=spacing_2d);
    }

    //top
    if (top)
    arrange_top_frame(width, height, depth, thickness, make_3d, spacing_2d)
    {
        new_width = width - 2*thickness;
        new_depth = depth - 2*thickness;
        set_color_box()
            frame(new_width, new_depth, frame_width, thickness, make_3d, spacing_2d=spacing_2d);
    }

    // front
    if (front)
    {   
        new_height = height;
        new_width = width;
        set_color_box()
        arrange_front_frame(width, height, depth, thickness, make_3d, spacing_2d)
            frame(new_width, new_height, frame_width, thickness, make_3d, spacing_2d=spacing_2d);
        
        set_color_facing_front()
        arrange_facing_front_front(width, height, depth, thickness, make_3d, spacing_2d)
            facing(new_width, new_height, facing_element_width, facing_element_no, thickness=facing_thickness, make_3d=make_3d);

        set_color_facing_back()
        arrange_facing_back_front(width, height, depth, thickness, make_3d, spacing_2d)
            facing(new_width - 2*thickness - 2*facing_thickness, new_height, facing_element_width, facing_element_no-1, thickness=facing_thickness, make_3d=make_3d);
    }

    // back
    if (back)
    {   
        new_height = height;
        new_width = width;
        set_color_box()
        arrange_back_frame(width, height, depth, thickness, make_3d, spacing_2d)
            frame(new_width, new_height, frame_width, thickness, make_3d, spacing_2d=spacing_2d);
        
        set_color_facing_front()
        arrange_facing_front_back(width, height, depth, thickness, make_3d, spacing_2d)
            facing(new_width, new_height, facing_element_width, facing_element_no, thickness=facing_thickness, make_3d=make_3d);
        
        set_color_facing_back()
        arrange_facing_back_back(width, height, depth, thickness, make_3d, spacing_2d)
            facing(new_width - 2*thickness - 2*facing_thickness, new_height, facing_element_width, facing_element_no-1, thickness=facing_thickness, make_3d=make_3d);
    }

    // left
    if (left)
    {
        new_height = height;
        new_depth = depth - 2*thickness;
        set_color_box()
        arrange_left_frame(width, height, depth, thickness, make_3d, spacing_2d)
            frame(new_depth, new_height, frame_width, thickness, make_3d, spacing_2d=spacing_2d);
            
        set_color_facing_front()
        arrange_facing_front_left(width, height, depth, thickness, make_3d, spacing_2d)
            facing(depth, new_height, facing_element_width, facing_element_no, thickness=facing_thickness, make_3d=make_3d);

        set_color_facing_back()
        arrange_facing_back_left(width, height, depth, thickness, make_3d, spacing_2d)
            facing(new_depth-2*facing_thickness, new_height, facing_element_width, facing_element_no-1, thickness=facing_thickness, make_3d=make_3d);
    }

    // right
    if (right)
    {
        new_height = height;
        new_depth = depth - 2*thickness;
        set_color_box()
        arrange_right_frame(width, height, depth, thickness, make_3d, spacing_2d)
            frame(new_depth, new_height, frame_width, thickness, make_3d, spacing_2d=spacing_2d);
        
        set_color_facing_front()
        arrange_facing_front_right(width, height, depth, thickness, make_3d, spacing_2d)
            facing(depth, new_height, facing_element_width, facing_element_no, thickness=facing_thickness, make_3d=make_3d);

        set_color_facing_back()
        arrange_facing_back_right(width, height, depth, thickness, make_3d, spacing_2d)
            facing(new_depth-2*facing_thickness, new_height, facing_element_width, facing_element_no-1, thickness=facing_thickness, make_3d=make_3d);
    }
}

module box_base_floor(width, height, depth, frame_width=10, thickness = 0, make_3d=false,
            top=true, bottom=true, left=true, right=true, front=true, back=true,
            spacing_2d=1)
{
    //bottom
    if (bottom)
    arrange_bottom_frame(width, height, depth, thickness, make_3d, spacing_2d)
    {
        new_width = width - 2*thickness;
        new_depth = depth - 2*thickness;
        set_color_box()
            frame_base_floor(new_width, new_depth, frame_width, thickness, make_3d, spacing_2d=spacing_2d);
    }

    //top
    if (top)
    arrange_top_frame(width, height, depth, thickness, make_3d, spacing_2d)
    {
        new_width = width - 2*thickness;
        new_depth = depth - 2*thickness;
        set_color_box()
            frame_base_floor(new_width, new_depth, frame_width, thickness, make_3d, spacing_2d=spacing_2d);
    }

    // front
    if (front)
    {   
        new_height = height;
        new_width = width;
        set_color_box()
        arrange_front_frame(width, height, depth, thickness, make_3d, spacing_2d)
            frame_base_floor(new_width, new_height, frame_width, thickness, make_3d, spacing_2d=spacing_2d);
        
        set_color_facing_front()
        arrange_facing_front_front(width, height, depth, thickness, make_3d, spacing_2d)
            facing(new_width, new_height, facing_element_width, facing_element_no, thickness=facing_thickness, make_3d=make_3d);

        set_color_facing_back()
        arrange_facing_back_front(width, height, depth, thickness, make_3d, spacing_2d)
            facing(new_width - 2*thickness - 2*facing_thickness, new_height, facing_element_width, facing_element_no-1, thickness=facing_thickness, make_3d=make_3d);
    }

    // back
    if (back)
    {   
        new_height = height;
        new_width = width;
        set_color_box()
        arrange_back_frame(width, height, depth, thickness, make_3d, spacing_2d)
            frame_base_floor(new_width, new_height, frame_width, thickness, make_3d, spacing_2d=spacing_2d);
        
        set_color_facing_front()
        arrange_facing_front_back(width, height, depth, thickness, make_3d, spacing_2d)
            facing(new_width, new_height, facing_element_width, facing_element_no, thickness=facing_thickness, make_3d=make_3d);
        
        set_color_facing_back()
        arrange_facing_back_back(width, height, depth, thickness, make_3d, spacing_2d)
            facing(new_width - 2*thickness - 2*facing_thickness, new_height, facing_element_width, facing_element_no-1, thickness=facing_thickness, make_3d=make_3d);
    }

    // left
    if (left)
    {
        new_height = height;
        new_depth = depth - 2*thickness;
        set_color_box()
        arrange_left_frame(width, height, depth, thickness, make_3d, spacing_2d)
            frame_base_floor(new_depth, new_height, frame_width, thickness, make_3d, spacing_2d=spacing_2d);
            
        set_color_facing_front()
        arrange_facing_front_left(width, height, depth, thickness, make_3d, spacing_2d)
            facing(depth, new_height, facing_element_width, facing_element_no, thickness=facing_thickness, make_3d=make_3d);

        set_color_facing_back()
        arrange_facing_back_left(width, height, depth, thickness, make_3d, spacing_2d)
            facing(new_depth-2*facing_thickness, new_height, facing_element_width, facing_element_no-1, thickness=facing_thickness, make_3d=make_3d);
    }

    // right
    if (right)
    {
        new_height = height;
        new_depth = depth - 2*thickness;
        set_color_box()
        arrange_right_frame(width, height, depth, thickness, make_3d, spacing_2d)
            frame_base_floor(new_depth, new_height, frame_width, thickness, make_3d, spacing_2d=spacing_2d);
        
        set_color_facing_front()
        arrange_facing_front_right(width, height, depth, thickness, make_3d, spacing_2d)
            facing(depth, new_height, facing_element_width, facing_element_no, thickness=facing_thickness, make_3d=make_3d);

        set_color_facing_back()
        arrange_facing_back_right(width, height, depth, thickness, make_3d, spacing_2d)
            facing(new_depth-2*facing_thickness, new_height, facing_element_width, facing_element_no-1, thickness=facing_thickness, make_3d=make_3d);
    }
}

module box_additional(width, height, depth, frame_width=10, thickness = 0, make_3d=false,
            top=true, bottom=true, left=true, right=true, front=true, back=true,
            spacing_2d=1)
{
    //bottom
    if (bottom)
    arrange_bottom_frame(width, height, depth, thickness, make_3d, spacing_2d)
    {
        new_width = width - 2*thickness;
        new_depth = depth - 2*thickness;
        set_color_box()
            frame_additional(new_width, new_depth, frame_width, thickness, make_3d, spacing_2d=spacing_2d);
    }

    //top
    if (top)
    arrange_top_frame(width, height, depth, thickness, make_3d, spacing_2d)
    {
        new_width = width - 2*thickness;
        new_depth = depth - 2*thickness;
        set_color_box()
            frame_additional(new_width, new_depth, frame_width, thickness, make_3d, spacing_2d=spacing_2d);
    }

    // front
    if (front)
    {   
        new_height = height;
        new_width = width;
        set_color_box()
        arrange_front_frame(width, height, depth, thickness, make_3d, spacing_2d)
            frame_additional(new_width, new_height, frame_width, thickness, make_3d, spacing_2d=spacing_2d);
        
        set_color_facing_front()
        arrange_facing_front_front(width, height, depth, thickness, make_3d, spacing_2d)
            facing(new_width, new_height, facing_element_width, facing_element_no, thickness=facing_thickness, make_3d=make_3d);

        set_color_facing_back()
        arrange_facing_back_front(width, height, depth, thickness, make_3d, spacing_2d)
            facing(new_width - 2*thickness - 2*facing_thickness, new_height, facing_element_width, facing_element_no-1, thickness=facing_thickness, make_3d=make_3d);
    }

    // back
    if (back)
    {   
        new_height = height;
        new_width = width;
        set_color_box()
        arrange_back_frame(width, height, depth, thickness, make_3d, spacing_2d)
            frame_additional(new_width, new_height, frame_width, thickness, make_3d, spacing_2d=spacing_2d);
        
        set_color_facing_front()
        arrange_facing_front_back(width, height, depth, thickness, make_3d, spacing_2d)
            facing(new_width, new_height, facing_element_width, facing_element_no, thickness=facing_thickness, make_3d=make_3d);
        
        set_color_facing_back()
        arrange_facing_back_back(width, height, depth, thickness, make_3d, spacing_2d)
            facing(new_width - 2*thickness - 2*facing_thickness, new_height, facing_element_width, facing_element_no-1, thickness=facing_thickness, make_3d=make_3d);
    }

    // left
    if (left)
    {
        new_height = height;
        new_depth = depth - 2*thickness;
        set_color_box()
        arrange_left_frame(width, height, depth, thickness, make_3d, spacing_2d)
            frame_additional(new_depth, new_height, frame_width, thickness, make_3d, spacing_2d=spacing_2d);
            
        set_color_facing_front()
        arrange_facing_front_left(width, height, depth, thickness, make_3d, spacing_2d)
            facing(depth, new_height, facing_element_width, facing_element_no, thickness=facing_thickness, make_3d=make_3d);

        set_color_facing_back()
        arrange_facing_back_left(width, height, depth, thickness, make_3d, spacing_2d)
            facing(new_depth-2*facing_thickness, new_height, facing_element_width, facing_element_no-1, thickness=facing_thickness, make_3d=make_3d);
    }

    // right
    if (right)
    {
        new_height = height;
        new_depth = depth - 2*thickness;
        set_color_box()
        arrange_right_frame(width, height, depth, thickness, make_3d, spacing_2d)
            frame_additional(new_depth, new_height, frame_width, thickness, make_3d, spacing_2d=spacing_2d);
        
        set_color_facing_front()
        arrange_facing_front_right(width, height, depth, thickness, make_3d, spacing_2d)
            facing(depth, new_height, facing_element_width, facing_element_no, thickness=facing_thickness, make_3d=make_3d);

        set_color_facing_back()
        arrange_facing_back_right(width, height, depth, thickness, make_3d, spacing_2d)
            facing(new_depth-2*facing_thickness, new_height, facing_element_width, facing_element_no-1, thickness=facing_thickness, make_3d=make_3d);
    }
}
